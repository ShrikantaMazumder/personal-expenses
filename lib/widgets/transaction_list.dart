import 'package:flutter/material.dart';
import 'package:personal_expense/models/transaction.dart';
import 'package:personal_expense/widgets/transaction_list_item.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function removeFunc;

  const TransactionList({Key key, this.userTransaction, this.removeFunc})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return userTransaction.isEmpty
        ? LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.08,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.14,
                    child: Text(
                      "No Transaction available",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.08,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.7,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              return TransactionListItem(
                  userTransaction: userTransaction[index],
                  removeFunc: removeFunc);
            },
            itemCount: userTransaction.length,
          );
  }
}
