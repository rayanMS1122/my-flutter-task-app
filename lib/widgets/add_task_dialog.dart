import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example3/utils/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class AddTaskDialog extends StatefulWidget {
  final void Function(TaskTile task) onAddTask;
  
  const AddTaskDialog({
    super.key,
    required this.onAddTask,
  });

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final DateTime kFirstDay = DateTime(2020, 1, 1);
  final DateTime kLastDay = DateTime(2030, 12, 31);
  String date = "Date";

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
  }

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
                'Add New Task',
                style: TextStyle(
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_titleController, 'Task Title'),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.deepPurple[50],
                ),
                child: ListTile(
                  leading: Icon(Icons.date_range,
                      size: 30, color: Colors.deepPurple),
                  title: Text(
                    DateFormat("d MMMM yyyy")
                        .format(_selectedDay ?? _focusedDay),
                    style:
                        TextStyle(fontSize: 18, color: Colors.deepPurple[700]),
                  ),
                  onTap: () {
                    _showCalendarDialog(context);
                  },
                ),
              ),
              const SizedBox(height: 30),
              _buildDialogActions(context),
            ],
          ),
        ),
      ),
    );
  }

  void _showCalendarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 350,
            height: 450,
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar(
              firstDay: kFirstDay,
              lastDay: kLastDay,
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  date = DateFormat("d MMMM yyyy").format(_selectedDay!);
                });
                Navigator.pop(context);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'PlayfairDisplay',
          fontSize: 18,
          color: Colors.deepPurple,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
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
            String generatedId =
                FirebaseFirestore.instance.collection('tasks').doc().id;

            if (_titleController.text.isNotEmpty) {
              widget.onAddTask(
                TaskTile(
                  id: generatedId,
                  deleteOnPress: () {},
                  checkOnPress: () {},
                  title: _titleController.text,
                  date: DateFormat("d MMMM yyyy").format(_focusedDay),
                ),
              );
              Navigator.pop(context);
            } else {
              final snackBar = SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "The Title can't be empty!",
                        style: TextStyle(
                          fontFamily: 'PlayfairDisplay',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                action: SnackBarAction(
                  onPressed: () {
                    // Action to take
                  },
                  label: "I understand",
                  textColor: Colors.yellowAccent,
                ),
                backgroundColor: Colors.deepPurple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 6.0,
              );

              ScaffoldMessenger.of(Navigator.of(context).context)
                  .showSnackBar(snackBar);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Add Task',
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
