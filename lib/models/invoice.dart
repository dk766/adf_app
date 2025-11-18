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
      invoiceId: json['invoice_id'] as String,
      invoiceType: json['invoice_type'] as String?,
      issueDate: json['issue_date'] != null
          ? DateTime.tryParse(json['issue_date'] as String)
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'] as String)
          : null,
      downloadedAt: json['downloaded_at'] != null
          ? DateTime.tryParse(json['downloaded_at'] as String)
          : null,
      downloadId: json['download_id'] as String?,
      sellerName: json['seller_name'] as String?,
      sellerCompanyTaxId: json['seller_company_tax_id'] as String?,
      buyerName: json['buyer_name'] as String?,
      buyerCompanyTaxId: json['buyer_company_tax_id'] as String?,
      tax: json['tax'] as String?,
      taxExclusiveAmount: _parseDouble(json['tax_exclusive_amount']),
      payableAmount: _parseDouble(json['payable_amount']),
    );
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
