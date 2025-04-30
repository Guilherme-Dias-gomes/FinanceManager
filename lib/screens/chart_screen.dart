import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/monthly_bar_chart.dart';

class ChartScreen extends StatefulWidget {
  final List<Transaction> transactions;

  const ChartScreen({super.key, required this.transactions});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<String> _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
    'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ];

  double _calculateBalanceForSelectedMonth() {
    final filtered = widget.transactions.where((tx) =>
        tx.date.month == _selectedMonth &&
        tx.date.year == _selectedYear);

    double income = 0;
    double expense = 0;

    for (var tx in filtered) {
      if (tx.isIncome) {
        income += tx.amount;
      } else {
        expense += tx.amount;
      }
    }

    return income - expense;
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime(_selectedYear, _selectedMonth);
    final double balance = _calculateBalanceForSelectedMonth();
    final bool isPositive = balance >= 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        title: const Text('Análise Mensal'),
        backgroundColor: Colors.teal[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month, color: Colors.teal),
                  const SizedBox(width: 12),
                  const Text("Selecione o mês:", style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 12),
                  DropdownButton<int>(
                    value: _selectedMonth,
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    underline: Container(),
                    items: List.generate(12, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text(_months[index]),
                      );
                    }),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedMonth = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Card de saldo
            Card(
              color: isPositive ? Colors.green[100] : Colors.red[100],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      color: isPositive ? Colors.green[700] : Colors.red[700],
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Saldo em ${_months[_selectedMonth - 1]}: '
                        '${isPositive ? 'R\$' : '-R\$'}${balance.abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? Colors.green[800] : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Gráfico
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: MonthlyBarChart(
                  transactions: widget.transactions,
                  selectedMonth: selectedDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
