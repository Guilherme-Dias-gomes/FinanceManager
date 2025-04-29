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

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime(_selectedYear, _selectedMonth);

    return Scaffold(
      appBar: AppBar(title: const Text('Análise Mensal')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("Selecione o mês: "),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: _selectedMonth,
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
            const SizedBox(height: 16),
            Expanded(
              child: MonthlyBarChart(
                transactions: widget.transactions,
                selectedMonth: selectedDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
