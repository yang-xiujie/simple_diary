import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as Firebase;
import 'package:firebase/firestore.dart';
import 'package:simple_diary/blocs/authentication_bloc.dart';
import 'package:simple_diary/blocs/authentication_bloc_provider.dart';
import 'package:simple_diary/blocs/home_bloc_provider.dart';
import 'package:simple_diary/blocs/home_bloc.dart';
import 'package:simple_diary/services/authentication.dart';
import 'package:simple_diary/pages/login.dart';
import 'package:simple_diary/pages/home.dart';
import 'package:simple_diary/services/diary_db.dart';
Future<void> main() async{
  if(Firebase.apps.isEmpty){
    Firebase.initializeApp(
        apiKey: "AIzaSyBV5kZWe3-9632vCeksSPAKbxO3bQsrs-0",
        authDomain: "diary-74f9b.firebaseapp.com",
        databaseURL: "https://diary-74f9b.firebaseio.com",
        projectId: "diary-74f9b",
        storageBucket: "diary-74f9b.appspot.com",
        messagingSenderId: "809943430631",
        appId: "1:809943430631:web:af8956859fc8ff3a9bf942",
        measurementId: "G-R35YLWJERS"
    );
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Authentication _authenticationService = Authentication();
    final AuthenticationBloc _authenticationBloc = AuthenticationBloc(authenticationApi: _authenticationService);
    return AuthenticationBlocProvider(
      authenticationBloc: _authenticationBloc,
      child: StreamBuilder(
        initialData: null,
        stream: _authenticationBloc.user,
        builder: (context, snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Container(
              color:Colors.lightGreen,
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.hasData){
            print('Main Snapshot data: ${snapshot.data}');
            return HomeBlocProvider(
              homeBloc: HomeBloc(DiaryDB(),_authenticationService,snapshot.data),
              uid: snapshot.data,
              child: _buildMaterialApp(Home()),
            );
          }
          else{
            return _buildMaterialApp(Login());
          }
        },
      ),
    );
  }
  MaterialApp _buildMaterialApp(Widget HomePage){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Simple Diary',
      theme:  ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.blueAccent.shade50,
        bottomAppBarColor: Colors.blue,
      ),
      home: HomePage,
    );
  }
}


