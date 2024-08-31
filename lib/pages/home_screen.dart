import 'dart:async';
import 'package:example3/utils/firestore_service.dart';
import 'package:example3/utils/task_tile.dart';
import 'package:example3/widgets/add_task_dialog.dart';
import 'package:example3/widgets/custom_drawer.dart';
import 'package:example3/widgets/edit_task_dialog.dart'; // Ensure EditTaskDialog is correctly imported
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  final String password;

  const HomeScreen({super.key, required this.email, required this.password});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  final TextEditingController titleEditingController = TextEditingController();

  List<TaskTile> taskTiles = [];

  @override
  void initState() {
    super.initState();
    _loadTaskTiles();
  }

  void _toggleTaskCompletion(TaskTile task) {
    setState(() {
      task.isComplete = !task.isComplete;
    });
    _firestoreService.updateTaskCompletionStatus(
      userId,
      task.id,
      task.isComplete,
    );
  }

  Future<void> _saveTaskTiles(TaskTile taskTile) async {
    if (userId.isEmpty || taskTile.id.isEmpty) {
      print("User ID or Task ID is empty");
      return;
    }
    await _firestoreService.saveTaskTile(userId, taskTile);
  }

  Future<void> _loadTaskTiles() async {
    final tasks = await _firestoreService.getTaskTiles(userId);
    setState(() {
      taskTiles = tasks;
    });
  }

  void _addTask(TaskTile task) {
    setState(() {
      taskTiles.add(task);
      _saveTaskTiles(task);
    });
  }

  void _editTask(TaskTile task) {
    // Display dialog for editing task
    showDialog(
      context: context,
      builder: (context) {
        titleEditingController.text = task.title;
        return EditTaskDialog(
          editTitleController: titleEditingController,
          onAddTask: (updatedTask) async {
            setState(() {
              task.title = titleEditingController.text;
            });
            // Update task title in Firestore
            await _firestoreService.updateTaskTitleAndDate(
              userId,
              task.id,
              task.title,
              DateTime.now(), // Update date or modify based on your needs
            );
          },
        );
      },
    );
  }

  void _deleteTask(String taskId) {
    _firestoreService.deleteTask(userId, taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: taskTiles.length,
                itemBuilder: (context, index) {
                  final task = taskTiles[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: GestureDetector(
                      onDoubleTap: () {
                        _editTask(task); // Trigger task editing
                      },
                      child: TaskTile(
                        id: task.id,
                        title: task.title,
                        date: task.date,
                        isComplete: task.isComplete,
                        checkOnPress: () {
                          _toggleTaskCompletion(task);
                        },
                        deleteOnPress: () {
                          setState(() {
                            _deleteTask(task.id);
                            taskTiles.remove(task);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
      drawer: CustomDrawer(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      title: const Text(
        'Serenity Tasks',
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AddTaskDialog(
              onAddTask: _addTask,
            );
          },
        );
      },
      backgroundColor: Colors.black,
      child: const Icon(Icons.add, size: 36, color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
    );
  }
}
