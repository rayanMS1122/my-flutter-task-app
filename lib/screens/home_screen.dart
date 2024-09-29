import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:serenity_tasks/utils/firestore_service.dart';
import 'package:serenity_tasks/widgets/edit_task_dialog.dart';
import 'package:serenity_tasks/widgets/add_task_dialog.dart';
import 'package:serenity_tasks/widgets/custom_drawer.dart';
import 'package:serenity_tasks/screens/finished_screen.dart';
import 'package:serenity_tasks/utils/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  final String userId = FirebaseAuth.instance.currentUser?.uid ?? "";
  List<TaskTile> taskTiles = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// Random generator for motivational messages

  @override
  void initState() {
    super.initState();
    _loadTaskTiles();
  }

  Future<void> _loadTaskTiles() async {
    final tasks = await _firestoreService.getTaskTiles(userId);
    setState(() {
      taskTiles = tasks.where((task) => !task.isComplete).toList();
    });
  }

  void _editTask(TaskTile task) {
    showDialog(
      context: context,
      builder: (context) {
        final titleEditingController = TextEditingController(text: task.title);
        return EditTaskDialog(
          editTitleController: titleEditingController,
          onAddTask: (updatedTask) async {
            setState(() {
              task.title = titleEditingController.text;
            });
            await _firestoreService.updateTaskTitleAndDate(
              userId,
              task.id,
              task.title,
              DateTime.now(),
            );
          },
        );
      },
    );
  }

  void _deleteTask(String taskId) {
    _firestoreService.deleteTask(userId, taskId);
    setState(() {
      taskTiles.removeWhere((task) => task.id == taskId);
    });
  }

  void _addTask(TaskTile task) {
    setState(() {
      taskTiles.add(task);
      _firestoreService.saveTaskTile(userId, task);
    });
  }

  void _finishTask(TaskTile task) {
    setState(() {
      task.isComplete = !task.isComplete;
    });
    _firestoreService.updateTaskCompletionStatus(userId, task.id, true);
  }

  void _openFinishedScreen() async {
    final shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FinishedScreen()),
    );

    if (shouldRefresh == true) {
      _loadTaskTiles();
    }
  }

  String _parseDateString(String dateString) {
    try {
      DateTime parsedDate = DateFormat('dd MMMM yyyy').parse(dateString);
      return DateFormat('dd.MM.yyyy').format(parsedDate);
    } catch (e) {
      return 'Invalid date';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              // flex: 2,
              child: _buildAppBar(),
            ),
            Expanded(
              flex: 8,
              child: ListView.builder(
                itemCount: taskTiles.length,
                itemBuilder: (context, index) {
                  final task = taskTiles[index];
                  return _buildTaskCard(task);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        const Text(
          'Your Tasks',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.check),
          onPressed: () {
            _openFinishedScreen();
          },
        )
      ],
    );
  }

  Widget _buildTaskCard(TaskTile task) {
    return GestureDetector(
      onTap: () => _finishTask(task),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: task.isComplete
                ? [Colors.grey.shade300, Colors.grey.shade500]
                : [Colors.white, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: task.isComplete ? Colors.grey : Colors.black,
                  decoration:
                      task.isComplete ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text(
                // ignore: unnecessary_type_check
                task.date is String
                    ? _parseDateString(task.date)
                    : DateFormat('dd.MM.yyyy').format(task.date as DateTime),
                style:
                    const TextStyle(color: Colors.grey, fontFamily: "Schyler"),
              ),
              trailing: _buildTaskActions(task),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskActions(TaskTile task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
    
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width * .15,
          height: MediaQuery.sizeOf(context).height * .05,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(55),
          ),
          child: MaterialButton(
            onPressed: () => _editTask(task),
            child: Image.asset(
              "assets/icons/edit-47-32.png",
              color: task.isComplete ? Colors.black45 : Colors.black,
            ),
          ),
        ),
        Container(
          width: MediaQuery.sizeOf(context).width * .15,
          height: MediaQuery.sizeOf(context).height * .05,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(55),
          ),
          child: MaterialButton(
            onPressed: () => _deleteTask(task.id),
            child: Image.asset(
              scale: .1,
              "assets/icons/delete_icon/icons8-löschen-24.png",
              color: task.isComplete ? Colors.red.shade300 : Colors.red,
            ),
          ),
        ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AddTaskDialog(onAddTask: _addTask);
          },
        );
      },
      child: const Icon(Icons.add, size: 36),
      elevation: 10,
      backgroundColor: const Color.fromARGB(255, 128, 128, 128),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
