import 'package:cbs_notes_flutter/presentation/pages/gyro_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notes_bloc.dart';
import '../../bloc/notes_event.dart';
import '../../bloc/notes_state.dart';
import '../../data/models/note.dart';
import '../widgets/note_card.dart';
import 'notes_detail_page.dart';
import 'notes_edit_page.dart';
import 'package:uuid/uuid.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(6.0, 12, 6, 12),
          child: Row(
            children: [
              if (!_isSearching)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GyroPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Notes',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
                  ),
                )
              else
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search notes...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    style: const TextStyle(fontSize: 20),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              if (!_isSearching) const Expanded(child: SizedBox.shrink()),
              IconButton.filled(
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(const Color(0xFF3D3D3D)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _searchController.clear();
                    }
                  });
                },
                icon: Icon(_isSearching ? Icons.close : Icons.search),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is NoteOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.read<NotesBloc>().add(LoadNotes());
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            final filteredNotes = _searchController.text.isEmpty
                ? state.notes
                : state.notes.where((note) {
                    final searchTerm = _searchController.text.toLowerCase();
                    return note.title.toLowerCase().contains(searchTerm) ||
                        note.content.toLowerCase().contains(searchTerm);
                  }).toList();

            if (filteredNotes.isEmpty) {
              return const Center(
                child: Text(
                  'No notes yet.\nTap + to add a new note.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Builder(
                  builder: (context) {
                    final backgroundColors = [
                      const Color(0xFFFFAB91),
                      const Color(0xFFFFCC80),
                      const Color(0xFFE7ED9B),
                      const Color(0xFF81DEEA),
                      const Color(0xFFCF94DA),
                      const Color(0xFF7FCBC3),
                      const Color(0xFFF48FB1),
                    ];
                    final List<Widget> leftColumn = [];
                    final List<Widget> rightColumn = [];
                    final int rowCount = (filteredNotes.length + 1) ~/ 2;

                    for (int r = 0; r < rowCount; r++) {
                      final int leftNoteIndex = 2 * r;
                      final int rightNoteIndex = leftNoteIndex + 1;
                      final bool evenRow = r % 2 == 0;

                      if (leftNoteIndex < filteredNotes.length) {
                        final leftNote = filteredNotes[leftNoteIndex];
                        final leftCard = Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            height: evenRow ? 200 : 150,
                            child: NoteCard(
                              color: backgroundColors[
                                  leftNoteIndex % backgroundColors.length],
                              note: leftNote,
                              onTap: () => _navigateToDetail(leftNote),
                              onDelete: () => context
                                  .read<NotesBloc>()
                                  .add(DeleteNote(leftNote.id)),
                            ),
                          ),
                        );
                        leftColumn.add(leftCard);
                      }

                      if (rightNoteIndex < filteredNotes.length) {
                        final rightNote = filteredNotes[rightNoteIndex];
                        final rightCard = Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SizedBox(
                            height: evenRow ? 150 : 200,
                            child: NoteCard(
                              color: backgroundColors[
                                  rightNoteIndex % backgroundColors.length],
                              note: rightNote,
                              onTap: () => _navigateToDetail(rightNote),
                              onDelete: () => context
                                  .read<NotesBloc>()
                                  .add(DeleteNote(rightNote.id)),
                            ),
                          ),
                        );
                        rightColumn.add(rightCard);
                      }
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(children: leftColumn)),
                        Expanded(child: Column(children: rightColumn)),
                      ],
                    );
                  },
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        onPressed: () => _navigateToDetail(
          Note(
            id: const Uuid().v4(),
            title: '',
            content: '',
            createdAt: DateTime.now(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _navigateToDetail(Note note) async {
    if (note.title.isEmpty && note.content.isEmpty) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotesEditPage(note: note),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NotesDetailPage(note: note),
        ),
      );
    }

    if (!mounted) return;

    context.read<NotesBloc>().add(LoadNotes());
  }
}
