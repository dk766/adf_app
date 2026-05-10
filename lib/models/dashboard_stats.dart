class DashboardStats {
  final Map<String, dynamic> data;

  DashboardStats({required this.data});

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(data: json);
  }

  Map<String, dynamic> get _cards =>
      (data['cards'] as Map<String, dynamic>?) ?? {};

  double? get monthlyTotal => _getDouble('month_sent_ron');
  double? get yearlyTotal => _getDouble('year_sent_ron');
  double? get totalInvoices => _getDouble('files_num');

  double? _getDouble(String key) {
    final value = _cards[key];
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

    // Actual API format: {valori: [v1, v2, ...]} — 12 entries indexed by month
    if (json['valori'] is List) {
      final values = json['valori'] as List;
      for (int i = 0; i < values.length; i++) {
        points.add(MonthlyDataPoint(
          month: _monthName(i + 1),
          value: _parseDouble(values[i]),
        ));
      }
      return MonthlyData(dataPoints: points);
    }

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

  static String _monthName(int month) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return (month >= 1 && month <= 12) ? names[month - 1] : '$month';
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

    // Actual API format: {expenses_by_company: [{company_name, total_expenses}]}
    if (json['expenses_by_company'] is List) {
      for (final item in json['expenses_by_company'] as List) {
        final map = item as Map<String, dynamic>;
        final name = map['company_name'] as String? ?? 'Unknown';
        final amount = map['total_expenses'];
        if (amount is num) {
          expensesMap[name] = amount.toDouble();
        } else if (amount is String) {
          expensesMap[name] = double.tryParse(amount) ?? 0.0;
        }
      }
      return ExpensesByCompany(expenses: expensesMap);
    }

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
