import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../aisdfjasfhsajdlf/models/transaction_model.dart';

class TransactionService with ChangeNotifier {
  final _box = Hive.box<TransactionModel>('transactions');

  List<TransactionModel> get all => _box.values.toList();

  void add(TransactionModel model) {
    _box.add(model);
    notifyListeners();
  }

  void update(int key, TransactionModel model) {
    _box.put(key, model);
    notifyListeners();
  }

  void delete(int key) {
    _box.delete(key);
    notifyListeners();
  }

  double get totalIncome =>
      _box.values.where((e) => e.isIncome).fold(0, (sum, e) => sum + e.amount);

  double get totalExpense =>
      _box.values.where((e) => !e.isIncome).fold(0, (sum, e) => sum + e.amount);
}
