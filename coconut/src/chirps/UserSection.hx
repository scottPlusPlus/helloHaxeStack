package chirps;

import tink.CoreApi.Noise;
import tink.core.Promise;
import general_tools.InputType;
import haxe.Constraints.IMap;

import bootstrap.Button;
import coconut.vdom.View;
import bootstrap.*;
import bootstrap.Container.Row;
import bootstrap.Container.Col;
import zenlog.Log;
import hawk.datatypes.Email as EmailT;
import hawk.datatypes.Password as PasswordT;

import general_tools.MyTextInput;

import String.fromCharCode in f;


using hawk.util.OutcomeX;


class UserSection  extends View {

    final REGISTER = "REGISTER";
    final SIGN_IN = "SIGN_IN";
    
    @:state var userID:String = "";
    @:state var email:String = "";
    @:state var token:String = "";

    @:state var intent:String = REGISTER;
    @:state var formPass:String = "";

    function signOut(_){
        userID = "";
        email = "";
        token = "";
    }

    function register(data:SignInData){
        var url = "api/register";
        var p = APIUtil.makePost(url, data);
        handleAuthResponse(p, data);
    }

    function signIn(data:SignInData){
        var url = "api/signin";
        var p = APIUtil.makePost(url, data);
        handleAuthResponse(p, data);
    }

    function handleAuthResponse(p:Promise<String>, data:SignInData){
        p.next(function(str:String){
            return hawk.util.Json.jsonToAnonMap(str);
        }).next(function(map:IMap<String,String>){
            userID = map.get("id");
            token = map.get("token");
            GlobalState.ensure().userToken = token;
            email = data.email;
            return Noise;
        }).eager();
    }

    function intentRegister(_){
        intent = REGISTER;
    }

    function intentSignIn(_){
        intent = SIGN_IN;
    }


    function render() 
        <div>
            <if {userID.length > 0}>
            <Row>
            <p>You are signed in as ${email}</p>
            <Button onclick=${signOut}>Sign Out</Button>
            </Row>
            <else>
            <Row>
                <Button onclick=${intentRegister}>Register</Button>
                <Button onclick=${intentSignIn}>Sign In</Button>
            </Row>
                <if {intent == REGISTER}>
                    <RegisterForm onSubmit=${register}/>
                <else>
                    <SignInForm onSubmit=${signIn}/>
                </if>
            </if>
        </div>;
}

typedef SignInData = {
    var email:EmailT;
    var password:PasswordT;
}


class SignInForm extends View {

    @:state var formEmail:String = "";
    @:state var formPass:String = "";

    @:state var error:String = "";

    @:attribute var onSubmit:SignInData->Void;

    function setEmail(v){
        formEmail = v;
    }

    function setPass(v){
        formPass = v;
    }

    function submit(_){
        var validateEmail = EmailT.createValid(formEmail);
        if (validateEmail.isFailure()){
            error = validateEmail.failure().message;
            return;
        }
        var validatePass = PasswordT.createValid(formPass);
        if (validatePass.isFailure()){
            error = validatePass.failure().message;
            return;
        }
        var data = {
            email:validateEmail.sure(),
            password:validatePass.sure(),
        };
        onSubmit(data);
    }

    function render() 
        <div>
            <if {error.length > 0}>
                <p>{error}</p>
            </if>
            <MyTextInput type=${InputType.Text} placeholder="email" onTextChange=${setEmail}></MyTextInput>
            <MyTextInput type=${InputType.Password} placeholder="password" onTextChange=${setPass}></MyTextInput>
            <Button onclick=${submit}>Submit</Button>
        </div>;
}


class RegisterForm extends View {

    @:state var formEmail:String = "";
    @:state var formPass:String = "";
    @:state var formPassConfirm:String = "";

    @:state var error:String = "";

    @:attribute var onSubmit:SignInData->Void;


    function setEmail(v){
        formEmail = v;
    }

    function setPass(v){
        formPass = v;
    }

    function setPassConfirm(v){
        formPassConfirm = v;
    }

    function submit(_){
        var validateEmail = EmailT.createValid(formEmail);
        if (validateEmail.isFailure()){
            error = validateEmail.failure().message;
            return;
        }

        if (formPass != formPassConfirm){
            error = "Passwords should match";
            return;
        }

        var validatePass = PasswordT.createValid(formPass);
        if (validatePass.isFailure()){
            error = validatePass.failure().message;
            return;
        }

        var data = {
            email:validateEmail.sure(),
            password:validatePass.sure(),
        };
        onSubmit(data);
    }

    function render() 
        <div>
            <if {error.length > 0}>
                <p>{error}</p>
            </if>
            <MyTextInput type=${InputType.Text} placeholder="email" onTextChange=${setEmail}></MyTextInput>
            <MyTextInput type=${InputType.Password} placeholder="password" onTextChange=${setPass}></MyTextInput>
            <MyTextInput type=${InputType.Password} placeholder="password again" onTextChange=${setPassConfirm}></MyTextInput>
            <Button onclick=${submit}>Submit</Button>
        </div>;
}
