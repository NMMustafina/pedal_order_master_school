import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseModel {
  final String id;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> instructorIds;
  final String courseName;
  final String vehicleCategory;
  final double price;

  CourseModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.instructorIds,
    required this.courseName,
    required this.vehicleCategory,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'instructorIds': instructorIds,
      'courseName': courseName,
      'vehicleCategory': vehicleCategory,
      'price': price,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as String,
      startDate: DateTime.fromMillisecondsSinceEpoch(map['startDate'] as int),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['endDate'] as int),
      instructorIds: List<String>.from((map['instructorIds'] as List<dynamic>)),
      courseName: map['courseName'] as String,
      vehicleCategory: map['vehicleCategory'] as String,
      price: (map['price'] as num).toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory CourseModel.fromJson(String source) =>
      CourseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CourseProvider extends ChangeNotifier {
  static const _prefsKey = 'courses_list';

  final List<CourseModel> _courses = [];
  List<CourseModel> get courses => List.unmodifiable(_courses);

  CourseProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);

    if (jsonString != null) {
      try {
        final List<dynamic> decoded = json.decode(jsonString) as List<dynamic>;
        _courses
          ..clear()
          ..addAll(
            decoded
                .map((e) => CourseModel.fromMap(e as Map<String, dynamic>))
                .toList(),
          );
      } catch (_) {
        _courses.clear();
      }
    }
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> listMap =
        _courses.map((c) => c.toMap()).toList();
    await prefs.setString(_prefsKey, json.encode(listMap));
  }

  Future<void> addCourse(CourseModel course) async {
    _courses.add(course);
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> updateCourse(int index, CourseModel newCourse) async {
    if (index >= 0 && index < _courses.length) {
      _courses[index] = newCourse;
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> deleteCourse(int index) async {
    if (index >= 0 && index < _courses.length) {
      _courses.removeAt(index);
      await _saveToPrefs();
      notifyListeners();
    }
  }
}
