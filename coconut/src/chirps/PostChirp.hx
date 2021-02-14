package chirps;

import general_tools.InputType;
import bootstrap.Button;
import bootstrap.Container.Row;
import coconut.vdom.View;
import general_tools.MyTextInput;


class PostChirp extends View {

    @:state var msg:String = "";
    @:attribute var postChirp:String->Void;

    public function setMsg(v:String){
        msg = v;
    }

    public function buttonClick(_){
        postChirp(msg);
    }

    function render(){
        //TODO: currently this will not re-render when user signs in
        //need to make this "coconut implicit" or something...
        if (GlobalState.ensure().userToken.length == 0){
            return <p>Sign in before you start chirping</p>;
        }
        return hxx(
            <Row>
                <MyTextInput type=${InputType.Text} placeholder="message" onTextChange=${setMsg}></MyTextInput>
                <Button onclick=${buttonClick}>Send</Button>
            </Row>
        );
    }
}
