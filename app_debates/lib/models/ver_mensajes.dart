class VerMensajes {
  String? id;
  String? nombreDelAutorDelMensaje;
  String? nombreDelDebate;
  String? contenido;
  int? personasReposteadas;
  String? tiempoPublicado;

  VerMensajes(
      {this.id,
      this.nombreDelAutorDelMensaje,
      this.nombreDelDebate,
      this.contenido,
      this.personasReposteadas,
      this.tiempoPublicado});

  VerMensajes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombreDelAutorDelMensaje = json['nombreDelAutorDelMensaje'];
    nombreDelDebate = json['nombreDelDebate'];
    contenido = json['contenido'];
    personasReposteadas = json['personasReposteadas'];
    tiempoPublicado = json['tiempoPublicado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nombreDelAutorDelMensaje'] = this.nombreDelAutorDelMensaje;
    data['nombreDelDebate'] = this.nombreDelDebate;
    data['contenido'] = this.contenido;
    data['personasReposteadas'] = this.personasReposteadas;
    data['tiempoPublicado'] = this.tiempoPublicado;
    return data;
  }
}
