class CrearDebateResponse {
  String? id;
  String? titulo;
  String? imagen;
  String? descripcion;
  String? categorias;

  CrearDebateResponse(
      {this.id, this.titulo, this.imagen, this.descripcion, this.categorias});

  CrearDebateResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titulo = json['titulo'];
    imagen = json['imagen'];
    descripcion = json['descripcion'];
    categorias = json['categorias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['titulo'] = this.titulo;
    data['imagen'] = this.imagen;
    data['descripcion'] = this.descripcion;
    data['categorias'] = this.categorias;
    return data;
  }
}
