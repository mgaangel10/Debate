class MegustaGuardado {
  String? idRepost;
  String? idUsuario;
  bool? like;

  MegustaGuardado({this.idRepost, this.idUsuario, this.like});

  MegustaGuardado.fromJson(Map<String, dynamic> json) {
    idRepost = json['idRepost'];
    idUsuario = json['idUsuario'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idRepost'] = this.idRepost;
    data['idUsuario'] = this.idUsuario;
    data['like'] = this.like;
    return data;
  }
}
