class Company {
  final int id;
  final String name;
  final String cif;
  final String? cui;
  final String? regcom;
  final String? officeAddress;
  final String? role;
  final bool isAdmin;
  final bool isAccountant;
  final bool hasReadPermissions;
  final bool hasAnafToken;
  final String? licensePackage;
  final String? licenseExpiresAt;
  final String? createdAt;

  // Legacy field for backward compatibility
  String? get license => licensePackage;
  String? get roles => role;

  Company({
    required this.id,
    required this.name,
    required this.cif,
    this.cui,
    this.regcom,
    this.officeAddress,
    this.role,
    required this.isAdmin,
    required this.isAccountant,
    required this.hasReadPermissions,
    required this.hasAnafToken,
    this.licensePackage,
    this.licenseExpiresAt,
    this.createdAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int,
      name: json['name'] as String,
      cif: json['cif'] as String,
      cui: json['cui'] as String?,
      regcom: json['regcom'] as String?,
      officeAddress: json['office_address'] as String?,
      role: json['role'] as String?,
      isAdmin: json['is_admin'] as bool? ?? false,
      isAccountant: json['is_accountant'] as bool? ?? false,
      hasReadPermissions: json['has_read_permissions'] as bool? ?? false,
      hasAnafToken: json['has_anaf_token'] as bool? ?? false,
      licensePackage: json['license_package'] as String?,
      licenseExpiresAt: json['license_expires_at'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cif': cif,
      'cui': cui,
      'regcom': regcom,
      'office_address': officeAddress,
      'role': role,
      'is_admin': isAdmin,
      'is_accountant': isAccountant,
      'has_read_permissions': hasReadPermissions,
      'has_anaf_token': hasAnafToken,
      'license_package': licensePackage,
      'license_expires_at': licenseExpiresAt,
      'created_at': createdAt,
    };
  }

  // Helper getters for permissions (now just direct access since they're already bool)
  bool get isUserAdmin => isAdmin;
  bool get isUserAccountant => isAccountant;
  bool get hasReadAccess => hasReadPermissions;
  bool get hasAnafIntegration => hasAnafToken;
}
