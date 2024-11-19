class PerfilResponse {
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
  List<VerRepostDtos>? verRepostDtos;

  PerfilResponse(
      {this.id,
      this.name,
      this.lastName,
      this.foto,
      this.nombreUsuario,
      this.seguidores,
      this.seguidos,
      this.debatesUnidos,
      this.repost,
      this.siguiendo,
      this.verRepostDtos});

  PerfilResponse.fromJson(Map<String, dynamic> json) {
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
    if (json['verRepostDtos'] != null) {
      verRepostDtos = <VerRepostDtos>[];
      json['verRepostDtos'].forEach((v) {
        verRepostDtos!.add(new VerRepostDtos.fromJson(v));
      });
    }
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
    if (this.verRepostDtos != null) {
      data['verRepostDtos'] =
          this.verRepostDtos!.map((v) => v.toJson()).toList();
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

  VerRepostDtos(
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
      this.idDebate});

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
