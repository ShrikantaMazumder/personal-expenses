import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:personal_expense/widgets/chart.dart';
import 'package:personal_expense/widgets/new_transaction.dart';
import 'package:personal_expense/widgets/transaction_list.dart';
import 'package:uuid/uuid.dart';

import 'models/transaction.dart';

void main() {
  // Add this line to ensure everything is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Lock app only to portrait orientation although it is landscape

  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.green,
        accentColor: Colors.purple,
        fontFamily: 'QuickSand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'OpenSans',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  final List<Transaction> _userTransaction = [];

  // Filter 7 recent days
  List<Transaction> get _recentTransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  // Add new transaction
  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTrx =
        Transaction(id: Uuid().v4(), title: title, amount: amount, date: date);
    setState(() {
      _userTransaction.add(newTrx);
    });
  }

  // remove transaction
  void _removeTransaction(String id) {
    setState(() {
      return _userTransaction.removeWhere((element) => id == element.id);
    });
  }

  void _startAddNewData(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          child: NewTransaction(_addNewTransaction),
          onTap: () {},
        );
      },
    );
  }

  // App lifecycle methods

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  // this will triggered when state is changed
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    // this will clear listener
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Landscape content

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Show Chart',
          style: Theme.of(context).textTheme.headline6,
        ),
        Switch.adaptive(
            activeColor: Theme.of(context).accentColor,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ],
    );
  }

  Widget _buildPortraitContent(MediaQueryData mediaQuery, AppBar _appBar) {
    return Container(
      height: (mediaQuery.size.height -
              _appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.30,
      child: Chart(_recentTransaction),
    );
  }

  // Show chart
  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Appbar variable
    final PreferredSizeWidget _appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewData(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewData(context),
              ),
            ],
          );

    // List variable
    final _txlist = Container(
      height: (mediaQuery.size.height -
              _appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.70,
      child: TransactionList(
        userTransaction: _userTransaction,
        removeFunc: _removeTransaction,
      ),
    );

    // Landscape check
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    // Page body
    final _pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) _buildLandscapeContent(),

            // Execute if it is not landscape
            if (!isLandscape) _buildPortraitContent(mediaQuery, _appBar),

            if (!isLandscape) _txlist,

            // Execute if it is landscape
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (mediaQuery.size.height -
                              _appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          0.70,
                      child: Chart(_recentTransaction),
                    )
                  : _txlist
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _pageBody,
            navigationBar: _appBar,
          )
        : Scaffold(
            appBar: _appBar,
            body: _pageBody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewData(context),
                  ),
          );
  }
}
