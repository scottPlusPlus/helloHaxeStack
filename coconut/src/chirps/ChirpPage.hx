package chirps;

import chirps.ChirpSection;
import bootstrap.Jumbotron;
import bootstrap.Container;

class ChirpPage extends coconut.ui.View {

	function render() 
		<Container>
			<h2>User</h2>
			<UserSection/>
			<h2>Chirp</h2>
			<ChirpSection/>
		</Container>
    ;
}