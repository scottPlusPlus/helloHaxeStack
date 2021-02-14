package chirp;

import hawk.messaging.Message;


class EvNewChirp implements DataClass {
    public final chirp:Chirp;

    public static function toMessage(ev:EvNewChirp):Message {
        var str = ev.chirp.toJson();
        var msg = Message.fromString(str);
        return msg;
    }

    public static function fromMessage(msg:Message):EvNewChirp {
        var str = msg.toString();
        var chirp = Chirp.fromJson(str);
        var event = new EvNewChirp({chirp:chirp});
        return event;
    }
}