import 'package:cbs_notes_flutter/presentation/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/notes_bloc.dart';
import '../../bloc/notes_event.dart';
import '../../data/models/note.dart';

class NotesEditPage extends StatefulWidget {
  final Note note;

  const NotesEditPage({super.key, required this.note});

  @override
  State<NotesEditPage> createState() => _NotesEditPageState();
}

class _NotesEditPageState extends State<NotesEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isEdited = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);

    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isEdited = _titleController.text != widget.note.title ||
          _contentController.text != widget.note.content;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isEdited,
      onPopInvokedWithResult: (bool didPop, bool? _) {
        if (!_isEdited || didPop) {
          return;
        }
        showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Discard changes?'),
            content: const Text(
                'You have unsaved changes. Do you want to discard them?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Discard'),
              ),
            ],
          ),
        ).then((dialogResult) {
          final shouldPop = dialogResult ?? false;
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        });
      },
      child: Scaffold(
        appBar: AppBar(
          leading: AppBackButton(),
          leadingWidth: 60,
          title: Text(widget.note.title.isEmpty ? 'New Note' : 'Edit Note'),
          actions: [
            if (_isEdited)
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton.filled(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(const Color(0xFF3D3D3D)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  onPressed: _saveNote,
                ),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Type something...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                maxLines: null,
                minLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() {
    final updatedNote = widget.note.copyWith(
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
    );

    if (widget.note.title.isEmpty && widget.note.content.isEmpty) {
      context.read<NotesBloc>().add(AddNote(updatedNote));
    } else {
      context.read<NotesBloc>().add(UpdateNote(updatedNote));
    }

    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
}
