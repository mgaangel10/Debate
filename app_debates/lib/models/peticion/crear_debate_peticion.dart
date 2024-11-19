class CrearDebatePeticion {
  String? titulo;
  String? imagen;
  String? descripcion;
  String? categorias;

  CrearDebatePeticion(
      {this.titulo, this.imagen, this.descripcion, this.categorias});

  CrearDebatePeticion.fromJson(Map<String, dynamic> json) {
    titulo = json['titulo'];
    imagen = json['imagen'];
    descripcion = json['descripcion'];
    categorias = json['categorias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['titulo'] = this.titulo;
    data['imagen'] = this.imagen;
    data['descripcion'] = this.descripcion;
    data['categorias'] = this.categorias;
    return data;
  }
}
