import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddNewExpense});

  final void Function(Expense expense) onAddNewExpense;
  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // var _enteredTitle = '';

  //Q. Why dont we need to set state?
  //Because we are not updating the UI when we input the title
  // void _saveTitleInput(String inputValue) {
  //   _enteredTitle = inputValue;
  // }

  //this text editing controller is provided by flutter to control any text editing you do
  //It saves the input for you
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Catergory _selectedCategory = Catergory.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    //Future is a value which you dont have yet but you would have in the future
    //in place of async and await ,we can add the 'then' keyword after the showDatePicker
    //async cannot be used for your widgets in the build method
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsValid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsValid ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Invalid Input'),
                content: const Text(
                    'Please make a valid title,amount,date and category was entered.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Okay'))
                ],
              ));
      return;
    }

    widget.onAddNewExpense(Expense(
        title: _titleController.text,
        time: _selectedDate!,
        amount: enteredAmount,
        catergory: _selectedCategory));

    //closes the modal overlay after the button has been clicked
    Navigator.pop(context);
  }

  //you should always dispose your texteditingcontroller
  //dispose can only be used in a stateful widget
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16,48,16,16),
      child: Column(
        children: [
          TextField(
            // onChanged: _saveTitleInput,
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(label: Text("Title")),
          ),
          Row(
            children: [
              //expanded is used so that the widget take a required space
              Expanded(
                child: TextField(
                  // onChanged: _saveTitleInput,
                  
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text("Amount"), prefix: Text('\$ ')),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Selected'
                        : formatter.format(_selectedDate!)),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              DropdownButton(
                  //this below ensures the currently selected value is shown on the screen
                  value: _selectedCategory,
                  items: Catergory.values
                      .map((category) => DropdownMenuItem(
                          //value is stored internally,its not visible to the user but it is the result of the users input
                          value: category,
                          child: Text(category.name.toUpperCase())))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    //updating the state whenever it changes
                    setState(() {
                      _selectedCategory = value;
                    });
                  }),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    //This navigator closes the modal screen and it can also be used to
                    //switch screens
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              ElevatedButton(
                  onPressed:
                      // onPressed: () {
                      //   print(_enteredTitle);
                      // },
                      _submitExpenseData,
                  child: const Text('Save Expense'))
            ],
          )
        ],
      ),
    );
  }
}
