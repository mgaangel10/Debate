class EnviarMensaje {
  String? contenido;

  EnviarMensaje({this.contenido});

  EnviarMensaje.fromJson(Map<String, dynamic> json) {
    contenido = json['contenido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contenido'] = this.contenido;
    return data;
  }
}
