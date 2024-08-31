import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example3/utils/task_tile.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Save a TaskTile
  Future<void> saveTaskTile(String userId, TaskTile taskTile) async {
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: User ID is empty.');
      } // Debugging line
      throw Exception('User ID cannot be empty.');
    }
    if (taskTile.id.isEmpty) {
      if (kDebugMode) {
        print('Error: Task ID is empty.');
      } // Debugging line
      throw Exception('Task ID cannot be empty.');
    }

    if (kDebugMode) {
      print(
          'Saving TaskTile with User ID: $userId and Task ID: ${taskTile.id}');
    } // Debugging line

    await _db
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskTile.id)
        .set(taskTile.toMap());
  }

  // Get all TaskTiles
  Future<List<TaskTile>> getTaskTiles(String userId) async {
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: User ID is empty.');
      } // Debugging line
      throw Exception('User ID cannot be empty.');
    }

    if (kDebugMode) {
      print('Fetching tasks for User ID: $userId');
    } // Debugging line

    final snapshot =
        await _db.collection('users').doc(userId).collection('tasks').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return TaskTile.fromMap(data);
    }).toList();
  }

  // Update the task's isComplete status
  Future<void> updateTaskCompletionStatus(
      String userId, String taskId, bool isComplete) async {
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: User ID is empty.');
      } // Debugging line
      throw Exception('User ID cannot be empty.');
    }
    if (taskId.isEmpty) {
      if (kDebugMode) {
        print('Error: Task ID is empty.');
      } // Debugging line
      throw Exception('Task ID cannot be empty.');
    }

    if (kDebugMode) {
      print('Updating task $taskId completion status for User ID: $userId');
    } // Debugging line

    await _db
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .update({'isComplete': isComplete});
  }

  // Update the task's title and date
  Future<void> updateTaskTitleAndDate(
      String userId, String taskId, String title, DateTime date) async {
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: User ID is empty.');
      }
      throw Exception('User ID cannot be empty.');
    }
    if (taskId.isEmpty) {
      if (kDebugMode) {
        print('Error: Task ID is empty.');
      }
      throw Exception('Task ID cannot be empty.');
    }

    if (kDebugMode) {
      print('Updating title and date for task $taskId for User ID: $userId');
    }

    // Reference the document
    final taskDoc =
        _db.collection('users').doc(userId).collection('tasks').doc(taskId);

    // Check if the document exists
    final docSnapshot = await taskDoc.get();

    if (docSnapshot.exists) {
      // Update only the title and date fields
      await taskDoc.update({
        'title': title,
        'date': DateFormat("d MMMM yyyy")
            .format(date), // Convert DateTime to ISO 8601 string
      });
    } else {
      if (kDebugMode) {
        print('Error: Task document does not exist.');
      }
      throw Exception('No task found with the provided Task ID.');
    }
  }

  // Delete a TaskTile by ID
  Future<void> deleteTask(String userId, String taskId) async {
    if (userId.isEmpty) {
      if (kDebugMode) {
        print('Error: User ID is empty.');
      } // Debugging line
      throw Exception('User ID cannot be empty.');
    }
    if (taskId.isEmpty) {
      if (kDebugMode) {
        print('Error: Task ID is empty.');
      } // Debugging line
      throw Exception('Task ID cannot be empty.');
    }

    if (kDebugMode) {
      print('Deleting task $taskId for User ID: $userId');
    } // Debugging line

    await _db
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
