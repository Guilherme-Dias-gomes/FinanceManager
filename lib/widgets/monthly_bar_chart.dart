import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<Transaction> transactions;
  final int? selectedMonth;

  const MonthlyBarChart({
    super.key,
    required this.transactions,
    this.selectedMonth,
  });

  Map<int, Map<String, double>> getMonthlyData() {
    final data = <int, Map<String, double>>{};

    for (var tx in transactions) {
      final month = tx.date.month;

      data[month] ??= {'income': 0.0, 'expense': 0.0};

      if (tx.isIncome) {
        data[month]!['income'] = data[month]!['income']! + tx.amount;
      } else {
        data[month]!['expense'] = data[month]!['expense']! + tx.amount;
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTransactions =
        selectedMonth == null
            ? transactions
            : transactions
                .where((tx) => tx.date.month == selectedMonth)
                .toList();

    final monthlyData = getMonthlyData();

    // Extrai todos os valores numéricos (income + expense)
    final allValues = monthlyData.values.expand((map) => map.values);
    final maxValue =
        allValues.isEmpty ? 100 : allValues.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue + 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.black87,
              fitInsideVertically:
                  true, // ← ESSA LINHA RESOLVE o problema do "vazamento"
              tooltipPadding: const EdgeInsets.all(8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  'R\$ ${rod.toY.toStringAsFixed(2)}',
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final month = value.toInt();
                  const monthLabels = [
                    'J',
                    'F',
                    'M',
                    'A',
                    'M',
                    'J',
                    'J',
                    'A',
                    'S',
                    'O',
                    'N',
                    'D',
                  ];
                  return Text(monthLabels[month - 1]);
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('0');
                  if (value >= 1000) {
                    return Text('${(value / 1000).toStringAsFixed(1)}k');
                  }
                  return Text(value.toStringAsFixed(0));
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: List.generate(12, (index) {
            final month = index + 1;
            final income = monthlyData[month]?['income'] ?? 0.0;
            final expense = monthlyData[month]?['expense'] ?? 0.0;

            return BarChartGroupData(
              x: month,
              barRods: [
                BarChartRodData(
                  toY: expense,
                  width: 8,
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: income,
                  width: 8,
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
              barsSpace: 4,
            );
          }),
        ),
      ),
    );
  }
}
