class Document {
  final int id;
  final String filename;
  final String? description;
  final String? category;
  final String? department;
  final int? fileSize;
  final String? fileHash;
  final DateTime? uploadedAt;
  final String? uploadedByUsername;
  final String? companyCif;
  final String? companyName;

  Document({
    required this.id,
    required this.filename,
    this.description,
    this.category,
    this.department,
    this.fileSize,
    this.fileHash,
    this.uploadedAt,
    this.uploadedByUsername,
    this.companyCif,
    this.companyName,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as int,
      filename: json['filename'] as String,
      description: json['description'] as String?,
      category: json['category'] as String?,
      department: json['department'] as String?,
      fileSize: json['file_size'] as int?,
      fileHash: json['file_hash'] as String?,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'] as String)
          : null,
      uploadedByUsername: json['uploaded_by_username'] as String?,
      companyCif: json['company_cif'] as String?,
      companyName: json['company_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filename': filename,
      'description': description,
      'category': category,
      'department': department,
      'file_size': fileSize,
      'file_hash': fileHash,
      'uploaded_at': uploadedAt?.toIso8601String(),
      'uploaded_by_username': uploadedByUsername,
      'company_cif': companyCif,
      'company_name': companyName,
    };
  }

  String get fileSizeFormatted {
    if (fileSize == null) return 'Unknown';
    final kb = fileSize! / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)} KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)} MB';
  }
}

class PaginatedDocuments {
  final int count;
  final String? next;
  final String? previous;
  final List<Document> results;

  PaginatedDocuments({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedDocuments.fromJson(Map<String, dynamic> json) {
    return PaginatedDocuments(
      count: json['count'] as int,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List)
          .map((e) => Document.fromJson(e as Map<String, dynamic>))
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
