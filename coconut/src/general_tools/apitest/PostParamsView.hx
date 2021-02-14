package general_tools.apitest;

import bootstrap.Container;
import bootstrap.Container.*;
import bootstrap.ListGroup;
import bootstrap.Button;
import coconut.vdom.View;

class PostParamsView extends View {

    @:attribute var params:coconut.data.List<Param>;

    @:attribute var addParam:Void->Void;
    @:attribute var removeParam:Int->Void;
    @:attribute var setParamKey:Int->String->Void;
    @:attribute var setParamVal:Int->String->Void;

    function render()
    <div>
        <Button onclick=${function(_){addParam();}}>Add Param</Button>

        <ListGroup className="mb-1">
        <items>
            <for ${p in params}>
                <item>
                <Row>
                    <Col>
                        ${p.id} 
                    </Col>
                    <Col>
                        <MyTextInput type=${InputType.Text} placeholder="key" onTextChange=${ function(v){ setParamKey(p.id, v);} }></MyTextInput>
                    </Col>
                    <Col>
                        <MyTextInput type=${InputType.Text} placeholder="value" onTextChange=${function(v){ setParamVal(p.id, v);}  }></MyTextInput>
                    </Col>
                </Row>
                <Button onclick=${removeParam(p.id)}>Remove</Button>
                </item>
            </for>
        </items>
        </ListGroup>
    </div>
    ;
}

