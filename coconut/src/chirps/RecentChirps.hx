package chirps;

import bootstrap.ListGroup;
import coconut.vdom.View;
import bootstrap.Container.Row;
import bootstrap.Container.Col;

class RecentChirps extends View {

    @:attribute var chirps: coconut.data.List<ChirpModel>;

    function render()
        <ListGroup className="mb-1">
            <items>
                <for ${t in chirps}>
                    <item>
                    <Row>
                        <p>${Std.string(t.user)} at ${Std.string(t.time)} says:  ${t.message}</p>
                    </Row>
                    </item>
                </for>
            </items>
        </ListGroup>
    ;
}