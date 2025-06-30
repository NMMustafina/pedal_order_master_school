import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final bool isIncome;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final double amount;

  @HiveField(3)
  final String type;

  @HiveField(4)
  final String? description;

  TransactionModel({
    required this.isIncome,
    required this.date,
    required this.amount,
    required this.type,
    this.description,
  });
}
