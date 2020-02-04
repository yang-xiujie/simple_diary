import 'dart:async';
import 'package:simple_diary/classes/validators.dart';
import 'package:simple_diary/services/authentication_api.dart';

class LoginBloc with Validator{
  final AuthenticationApi authenticationApi;
  String _email;
  String _password;
  bool _emailValid;
  bool _passwordValid;
  final StreamController<String> _emailController = StreamController<String>.broadcast();
  Sink<String> get emailChange =>_emailController.sink;
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  final StreamController<String> _passwordController = StreamController<String>.broadcast();
  Sink<String> get passwordChange =>_passwordController.sink;
  Stream<String> get password =>_passwordController.stream.transform(validatePassword);
  final StreamController<String> _loginOrCreateController= StreamController<String>.broadcast();
  Sink<String> get loginOrCreate => _loginOrCreateController.sink;
  Stream<String> get logingOrCreateAction =>_loginOrCreateController.stream;
  LoginBloc(this.authenticationApi){
    _startListenerIfEmailPasswordAreValid();
  }
  void dispose(){
    _emailController.close();
    _passwordController.close();
    _loginOrCreateController.close();
  }

  void _startListenerIfEmailPasswordAreValid(){
   email.listen((email){
     _email=email;
     _emailValid=true;
   }).onError((error){
     _email='';
     _emailValid=false;
   });
   password.listen((password){
     _password=password;
     _passwordValid=true;
   }).onError((error){
     _passwordValid=false;
     _password='';
   });
    logingOrCreateAction.listen((action){
      print('Login or create action $action');
      action=='Login'?_login():_createAccount();
    });
  }
  Future<String> _login() async{
    print('Login is called');
    String _result="";
    if(_emailValid && _passwordValid){
      await authenticationApi.signInWithEmailAndPassword(email: _email,password: _password).then((user){
        print('create user $user');
        _result='Success';
      }).catchError((error){
        _result=error;
      });
      return _result;
    }else{
      return "Email and Password are not valid";
    }
  }
  Future<String> _createAccount() async{
    print('Creata account is called');
    String _result="";
    if(_emailValid && _passwordValid){
      await authenticationApi.createUserWithEmailAndPassword(email: _email,password: _password).then((user){
        print('create user $user');
        _result='Success';
        _login();
      }).catchError((error) async{
        _result=error;
      });
      return _result;
    }else{
      return 'Error creating user';
    }
  }
}