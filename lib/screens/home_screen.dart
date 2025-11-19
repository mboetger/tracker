import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/providers/task_provider.dart';
import 'package:tracker/screens/add_task_screen.dart';
import 'package:tracker/widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Tracker'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, provider, child) {
          if (provider.tasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks yet.\nTap + to add one!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 16),
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.tasks.length,
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            itemBuilder: (context, index) {
              return TaskTile(task: provider.tasks[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        backgroundColor: const Color(0xFF00E699),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
