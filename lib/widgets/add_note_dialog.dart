import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AddNoteDialog extends StatefulWidget {
  final void Function(String noteId, String content, String date) onAddNote;

  const AddNoteDialog({
    super.key,
    required this.onAddNote,
  });

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  final TextEditingController _contentController = TextEditingController();
  DateTime _selectedDay = DateTime.now();
  String _formattedDate = DateFormat("d MMMM yyyy").format(DateTime.now());
  bool _isFavorite = false; // Neue Variable

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add New Note',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_contentController, 'Note Content'),
              const SizedBox(height: 20),
              ListTile(
                leading:
                    const Icon(Icons.date_range, size: 30, color: Colors.grey),
                title: Text(
                  _formattedDate,
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                ),
                onTap: () {
                  _showDatePicker();
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: _isFavorite,
                    onChanged: (value) {
                      setState(() {
                        _isFavorite = value ?? false;
                      });
                    },
                  ),
                  const Text('Favorite'),
                ],
              ),
              const SizedBox(height: 30),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime(2020, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    ).then((pickedDate) {
      if (pickedDate != null && pickedDate != _selectedDay) {
        setState(() {
          _selectedDay = pickedDate;
          _formattedDate = DateFormat("d MMMM yyyy").format(_selectedDay);
        });
      }
    });
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      maxLines: 5,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 18,
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 18,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildDialogActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              color: Colors.redAccent,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              String noteId =
                  FirebaseFirestore.instance.collection('notes').doc().id;

              widget.onAddNote(
                noteId,
                _contentController.text,
                _formattedDate,
              );

              FirebaseFirestore.instance.collection('notes').doc(noteId).set({
                'content': _contentController.text,
                'date': _formattedDate,
              });

              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // ignore: prefer_const_constructors
                  content: Row(
                    children: const [
                      Icon(Icons.warning, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "The note content can't be empty!",
                          style: TextStyle(
                            fontFamily: 'PlayfairDisplay',
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.grey,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 6.0,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Add Note',
            style: TextStyle(
              fontFamily: 'PlayfairDisplay',
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
