import 'package:flutter/material.dart';
import 'package:simple_diary/blocs/authentication_bloc.dart';
import 'package:simple_diary/blocs/authentication_bloc_provider.dart';
import 'package:simple_diary/blocs/home_bloc.dart';
import 'package:simple_diary/blocs/login_bloc.dart';
import 'package:simple_diary/blocs/home_bloc_provider.dart';
import 'package:simple_diary/services/authentication.dart';
import 'package:simple_diary/models/diary.dart';
import 'package:simple_diary/services/diary_db.dart';
import 'package:simple_diary/blocs/diary_edit_bloc_provider.dart';
import 'package:simple_diary/blocs/diary_edit_bloc.dart';
import 'edit_entry.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthenticationBloc _authenticationBloc;
  HomeBloc _homeBloc;
  String _uid;
  LoginBloc _loginBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = LoginBloc(Authentication());

  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    print('Change dependencies');
    super.didChangeDependencies();
    _authenticationBloc = AuthenticationBlocProvider.of(context).authenticationBloc;
    _homeBloc = HomeBlocProvider.of(context).homeBloc;
    _uid = HomeBlocProvider.of(context).uid;
    print('uid $_uid');
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _loginBloc.dispose();
    _homeBloc.dispose();
    super.dispose();
  }
  void _addOrEditDiary({bool add,Diary diary}){
    Navigator.push(
        context,MaterialPageRoute(
      builder: (context)=>DiaryEditBlocProvider(
        diaryEditBloc: DiaryEditBloc(add,diary,DiaryDB()),
        child:EditEntry(),
      ),
      fullscreenDialog: true,
    )
    );
  }
  Future<bool> _confirmDeleteDiary() async{
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text('Delete Diary'),
            content: Text("Are your sure you would like to delete?"),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.pop(context,false);
                },
              ),
              FlatButton(
                child: Text('Delete',style: TextStyle(color: Colors.red),),
                onPressed: (){
                  Navigator.pop(context,true);
                },
              )
            ],
          );
        }
    );
  }
  Widget _buildListViewSeparated(AsyncSnapshot snapshot){
    print('Snapshot length: ${snapshot.data.length}');
    return ListView.separated(
        itemBuilder: (context,index){
          String _titleDate = snapshot.data[index].date;
          String _subtitle = snapshot.data[index].note;

          return Dismissible(
            key: Key(snapshot.data[index].documentID),
            background: Container(
              color:Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right:16.0),
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: ListTile(
              leading: Column(
                children: <Widget>[
                  Text(_titleDate)
                ],

              ),
              title: Text(
                snapshot.data[index].title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                  _subtitle
              ),
              onTap: (){
                _addOrEditDiary(
                    add:false,
                    diary:snapshot.data[index]
                );
              },
            ),
            confirmDismiss: (direction) async{
              bool confirmDelete = await _confirmDeleteDiary();
              if(confirmDelete){
                _homeBloc.deleteDiary.add(snapshot.data[index]);
              }
              return confirmDelete;
            },
          );
        },
        separatorBuilder: (context,index){
          return Divider(
            color: Colors.grey,
          );
        },
        itemCount: snapshot.data.length);
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(32.0),
        ),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: (){
            _authenticationBloc.logoutUser.add(true);
          },)
        ],
      ),
      body: StreamBuilder(
        stream: _homeBloc.firestoreApi.getDiaryList(_uid),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.hasData){
            return _buildListViewSeparated(snapshot);
          }else{
            return Center(
              child: Container(
                child: Text('Add Journals'),
              ),
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Container(
          height:44.0,

        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Diary Entry',
        child: Icon(Icons.add),
        onPressed: (){
          _addOrEditDiary(add:true,diary:Diary(uid:_uid));
        },
      ),
    );
  }
}
