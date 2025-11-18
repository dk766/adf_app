class DashboardStats {
  final Map<String, dynamic> data;

  DashboardStats({required this.data});

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(data: json);
  }

  // Helper getters for common stats
  double? get totalInvoices => _getDouble('total_invoices');
  double? get monthlyTotal => _getDouble('monthly_total');
  double? get yearlyTotal => _getDouble('yearly_total');

  double? _getDouble(String key) {
    final value = data[key];
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() => data;
}

class MonthlyData {
  final List<MonthlyDataPoint> dataPoints;

  MonthlyData({required this.dataPoints});

  factory MonthlyData.fromJson(Map<String, dynamic> json) {
    final List<MonthlyDataPoint> points = [];

    // Handle different possible JSON structures
    if (json['data'] is List) {
      points.addAll((json['data'] as List)
          .map((e) => MonthlyDataPoint.fromJson(e as Map<String, dynamic>))
          .toList());
    } else if (json['months'] is List && json['values'] is List) {
      final months = json['months'] as List;
      final values = json['values'] as List;
      for (int i = 0; i < months.length && i < values.length; i++) {
        points.add(MonthlyDataPoint(
          month: months[i].toString(),
          value: _parseDouble(values[i]),
        ));
      }
    }

    return MonthlyData(dataPoints: points);
  }

  static double _parseDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'data': dataPoints.map((e) => e.toJson()).toList(),
    };
  }
}

class MonthlyDataPoint {
  final String month;
  final double value;

  MonthlyDataPoint({required this.month, required this.value});

  factory MonthlyDataPoint.fromJson(Map<String, dynamic> json) {
    return MonthlyDataPoint(
      month: json['month']?.toString() ?? '',
      value: MonthlyData._parseDouble(json['value']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'value': value,
    };
  }
}

class ExpensesByCompany {
  final Map<String, double> expenses;

  ExpensesByCompany({required this.expenses});

  factory ExpensesByCompany.fromJson(Map<String, dynamic> json) {
    final Map<String, double> expensesMap = {};
    json.forEach((key, value) {
      if (value is num) {
        expensesMap[key] = value.toDouble();
      } else if (value is String) {
        expensesMap[key] = double.tryParse(value) ?? 0.0;
      }
    });
    return ExpensesByCompany(expenses: expensesMap);
  }

  Map<String, dynamic> toJson() => expenses;
}
