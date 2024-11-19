import 'dart:convert';

class RegisterDto {
  String? email;
  String? name;
  String? lastName;
  String? password;
  String? phoneNumber;

  RegisterDto({
    this.email,
    this.name,
    this.lastName,
    this.password,
    this.phoneNumber,
  });

  factory RegisterDto.fromMap(Map<String, dynamic> data) => RegisterDto(
        email: data['email'] as String?,
        name: data['name'] as String?,
        lastName: data['lastName'] as String?,
        password: data['password'] as String?,
        phoneNumber: data['phoneNumber'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'email': email,
        'name': name,
        'lastName': lastName,
        'password': password,
        'phoneNumber': phoneNumber,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterDto].
  factory RegisterDto.fromJson(String data) {
    return RegisterDto.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegisterDto] to a JSON string.
  String toJson() => json.encode(toMap());
}
