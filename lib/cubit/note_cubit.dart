import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test_sqflite_app/model/note_model.dart';

import 'note_state.dart';



class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(NoteInitial());
  
  
  static NoteCubit get(context)=>BlocProvider.of(context);
  

  var titleController=TextEditingController();
  var descriptionController=TextEditingController();

  late Database db;

  String tableName="Note";

  Future<void> createDatabase()async{
    emit(TableCreatedLoadingState());
    await openDatabase("note3.db",
    version: 3,
    onCreate: (db,version)async{
      await db.execute("CREATE TABLE $tableName(id INTEGER PRIMARY KEY,title TEXT,description TEXT)").then((value) {
        emit(TableCreatedSuccessfullyState());
      }).catchError((error){
        emit(TableCreatedErrorState(error: error.toString()));
      });
    },
    onOpen: (db){
      getFromDatabase(db);
    }).then((value) {
      db=value;

      emit(TableCreatedSuccessfullyState());

    }).catchError((error){
      emit(TableCreatedErrorState(error: error.toString()));

    });
  }
List<NoteModel> noteModel=[];
  Future<void> getFromDatabase(db)async{
    await  db.rawQuery("SELECT * FROM $tableName").then((value) {
noteModel=List<NoteModel>.from((value as List).map((e) => NoteModel.fromJson(e)));
print("listtt ${noteModel}");

    });

  }
Future<void> insertIntoDatabase({
  required String title,
  required String description,
})async{

    emit(InsertIntoDatabaseLoadingState());
    await db.transaction((txn) async{
      await txn.rawQuery('INSERT INTO $tableName(title,description)VALUES("$title","$description")')
          .then((value) {

        emit(InsertIntoDatabaseSuccessfullyState());
      }).catchError((error){
        emit(InsertIntoDatabaseErrorState(error: error.toString()));
      });

    });
}
}
