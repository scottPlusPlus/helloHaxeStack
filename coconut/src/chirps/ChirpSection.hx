package chirps;

import bootstrap.Button;
import coconut.vdom.View;
import zenlog.Log;

class ChirpSection extends View {

    @:state var chirps:coconut.data.List<ChirpModel> = null;


    function loadChirps(_){
        var url = "api/chirps";
        APIUtil.makeGet(url).next(function(s:String){
            Log.debug('res body == ' + s);
            chirps = ChirpModel.listFromJson(s);
            Log.debug('got ${chirps.length} chirps');
            return s;
        }).eager();
    }

    function postChirp(msg:String){
        var url = "api/chirp";
        APIUtil.makePost(url, {msg:msg}).next(function(s:String){
            Log.debug('res body == ' + s);
            chirps = ChirpModel.listFromJson(s);
            Log.debug('got ${chirps.length} chirps');
            return s;
        }).eager();
    }

    function viewDidMount():Void{
        loadChirps(null);
    }

    function render()
        <div>
            <Button onclick=${loadChirps}>Load</Button>
            <PostChirp postChirp=${postChirp}/>
            <RecentChirps  chirps=${chirps}/>
        </div>
    ;
}