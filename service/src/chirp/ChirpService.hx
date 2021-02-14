package chirp;

import zenlog.Log;
import hawk.store.IStringStore;
import tink.core.Error.ErrorCode;
import hawk.messaging.*;
import hawk.datatypes.Timestamp;
import tink.CoreApi;
import hawk.util.ErrorX;
import tink.core.Promise;
import hawk.core.UUID;

using hawk.util.PromiseX;

class ChirpService {
	private var _chirpPub:IPublisher<EvNewChirp>;
	private var _chirpSub:ISubscriber<EvNewChirp>;
	private var _recents:RecentChirpsStore;

	public function new() {}

	public function init(deps:ChirpServiceDeps):Promise<ChirpService> {	
		_chirpPub = deps.newChirpPub;
		_chirpSub = deps.newChirpSub;
		if (_chirpPub == null){
			Log.error("chirp Pub is null");
		}
		if (_chirpSub == null){
			Log.error("chirp Sub is null!");
		}

		_chirpSub.subscribe(handleNewChirp);
		_recents = new RecentChirpsStore();
		var p = _recents.init(deps.recentChirpStore).eager();		
		return p.next(function(_){
			Log.info("ChirpService init is done...");
			return this;
		});
	}

	public function getChirps():Promise<Array<Chirp>> {
		return _recents.recentChirps().next(function(val){
			return val;
		}).wrapErr(ErrorCode.InternalError, 'infra error with getMessages');
	}

	public function postChirp(actor:UUID, message:String):Promise<Array<Chirp>> {
		// TODO - check valid message / profanity
		Log.debug("posting new chirp:  " + message);
		if (message.length > 140) {
			var err = new Error(ErrorCode.NotAcceptable, 'message should be 140 chars or less');
			return Failure(err);
		}

		var chirp = new Chirp({
			user: actor,
			time: Timestamp.now(),
			message: message
		});

		var event = new EvNewChirp({
			chirp: chirp
		});

		return _chirpPub.publish(event)
			.wrapErr(ErrorCode.InternalError, 'infra error with postMessage')
			.next(function(_){
				return getChirps().next(function(chirps){
					chirps.insert(0, chirp);
					return chirps;
				});
			});
	}

	private function handleNewChirp(ev:EvNewChirp):Promise<Noise> {
		Log.debug("handle new chirp:  " + ev.chirp.message);
		return _recents.addChirp(ev.chirp).wrapErr(ErrorCode.InternalError, 'infra error with handleNewChirp');
	}

}

typedef ChirpServiceDeps = {
	newChirpPub:IPublisher<EvNewChirp>,
	newChirpSub:ISubscriber<EvNewChirp>,
	recentChirpStore:IStringStore
}
