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
    Transaction(
      id: 't3',
      description: 'Presente',
      amount: 150.00,
      date: DateTime(2025, 3, 15),
      isIncome: false,
    ),
  ];

  String _searchText = '';
  int? _selectedMonth; // 1 = Janeiro, 2 = Fevereiro, etc.

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

  List<Transaction> get _filteredTransactions {
    return _transactions.where((tx) {
      final matchesSearch = tx.description.toLowerCase().contains(_searchText.toLowerCase());
      final matchesMonth = _selectedMonth == null || tx.date.month == _selectedMonth;
      return matchesSearch && matchesMonth;
    }).toList();
  }

  List<DropdownMenuItem<int>> _buildMonthDropdownItems() {
    return List.generate(12, (index) {
      return DropdownMenuItem(
        value: index + 1,
        child: Text(
          _monthName(index + 1),
        ),
      );
    });
  }

  String _monthName(int month) {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return months[month - 1];
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
      body: Column(
        children: [
          // Campo de pesquisa
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),

          // Dropdown para escolher o mês
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: const InputDecoration(
                labelText: 'Filtrar por mês',
                border: OutlineInputBorder(),
              ),
              items: _buildMonthDropdownItems(),
              onChanged: (value) {
                setState(() {
                  _selectedMonth = value;
                });
              },
              isExpanded: true,
            ),
          ),

          const SizedBox(height: 10),

          // Lista de transações filtradas
          Expanded(
            child: _filteredTransactions.isEmpty
                ? const Center(child: Text('Nenhuma transação encontrada.'))
                : ListView.builder(
                    itemCount: _filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final tx = _filteredTransactions[index];
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTransactionScreen,
        child: const Icon(Icons.add),
      ),
    );
  }
}

