import 'dart:convert';

class RegisterResponse {
  String? id;
  String? fullname;
  String? username;
  dynamic birthdate;
  String? email;
  String? fotoUrl;
  DateTime? creadoen;

  RegisterResponse({
    this.id,
    this.fullname,
    this.username,
    this.birthdate,
    this.email,
    this.fotoUrl,
    this.creadoen,
  });

  factory RegisterResponse.fromMap(Map<String, dynamic> data) {
    return RegisterResponse(
      id: data['id'] as String?,
      fullname: data['fullname'] as String?,
      username: data['username'] as String?,
      birthdate: data['birthdate'] as dynamic,
      email: data['email'] as String?,
      fotoUrl: data['fotoUrl'] as String?,
      creadoen: data['creadoen'] == null
          ? null
          : DateTime.parse(data['creadoen'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'fullname': fullname,
        'username': username,
        'birthdate': birthdate,
        'email': email,
        'fotoUrl': fotoUrl,
        'creadoen': creadoen?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RegisterResponse].
  factory RegisterResponse.fromJson(String data) {
    return RegisterResponse.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RegisterResponse] to a JSON string.
  String toJson() => json.encode(toMap());
}
