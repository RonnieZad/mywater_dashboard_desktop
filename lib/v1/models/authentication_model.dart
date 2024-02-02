class AuthenticationModel {
  final String email;
  final String password;
  final String role;
  final String? confirmPassword;
  final String? phoneNumber;
  final String? companyName;
  final String? description;
  final String? website;
  final String? logoUrl;

  AuthenticationModel({
    required this.email,
    required this.password,
    required this.role,

    this.confirmPassword,
    this.phoneNumber,
    this.companyName,
    this.description,
    this.website,
    this.logoUrl
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> mapResult = {
      'email_address': email,
      'company_email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'company_name': companyName,
      'company_phone': phoneNumber,
      'company_description': description,
      'company_website': website,
      'company_logo': logoUrl,
      'role': role,
    };

    //remove null values
    return mapResult..removeWhere((key, value) => value == null);
  }
}
