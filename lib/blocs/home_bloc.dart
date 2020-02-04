import 'dart:async';
import 'package:simple_diary/services/authentication_api.dart';
import 'package:simple_diary/services/firestore_api.dart';
import 'package:simple_diary/models/diary.dart';

class HomeBloc{
  final FirestoreApi firestoreApi;
  final AuthenticationApi authenticationApi;
  final String uid;
  final StreamController<Diary> _diaryDeleteController = StreamController<Diary>.broadcast();
  Sink<Diary> get deleteDiary=>_diaryDeleteController.sink;
  final StreamController<List<Diary>> _diaryListController = StreamController<List<Diary>>.broadcast();
  Stream<List<Diary>> get listDiary => _diaryListController.stream;
  Sink<List<Diary>> get updateDiary=> _diaryListController.sink;
  HomeBloc(this.firestoreApi,this.authenticationApi,this.uid) {
   _startListener();
  }
  void _startListener(){
//      print('Home Bloc Listener starts');
//      firestoreApi.getDiaryList(uid).listen((docs){
//        print('Home bloc update');
//        updateDiary.add(docs);
//      });

    _diaryDeleteController.stream.listen((diary){
      print('In delete');
      firestoreApi.deleteDiary(diary);
    });
  }
  void dispose(){
    _diaryDeleteController.close();
    _diaryListController.close();
  }
}