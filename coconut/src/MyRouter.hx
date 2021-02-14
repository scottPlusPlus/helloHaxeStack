import coconut.router.BrowserRouter;

class MyRouter {

    public static function create() {
        var router = new coconut.router.BrowserRouter({
            routeToLocation: routeToLocation,
            locationToRoute: function(url) {
                GlobalState.ensure().currentURL = url;
                return switch url.path.parts().toStringArray() {
                    case []: Home;
                    case ['chirp']: Chirp;
                    case ['test']: APITest;
                    case _: Unknown(url.path.toString());
                }
            },
        });

        return router;
    }

    public static function routeToLocation(route): tink.Url {
        return switch route {
            case Route.Home: '/';
            case Route.Chirp: '/chirp';
            case Route.APITest: '/test';
            case Route.Unknown(v): v;
        }
    }

    // public static function currentLoc(router):String {
    //     return routeToLocation(router.route);
    // }


}

