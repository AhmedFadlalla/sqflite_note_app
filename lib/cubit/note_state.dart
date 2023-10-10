
abstract class NoteState {}

class NoteInitial extends NoteState {}
class TableCreatedSuccessfullyState extends NoteState {}
class TableCreatedLoadingState extends NoteState {}
class TableCreatedErrorState extends NoteState {
  final String error;

  TableCreatedErrorState({
    required this.error});
}

class InsertIntoDatabaseSuccessfullyState extends NoteState {}
class InsertIntoDatabaseLoadingState extends NoteState {}
class InsertIntoDatabaseErrorState extends NoteState {
  final String error;

  InsertIntoDatabaseErrorState({
    required this.error});
}




