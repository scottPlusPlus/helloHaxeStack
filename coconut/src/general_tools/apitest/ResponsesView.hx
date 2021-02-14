package general_tools.apitest;

import bootstrap.ListGroup;
import coconut.vdom.View;

class ResponsesView extends View {
    @:skipCheck @:attribute var responses:Array<String> = [];

    function render()
        // <div>
        //     ${responses}
        // </div>
        <ListGroup className="mb-1">
            <items>
                <for ${r in responses}>
                    <item>
                        <FormattedText val=${r}/>
                    </item>
                </for>
            </items>
        </ListGroup>
    ;
}
