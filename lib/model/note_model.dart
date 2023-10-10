import 'dart:convert';

class NoteModel {
  final String title;
  final String description;

  NoteModel(this.title, this.description);

 factory NoteModel.fromJson(Map<String,dynamic> json)=>
      NoteModel(json['title'], json['description']);
  Map<String,dynamic> toMap(){
    return {
      title:title,
      description:description,
    };
  }
}