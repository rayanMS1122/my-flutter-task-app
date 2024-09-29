import 'package:serenity_tasks/widgets/add_note_dialog.dart';
import 'package:serenity_tasks/widgets/edit_note_dialog.dart';
import 'package:serenity_tasks/utils/note.dart';
import 'package:serenity_tasks/utils/note_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final NotesService _notesService = NotesService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: StreamBuilder<List<Note>>(
          stream: _getNotesStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No notes available'));
            }

            final notes = snapshot.data!;
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: GestureDetector(
                    onDoubleTap: () =>
                        _showEditNoteDialog(note.id, note.content),
                    child: ListTile(
                      title: Text(note.content,
                          style: const TextStyle(fontSize: 18)),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy').format(note.date),
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () =>
                                _showEditNoteDialog(note.id, note.content),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteNote(note.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Notes',
        style: TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
    );
  }
  

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showAddNoteDialog(),
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, size: 36, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
    );
  }

  Stream<List<Note>> _getNotesStream() {
    return _notesService.getNotesStream(userId);
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) => AddNoteDialog(
        onAddNote: (noteId, content, date) {
          if (content.isNotEmpty) {
            _notesService.saveNote(
              userId,
              Note(
                id: noteId,
                content: content,
                date: DateTime.now(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Note content cannot be empty')),
            );
          }
        },
      ),
    );
  }

  void _showEditNoteDialog(String noteId, String currentContent) {
    showDialog(
      context: context,
      builder: (context) => EditNoteDialog(
        noteId: noteId,
        currentContent: currentContent,
        onEditNote: (updatedContent) {
          _notesService.updateNoteContent(userId, noteId, updatedContent);
        },
      ),
    );
  }

  void _deleteNote(String noteId) {
    _notesService.deleteNote(userId, noteId);
  }
}
