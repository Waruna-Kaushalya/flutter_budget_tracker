import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'package:flutter_budget_tracker/item_model.dart';
import 'package:flutter_budget_tracker/main.dart';

class SpendingChart extends StatelessWidget {
  final List<Item> items;

  const SpendingChart({
    Key? key,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final spending = <String, double>{};

    items.forEach(
      (item) => spending.update(
        item.category,
        (value) => value + item.price,
        ifAbsent: () => item.price,
      ),
    );

    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 360.0,
        child: PieChart(
          PieChartData(
            sections: spending
                .map((category, amountSpent) => MapEntry(
                      category,
                      PieChartSectionData(
                        color: getCatogeryColor(category),
                        radius: 100.0,
                        title: '\$${amountSpent.toStringAsFixed(2)}',
                        value: amountSpent,
                      ),
                    ))
                .values
                .toList(),
            sectionsSpace: 0,
          ),
        ),
      ),
    );
  }
}
