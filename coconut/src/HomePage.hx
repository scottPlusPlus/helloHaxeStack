import bootstrap.Jumbotron;
import bootstrap.Container;

class HomePage extends coconut.ui.View {
	function render() 
		<Container>
			<Row>
				<Jumbotron>
					<h1>Hello, HaxeStack!</h1>
					<p>An example of a full stack web app using <a href="https://haxe.org/">Haxe</a></p>
					<p>Key libraries:</p>
					<ul>
						<li><a href="https://haxetink.github.io/#/">Tink</a></li>
						<li><a href="https://github.com/MVCoconut">MVCoconut</a></li>
						<li><a href="https://github.com/markknol/coconut.bootstrap">Coconut Bootstrap</a></li>
						<li>Hawk</li>
					</ul>
					<p>This frontend was compiled at ${compiledTime()}</p>
					<p>Still a work-in-progress. Check out our <a href="https://trello.com/b/ksjwsnyj/hellohaxestack">Trello</a></p>
					<p>Currently running in a <a href="https://www.heroku.com/">Heroku</a> container (obviously)</p>
				</Jumbotron>
			</Row>
		</Container>
    ;

	function compiledTime():String {
		var buildTime = CompileTime.buildDate();
		return DateTools.format(buildTime, "%H:%M:%S on %Y-%m-%d");
	}
}