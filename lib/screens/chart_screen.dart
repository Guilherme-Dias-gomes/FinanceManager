import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/monthly_bar_chart.dart';

class ChartScreen extends StatelessWidget {
  final List<Transaction> transactions;

  const ChartScreen({super.key, required this.transactions});

  @override@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Análise Gráfica')),
    body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 400, // ou defina dinamicamente com base no maior valor
          child: MonthlyBarChart(transactions: transactions),
        ),
      ),
    ),
  );
}

}
