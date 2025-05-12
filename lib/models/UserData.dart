// Create this file at: lib/models/UserData.dart

class UserData {
  final String name;
  final String email;
  final String phone;
  final String address;
  final bool biometric;
  final String imageName;

  UserData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.biometric,
    required this.imageName,
  });
}