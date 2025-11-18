import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../config/app_config.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final String title;
  final bool showLegend;

  const PieChartWidget({
    super.key,
    required this.data,
    required this.title,
    this.showLegend = true,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text('No data available'));
    }

    final sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Take top 10 entries
    final topEntries = sortedEntries.take(10).toList();
    final total = topEntries.fold(0.0, (sum, entry) => sum + entry.value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: PieChart(
                  PieChartData(
                    sections: topEntries.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dataEntry = entry.value;
                      final percentage = (dataEntry.value / total) * 100;

                      return PieChartSectionData(
                        color: Color(AppConfig.chartColors[index % AppConfig.chartColors.length]),
                        value: dataEntry.value,
                        title: '${percentage.toStringAsFixed(1)}%',
                        radius: 80,
                        titleStyle: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              if (showLegend)
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: topEntries.asMap().entries.map((entry) {
                        final index = entry.key;
                        final dataEntry = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Color(AppConfig.chartColors[index % AppConfig.chartColors.length]),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  dataEntry.key,
                                  style: const TextStyle(fontSize: 11),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
