class GlobalState {

    public static var instance (default, null):GlobalState;

    public var userToken:String = "";
    public var currentURL:tink.Url;

    public function new(){}

    public static function ensure():GlobalState {
        if (instance == null){
            instance = new GlobalState();
        }
        return instance;
    }

}