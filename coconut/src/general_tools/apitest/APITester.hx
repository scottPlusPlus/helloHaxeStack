package general_tools.apitest;

import haxe.format.JsonPrinter;
import haxe.Json;
import tink.http.Method;
import tink.http.Header.HeaderField;

import coconut.ui.View;
import coconut.data.*;
import bootstrap.*;
import general_tools.apitest.PostParamsView;

using hawk.util.OptionX;
using thx.Maps;

class APITester extends View {
    
    @:state var url:String = "";
    @:state var auth:String = "";
    @:state var params: coconut.data.List<Param> = null;
    @:state var param_ids:Int = 0;
    @:state var apiMethod:Method = Method.GET;

    @:state var responses:List<String> = null;

	function onSend(_) {
		sendFetch().all().handle(function(o) {
			switch o {
				case Success(res):
					trace(res.header.statusCode);
					trace(res.body);
					prependResponse(res.body);
				case Failure(e):
					trace(e);
					prependResponse("Failure:  " + e.message);
			}
		});
	}

	function sendFetch() {
		if (apiMethod == Method.POST) {
			var param_map = new Map<String, String>();
			for (p in params.toArray()) {
				param_map.set(p.key, p.val);
			}
			var body_str = hawk.util.Json.mapToJson(param_map);
			return tink.http.Client.fetch(url, {
				method: POST,
				headers: [
					new HeaderField(CONTENT_TYPE, 'application/json'),
					new HeaderField(AUTHORIZATION, auth)
				],
				body: body_str
			});
		}
		return tink.http.Client.fetch(url, {
			method: GET,
			headers: [
				new HeaderField(CONTENT_TYPE, 'application/json'),
				new HeaderField(AUTHORIZATION, auth)
			],
		});
	}

	function prependResponse(str:String) {
		try {
			var obj = Json.parse(str);
			str = JsonPrinter.print(obj, null, "  ");
		} catch (e) {
			// fine if it's not json
		}
		str = url + "\n- - - - -\n" + str;
		responses = responses.prepend(str);
	}

    
    function clearResponses(_){
        responses = [];
    }

    function setUrl(v:String){
        url = v;
    }

    function setAuth(v:String){
        auth = v;
    }

    function addParam(){
       // var newp = new Param({id: Std.string(params.length)});
       param_ids++;
       var newp = new Param({id: param_ids, key:"", val:""});
        params = params.append(newp);
    }

    function removeParam(id:Int) {
        trace('remove param ${id}');
		params = params.filter(i -> i.id != id);
    }
    
    function setParamKey(id:Int, val:String){
        var old_p = params.first(function(p){ return p.id == id;}).sure();
        var new_p = new Param({id:old_p.id, key:val, val:old_p.val});
        params = params.replace(old_p, new_p);
    }

    function setParamVal(id:Int, val:String){
        var old_p = params.first(function(p){ return p.id == id;}).sure();
        var new_p = new Param({id:old_p.id, key:old_p.key, val: val});
        params = params.replace(old_p, new_p);
    }

    function validURL(str:String):Bool {
        if (str.length <= 3){
            return false;
        }
        return true;
    }


    function render() 
        <Container>

            <p>This page is a simple tool for testing your app while in development.  Basically Postman in your app</p>

            <h2>Request</h2>
            <MethodNav setMeth=${function(meth){
                apiMethod=meth;
            }}/>
            <MyTextInput type=${InputType.Text} placeholder="URL" onTextChange=${setUrl}></MyTextInput>
            <MyTextInput type=${InputType.Text} placeholder="Authorization" onTextChange=${setAuth}></MyTextInput>

            <if {apiMethod == Method.POST}>
            <PostParamsView
                params=${params}
                addParam=${addParam}
                removeParam=${removeParam}
                setParamKey=${setParamKey}
                setParamVal=${setParamVal}
            />
            </if>
            <if {validURL(url)}>
                <Button onclick=${onSend}>Send ${apiMethod}</Button>
            <else>
                <Button disabled>Send ${apiMethod}</Button>
            </if>
            <h2>Responses</h2>
            <Button onclick=${clearResponses}>Clear</Button>
            <ResponsesView responses=${responses.toArray()}/>


        </Container>
	;
}

class MethodNav extends View {
    @:attribute var setMeth:Method->Void;

    function setGet(_){
        setMeth(Method.GET);
    }

    function setPost(_){
        setMeth(Method.POST);
    }

    function render()
        <div>
            <Button onclick=${setGet}>GET</Button>
            <Button onclick=${setPost}>POST</Button>
        </div>
    ;
}



