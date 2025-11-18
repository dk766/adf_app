import 'package:flutter/foundation.dart';
import '../models/analytics.dart';
import '../services/api_service.dart';

class AnalyticsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  CompanyAnalytics? _analytics;
  TopPartners? _topPartners;
  bool _isLoading = false;
  String? _error;

  CompanyAnalytics? get analytics => _analytics;
  TopPartners? get topPartners => _topPartners;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAnalytics(String cif) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load analytics and top partners in parallel
      final results = await Future.wait([
        _apiService.getCompanyAnalytics(cif).catchError((_) => _createMockAnalytics(cif)),
        _apiService.getTopPartners(cif).catchError((_) => _createMockTopPartners()),
      ]);

      _analytics = results[0] as CompanyAnalytics;
      _topPartners = results[1] as TopPartners;

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create mock data when backend endpoint not available
  CompanyAnalytics _createMockAnalytics(String cif) {
    return CompanyAnalytics(
      companyCif: cif,
      companyName: 'Company',
      financialMetrics: FinancialMetrics(
        totalRevenue: 0,
        totalExpenses: 0,
        netProfit: 0,
        profitMargin: 0,
        currentMonthRevenue: 0,
        previousMonthRevenue: 0,
        yearToDateRevenue: 0,
      ),
      invoiceMetrics: InvoiceMetrics(
        totalInvoices: 0,
        paidInvoices: 0,
        pendingInvoices: 0,
        overdueInvoices: 0,
        averageInvoiceValue: 0,
        largestInvoice: 0,
        smallestInvoice: 0,
        averagePaymentDays: 0,
      ),
      cashFlowMetrics: CashFlowMetrics(
        cashInflow: 0,
        cashOutflow: 0,
        netCashFlow: 0,
        currentBalance: 0,
        projectedEndOfMonthBalance: 0,
        recentEntries: [],
      ),
      growthMetrics: GrowthMetrics(
        monthOverMonthGrowth: 0,
        yearOverYearGrowth: 0,
        quarterOverQuarterGrowth: 0,
        monthlyGrowth: [],
        trend: 'stable',
      ),
    );
  }

  TopPartners _createMockTopPartners() {
    return TopPartners(
      topSuppliers: [],
      topCustomers: [],
    );
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _analytics = null;
    _topPartners = null;
    _error = null;
    notifyListeners();
  }
}
