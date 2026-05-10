// Enhanced invoice model with search and analytics support
class Invoice {
  final String invoiceId;
  final String? invoiceType;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final DateTime? downloadedAt;
  final String? downloadId;
  final String? sellerName;
  final String? sellerCompanyTaxId;
  final String? buyerName;
  final String? buyerCompanyTaxId;
  final String? tax;
  final double? taxExclusiveAmount;
  final double? payableAmount;

  Invoice({
    required this.invoiceId,
    this.invoiceType,
    this.issueDate,
    this.dueDate,
    this.downloadedAt,
    this.downloadId,
    this.sellerName,
    this.sellerCompanyTaxId,
    this.buyerName,
    this.buyerCompanyTaxId,
    this.tax,
    this.taxExclusiveAmount,
    this.payableAmount,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      invoiceId: json['invoice_id']?.toString() ?? '',
      invoiceType: json['invoice_type']?.toString(),
      issueDate: _parseDate(json['issue_date']),
      dueDate: _parseDate(json['due_date']),
      downloadedAt: _parseDate(json['downloaded_at']),
      downloadId: json['download_id']?.toString(),
      sellerName: json['seller_name']?.toString(),
      sellerCompanyTaxId: (json['seller_company_tax_id'] ?? json['seller_cif'])?.toString(),
      buyerName: json['buyer_name']?.toString(),
      buyerCompanyTaxId: (json['buyer_company_tax_id'] ?? json['buyer_cif'])?.toString(),
      tax: json['tax']?.toString(),
      taxExclusiveAmount: _parseDouble(json['tax_exclusive_amount']),
      payableAmount: _parseDouble(json['payable_amount'] ?? json['total_amount']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'invoice_id': invoiceId,
      'invoice_type': invoiceType,
      'issue_date': issueDate?.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'downloaded_at': downloadedAt?.toIso8601String(),
      'download_id': downloadId,
      'seller_name': sellerName,
      'seller_company_tax_id': sellerCompanyTaxId,
      'buyer_name': buyerName,
      'buyer_company_tax_id': buyerCompanyTaxId,
      'tax': tax,
      'tax_exclusive_amount': taxExclusiveAmount,
      'payable_amount': payableAmount,
    };
  }

  // Computed properties for analytics
  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  int? get daysUntilDue {
    if (dueDate == null) return null;
    return dueDate!.difference(DateTime.now()).inDays;
  }

  String get formattedAmount {
    if (payableAmount == null) return 'N/A';
    return '${payableAmount!.toStringAsFixed(2)} RON';
  }

  String get formattedTaxExclusive {
    if (taxExclusiveAmount == null) return 'N/A';
    return '${taxExclusiveAmount!.toStringAsFixed(2)} RON';
  }
}

class PaginatedInvoices {
  final int count;
  final String? next;
  final String? previous;
  final List<Invoice> results;

  PaginatedInvoices({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedInvoices.fromJson(Map<String, dynamic> json) {
    return PaginatedInvoices(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

// Analytics models
class InvoiceAnalytics {
  final int totalInvoices;
  final double totalAmount;
  final double averageAmount;
  final int overdueCount;
  final double overdueAmount;
  final Map<String, int> byType;
  final Map<String, double> bySupplier;
  final List<MonthlyInvoiceData> monthlyTrend;

  InvoiceAnalytics({
    required this.totalInvoices,
    required this.totalAmount,
    required this.averageAmount,
    required this.overdueCount,
    required this.overdueAmount,
    required this.byType,
    required this.bySupplier,
    required this.monthlyTrend,
  });

  factory InvoiceAnalytics.fromInvoices(List<Invoice> invoices) {
    if (invoices.isEmpty) {
      return InvoiceAnalytics(
        totalInvoices: 0,
        totalAmount: 0,
        averageAmount: 0,
        overdueCount: 0,
        overdueAmount: 0,
        byType: {},
        bySupplier: {},
        monthlyTrend: [],
      );
    }

    final totalAmount = invoices
        .where((i) => i.payableAmount != null)
        .fold(0.0, (sum, i) => sum + i.payableAmount!);

    final overdueInvoices = invoices.where((i) => i.isOverdue).toList();
    final overdueAmount = overdueInvoices
        .where((i) => i.payableAmount != null)
        .fold(0.0, (sum, i) => sum + i.payableAmount!);

    // Group by type
    final Map<String, int> byType = {};
    for (var invoice in invoices) {
      final type = invoice.invoiceType ?? 'Unknown';
      byType[type] = (byType[type] ?? 0) + 1;
    }

    // Group by supplier with amounts
    final Map<String, double> bySupplier = {};
    for (var invoice in invoices) {
      final supplier = invoice.sellerName ?? 'Unknown';
      final amount = invoice.payableAmount ?? 0;
      bySupplier[supplier] = (bySupplier[supplier] ?? 0) + amount;
    }

    // Monthly trend
    final Map<String, List<Invoice>> byMonth = {};
    for (var invoice in invoices) {
      if (invoice.issueDate != null) {
        final key = '${invoice.issueDate!.year}-${invoice.issueDate!.month.toString().padLeft(2, '0')}';
        byMonth[key] = [...(byMonth[key] ?? []), invoice];
      }
    }

    final monthlyTrend = byMonth.entries.map((e) {
      final amount = e.value
          .where((i) => i.payableAmount != null)
          .fold(0.0, (sum, i) => sum + i.payableAmount!);
      return MonthlyInvoiceData(
        month: e.key,
        count: e.value.length,
        totalAmount: amount,
      );
    }).toList()
      ..sort((a, b) => a.month.compareTo(b.month));

    return InvoiceAnalytics(
      totalInvoices: invoices.length,
      totalAmount: totalAmount,
      averageAmount: totalAmount / invoices.length,
      overdueCount: overdueInvoices.length,
      overdueAmount: overdueAmount,
      byType: byType,
      bySupplier: bySupplier,
      monthlyTrend: monthlyTrend,
    );
  }
}

class MonthlyInvoiceData {
  final String month;
  final int count;
  final double totalAmount;

  MonthlyInvoiceData({
    required this.month,
    required this.count,
    required this.totalAmount,
  });
}
