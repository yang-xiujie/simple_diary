class Diary{
  String documentID;
  String date;

  String note;
  String uid;
  String title;
  Diary({
    this.documentID,this.title,this.date,this.note,this.uid
  });
  factory Diary.fromDoc(dynamic doc)=>Diary(
    documentID: doc.id,
    title:doc.get('title'),
    date:doc.get('date'),
    note:doc.get('note'),
    uid:doc.get('uid')
  );
}