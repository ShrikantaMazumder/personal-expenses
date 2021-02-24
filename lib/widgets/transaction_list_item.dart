import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expense/models/transaction.dart';

class TransactionListItem extends StatefulWidget {
  const TransactionListItem({
    Key key,
    @required this.userTransaction,
    @required this.removeFunc,
  }) : super(key: key);

  final Transaction userTransaction;
  final Function removeFunc;

  @override
  _TransactionListItemState createState() => _TransactionListItemState();
}

class _TransactionListItemState extends State<TransactionListItem> {
  var _bgColor;
  @override
  void initState() {
    const _availableColors = [
      Colors.red,
      Colors.blue,
      Colors.amber,
      Colors.deepPurple,
    ];
    _bgColor = _availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  '\$${widget.userTransaction.amount.toStringAsFixed(2)}',
                ),
              ),
            ),
          ),
          radius: 30.0,
          backgroundColor: _bgColor,
        ),
        title: Text(
          '${widget.userTransaction.title}',
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.userTransaction.date),
          style: Theme.of(context).textTheme.subtitle2,
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
                onPressed: () => widget.removeFunc(widget.userTransaction.id),
                icon: Icon(Icons.delete),
                label: Text('Delete'),
                textColor: Theme.of(context).errorColor,
              )
            : IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => widget.removeFunc(widget.userTransaction.id),
                color: Theme.of(context).errorColor,
              ),
      ),
    );
  }
}
