import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HabitModel {
  String name;
  Timestamp timestamp;
  List days;

  HabitModel({
    required this.name,
    required this.timestamp,
    required this.days,
  });

  Map<String, dynamic> toJson() {
    DateTime date = timestamp.toDate();
    TimeOfDay time = TimeOfDay.fromDateTime(timestamp.toDate());
    return {
      'name': name,
      'date': date,
      'time': time,
      'days': days,
    };
  }
}
