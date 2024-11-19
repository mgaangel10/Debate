class VerComentarios {
  String? id;
  String? foto;
  String? nombreUsuario;
  String? idUsuario;
  String? contenido;
  int? cantidadMegusta;

  VerComentarios(
      {this.id,
      this.foto,
      this.nombreUsuario,
      this.idUsuario,
      this.contenido,
      this.cantidadMegusta});

  VerComentarios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foto = json['foto'];
    nombreUsuario = json['nombreUsuario'];
    idUsuario = json['idUsuario'];
    contenido = json['contenido'];
    cantidadMegusta = json['cantidadMegusta'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['foto'] = this.foto;
    data['nombreUsuario'] = this.nombreUsuario;
    data['idUsuario'] = this.idUsuario;
    data['contenido'] = this.contenido;
    data['cantidadMegusta'] = this.cantidadMegusta;
    return data;
  }
}
