import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final int goal;
  final String unit; // e.g., "mins", "pages", "glasses"
  final int iconCode; // Store IconData codePoint
  final int colorValue; // Store Color value
  Map<String, int> history; // Date (ISO8601 String) -> Value

  Task({
    required this.id,
    required this.title,
    required this.goal,
    this.unit = 'times',
    required this.iconCode,
    required this.colorValue,
    Map<String, int>? history,
  }) : history = history ?? {};

  // Helper to get IconData
  IconData get icon => IconData(iconCode, fontFamily: 'MaterialIcons');
  
  // Helper to get Color
  Color get color => Color(colorValue);

  // Get progress for a specific date
  int getProgress(DateTime date) {
    final dateKey = date.toIso8601String().split('T')[0];
    return history[dateKey] ?? 0;
  }

  // Update progress
  void updateProgress(DateTime date, int value) {
    final dateKey = date.toIso8601String().split('T')[0];
    history[dateKey] = value;
  }

  // JSON Serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'goal': goal,
      'unit': unit,
      'iconCode': iconCode,
      'colorValue': colorValue,
      'history': history,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      goal: json['goal'],
      unit: json['unit'],
      iconCode: json['iconCode'],
      colorValue: json['colorValue'],
      history: Map<String, int>.from(json['history'] ?? {}),
    );
  }
}
