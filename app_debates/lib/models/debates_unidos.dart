class DebatesUnidos {
  String? id;
  String? titulo;
  String? imagen;
  String? descripcion;
  int? numeroPersonasUnidas;
  String? ultimoMensaje;
  String? nombreCreador;
  String? foto;
  String? idCreador;
  String? fechaCreacion;

  DebatesUnidos(
      {this.id,
      this.titulo,
      this.imagen,
      this.descripcion,
      this.numeroPersonasUnidas,
      this.ultimoMensaje,
      this.nombreCreador,
      this.foto,
      this.idCreador,
      this.fechaCreacion});

  DebatesUnidos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    imagen = json['imagen'];
    descripcion = json['descripcion'];
    numeroPersonasUnidas = json['numeroPersonasUnidas'];
    ultimoMensaje = json['ultimoMensaje'];
    nombreCreador = json['nombreCreador'];
    foto = json['foto'];
    idCreador = json['idCreador'];
    fechaCreacion = json['fechaCreacion'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['imagen'] = this.imagen;
    data['descripcion'] = this.descripcion;
    data['numeroPersonasUnidas'] = this.numeroPersonasUnidas;
    data['ultimoMensaje'] = this.ultimoMensaje;
    data['nombreCreador'] = this.nombreCreador;
    data['foto'] = this.foto;
    data['idCreador'] = this.idCreador;
    data['fechaCreacion'] = this.fechaCreacion;
    return data;
  }
}
