class NavBar extends coconut.ui.View {

	@:attr var current:String;

	function render(){
		var str = current; //seems the child navitems aren't re-rendered unless accessing current here
		return hxx(
			<nav class="navbar navbar-expand-md navbar-dark bg-dark">
			<a class="navbar-brand" href="#">Navbar</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
  
			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav mr-auto">
					<NavItem text="Home" link="/" current=${current}/>
					<NavItem text="Chirp" link="/chirp" current=${current}/>
					<NavItem text="API Tester" link="/test" current=${current}/>
					<NavItem text="Other" link="/other" current=${current}/>
				</ul>
			</div>
		</nav>
		);
	}

}

class NavItem extends coconut.ui.View {

	@:attr var text:String;
	@:attr var link:String;
	@:attr var current:String;

	function cls():String{
		//trace('${link} vs ${current} ?');
		if (link == current){
			return "nav-item active";
		}
		return "nav-item";
	}

	function render() 
		<li class=${cls()}>
			<a class="nav-link" href=${link}>${text}</a>
		</li>;
}