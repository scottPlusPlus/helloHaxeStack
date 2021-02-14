import hawk.general_tools.adapters.TStringAdapter;
import hawk.store.InMemoryKVStore;
import zenlog.Log;
import hawk.authservice.AuthService.AuthServiceDeps;
import hawk.webserver.WebLogger;
import hawk.authservice.*;
import hawk.store.InMemoryStringStore;
import chirp.EvNewChirp;
import hawk.messaging.LocalChannel;
import chirp.ChirpService;
import tink.CoreApi;
import hawk.datatypes.Email;

using hawk.util.OutcomeX;

@:keep
class Services {
	public var chirpService:ChirpService;
	public var authService:AuthService;

	// creation

	@:expose("create")
	public static function create():Promise<Services> {
		var s = new Services();
		return s.init().eager();
	}

	public function new() {
		chirpService = new ChirpService();
		authService = new AuthService();
	}

	public function init():Promise<Services> {
		Log.debug("Services.init");
		WebLogger.init();
		var arr = [initChirpService().noise(), initAuthService().noise()];

		return Promise.inParallel(arr).next(function(_) {
			Log.debug("in parallel complete");
			return this;
		});
	}

	private function initChirpService():Promise<ChirpService> {
		Log.debug("begin initChirpService");
		var channel = new LocalChannel<EvNewChirp>("chirp", EvNewChirp.toMessage, EvNewChirp.fromMessage);
		var deps:ChirpServiceDeps = {
			newChirpPub: channel,
			newChirpSub: channel,
			recentChirpStore: new InMemoryStringStore()
		}
		return chirpService.init(deps);
	}

	private function initAuthService():Promise<AuthService> {
		Log.debug("begin initAuthService");
		var authUserAdapter = new TStringAdapter<AuthUser>(AuthUser.toJson, AuthUser.fromJson);
		var inMemoryStore = new InMemoryKVStore(Email.stringAdapter(), authUserAdapter);
		var channel = new LocalChannel<EvNewUser>("newUser", EvNewUser.toMessage, EvNewUser.fromMessage);
		var deps:AuthServiceDeps = {
			tokenSecret: function() {
				return "shhhh, it's a secret";
			},
			tokenIssuer: "helloHaxeStack",
			userStore: inMemoryStore,
			newUserPub: channel,
			newUserSub: channel,
		}
		var auth = authService.init(deps);
		Log.info("auth service init complete");
		return auth;
	}

	// end creation

	public function log(str:String) {
		Log.info(str);
	}

	public function getLogs():Array<String> {
		var logs = WebLogger.dump();
		logs.reverse();
		return logs;
	}

	@:expose("handlePromise")
	public static function handlePromise<T>(p:Promise<T>, onSuccess:T->Void, onFailure:Error->Void) {
		p.handle(function(o) {
			return switch o {
				case Success(v):
					onSuccess(v);
				case Failure(e):
					onFailure(e);
			}
		});
	}

	@:expose("handleOutcome")
	public static function handleOutcome<T1, T2>(o:Outcome<T1, T2>, onFirst:T1->Void, onSecond:T2->Void) {
		return switch o {
			case Success(v):
				onFirst(v);
			case Failure(e):
				onSecond(e);
		}
	}
}