import 'package:flutter/foundation.dart';
import '../models/invoice.dart';
import '../services/api_service.dart';

class InvoiceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Invoice> _invoices = [];
  InvoiceAnalytics? _analytics;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  int _totalCount = 0;
  bool _hasMore = true;

  // Filters
  String? _searchQuery;
  String? _invoiceType;
  DateTime? _startDate;
  DateTime? _endDate;

  List<Invoice> get invoices => _invoices;
  InvoiceAnalytics? get analytics => _analytics;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get totalCount => _totalCount;
  bool get hasMore => _hasMore;

  Future<void> loadInvoices({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _invoices = [];
      _hasMore = true;
    }

    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiService.getInvoices(
        page: _currentPage,
        pageSize: 50,
        searchQuery: _searchQuery,
        invoiceType: _invoiceType,
        startDate: _startDate,
        endDate: _endDate,
      );

      if (refresh) {
        _invoices = result.results;
      } else {
        _invoices.addAll(result.results);
      }

      _totalCount = result.count;
      _hasMore = result.next != null;
      _currentPage++;

      // Calculate analytics from loaded invoices
      _analytics = InvoiceAnalytics.fromInvoices(_invoices);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchInvoices(String query) async {
    _searchQuery = query.isNotEmpty ? query : null;
    await loadInvoices(refresh: true);
  }

  Future<void> filterByType(String? type) async {
    _invoiceType = type;
    await loadInvoices(refresh: true);
  }

  Future<void> filterByDateRange(DateTime? start, DateTime? end) async {
    _startDate = start;
    _endDate = end;
    await loadInvoices(refresh: true);
  }

  Future<void> clearFilters() async {
    _searchQuery = null;
    _invoiceType = null;
    _startDate = null;
    _endDate = null;
    await loadInvoices(refresh: true);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void clear() {
    _invoices = [];
    _analytics = null;
    _currentPage = 1;
    _totalCount = 0;
    _hasMore = true;
    _searchQuery = null;
    _invoiceType = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }
}
