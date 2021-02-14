package general_tools.apitest;

import bootstrap.ListGroup;
import coconut.vdom.View;

class FormattedText extends View {
    @:attribute var val:String;

    function render() {
        var lines = val.split("\n");
        return hxx(
            <div>
                <for ${line in lines}>
                    <pre>${line}</pre>
                </for>
            </div>
        );
    }
}
