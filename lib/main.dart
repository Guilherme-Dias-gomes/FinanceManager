import 'package:flutter/material.dart';
import 'models/transaction.dart';
import 'screens/add_transaction_screen.dart';

void main() {
  runApp(const FinanceManagerApp());
}

class FinanceManagerApp extends StatelessWidget {
  const FinanceManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Transaction> _transactions = [
    Transaction(
      id: 't1',
      description: 'Salário',
      amount: 5000.00,
      date: DateTime.now(),
      isIncome: true,
    ),
    Transaction(
      id: 't2',
      description: 'Supermercado',
      amount: 300.00,
      date: DateTime.now(),
      isIncome: false,
    ),
  ];

  void _addNewTransaction(Transaction newTransaction) {
    setState(() {
      _transactions.add(newTransaction);
    });
  }

  void _openAddTransactionScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => AddTransactionScreen(
          onAddTransaction: _addNewTransaction,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Manager'),
        actions: [
          IconButton(
            onPressed: _openAddTransactionScreen,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final tx = _transactions[index];
          return ListTile(
            leading: Icon(
              tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: tx.isIncome ? Colors.green : Colors.red,
            ),
            title: Text(tx.description),
            subtitle: Text(
              '${tx.date.day}/${tx.date.month}/${tx.date.year}',
            ),
            trailing: Text(
              'R\$ ${tx.amount.toStringAsFixed(2)}',
              style: TextStyle(
                color: tx.isIncome ? Colors.green : Colors.red,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}
