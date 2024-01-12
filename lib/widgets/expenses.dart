import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});
  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _listOfExpense = [
    Expense(
        title: 'Flutter',
        time: DateTime.now(),
        amount: 19.44,
        catergory: Catergory.food),
    Expense(
        title: 'Dart',
        time: DateTime.now(),
        amount: 10.44,
        catergory: Catergory.leisure),
  ];

  //the context seen below holds information about this expense widget(what ever class we are in)
  //and its position in the widget tree
  // whenever you see a builder argument ,it means you have to provide a function that returns a widget
  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        //the below is to make the the overlay take up the over all page
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddNewExpense: _addNewExpenses));
  }

  void _addNewExpenses(Expense expense) {
    setState(() {
      _listOfExpense.add(expense);
    });
  }

  void _removeExpenses(Expense expense) {
    final expenseIndex = _listOfExpense.indexOf(expense);
    setState(() {
      _listOfExpense.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    //This is used to show those one lined info that has an undo next to it especially when you delete
    //a few messeges.
    //snackbar is just an info message shown on the screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _listOfExpense.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No expenses found. Start adding some!'),
    );
    if (_listOfExpense.isNotEmpty) {
      mainContent = ExpenseList(
        expenses: _listOfExpense,
        onRemoveExpense: _removeExpenses,
      );
    }
    return Scaffold(
        appBar: AppBar(title: const Text("Flutter Expense tracker"), actions: [
          IconButton(
              onPressed: _openAddExpenseOverlay, icon: const Icon(Icons.add))
        ]),
        body: Column(
          children: [Chart(expenses: _listOfExpense), Expanded(child: mainContent)],
        ));
  }
}
