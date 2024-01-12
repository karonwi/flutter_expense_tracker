//this below package is used to generate unique id , the command used is 'flutter pub add uuid
import 'package:uuid/uuid.dart';

//this package below is used to format dates ,the command to run is flutter pub add intl
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

const uuid = Uuid();

enum Catergory { food, travel, leisure, work }

final formatter = DateFormat.yMd();
const categoryIcons = {
  Catergory.food: Icons.lunch_dining,
  Catergory.leisure: Icons.movie,
  Catergory.travel: Icons.flight,
  Catergory.work: Icons.work
};

class Expense {
  Expense(
      {required this.title,
      required this.time,
      required this.amount,
      required this.catergory})
      : id = uuid.v4();
  final String id;
  final String title;
  final double amount;
  final DateTime time;
  final Catergory catergory;

  // the get is similar to the one used in c# for a property definition
  String get formattedDate {
    return formatter.format(time);
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.catergory, required this.expenses});
  ExpenseBucket.forCatergory(List<Expense> allExpenses,this.catergory): expenses = allExpenses.where((expense) => expense.catergory == catergory).toList();
  final Catergory catergory;
  final List<Expense> expenses;

  double get totalExpenses {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
