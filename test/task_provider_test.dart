import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/models/task.dart';
import 'package:tracker/providers/task_provider.dart';

void main() {
  test('TaskProvider adds task', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = TaskProvider();
    
    // Wait for loadTasks
    await Future.delayed(Duration.zero);

    final task = Task(
      id: '1',
      title: 'Test Task',
      goal: 10,
      iconCode: 123,
      colorValue: 0xFF000000,
    );

    provider.addTask(task);

    expect(provider.tasks.length, greaterThan(0));
    expect(provider.tasks.last.title, 'Test Task');
  });

  test('TaskProvider updates progress', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = TaskProvider();
    await Future.delayed(Duration.zero);

    final task = Task(
      id: '1',
      title: 'Test Task',
      goal: 10,
      iconCode: 123,
      colorValue: 0xFF000000,
    );
    provider.addTask(task);

    final now = DateTime.now();
    provider.updateTaskProgress('1', now, 5);

    expect(provider.tasks.last.getProgress(now), 5);
  });
}
