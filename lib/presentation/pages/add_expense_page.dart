import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/models/expense_model.dart';
import '../providers/expense_provider.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  _AddExpensePageState createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Expense')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                // Only allow numeric input
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Pick Date'),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
            ),
            ElevatedButton(
              onPressed: () {
                final description = _descriptionController.text;
                final amount = double.tryParse(_amountController.text) ?? 0;
                final int newId = DateTime.now().millisecondsSinceEpoch;
                final expense = ExpenseModel(
                  id: newId,
                  description: description,
                  amount: amount,
                  date: _selectedDate,
                );
                Provider.of<ExpenseProvider>(context, listen: false)
                    .addExpense(expense);
                Navigator.pop(context);
              },
              child: const Text('Add Expense'),
            ),
          ],
        ),
      ),
    );
  }
}
