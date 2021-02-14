package chirp;

import zenlog.Log;
import hawk.store.IStringStore;
import tink.CoreApi;

class RecentChirpsStore {
	private var _chirps:Array<Chirp>;
	private var _store:IStringStore;

	private final _max:Int = 16;

	public function new() {}

	public function init(store:IStringStore):Promise<RecentChirpsStore> {
		_chirps = [];
		_store = store;
		return load().next(function(_) {
			return this;
		});
	}

	public function addChirp(chirp:Chirp):Promise<Noise> {
		if (_chirps.length == _max) {
			_chirps.pop();
		}
		_chirps.insert(0, chirp);
		return save();
	}

	private function save():Promise<Noise> {
		var writer = new json2object.JsonWriter<Array<Chirp>>();
		var json = writer.write(_chirps);
		return _store.save(json);
	}

	private function load():Promise<Noise> {
		return _store.load().next(function(str:String) {
			if (str == null || str.length == 0) {
				return Noise;
			}
			var reader = new json2object.JsonParser<Array<Chirp>>();
			_chirps = reader.fromJson(str);
			return Noise;
		});
	}

	public function recentChirps():Promise<Array<Chirp>> {
		return (Success(_chirps.copy()));
	}
}
