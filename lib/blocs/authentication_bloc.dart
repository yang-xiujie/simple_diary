import 'dart:async';
import 'package:simple_diary/services/authentication_api.dart';

class AuthenticationBloc{
  final AuthenticationApi authenticationApi;
  final StreamController<String> _authenticationController = StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user=>_authenticationController.stream;
  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;
  void dispose(){
    _authenticationController.close();
    _logoutController.close();
  }
  AuthenticationBloc({this.authenticationApi}){
    onAuthChange();
  }
  void onAuthChange(){
    authenticationApi.getFirebaseAuth().onAuthStateChanged.listen((user){
      final String uid = user!=null?user.uid:null;
      addUser.add(uid);
      });
    listLogoutUser.listen((logout){
      if(logout==true){
        authenticationApi.signOut();
      }
    });
  }


}