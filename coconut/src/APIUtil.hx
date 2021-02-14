package;

import tink.http.Fetch.CompleteResponse;
import tink.http.Response.StatusCode;
import tink.CoreApi;
import tink.CoreApi.Error;
import tink.http.Header.HeaderField;
import zenlog.Log;

class APIUtil {
	static var _host ="";

	public static function host():String {
		if (_host.length == 0){
			var u =  GlobalState.ensure().currentURL;
			var str = u.toString();
			var endHost = str.lastIndexOf(u.pathWithQuery);
			_host = str.substring(0, endHost) + "/";
			Log.debug("APIUtil set host to " + _host);
		}
		return _host;
	}

	public static function makePost(relativeUrl:String, data:Dynamic):Promise<String> {
		var url = host() + relativeUrl;
		var body_str = hawk.util.Json.anonToJson(data);
		Log.debug('posting  ${url}  with  ${body_str}');
		var auth = GlobalState.ensure().userToken;
		var p = tink.http.Client.fetch(url, {
			method: POST,
			headers: [
				new HeaderField(CONTENT_TYPE, 'application/json'),
				new HeaderField(AUTHORIZATION, auth)
			],
			body: body_str
		}).all();
		return extractBodyOrError(p, url);
	}

	public static function makeGet(relativeUrl:String):Promise<String> {
		var url = host() + relativeUrl;
		Log.debug('getting  ${url}');

		var p = tink.http.Client.fetch(url, {
			method: GET,
			headers: [new HeaderField(CONTENT_TYPE, 'application/json')],
		}).all();
		return extractBodyOrError(p, url);
	}

	private static function extractBodyOrError(p:Promise<CompleteResponse>, url:String):Promise<String> {
		return p.map(function(o) {
			switch o {
				case Success(res):
					var status = res.header.statusCode;
					if (status < 200 || status >= 300) {
						Log.error('post ${url} response == ${res.header.statusCode}');
						return Failure(new Error('bad status code: ${res.header.statusCode} '));
					}
					var str:String = res.body;
					return Success(str);
				case Failure(e):
					Log.error('post ${url} failed:');
					Log.error(e);
					return Failure(e);
			}
		});
	}
}
