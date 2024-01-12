import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList(
      {super.key, required this.expenses, required this.onRemoveExpense});
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  @override
  Widget build(BuildContext context) {
    //makes sure the items are created only when they are needed. the listview.builder
    //and it is scrollable
    //Dismissible is for the ability to swipe to delete or erase contents from a list
    //onDismiissed=> the direction it takes is basically saying,in whatever direction you swipe,do the function
    return ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (ctx, index) => Dismissible(
            key: ValueKey(expenses[index]),
            background: Container(
              color: Theme.of(context).colorScheme.error.withOpacity(0.75),
              margin: EdgeInsets.symmetric(
                //the below inherits the card theme set in the main.dart
                horizontal: Theme.of(context).cardTheme.margin!.horizontal,
              ),
            ),
            onDismissed: (direction) {
              onRemoveExpense(expenses[index]);
            },
            child: ExpenseItem(expense: expenses[index])));
  }
}
