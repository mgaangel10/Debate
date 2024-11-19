import 'dart:convert';

class LoginResponse {
  String? id;
  String? fullname;
  String? username;
  String? email;
  DateTime? creadoen;
  String? token;

  LoginResponse({
    this.id,
    this.fullname,
    this.username,
    this.email,
    this.creadoen,
    this.token,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> data) => LoginResponse(
        id: data['id'] as String?,
        fullname: data['fullname'] as String?,
        username: data['username'] as String?,
        email: data['email'] as String?,
        creadoen: data['creadoen'] == null
            ? null
            : DateTime.parse(data['creadoen'] as String),
        token: data['token'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullname': fullname,
        'username': username,
        'email': email,
        'creadoen': creadoen?.toIso8601String(),
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LoginResponse].
  factory LoginResponse.fromJson(String data) {
    return LoginResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LoginResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
