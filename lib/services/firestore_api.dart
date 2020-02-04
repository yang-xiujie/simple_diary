import 'package:simple_diary/models/diary.dart';

abstract class FirestoreApi{
  Stream<List<Diary>> getDiaryList(String uid);
  Future<bool> addDiary(Diary diary);
  void updateDiary(Diary diary);
  void deleteDiary(Diary diary);
}