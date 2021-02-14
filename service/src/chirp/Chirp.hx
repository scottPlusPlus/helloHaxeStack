package chirp;

import hawk.datatypes.Timestamp;
import hawk.core.UUID;

class Chirp implements DataClass {

    public final user: UUID;
    public final time: Timestamp;
    public final message: String;

    public static function fromJson(str:String): Chirp {
        var parser = new json2object.JsonParser<Chirp>();
        return parser.fromJson(str);
    }

    public function toJson():String {
        var writer = new json2object.JsonWriter<Chirp>();
        return writer.write(this);
    }
}