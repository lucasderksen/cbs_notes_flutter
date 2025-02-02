import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/note_repository.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteRepository repository;

  NotesBloc({required this.repository}) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<LoadNote>(_onLoadNote);
    on<AddNote>(_onAddNote);
    on<UpdateNote>(_onUpdateNote);
    on<DeleteNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading());
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError('Failed to load notes: ${e.toString()}'));
    }
  }

  Future<void> _onLoadNote(LoadNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading());
      final note = await repository.getNoteById(event.id);
      emit(NoteLoaded(note));
    } catch (e) {
      emit(NotesError('Failed to load note: ${e.toString()}'));
    }
  }

  Future<void> _onAddNote(AddNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading());
      await repository.insertNote(event.note);
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes));
      emit(NoteOperationSuccess('Note added successfully'));
    } catch (e) {
      emit(NotesError('Failed to add note: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNote(UpdateNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading());
      await repository.updateNote(event.note);
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes));
      emit(NoteOperationSuccess('Note updated successfully'));
    } catch (e) {
      emit(NotesError('Failed to update note: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNote(DeleteNote event, Emitter<NotesState> emit) async {
    try {
      emit(NotesLoading());
      await repository.deleteNote(event.id);
      final notes = await repository.getNotes();
      emit(NotesLoaded(notes));
      emit(NoteOperationSuccess('Note deleted successfully'));
    } catch (e) {
      emit(NotesError('Failed to delete note: ${e.toString()}'));
    }
  }
}
