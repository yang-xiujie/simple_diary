import 'package:flutter/material.dart';
import 'package:simple_diary/blocs/login_bloc.dart';
import 'package:simple_diary/services/authentication.dart';
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  LoginBloc _loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc=LoginBloc(Authentication());
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _loginBloc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Widget _buildLoginAndCreateButtons(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            elevation: 16.0,
            child: Text('Login'),
            onPressed: (){_loginBloc.loginOrCreate.add("Login");},
          ),
          RaisedButton(
            elevation:16.0,
            child: Text('Create Account'),
            onPressed: (){
              _loginBloc.loginOrCreate.add('Create Account');
            },
          )
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Icon(Icons.account_circle,size: 88.0,color: Colors.white,),
            preferredSize: Size.fromHeight(40.0)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          //child padding size
          padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            //expanded child to full width
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              StreamBuilder(
                stream: _loginBloc.email,
                builder: (context,snapshot){
                  return TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      icon: Icon(Icons.mail_outline),
                      errorText: snapshot.error
                    ),
                    onChanged: _loginBloc.emailChange.add,
                    onSubmitted: _loginBloc.emailChange.add,
                  );
                },
              ),
              StreamBuilder(
                stream: _loginBloc.password,
                builder: (context,snapshot){
                  return TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.security),
                      errorText: snapshot.error
                    ),
                    onChanged: _loginBloc.passwordChange.add,
                    onSubmitted: _loginBloc.passwordChange.add,
                  );
                },
              ),
              SizedBox(height: 48.0,),
              _buildLoginAndCreateButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
