class NotificacionRepost {
  String? nombreUsuario;
  String? foto;
  String? concepto;
  String? tiempo;
  VerRepostDto? verRepostDto;

  NotificacionRepost(
      {this.nombreUsuario,
      this.foto,
      this.concepto,
      this.tiempo,
      this.verRepostDto});

  NotificacionRepost.fromJson(Map<String, dynamic> json) {
    nombreUsuario = json['nombreUsuario'];
    foto = json['foto'];
    concepto = json['concepto'];
    tiempo = json['tiempo'];
    verRepostDto = json['verRepostDto'] != null
        ? new VerRepostDto.fromJson(json['verRepostDto'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombreUsuario'] = this.nombreUsuario;
    data['foto'] = this.foto;
    data['concepto'] = this.concepto;
    data['tiempo'] = this.tiempo;
    if (this.verRepostDto != null) {
      data['verRepostDto'] = this.verRepostDto!.toJson();
    }
    return data;
  }
}

class VerRepostDto {
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

  VerRepostDto(
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

  VerRepostDto.fromJson(Map<String, dynamic> json) {
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
