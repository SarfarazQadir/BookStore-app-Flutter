class ModelUser {
  final String? id;
  final String fullName;
  final String email;
  final String phoneNo;
  final String password;

  const ModelUser({
    this.id,
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNo,
  });

  toJson() {
    return {
      "fullName": fullName,
      "Email": email,
      "Phone": phoneNo,
      "Password": password,
    };
  }
}
