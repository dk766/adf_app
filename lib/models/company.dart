class Company {
  final int id;
  final String name;
  final String cif;
  final String? license;
  final String? roles;

  Company({
    required this.id,
    required this.name,
    required this.cif,
    this.license,
    this.roles,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'] as int,
      name: json['name'] as String,
      cif: json['cif'] as String,
      license: json['license'] as String?,
      roles: json['roles'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'cif': cif,
      'license': license,
      'roles': roles,
    };
  }
}
