import 'user_response.dart';

class AuthResponse {
  final bool status;
  final String message;
  final String token;
  final UserResponse? user;

  const AuthResponse({
    required this.status,
    required this.message,
    required this.token,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? '',
      user: json['user'] != null
          ? UserResponse.fromJson(json['user'])
          : null,
    );
  }
}
