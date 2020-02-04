import 'package:firebase_auth/firebase_auth.dart';
import 'authentication_api.dart';

class Authentication implements AuthenticationApi{
  final _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<String> createUserWithEmailAndPassword({String email, String password}) async {
    print('create user');
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((result)=>result.user).catchError((error){
      print('error to create user $error');
    });
    print('Uid: ${user.uid}');
    return user.uid;
  }

  @override
  Future<String> currentUserUid() async {
    print('CurrentUserUid');
    FirebaseUser currentUser = await _firebaseAuth.currentUser();
    print('Uid: ${currentUser.uid}');
    return currentUser.uid;
  }

  @override
  FirebaseAuth getFirebaseAuth() {
    print('_firebaseAuth: $_firebaseAuth');
    return _firebaseAuth;
  }

  @override
  Future<bool> isEmailVerified() async{
    print('IsEmailVerified');
    FirebaseUser user = await _firebaseAuth.currentUser();
    print('Uid ${user.uid}');
    return user.isEmailVerified;
  }

  @override
  Future<void> sendEmailVerification() async{
    print('sendEmailVerification');
    FirebaseUser user = await _firebaseAuth.currentUser();
    print('Uid ${user.uid}');
    user.sendEmailVerification();
  }

  @override
  Future<String> signInWithEmailAndPassword({String email, String password}) async{
   print('SignInWithEmailAndPassword');
    FirebaseUser user =  await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((result)=>result.user).catchError((error){
      print('Error sign user: $error');
    });
    print('Uid ${user.uid}');
    return user.uid;
  }

  @override
  Future<void> signOut() async{
   print('SignOUt');
   await _firebaseAuth.signOut();
  }

}