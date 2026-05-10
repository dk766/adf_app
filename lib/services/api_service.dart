import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/auth_token.dart';
import '../models/company.dart';
import '../models/dashboard_stats.dart';
import '../models/document.dart';
import '../models/invoice.dart';
import '../models/analytics.dart';
import 'storage_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final StorageService _storage = StorageService();

  void initialize() {
    final baseUrl = _storage.getBaseUrl();
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptor for auth token
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Token $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Handle errors globally
        debugPrint('API Error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  // Update base URL
  void updateBaseUrl(String newBaseUrl) {
    _dio.options.baseUrl = newBaseUrl;
  }

  // Authentication
  Future<AuthToken> login(String username, String password) async {
    try {
      final response = await _dio.post(
        AppConfig.authEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );
      return AuthToken.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Companies
  Future<List<Company>> getCompanies() async {
    try {
      final response = await _dio.get(AppConfig.companiesEndpoint);

      // Handle both array and object response formats
      List<dynamic> results;
      if (response.data is List) {
        // Direct array response
        results = response.data as List;
      } else if (response.data is Map) {
        final dataMap = response.data as Map<String, dynamic>;
        // Check for 'companies' key (new endpoint format)
        if (dataMap.containsKey('companies')) {
          results = dataMap['companies'] as List;
        }
        // Check for 'results' key (paginated format)
        else if (dataMap.containsKey('results')) {
          results = dataMap['results'] as List;
        } else {
          throw Exception('Unexpected response format: Map without companies or results key');
        }
      } else {
        throw Exception('Unexpected response format: ${response.data.runtimeType}');
      }

      return results.map((e) => Company.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Dashboard Statistics
  Future<DashboardStats> getDashboardStats(String cif) async {
    try {
      final response = await _dio.get(
        AppConfig.dashboardStatsEndpoint,
        queryParameters: {'cif': cif},
      );
      return DashboardStats.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<MonthlyData> getMonthlyExpenses(String cif) async {
    try {
      final response = await _dio.get(
        AppConfig.monthlyExpensesEndpoint,
        queryParameters: {'cif': cif},
      );
      return MonthlyData.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<MonthlyData> getMonthlySales(String cif) async {
    try {
      final response = await _dio.get(
        AppConfig.monthlySalesEndpoint,
        queryParameters: {'cif': cif},
      );
      return MonthlyData.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<MonthlyData> getMonthlyProfit(String cif) async {
    try {
      final response = await _dio.get(
        AppConfig.monthlyProfitEndpoint,
        queryParameters: {'cif': cif},
      );
      return MonthlyData.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ExpensesByCompany> getExpensesByCompany(String cif) async {
    try {
      final response = await _dio.get(
        AppConfig.expensesByCompanyEndpoint,
        queryParameters: {'cif': cif},
      );
      return ExpensesByCompany.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Documents
  Future<PaginatedDocuments> getDocuments({
    required String cif,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _dio.get(
        AppConfig.documentsEndpoint,
        queryParameters: {
          'cif': cif,
          'page': page,
          'page_size': pageSize,
        },
      );
      return PaginatedDocuments.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Document> uploadDocument({
    required String cif,
    required String filePath,
    String? description,
    String? category,
    String? department,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'cif': cif,
        if (description != null) 'description': description,
        if (category != null) 'category': category,
        if (department != null) 'department': department,
      });

      final response = await _dio.post(
        AppConfig.documentUploadEndpoint,
        data: formData,
      );
      return Document.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> downloadDocument(int documentId, String savePath) async {
    try {
      await _dio.download(
        '${AppConfig.documentsEndpoint}$documentId/',
        savePath,
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Invoices with advanced filtering
  Future<PaginatedInvoices> getInvoices({
    String? cif,
    int page = 1,
    int pageSize = 50,
    String? searchQuery,
    String? invoiceType,
    DateTime? startDate,
    DateTime? endDate,
    String? sellerTaxId,
    String? buyerTaxId,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'page_size': pageSize,
      };

      if (cif != null && cif.isNotEmpty) queryParams['cif'] = cif;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }
      if (invoiceType != null && invoiceType.isNotEmpty) {
        queryParams['invoice_type'] = invoiceType;
      }
      if (startDate != null) {
        queryParams['start_date'] = startDate.toIso8601String().split('T')[0];
      }
      if (endDate != null) {
        queryParams['end_date'] = endDate.toIso8601String().split('T')[0];
      }
      if (sellerTaxId != null && sellerTaxId.isNotEmpty) {
        queryParams['seller_tax_id'] = sellerTaxId;
      }
      if (buyerTaxId != null && buyerTaxId.isNotEmpty) {
        queryParams['buyer_tax_id'] = buyerTaxId;
      }

      final response = await _dio.get(
        AppConfig.invoicesEndpoint,
        queryParameters: queryParams,
      );
      return PaginatedInvoices.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Invoice?> getInvoiceById(String invoiceId) async {
    try {
      final response = await _dio.get('${AppConfig.invoicesEndpoint}$invoiceId/');
      return Invoice.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Deep search for invoices (content search using OpenSearch)
  Future<PaginatedInvoices> searchInvoicesDeep({
    required String query,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final response = await _dio.get(
        AppConfig.invoiceSearchEndpoint,
        queryParameters: {
          'q': query,
          'page': page,
          'page_size': pageSize,
        },
      );
      return PaginatedInvoices.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      // Fallback to regular search if deep search not available
      return getInvoices(searchQuery: query, page: page, pageSize: pageSize);
    }
  }

  // Analytics
  Future<CompanyAnalytics> getCompanyAnalytics(String cif) async {
    try {
      final response = await _dio.get(
        AppConfig.companyAnalyticsEndpoint,
        queryParameters: {'cif': cif},
      );
      return CompanyAnalytics.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<TopPartners> getTopPartners(String cif, {int limit = 10}) async {
    try {
      final response = await _dio.get(
        AppConfig.topPartnersEndpoint,
        queryParameters: {
          'cif': cif,
          'limit': limit,
        },
      );
      return TopPartners.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Cash flow data
  Future<Map<String, dynamic>> getCashFlow({
    String? cif,
    int page = 1,
    int pageSize = 50,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'page': page,
        'page_size': pageSize,
      };
      if (cif != null) {
        queryParams['cif'] = cif;
      }

      final response = await _dio.get(
        AppConfig.cashFlowEndpoint,
        queryParameters: queryParams,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message = error.response?.data['error'] ??
              error.response?.data['detail'] ??
              'Server error';
          return 'Error $statusCode: $message';
        case DioExceptionType.cancel:
          return 'Request cancelled';
        default:
          return 'Network error: ${error.message}';
      }
    }
    return 'Unexpected error: $error';
  }
}
