// Company analytics and metrics
class CompanyAnalytics {
  final String companyCif;
  final String companyName;
  final FinancialMetrics financialMetrics;
  final InvoiceMetrics invoiceMetrics;
  final CashFlowMetrics cashFlowMetrics;
  final GrowthMetrics growthMetrics;

  CompanyAnalytics({
    required this.companyCif,
    required this.companyName,
    required this.financialMetrics,
    required this.invoiceMetrics,
    required this.cashFlowMetrics,
    required this.growthMetrics,
  });

  factory CompanyAnalytics.fromJson(Map<String, dynamic> json) {
    return CompanyAnalytics(
      companyCif: json['company_cif'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      financialMetrics: FinancialMetrics.fromJson(
        json['financial_metrics'] as Map<String, dynamic>? ?? {},
      ),
      invoiceMetrics: InvoiceMetrics.fromJson(
        json['invoice_metrics'] as Map<String, dynamic>? ?? {},
      ),
      cashFlowMetrics: CashFlowMetrics.fromJson(
        json['cash_flow_metrics'] as Map<String, dynamic>? ?? {},
      ),
      growthMetrics: GrowthMetrics.fromJson(
        json['growth_metrics'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

class FinancialMetrics {
  final double totalRevenue;
  final double totalExpenses;
  final double netProfit;
  final double profitMargin;
  final double currentMonthRevenue;
  final double previousMonthRevenue;
  final double yearToDateRevenue;

  FinancialMetrics({
    required this.totalRevenue,
    required this.totalExpenses,
    required this.netProfit,
    required this.profitMargin,
    required this.currentMonthRevenue,
    required this.previousMonthRevenue,
    required this.yearToDateRevenue,
  });

  factory FinancialMetrics.fromJson(Map<String, dynamic> json) {
    return FinancialMetrics(
      totalRevenue: _parseDouble(json['total_revenue']) ?? 0,
      totalExpenses: _parseDouble(json['total_expenses']) ?? 0,
      netProfit: _parseDouble(json['net_profit']) ?? 0,
      profitMargin: _parseDouble(json['profit_margin']) ?? 0,
      currentMonthRevenue: _parseDouble(json['current_month_revenue']) ?? 0,
      previousMonthRevenue: _parseDouble(json['previous_month_revenue']) ?? 0,
      yearToDateRevenue: _parseDouble(json['year_to_date_revenue']) ?? 0,
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  double get revenueGrowth {
    if (previousMonthRevenue == 0) return 0;
    return ((currentMonthRevenue - previousMonthRevenue) / previousMonthRevenue) * 100;
  }
}

class InvoiceMetrics {
  final int totalInvoices;
  final int paidInvoices;
  final int pendingInvoices;
  final int overdueInvoices;
  final double averageInvoiceValue;
  final double largestInvoice;
  final double smallestInvoice;
  final int averagePaymentDays;

  InvoiceMetrics({
    required this.totalInvoices,
    required this.paidInvoices,
    required this.pendingInvoices,
    required this.overdueInvoices,
    required this.averageInvoiceValue,
    required this.largestInvoice,
    required this.smallestInvoice,
    required this.averagePaymentDays,
  });

  factory InvoiceMetrics.fromJson(Map<String, dynamic> json) {
    return InvoiceMetrics(
      totalInvoices: json['total_invoices'] as int? ?? 0,
      paidInvoices: json['paid_invoices'] as int? ?? 0,
      pendingInvoices: json['pending_invoices'] as int? ?? 0,
      overdueInvoices: json['overdue_invoices'] as int? ?? 0,
      averageInvoiceValue: FinancialMetrics._parseDouble(json['average_invoice_value']) ?? 0,
      largestInvoice: FinancialMetrics._parseDouble(json['largest_invoice']) ?? 0,
      smallestInvoice: FinancialMetrics._parseDouble(json['smallest_invoice']) ?? 0,
      averagePaymentDays: json['average_payment_days'] as int? ?? 0,
    );
  }

  double get paymentRate {
    if (totalInvoices == 0) return 0;
    return (paidInvoices / totalInvoices) * 100;
  }

  double get overdueRate {
    if (totalInvoices == 0) return 0;
    return (overdueInvoices / totalInvoices) * 100;
  }
}

class CashFlowMetrics {
  final double cashInflow;
  final double cashOutflow;
  final double netCashFlow;
  final double currentBalance;
  final double projectedEndOfMonthBalance;
  final List<CashFlowEntry> recentEntries;

  CashFlowMetrics({
    required this.cashInflow,
    required this.cashOutflow,
    required this.netCashFlow,
    required this.currentBalance,
    required this.projectedEndOfMonthBalance,
    required this.recentEntries,
  });

  factory CashFlowMetrics.fromJson(Map<String, dynamic> json) {
    return CashFlowMetrics(
      cashInflow: FinancialMetrics._parseDouble(json['cash_inflow']) ?? 0,
      cashOutflow: FinancialMetrics._parseDouble(json['cash_outflow']) ?? 0,
      netCashFlow: FinancialMetrics._parseDouble(json['net_cash_flow']) ?? 0,
      currentBalance: FinancialMetrics._parseDouble(json['current_balance']) ?? 0,
      projectedEndOfMonthBalance: FinancialMetrics._parseDouble(json['projected_end_of_month_balance']) ?? 0,
      recentEntries: (json['recent_entries'] as List?)
              ?.map((e) => CashFlowEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CashFlowEntry {
  final DateTime date;
  final String description;
  final double amount;
  final String type;

  CashFlowEntry({
    required this.date,
    required this.description,
    required this.amount,
    required this.type,
  });

  factory CashFlowEntry.fromJson(Map<String, dynamic> json) {
    return CashFlowEntry(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      description: json['description'] as String? ?? '',
      amount: FinancialMetrics._parseDouble(json['amount']) ?? 0,
      type: json['type'] as String? ?? '',
    );
  }
}

class GrowthMetrics {
  final double monthOverMonthGrowth;
  final double yearOverYearGrowth;
  final double quarterOverQuarterGrowth;
  final List<GrowthDataPoint> monthlyGrowth;
  final String trend; // 'increasing', 'decreasing', 'stable'

  GrowthMetrics({
    required this.monthOverMonthGrowth,
    required this.yearOverYearGrowth,
    required this.quarterOverQuarterGrowth,
    required this.monthlyGrowth,
    required this.trend,
  });

  factory GrowthMetrics.fromJson(Map<String, dynamic> json) {
    return GrowthMetrics(
      monthOverMonthGrowth: FinancialMetrics._parseDouble(json['month_over_month_growth']) ?? 0,
      yearOverYearGrowth: FinancialMetrics._parseDouble(json['year_over_year_growth']) ?? 0,
      quarterOverQuarterGrowth: FinancialMetrics._parseDouble(json['quarter_over_quarter_growth']) ?? 0,
      monthlyGrowth: (json['monthly_growth'] as List?)
              ?.map((e) => GrowthDataPoint.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trend: json['trend'] as String? ?? 'stable',
    );
  }
}

class GrowthDataPoint {
  final String period;
  final double value;
  final double growthRate;

  GrowthDataPoint({
    required this.period,
    required this.value,
    required this.growthRate,
  });

  factory GrowthDataPoint.fromJson(Map<String, dynamic> json) {
    return GrowthDataPoint(
      period: json['period'] as String? ?? '',
      value: FinancialMetrics._parseDouble(json['value']) ?? 0,
      growthRate: FinancialMetrics._parseDouble(json['growth_rate']) ?? 0,
    );
  }
}

// Top suppliers/customers
class TopPartners {
  final List<PartnerData> topSuppliers;
  final List<PartnerData> topCustomers;

  TopPartners({
    required this.topSuppliers,
    required this.topCustomers,
  });

  factory TopPartners.fromJson(Map<String, dynamic> json) {
    return TopPartners(
      topSuppliers: (json['top_suppliers'] as List?)
              ?.map((e) => PartnerData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      topCustomers: (json['top_customers'] as List?)
              ?.map((e) => PartnerData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PartnerData {
  final String name;
  final String taxId;
  final double totalAmount;
  final int transactionCount;
  final double percentage;

  PartnerData({
    required this.name,
    required this.taxId,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentage,
  });

  factory PartnerData.fromJson(Map<String, dynamic> json) {
    return PartnerData(
      name: json['name'] as String? ?? '',
      taxId: json['tax_id'] as String? ?? '',
      totalAmount: FinancialMetrics._parseDouble(json['total_amount']) ?? 0,
      transactionCount: json['transaction_count'] as int? ?? 0,
      percentage: FinancialMetrics._parseDouble(json['percentage']) ?? 0,
    );
  }
}
