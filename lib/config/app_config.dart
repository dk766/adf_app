class AppConfig {
  static const String appName = 'ADF App';
  static const String defaultBaseUrl = 'http://localhost:8000';

  // Storage keys
  static const String keyBaseUrl = 'base_url';
  static const String keyToken = 'auth_token';
  static const String keyUsername = 'username';
  static const String keySelectedCompanyCif = 'selected_company_cif';
  static const String keyUserLogo = 'user_logo';
  static const String keyUserInfo = 'user_info';

  // API endpoints
  static const String authEndpoint = '/api/token-auth/';
  static const String dashboardStatsEndpoint = '/api/dashboard/company-stats/';
  static const String monthlyExpensesEndpoint = '/api/dashboard/monthly-expenses/';
  static const String monthlySalesEndpoint = '/api/dashboard/monthly-sales/';
  static const String monthlyProfitEndpoint = '/api/dashboard/monthly-profit/';
  static const String expensesByCompanyEndpoint = '/api/dashboard/expenses-by-company/';
  static const String documentsEndpoint = '/api/documents/';
  static const String documentUploadEndpoint = '/api/documents/upload/';
  static const String companiesEndpoint = '/data/company_roles_backend/';
  static const String invoicesEndpoint = '/data/invoice_backend/';

  // Pagination defaults
  static const int defaultPageSize = 50;
  static const int maxPageSize = 1000;

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;
}
