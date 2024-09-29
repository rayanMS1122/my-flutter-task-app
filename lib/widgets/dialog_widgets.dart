import 'package:serenity_tasks/utils/task_tile.dart';
import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  final Function(TaskTile) onAddTask;

  const AddTaskDialog({super.key, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Task'),
      content: TextField(
        controller: titleController,
        decoration: const InputDecoration(hintText: 'Enter task title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              onAddTask(TaskTile(
                id: DateTime.now().toString(),
                title: titleController.text,
                date: DateTime.now().toString(),
                isComplete: false,
                checkOnPress: () {},
                deleteOnPress: () {},
              ));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class EditTaskDialog extends StatelessWidget {
  final TextEditingController editTitleController;
  final Function(TaskTile) onAddTask;

  const EditTaskDialog(
      {super.key, required this.editTitleController, required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Task'),
      content: TextField(
        controller: editTitleController,
        decoration: const InputDecoration(hintText: 'Edit task title'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onAddTask(TaskTile(
              id: DateTime.now().toString(),
              title: editTitleController.text,
              date: DateTime.now().toString(),
              isComplete: false,
              checkOnPress: () {},
              deleteOnPress: () {},
            ));
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
