class SeguirUsuario {
  String? siguiendo;

  SeguirUsuario({this.siguiendo});

  SeguirUsuario.fromJson(Map<String, dynamic> json) {
    siguiendo = json['siguiendo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['siguiendo'] = this.siguiendo;
    return data;
  }
}
