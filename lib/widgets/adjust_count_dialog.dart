import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:tracker/models/task.dart';

class AdjustCountDialog extends StatefulWidget {
  final Task task;
  final int currentProgress;
  final Function(int) onSave;

  const AdjustCountDialog({
    super.key,
    required this.task,
    required this.currentProgress,
    required this.onSave,
  });

  @override
  State<AdjustCountDialog> createState() => _AdjustCountDialogState();
}

class _AdjustCountDialogState extends State<AdjustCountDialog> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentProgress.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E232E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Set ${widget.task.title} Count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Adjust the number for today.',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            SleekCircularSlider(
              min: 0,
              max: (widget.task.goal * 2).toDouble(), // Allow going over goal
              initialValue: _currentValue,
              appearance: CircularSliderAppearance(
                size: 220,
                customWidths: CustomSliderWidths(
                  trackWidth: 20,
                  progressBarWidth: 20,
                  handlerSize: 12,
                ),
                customColors: CustomSliderColors(
                  trackColor: const Color(0xFF2C3440),
                  progressBarColor: const Color(0xFF00E699),
                  dotColor: Colors.white,
                  hideShadow: true,
                ),
                infoProperties: InfoProperties(
                  mainLabelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                  modifier: (double value) {
                    return '${value.toInt()}';
                  },
                ),
              ),
              onChange: (double value) {
                setState(() {
                  _currentValue = value;
                });
              },
              innerWidget: (double value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${value.toInt()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '/ ${widget.task.goal}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3440),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      widget.onSave(_currentValue.toInt());
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF00E699),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
