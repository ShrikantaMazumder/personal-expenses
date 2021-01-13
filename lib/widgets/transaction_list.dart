import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;

  const TransactionList({Key key, this.userTransaction}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: userTransaction.isEmpty
          ? Column(
              children: [
                SizedBox(height: 40,),
                Text(
                  "No Transaction available",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 20,),
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
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        )),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          '\$${userTransaction[index].amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Text(
                              userTransaction[index].title.toString(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Card(
                            child: Text(
                              DateFormat.yMMMMd()
                                  .format(userTransaction[index].date),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
              itemCount: userTransaction.length,
            ),
    );
  }
}
