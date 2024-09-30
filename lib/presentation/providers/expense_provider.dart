import 'package:flutter/foundation.dart';
import 'package:tracker_app/data/repository/expense_repository.dart';
import '../../data/models/expense_model.dart';

class ExpenseProvider extends ChangeNotifier {
  List<ExpenseModel> _expenses = [];

  List<ExpenseModel> get expenses => _expenses;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final ExpenseRepository _expenseRepository = ExpenseRepository.instance;

  ExpenseProvider() {
    _loadExpenses();
  }

  // Load the saved expenses from the database
  Future<void> _loadExpenses() async {
    _isLoading = true; // Set loading to true
    notifyListeners(); // Notify listeners to update UI
    _expenses = await _expenseRepository.fetchExpenses(); // Fetch expenses
    _isLoading = false; // Set loading to false
    notifyListeners(); // Notify listeners to update UI
  }

  // Add a new expense and save it to the database
  Future<void> addExpense(ExpenseModel expense) async {
    await _expenseRepository.addExpense(expense);
    _expenses.add(expense);
    notifyListeners();
  }

  // Delete an expense and update the database
  Future<void> deleteExpense(int id) async {
    await _expenseRepository.deleteExpense(id);
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }
}
