import 'package:equatable/equatable.dart';
import '../data/models/note.dart';

abstract class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;

  const NotesLoaded(this.notes);

  @override
  List<Object> get props => [notes];
}

class NoteLoaded extends NotesState {
  final Note note;

  const NoteLoaded(this.note);

  @override
  List<Object> get props => [note];
}

class NotesError extends NotesState {
  final String message;

  const NotesError(this.message);

  @override
  List<Object> get props => [message];
}

class NoteOperationSuccess extends NotesState {
  final String message;

  const NoteOperationSuccess(this.message);

  @override
  List<Object> get props => [message];
}
