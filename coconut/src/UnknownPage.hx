class UnknownPage extends coconut.ui.View {
	@:attr var path:String;
	function render() '
		<div>
			Page not found: ${path}
		</div>
	';
}
