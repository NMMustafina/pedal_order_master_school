import 'package:hive/hive.dart';

part 'instructor_model.g.dart';

@HiveType(typeId: 1)
class InstructorModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final Map<String, Map<String, String>> weekly;

  @HiveField(4)
  final bool isAvailable;

  InstructorModel({
    required this.id,
    required this.name,
    required this.category,
    required this.weekly,
    this.isAvailable = true,
  });
}
