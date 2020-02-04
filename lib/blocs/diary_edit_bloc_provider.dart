import 'package:flutter/material.dart';
import 'diary_edit_bloc.dart';
import 'Package:simple_diary/models/diary.dart';
class DiaryEditBlocProvider extends InheritedWidget{
  final DiaryEditBloc diaryEditBloc;
  final bool add;
  final Diary diary;
  const DiaryEditBlocProvider({Key key, Widget child, this.diaryEditBloc,this.add,this.diary}):super(key:key,child:child);
  static DiaryEditBlocProvider of(BuildContext context){
    return context.dependOnInheritedWidgetOfExactType<DiaryEditBlocProvider>();
  }
  @override
  bool updateShouldNotify(DiaryEditBlocProvider oldWidget) => diaryEditBloc!=oldWidget.diaryEditBloc;

}