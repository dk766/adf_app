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

  // Dashboard endpoints
  static const String dashboardStatsEndpoint = '/api/dashboard/company-stats/';
  static const String monthlyExpensesEndpoint = '/api/dashboard/monthly-expenses/';
  static const String monthlySalesEndpoint = '/api/dashboard/monthly-sales/';
  static const String monthlyProfitEndpoint = '/api/dashboard/monthly-profit/';
  static const String expensesByCompanyEndpoint = '/api/dashboard/expenses-by-company/';

  // Documents endpoints
  static const String documentsEndpoint = '/api/documents/';
  static const String documentUploadEndpoint = '/api/documents/upload/';
  static const String documentMetadataEndpoint = '/api/documents/metadata/';

  // Company endpoints
  static const String companiesEndpoint = '/data/company_roles_backend/';
  static const String companyLicensesEndpoint = '/data/company_licenses_backend/';

  // Invoice endpoints
  static const String invoicesEndpoint = '/data/invoice_backend/';
  static const String invoiceSearchEndpoint = '/api/invoices/search/'; // For future deep search

  // Analytics endpoints (to be implemented on backend)
  static const String companyAnalyticsEndpoint = '/api/analytics/company/';
  static const String topPartnersEndpoint = '/api/analytics/top-partners/';
  static const String cashFlowEndpoint = '/data/cash_backend/';
  static const String extraCashFlowEndpoint = '/data/extra_cash_flow/';

  // Pagination defaults
  static const int defaultPageSize = 50;
  static const int maxPageSize = 1000;

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double cardElevation = 2.0;

  // Chart colors
  static const chartColors = [
    0xFF6200EE, // Primary purple
    0xFF03DAC6, // Teal
    0xFFFF6B6B, // Red
    0xFF4ECDC4, // Cyan
    0xFFFFE66D, // Yellow
    0xFF95E1D3, // Mint
    0xFFF38181, // Pink
    0xFF3D5A80, // Navy
    0xFFEE6C4D, // Orange
    0xFF98C1D9, // Light blue
  ];

  // Logo assets (to be added later)
  static const String appLogoPath = 'assets/images/app_logo.png';
  static const String defaultCompanyLogoPath = 'assets/images/default_company.png';
}
