import 'package:flutter/material.dart';
import 'package:simple_diary/blocs/diary_edit_bloc.dart';
import 'package:simple_diary/blocs/diary_edit_bloc_provider.dart';

class EditEntry extends StatefulWidget {
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  DiaryEditBloc _diaryEditBloc;
  TextEditingController _noteController;
  TextEditingController _titleController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _noteController=TextEditingController();
    _titleController=TextEditingController();
    _noteController.text='';
    _titleController.text='';
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _diaryEditBloc = DiaryEditBlocProvider.of(context).diaryEditBloc;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _noteController.dispose();
    _titleController.dispose();
    _diaryEditBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _addOrUpdateDiary(){
      _diaryEditBloc.saveDiaryChange.add("Save");
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StreamBuilder(
                stream: _diaryEditBloc.title,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Container();
                  }
                    //preventing bounce to first character
                  _titleController.value = _titleController.value.copyWith(text:snapshot.data);
                  return TextField(
                    controller: _titleController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      icon: Icon(Icons.title),
                    ),
                    onChanged: _diaryEditBloc.titleChange.add,
                  );
                },
              ),
              SizedBox(height: 15,),
             // SizedBox(width: double.infinity, child: Text(_diaryEditBloc.diary.date),),
              StreamBuilder(
                stream: _diaryEditBloc.note,
                builder: (context,snapshot){
                  if(!snapshot.hasData){
                    return Container();
                  }
                  _noteController.value = _noteController.value.copyWith(text:snapshot.data);
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    decoration: InputDecoration(
                      labelText: 'Diary',
                      icon: Icon(Icons.note)
                    ),
                    onChanged: _diaryEditBloc.noteChange.add,
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    child: Text('Cancel'),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),
                  SizedBox(width: 10.0,),
                  FlatButton(
                    child: Text('Save'),
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      _addOrUpdateDiary();
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
