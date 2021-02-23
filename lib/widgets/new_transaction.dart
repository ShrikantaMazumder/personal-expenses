import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  // Handling user input here
  // String titleInput;
  // String amountInput;
  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate;

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }

    final title = titleController.text;
    final amount = double.parse(amountController.text);

    if (title.isEmpty || amount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addNewTransaction(
      title,
      amount,
      _selectedDate,
    );

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            right: 10,
            left: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              //ios
              // CupertinoTextField(
              //   placeholder: "Title",
              // ),

              // android
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                cursorColor: Colors.amber,
                // onChanged: (val) => titleInput = val,
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                // onChanged: (val) => amountInput = val,
                decoration: InputDecoration(labelText: 'Amount'),
                maxLength: 10,
                keyboardType: TextInputType.number,
                controller: amountController,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 70.0,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedDate == null
                            ? 'No date chosen!'
                            : 'Picked date: ' +
                                DateFormat.yMd().format(_selectedDate),
                      ),
                    ),
                    Platform.isIOS
                        ? CupertinoButton(
                            child: Text(
                              "Choose a date",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: _showDatePicker,
                          )
                        : FlatButton(
                            onPressed: _showDatePicker,
                            child: Text(
                              'Choose a date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            textColor: Theme.of(context).primaryColor,
                          )
                  ],
                ),
              ),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                onPressed: submitData,
                child: Text('Add Transaction',
                    style: Theme.of(context).textTheme.button),
              )
            ],
          ),
        ),
      ),
    );
  }
}
