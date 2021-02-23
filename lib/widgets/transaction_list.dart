import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function removeFunc;

  const TransactionList({Key key, this.userTransaction, this.removeFunc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: userTransaction.isEmpty
          ? Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "No Transaction available",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '\$${userTransaction[index].amount.toStringAsFixed(2)}',
                            ),
                          ),
                        ),
                      ),
                      radius: 30.0,
                    ),
                    title: Text(
                      '${userTransaction[index].title}',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(userTransaction[index].date),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => removeFunc(userTransaction[index].id),
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                );
              },
              itemCount: userTransaction.length,
            ),
    );
  }
}
