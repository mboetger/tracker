import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/models/task.dart';
import 'package:tracker/providers/task_provider.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _goalController;
  late String _unit;
  late int _selectedIconCode;
  late int _selectedColorValue;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _goalController = TextEditingController(text: widget.task?.goal.toString() ?? '');
    _unit = widget.task?.unit ?? 'times';
    _selectedIconCode = widget.task?.iconCode ?? Icons.fitness_center.codePoint;
    _selectedColorValue = widget.task?.colorValue ?? 0xFF2D6A4F;
  }

  final List<IconData> _icons = [
    Icons.fitness_center,
    Icons.self_improvement,
    Icons.water_drop,
    Icons.book,
    Icons.directions_run,
    Icons.bed,
    Icons.code,
    Icons.music_note,
  ];

  final List<Color> _colors = [
    const Color(0xFF2D6A4F), // Green
    const Color(0xFF1B4332), // Dark Green
    const Color(0xFF0077B6), // Blue
    const Color(0xFF7209B7), // Purple
    const Color(0xFFB5179E), // Pink
    const Color(0xFFF72585), // Hot Pink
    const Color(0xFFE63946), // Red
    const Color(0xFFF4A261), // Orange
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: widget.task?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        goal: int.tryParse(_goalController.text) ?? 1,
        unit: _unit,
        iconCode: _selectedIconCode,
        colorValue: _selectedColorValue,
        history: widget.task?.history, // Preserve history if editing
      );

      if (widget.task != null) {
        context.read<TaskProvider>().editTask(newTask);
      } else {
        context.read<TaskProvider>().addTask(newTask);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Habit' : 'New Habit'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('What do you want to track?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g., Meditate for 10 minutes',
                  filled: true,
                  fillColor: const Color(0xFF1E232E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              const Text('Goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _goalController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g., 10',
                        filled: true,
                        fillColor: const Color(0xFF1E232E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter a goal';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Must be a number';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _unit,
                      items: ['times', 'mins', 'pages', 'glasses', 'km']
                          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                          .toList(),
                      onChanged: (val) => setState(() => _unit = val!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF1E232E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Choose an Icon', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 60,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _icons.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final icon = _icons[index];
                    final isSelected = icon.codePoint == _selectedIconCode;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIconCode = icon.codePoint),
                      child: Container(
                        width: 60,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF00E699) : const Color(0xFF1E232E),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              const Text('Color', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final color = _colors[index];
                    final isSelected = color.value == _selectedColorValue;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColorValue = color.value),
                      child: Container(
                        width: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E699),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Task', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
