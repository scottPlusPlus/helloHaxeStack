import js.Browser.document;
import coconut.vdom.Renderer.hxx;
import coconut.data.Model;
import coconut.ui.View;
import bootstrap.*;
import bootstrap.Container.Row;
import HomePage;
import general_tools.apitest.APITester;
import chirps.ChirpPage;

class Main {
	static function main() {
		coconut.ui.Renderer.mount(
			cast document.body.appendChild(document.createDivElement()), hxx('<Root />')
		);
	}
}

class Root extends View {
	var router = MyRouter.create();


	function render() {
		var current = Std.string(router.routeToLocation(router.route));
		//trace("rendering main  " + current);
		return hxx(
		<div ref=${router.intercept}>
			<NavBar current=${current}/>
			<switch ${router.route}>
				<case ${Route.Home}><HomePage/>
				<case ${Route.Chirp}><ChirpPage/>
				<case ${Route.APITest}><APITester/>
				<case ${Route.Unknown(v)}><UnknownPage path=${v}/>
			</switch>
		</div>
		);
	}
}