class BuscarPeticion {
  String? palabra;

  BuscarPeticion({this.palabra, required String query});

  BuscarPeticion.fromJson(Map<String, dynamic> json) {
    palabra = json['palabra'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['palabra'] = this.palabra;
    return data;
  }
}
