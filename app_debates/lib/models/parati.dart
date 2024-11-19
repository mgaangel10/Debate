class ParaTi {
  List<VerRepostDtos>? verRepostDtos;
  List<MostrarDebatesDtos>? mostrarDebatesDtos;

  ParaTi({this.verRepostDtos, this.mostrarDebatesDtos});

  ParaTi.fromJson(Map<String, dynamic> json) {
    if (json['verRepostDtos'] != null) {
      verRepostDtos = <VerRepostDtos>[];
      json['verRepostDtos'].forEach((v) {
        verRepostDtos!.add(new VerRepostDtos.fromJson(v));
      });
    }
    if (json['mostrarDebatesDtos'] != null) {
      mostrarDebatesDtos = <MostrarDebatesDtos>[];
      json['mostrarDebatesDtos'].forEach((v) {
        mostrarDebatesDtos!.add(new MostrarDebatesDtos.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.verRepostDtos != null) {
      data['verRepostDtos'] =
          this.verRepostDtos!.map((v) => v.toJson()).toList();
    }
    if (this.mostrarDebatesDtos != null) {
      data['mostrarDebatesDtos'] =
          this.mostrarDebatesDtos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VerRepostDtos {
  String? id;
  String? fotoUsuario;
  String? nombreUsuario;
  String? nombreDebate;
  String? imagenDebate;
  int? cantidadPersonasEnElDebate;
  String? mensajeChat;
  String? tiempoPublicado;
  int? cantidadMegusta;
  int? cantidadGuardados;
  int? cantidaComentraios;
  int? cantidadRespost;
  List<VerComentarioDtos>? verComentarioDtos;
  String? idUsuario;
  String? idDebate;
  String? idMensaje;

  VerRepostDtos(verRepostDtos,
      {this.id,
      this.fotoUsuario,
      this.nombreUsuario,
      this.nombreDebate,
      this.imagenDebate,
      this.cantidadPersonasEnElDebate,
      this.mensajeChat,
      this.tiempoPublicado,
      this.cantidadMegusta,
      this.cantidadGuardados,
      this.cantidaComentraios,
      this.cantidadRespost,
      this.verComentarioDtos,
      this.idUsuario,
      this.idDebate,
      this.idMensaje});

  VerRepostDtos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fotoUsuario = json['fotoUsuario'];
    nombreUsuario = json['nombreUsuario'];
    nombreDebate = json['nombreDebate'];
    imagenDebate = json['imagenDebate'];
    cantidadPersonasEnElDebate = json['cantidadPersonasEnElDebate'];
    mensajeChat = json['mensajeChat'];
    tiempoPublicado = json['tiempoPublicado'];
    cantidadMegusta = json['cantidadMegusta'];
    cantidadGuardados = json['cantidadGuardados'];
    cantidaComentraios = json['cantidaComentraios'];
    cantidadRespost = json['cantidadRespost'];
    if (json['verComentarioDtos'] != null) {
      verComentarioDtos = <VerComentarioDtos>[];
      json['verComentarioDtos'].forEach((v) {
        verComentarioDtos!.add(new VerComentarioDtos.fromJson(v));
      });
    }
    idUsuario = json['idUsuario'];
    idDebate = json['idDebate'];
    idMensaje = json['idMensaje'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fotoUsuario'] = this.fotoUsuario;
    data['nombreUsuario'] = this.nombreUsuario;
    data['nombreDebate'] = this.nombreDebate;
    data['imagenDebate'] = this.imagenDebate;
    data['cantidadPersonasEnElDebate'] = this.cantidadPersonasEnElDebate;
    data['mensajeChat'] = this.mensajeChat;
    data['tiempoPublicado'] = this.tiempoPublicado;
    data['cantidadMegusta'] = this.cantidadMegusta;
    data['cantidadGuardados'] = this.cantidadGuardados;
    data['cantidaComentraios'] = this.cantidaComentraios;
    data['cantidadRespost'] = this.cantidadRespost;
    if (this.verComentarioDtos != null) {
      data['verComentarioDtos'] =
          this.verComentarioDtos!.map((v) => v.toJson()).toList();
    }
    data['idUsuario'] = this.idUsuario;
    data['idDebate'] = this.idDebate;
    data['idMensaje'] = this.idMensaje;
    return data;
  }
}

class VerComentarioDtos {
  String? id;
  String? foto;
  String? nombreUsuario;
  String? idUsuario;
  String? contenido;
  int? cantidadMegusta;

  VerComentarioDtos(
      {this.id,
      this.foto,
      this.nombreUsuario,
      this.idUsuario,
      this.contenido,
      this.cantidadMegusta});

  VerComentarioDtos.fromJson(Map<String, dynamic> json) {
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
