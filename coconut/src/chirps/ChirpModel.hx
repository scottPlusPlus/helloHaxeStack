package chirps;

import zenlog.Log;
import tink.json.*;
import coconut.data.Model;
import hawk.datatypes.Timestamp;
import hawk.core.UUID;


class ChirpModel implements Model {

    @:constant public var user: UUID;
    @:constant public var time: Timestamp;
    @:constant public var message: String;


    // public static function fromJson(json):ChirpModel{
    //     return new ChirpModel({user:json.user, time:json.time, message:json.message});
    // }

    public static function listFromJson(str:String): coconut.data.List<ChirpModel> {
        var parser = new json2object.JsonParser<Array<ChirpSimple>>();
        var simples = parser.fromJson(str);
        Log.debug('got ${simples.length} simple-chirps...');
        var list = new coconut.data.List<ChirpModel>();
        for (item in simples){
            Log.debug('processing ${item}');
            var model = new ChirpModel({user:item.user, time:item.time, message:item.message});
            list = list.append(model);
        }
        return list;
    }

    // public static function listFromJson(str:String): List<ChirpModel> {
    //     return tink.Json.parse(str);
    // }

    // public function toJson():String {
    //     var writer = new json2object.JsonWriter<ChirpModel>();
    //     return writer.write(this);
    // }
}

class ChirpSimple {
    public function new(){}
    
    public var user:String;
    public var time:Int;
    public var message:String;
}