class Client {
  final String id;
  final String userId;
  final String name;
  final String? email;
  final String? phone;
  final String? companyName;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Client({
    required this.id,
    required this.userId,
    required this.name,
    this.email,
    this.phone,
    this.companyName,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      companyName: json['company_name'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      if (email != null && email!.isNotEmpty) 'email': email,
      if (phone != null && phone!.isNotEmpty) 'phone': phone,
      if (companyName != null && companyName!.isNotEmpty) 'company_name': companyName,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
    };
  }
}
