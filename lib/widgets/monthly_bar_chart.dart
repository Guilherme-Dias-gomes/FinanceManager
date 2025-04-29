import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<Transaction> transactions;
  final DateTime selectedMonth;

  const MonthlyBarChart({
    super.key,
    required this.transactions,
    required this.selectedMonth,
  });

  Map<int, Map<String, double>> getDailyDataForMonth() {
    final filteredTx = transactions.where((tx) =>
        tx.date.year == selectedMonth.year && tx.date.month == selectedMonth.month);

    final data = <int, Map<String, double>>{};

    for (var tx in filteredTx) {
      final day = tx.date.day;

      data[day] ??= {'income': 0.0, 'expense': 0.0};

      if (tx.isIncome) {
        data[day]!['income'] = data[day]!['income']! + tx.amount;
      } else {
        data[day]!['expense'] = data[day]!['expense']! + tx.amount;
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final data = getDailyDataForMonth();

    final allValues = data.values.expand((map) => map.values);
    final maxValue = allValues.isEmpty ? 100 : allValues.reduce((a, b) => a > b ? a : b);

    final sortedDays = data.keys.toList()..sort();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue + 100,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.black87,
            fitInsideVertically: true,
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
              reservedSize: 28,
              getTitlesWidget: (value, meta) => Text('Dia ${value.toInt()}', style: const TextStyle(fontSize: 10)),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const Text('0');
                if (value >= 1000) return Text('${(value / 1000).toStringAsFixed(1)}k');
                return Text(value.toStringAsFixed(0));
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        barGroups: sortedDays.map((day) {
          final income = data[day]?['income'] ?? 0.0;
          final expense = data[day]?['expense'] ?? 0.0;

          return BarChartGroupData(
            x: day,
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
        }).toList(),
      ),
    );
  }
}
