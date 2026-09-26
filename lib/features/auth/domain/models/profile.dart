class Profile {
  final String id;
  final String email;
  final String? fullName;
  final String? businessName;
  final String currency;

  Profile({
    required this.id,
    required this.email,
    this.fullName,
    this.businessName,
    this.currency = 'USD',
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
      businessName: json['business_name'] as String?,
      currency: json['currency'] as String? ?? 'USD',
    );
  }
}
