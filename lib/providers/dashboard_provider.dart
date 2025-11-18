import 'package:flutter/foundation.dart';
import '../models/dashboard_stats.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  DashboardStats? _stats;
  MonthlyData? _monthlyExpenses;
  MonthlyData? _monthlySales;
  MonthlyData? _monthlyProfit;
  ExpensesByCompany? _expensesByCompany;

  bool _isLoading = false;
  String? _error;

  DashboardStats? get stats => _stats;
  MonthlyData? get monthlyExpenses => _monthlyExpenses;
  MonthlyData? get monthlySales => _monthlySales;
  MonthlyData? get monthlyProfit => _monthlyProfit;
  ExpensesByCompany? get expensesByCompany => _expensesByCompany;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboardData(String cif) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load all dashboard data in parallel
      final results = await Future.wait([
        _apiService.getDashboardStats(cif),
        _apiService.getMonthlyExpenses(cif),
        _apiService.getMonthlySales(cif),
        _apiService.getMonthlyProfit(cif),
        _apiService.getExpensesByCompany(cif),
      ]);

      _stats = results[0] as DashboardStats;
      _monthlyExpenses = results[1] as MonthlyData;
      _monthlySales = results[2] as MonthlyData;
      _monthlyProfit = results[3] as MonthlyData;
      _expensesByCompany = results[4] as ExpensesByCompany;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _stats = null;
    _monthlyExpenses = null;
    _monthlySales = null;
    _monthlyProfit = null;
    _expensesByCompany = null;
    _error = null;
    notifyListeners();
  }
}
