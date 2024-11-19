import 'dart:convert';

class LoginDto {
  String? email;
  String? password;

  LoginDto({this.email, this.password});

  factory LoginDto.fromMap(Map<String, dynamic> data) => LoginDto(
        email: data['email'] as String?,
        password: data['password'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'password': password,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginDto].
  factory LoginDto.fromJson(String data) {
    return LoginDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
