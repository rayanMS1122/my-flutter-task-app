import 'package:flutter/material.dart';

class TaskTile extends StatefulWidget {
  final String id;
  String title;
  final String date;
  final VoidCallback checkOnPress;
  final VoidCallback deleteOnPress;
  bool isComplete;
  bool favorite; 

  TaskTile({
    required this.id,
    required this.title,
    required this.date,
    required this.checkOnPress,
    required this.deleteOnPress,
    this.isComplete = false,
    this.favorite = false,
  });

  factory TaskTile.fromMap(Map<String, dynamic> map) {
    return TaskTile(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      isComplete: map["isComplete"] ?? false,
      checkOnPress: () {}, // Placeholder for actual callback
      deleteOnPress: () {}, // Placeholder for actual callback
    );
  }

  // Convert TaskTile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      "isComplete": isComplete,
    };
  }

  @override
  State<TaskTile> createState() => _TaskTileState();

  static fromFirestore(Map<String, dynamic> data) {}
}

class _TaskTileState extends State<TaskTile> {
  // Convert TaskTile instance to a map
  Map<String, dynamic> toMap() {
    return {
      'id': widget.id,
      'title': widget.title,
      'date': widget.date,
      "isComplete": widget.isComplete,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFDEBEB), Color(0xFFE3FDFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        leading: Checkbox(
          value: widget.isComplete,
          onChanged: (value) {
            setState(() {
              widget.isComplete = value ?? false; // Update isComplete state
            });
            widget.checkOnPress(); // Trigger the checkOnPress callback
          },
        ),
        title: Text(
          widget.title,
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            decoration: widget.isComplete ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Due in ${widget.date}',
          style: const TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.delete_outline,
            color: Colors.redAccent,
            size: 28,
          ),
          onPressed: widget.deleteOnPress,
        ),
      ),
    );
  }

  Widget _buildCheckContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IconButton(
        onPressed: widget.checkOnPress,
        icon: Icon(
          Icons.check_circle_outline,
          color: widget.isComplete ? Colors.black : Colors.red,
        ),
      ),
    );
  }
}
