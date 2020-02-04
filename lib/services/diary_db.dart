
import 'package:simple_diary/models/diary.dart';
import 'package:simple_diary/services/firestore_api.dart';
import 'package:firebase/firebase.dart' as Firebase;
import 'package:firebase/firestore.dart';
class DiaryDB implements FirestoreApi{
  final Firestore _fireStore = Firebase.firestore();
  String _collectionLibrary = 'Diaries';

  @override
  Future<bool> addDiary(Diary diary) async{
    DocumentReference _documentReference = await _fireStore.collection(_collectionLibrary).add({
      'title':diary.title,
      'date':diary.date,
      //'mood':diary.mood,
      'note':diary.note,
      'uid':diary.uid
    }).catchError((error)=>print(error));
    return _documentReference.id!=null;
  }

  @override
  void deleteDiary(Diary diary) async{
    // TODO: implement deleteDiary
    await _fireStore.collection(_collectionLibrary).doc(diary.documentID).delete().catchError((error)=>print('error deleteing $error'));
  }

  @override
  Stream<List<Diary>> getDiaryList(String uid) {
      return _fireStore.collection(_collectionLibrary).where('uid',"==", uid).get().asStream().map((snapshot){
        print('has new records');
        List<Diary> _diaryDocs = snapshot.docs.map((DocumentSnapshot doc)=>Diary.fromDoc(doc)).toList();
        _diaryDocs.sort((comp1,comp2)=>comp2.date.compareTo(comp1.date));
        return _diaryDocs;
      });
  }

  @override
  void updateDiary(Diary diary) async{
    await _fireStore.collection(_collectionLibrary).doc(diary.documentID).update(
        data: {
          "title":diary.title,
        "date":diary.date,
       // "mood":diary.mood,
        "note":diary.note
      }
    ).catchError((error)=>print('error on update'));
  }

}