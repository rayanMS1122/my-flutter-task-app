import 'package:serenity_tasks/screens/home_screen.dart';
import 'package:serenity_tasks/utils/firestore_service.dart';
import 'package:serenity_tasks/utils/task_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinishedScreen extends StatefulWidget {
  const FinishedScreen({super.key});

  @override
  State<FinishedScreen> createState() => _FinishedScreenState();
}

class _FinishedScreenState extends State<FinishedScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  List<TaskTile> finishedTasks = [];

  @override
  void initState() {
    super.initState();
    _loadFinishedTasks();
  }

  Future<void> _loadFinishedTasks() async {
    final tasks = await _firestoreService.getTaskTiles(userId);
    setState(() {
      finishedTasks = tasks.where((task) => task.isComplete).toList();
    });
  }

  String _parseDateString(String dateString) {
    try {
      DateTime parsedDate = DateFormat('dd MMMM yyyy').parse(dateString);
      return DateFormat('dd.MM.yyyy').format(parsedDate);
    } catch (e) {
      print('Fehler beim Parsen des Datums: $e');
      return 'Ungültiges Datum';
    }
  }

  void _unFinishTask(TaskTile task) {
    setState(() {
      task.isComplete = false; // Mark the task as incomplete
      _firestoreService.updateTaskCompletionStatus(
        userId,
        task.id,
        false, // Update task status in Firestore
      );
      finishedTasks.remove(task); // Remove it from the finished list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: finishedTasks.isEmpty
          ? const Center(
              child: Text("Keine abgeschlossenen Aufgaben.",
                  style: TextStyle(fontSize: 18, color: Colors.grey)))
          : _buildTaskList(),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: finishedTasks.length,
      itemBuilder: (context, index) {
        final task = finishedTasks[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              title: Text(
                task.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                task.date is String
                    ? _parseDateString(task.date)
                    : DateFormat('dd.MM.yyyy').format(task.date as DateTime),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              trailing: IconButton(
                onPressed: () {
                  _unFinishTask(task);
                },
                icon: const Icon(Icons.restore, color: Colors.orange),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      // backgroundColor: Colors.blueAccent,
      leading: IconButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text(
        'Completed Tasks',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          // color: Colors.white,
        ),
      ),
      centerTitle: true,
    );
  }
}
