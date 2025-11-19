import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:tracker/models/task.dart';
import 'package:tracker/providers/task_provider.dart';
import 'package:tracker/screens/add_task_screen.dart';
import 'package:tracker/screens/calendar_screen.dart';
import 'package:tracker/widgets/adjust_count_dialog.dart';

class TaskTile extends StatelessWidget {
  final Task task;

  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final progress = task.getProgress(today);
    final isCompleted = progress >= task.goal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Slidable(
        key: Key(task.id),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {}, // Not used because confirmDismiss returns false
            confirmDismiss: () async {
              context.read<TaskProvider>().updateTaskProgress(task.id, today, -1);
              return false; // Prevent dismissal
            },
          ),
          children: [
            CustomSlidableAction(
              onPressed: (context) {
                context.read<TaskProvider>().updateTaskProgress(task.id, today, -1);
              },
              backgroundColor: const Color(0xFFEF476F),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AdjustCountDialog(
                      task: task,
                      currentProgress: progress,
                      onSave: (newValue) {
                        context.read<TaskProvider>().updateTaskProgress(task.id, today, newValue - progress);
                      },
                    ),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove),
                    SizedBox(height: 4),
                    Text('Subtract', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(
            onDismissed: () {},
            confirmDismiss: () async {
              context.read<TaskProvider>().updateTaskProgress(task.id, today, 1);
              return false;
            },
          ),
          children: [
            CustomSlidableAction(
              onPressed: (context) {
                context.read<TaskProvider>().updateTaskProgress(task.id, today, 1);
              },
              backgroundColor: const Color(0xFF06D6A0),
              foregroundColor: Colors.white,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              child: GestureDetector(
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AdjustCountDialog(
                      task: task,
                      currentProgress: progress,
                      onSave: (newValue) {
                        context.read<TaskProvider>().updateTaskProgress(task.id, today, newValue - progress);
                      },
                    ),
                  );
                },
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add),
                    SizedBox(height: 4),
                    Text('Add', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarScreen(task: task),
              ),
            );
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: const Color(0xFF1E232E),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.edit, color: Colors.white),
                        title: const Text(
                          'Edit Task',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTaskScreen(task: task),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.delete, color: Color(0xFFEF476F)),
                        title: const Text(
                          'Delete Task',
                          style: TextStyle(
                            color: Color(0xFFEF476F),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context); // Close bottom sheet
                          // Show confirmation dialog
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E232E),
                              title: const Text('Delete Task?', style: TextStyle(color: Colors.white)),
                              content: Text(
                                'Are you sure you want to delete "${task.title}"? This cannot be undone.',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<TaskProvider>().deleteTask(task.id);
                                    Navigator.pop(context); // Close dialog
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Color(0xFFEF476F))),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E232E),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(task.colorValue).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    task.icon,
                    color: Color(task.colorValue),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Goal: ${task.goal} ${task.unit}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted ? const Color(0xFF00E699) : Colors.grey[700]!,
                      width: 2,
                    ),
                    color: isCompleted ? const Color(0xFF00E699).withOpacity(0.1) : null,
                  ),
                  child: Text(
                    '$progress',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
