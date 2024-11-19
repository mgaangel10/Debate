class Buscar {
  List<MostrarDebatesDtos>? mostrarDebatesDtos;
  List<Usuarios>? usuarios;

  Buscar({this.mostrarDebatesDtos, this.usuarios});

  Buscar.fromJson(Map<String, dynamic> json) {
    if (json['mostrarDebatesDtos'] != null) {
      mostrarDebatesDtos = <MostrarDebatesDtos>[];
      json['mostrarDebatesDtos'].forEach((v) {
        mostrarDebatesDtos!.add(new MostrarDebatesDtos.fromJson(v));
      });
    }
    if (json['usuarios'] != null) {
      usuarios = <Usuarios>[];
      json['usuarios'].forEach((v) {
        usuarios!.add(new Usuarios.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.mostrarDebatesDtos != null) {
      data['mostrarDebatesDtos'] =
          this.mostrarDebatesDtos!.map((v) => v.toJson()).toList();
    }
    if (this.usuarios != null) {
      data['usuarios'] = this.usuarios!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MostrarDebatesDtos {
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

  MostrarDebatesDtos(
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

  MostrarDebatesDtos.fromJson(Map<String, dynamic> json) {
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

class Usuarios {
  String? id;
  String? name;
  String? lastName;
  String? foto;
  String? nombreUsuario;
  int? seguidores;
  int? seguidos;
  int? debatesUnidos;
  int? repost;
  bool? siguiendo;

  Usuarios(
      {this.id,
      this.name,
      this.lastName,
      this.foto,
      this.nombreUsuario,
      this.seguidores,
      this.seguidos,
      this.debatesUnidos,
      this.repost,
      this.siguiendo});

  Usuarios.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    lastName = json['lastName'];
    foto = json['foto'];
    nombreUsuario = json['nombreUsuario'];
    seguidores = json['seguidores'];
    seguidos = json['seguidos'];
    debatesUnidos = json['debatesUnidos'];
    repost = json['repost'];
    siguiendo = json['siguiendo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['foto'] = this.foto;
    data['nombreUsuario'] = this.nombreUsuario;
    data['seguidores'] = this.seguidores;
    data['seguidos'] = this.seguidos;
    data['debatesUnidos'] = this.debatesUnidos;
    data['repost'] = this.repost;
    data['siguiendo'] = this.siguiendo;
    return data;
  }
}
