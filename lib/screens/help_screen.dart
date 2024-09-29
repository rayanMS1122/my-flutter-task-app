import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Help & Support',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.teal],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            _buildSectionHeader('Frequently Asked Questions'),
            _buildFAQItem(
              'How to create a task?',
              'To create a task, tap on the "+" button on the home screen.',
            ),
            _buildFAQItem(
              'How to edit a task?',
              'Double-tap on any task to edit it.',
            ),
            _buildFAQItem(
              'How to delete a task?',
              'Swipe left on the task or tap on the delete icon to remove it.',
            ),
            const Divider(),
            _buildSectionHeader('Contact Support'),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.deepPurple),
              title: const Text('Email Support'),
              subtitle: const Text('support@serenitytasks.com'),
              onTap: () => _showSupportEmailDialog(context),
              tileColor: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const Divider(),
            _buildSectionHeader('App Tutorial'),
            ListTile(
              leading:
                  const Icon(Icons.play_circle_fill, color: Colors.deepPurple),
              title: const Text('Watch Tutorial'),
              onTap: () => _showTutorialDialog(context),
              tileColor: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const Divider(),
            _buildSectionHeader('Feedback & Suggestions'),
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.deepPurple),
              title: const Text('Send Feedback'),
              onTap: () => _showFeedbackForm(context),
              tileColor: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const Divider(),
            _buildSectionHeader('Troubleshooting Tips'),
            _buildFAQItem(
              'App not syncing?',
              'Try restarting the app or checking your internet connection.',
            ),
            _buildFAQItem(
              'Notifications not working?',
              'Ensure notifications are enabled in settings and your device permissions.',
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.deepPurple),
              title: const Text('Version Information'),
              subtitle: const Text('Version 1.0.0'),
              onTap: () {
                // Additional version information can be displayed here
              },
              tileColor: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.privacy_tip, color: Colors.deepPurple),
              title: const Text('Privacy Policy'),
              onTap: () {
                // Navigate to Privacy Policy
              },
              tileColor: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Colors.deepPurple),
              title: const Text('Terms of Service'),
              onTap: () {
                // Navigate to Terms of Service
              },
              tileColor: Colors.deepPurple.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showSupportEmailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contact Support'),
          content:
              const Text('Please send an email to support@serenitytasks.com'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTutorialDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('App Tutorial'),
          content: const Text('Tutorial video or guide goes here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showFeedbackForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Feedback & Suggestions'),
          content: const TextField(
            decoration:
                InputDecoration(hintText: 'Write your feedback here...'),
            maxLines: 4,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Submit'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
