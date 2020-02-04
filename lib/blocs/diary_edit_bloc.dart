import 'dart:async';
import 'package:simple_diary/models/diary.dart';
import 'package:simple_diary/services/firestore_api.dart';

class DiaryEditBloc{
  final FirestoreApi firestoreApi;
  final bool add;
  Diary diary;
  final StreamController<String> _titleController = StreamController<String>.broadcast();
  Sink<String> get titleChange => _titleController.sink;
  Stream<String> get title => _titleController.stream;
//  final StreamController<String> _moodController = StreamController<String>.broadcast();
//  Sink<String> get moodChange => _moodController.sink;
//  Stream<String> get mood => _moodController.stream;
  final StreamController<String> _noteController = StreamController<String>.broadcast();
  Sink<String> get noteChange => _noteController.sink;
  Stream<String> get note => _noteController.stream;
  final StreamController<String> _saveDiaryController = StreamController<String>.broadcast();
  Sink<String> get saveDiaryChange => _saveDiaryController.sink;
  Stream<String> get saveDiary => _saveDiaryController.stream;
  DiaryEditBloc(this.add,this.diary,this.firestoreApi){
    _startEditListeners().then((finished)=>_getDiary(add,diary));
  }

  void dispose(){
    //_moodController.close();
    _noteController.close();
    _saveDiaryController.close();
    _titleController.close();
  }
  Future<bool> _startEditListeners() async{
    _titleController.stream.listen((title){
      diary.title=title;
    });
   // _moodController.stream.listen((mood){
     // diary.mood=mood;
   // });
    _noteController.stream.listen((note){
      diary.note=note;
    });
    _saveDiaryController.stream.listen((action){
      if(action=='Save'){
        _saveDiary();
      }
    });
  }
  void _getDiary(bool add,Diary selectedDiary){
    if(add){
      diary = Diary();
      diary.date = DateTime.now().toString();
      //diary.mood ='Happy Mood';
      diary.note='';
      diary.uid=selectedDiary.uid;
      diary.title='';
    }
    else{
      diary.date = selectedDiary.date;
      //diary.mood=selectedDiary.mood;
      diary.note = selectedDiary.note;
      diary.title = selectedDiary.title;
    }
    //moodChange.add(diary.mood);
    noteChange.add(diary.note);
    titleChange.add(diary.title);
  }

  void _saveDiary(){
    Diary savedDiary = Diary(
      documentID: diary.documentID,
      date:diary.date,
     // mood:diary.mood,
      note:diary.note,
      uid:diary.uid,
        title:diary.title
    );
    add ? firestoreApi.addDiary(savedDiary): firestoreApi.updateDiary(savedDiary);
  }

}
