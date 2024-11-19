import 'dart:convert';
import 'dart:ffi';

import 'package:app_debates/models/buscar.dart';
import 'package:app_debates/models/crear_debate_response.dart';
import 'package:app_debates/models/debates_unidos.dart';
import 'package:app_debates/models/details_debates.dart';
import 'package:app_debates/models/enviar_mensaje_response.dart';
import 'package:app_debates/models/guardar_repost.dart';
import 'package:app_debates/models/login_response.dart';
import 'package:app_debates/models/megusta_guardado.dart';
import 'package:app_debates/models/notificion_repost.dart';
import 'package:app_debates/models/parati.dart' as parati;
import 'package:app_debates/models/parati.dart';
import 'package:app_debates/models/perfil_usuarios.dart';
import 'package:app_debates/models/peticion/buscar_peticion.dart';
import 'package:app_debates/models/peticion/comentar.dart';
import 'package:app_debates/models/peticion/crear_debate_peticion.dart';
import 'package:app_debates/models/peticion/enviar_mensaje.dart';
import 'package:app_debates/models/peticion/login.dart';
import 'package:app_debates/models/peticion/register.dart';
import 'package:app_debates/models/register_response.dart';
import 'package:app_debates/models/repost_repsonse.dart';
import 'package:app_debates/models/seguir.dart';
import 'package:app_debates/models/ver_mensajes.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Unirse_al_debate_response.dart';
import '../models/perfil_response.dart' as perfil;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:9000'; // Para el emulador

  //VER MEGUSTAS DEL USUARIO
  Future<List<perfil.VerRepostDtos>> verMegustasUsuarios() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('$baseUrl/usuario/ver/sus/megustas'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final List<dynamic> responseBody = json.decode(response.body);
        print('repost dado megustas: ${response.body}');

        // Mostrar notificación de repost

        return responseBody
            .map((json) => perfil.VerRepostDtos.fromJson(json))
            .toList();
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(
          'Error al obtener notificaciones de repost: ${response.statusCode}');
    }
  }

  // NOTIFICACIONES DE REPOST
  Future<List<NotificacionRepost>> notificacionesRepost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('$baseUrl/usuario/notificacion/repost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final List<dynamic> responseBody = json.decode(response.body);
        print('Response body: ${response.body}');

        // Mostrar notificación de repost

        return responseBody
            .map((json) => NotificacionRepost.fromJson(json))
            .toList();
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception(
          'Error al obtener notificaciones de repost: ${response.statusCode}');
    }
  }

//quitar me gusta
  Future<void> QuitarMegusta(String idUsuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:9000/usuario/quitar/megusta/${idUsuario}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 204) {
      // La respuesta no debe tener cuerpo para el código 204
      print('El "guardado" ha sido quitado exitosamente.');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al quitar "me gusta": ${response.statusCode}');
    }
  }

  //DEJAR DE SEGUIR
  Future<void> dejarDeSeguirUsuario(String idUsuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
        Uri.parse('http://10.0.2.2:9000/usuario/dejar/seguir/${idUsuario}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: null);

    if (response.statusCode == 201) {
      // La respuesta no debe tener cuerpo para el código 204
      print('El "guardado" ha sido quitado exitosamente.');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al quitar "me gusta": ${response.statusCode}');
    }
  }

  //REPOSTEAR

  Future<RespostResponse> repostear(String idDebate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final response = await http.post(
      Uri.parse('$baseUrl/usuario/repostear/$idDebate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: null,
    );
    if (response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        final responseBody =
            RespostResponse.fromJson(json.decode(response.body));
        print('Response body: ${response.body}');
        return responseBody;
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al repostear: ${response.statusCode}');
    }
  }

  //DAR MEGUSTA REPOST
  Future<parati.VerRepostDtos> darMegustaRepost(String idRepost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
        Uri.parse('http://10.0.2.2:9000/usuario/dar/megusta/${idRepost}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: null);

    if (response.statusCode == 201) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final responseBody =
            parati.VerRepostDtos.fromJson(json.decode(response.body));
        print('Response body succes: ${response.body}');
        return responseBody;
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al seguir: ${response.statusCode}');
    }
  }

  //QUITAR GUARDADO
  Future<void> quitarGuardado(String idRepost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:9000/usuario/quitar/guardado/${idRepost}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 204) {
      // La respuesta no debe tener cuerpo para el código 204
      print('El "guardado" ha sido quitado exitosamente.');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al quitar "me gusta": ${response.statusCode}');
    }
  }

  //QUITAR MEGUSTA
  Future<void> quitarMegusta(String idRepost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:9000/usuario/quitar/megusta/${idRepost}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 204) {
      // La respuesta no debe tener cuerpo para el código 204
      print('El "me gusta" ha sido quitado exitosamente.');
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al quitar "me gusta": ${response.statusCode}');
    }
  }

  //GUARDAR REPOST
  Future<parati.VerRepostDtos> guardarRepost(String idRepost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
        Uri.parse('http://10.0.2.2:9000/usuario/guardar/repost/${idRepost}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: null);

    if (response.statusCode == 201) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final responseBody =
            parati.VerRepostDtos.fromJson(json.decode(response.body));
        print('Response body succes: ${response.body}');
        return responseBody;
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al seguir: ${response.statusCode}');
    }
  }

  //SEGUIR A USUARIO
  Future<SeguirUsuario> SeguirAUsuario(String idUsuario) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
        Uri.parse('http://10.0.2.2:9000/usuario/seguir/${idUsuario}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: null);

    if (response.statusCode == 201) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final responseBody = SeguirUsuario.fromJson(json.decode(response.body));
        print('Response body succes: ${response.body}');
        return responseBody;
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al seguir: ${response.statusCode}');
    }
  }

  //ver perfil de un usuario
  Future<PerfilUSuariosREsponse> verPerfilUsuario(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:9000/usuario/ver/detalles/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final responseBody =
            PerfilUSuariosREsponse.fromJson(json.decode(response.body));
        print('Response body: ${response.body}');
        return responseBody;
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al repostear: ${response.statusCode}');
    }
  }

  //VER PERFIL
  Future<perfil.PerfilResponse> verPerfil() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:9000/usuario/ver/perfil'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      // Verifica si el cuerpo de la respuesta no está vacío
      if (response.body.isNotEmpty) {
        final responseBody =
            perfil.PerfilResponse.fromJson(json.decode(response.body));
        print('Response body: ${response.body}');
        return responseBody;
      } else {
        print('Respuesta vacía');
        throw Exception('El servidor devolvió una respuesta vacía');
      }
    } else {
      print('Error: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Error al repostear: ${response.statusCode}');
    }
  }

  //ENVIAR MENSAJE
  Future<EnviarMensajeResponse> enviarMensaje(
      EnviarMensaje enviar, String idDebate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse('http://10.0.2.2:9000/usuario/enviar/$idDebate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(enviar.toJson()),
    );

    if (response.statusCode == 201) {
      final responseBody =
          EnviarMensajeResponse.fromJson(json.decode(response.body));
      print('Response body: ${response.body}');
      return responseBody;
    } else {
      print('Error: ${response.statusCode}'); // Muestra el código de estado
      print(
          'Response body: ${response.body}'); // Muestra el cuerpo de la respuesta
      throw Exception(
          'Failed to send message'); // Cambié UnimplementedError por Exception
    }
  }

  //DETALLES DEBATES
  Future<DetallesDebates> detallesDebates(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:9000/usuario/buscar/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final responseBody = DetallesDebates.fromJson(json.decode(response.body));
      final content = responseBody;
      print('Response body: ${response.body}'); // <--- Agrega este log

      print(content);
      return content;
    } else {
      throw UnimplementedError('Failed to load comercios');
    }
  }

  //VER MENSAJES
  Future<List<VerMensajes>> verMensajes(String idDebate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:9000/usuario/ver/mensajes/${idDebate}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List;
      final content =
          responseBody.map((json) => VerMensajes.fromJson(json)).toList();
      return content;
    } else {
      throw Exception('Failed to load buscar');
    }
  }

  //CREAR DEBATE
  Future<CrearDebateResponse> crearDebate(CrearDebatePeticion loginDto) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final body = json.encode(loginDto.toJson());
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9000/usuario/crear/debate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(loginDto.toJson()),
    );
    if (response.statusCode == 201) {
      final responseBody =
          CrearDebateResponse.fromJson(json.decode(response.body));

      return responseBody;
    } else {
      throw Exception('El email y/o contraseña no son correctos');
    }
  }

  //VER DEBATES UNIDOS
  Future<List<DebatesUnidos>> debatesUnidos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:9000/usuario/ver/debates/unidos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List;
      final content =
          responseBody.map((json) => DebatesUnidos.fromJson(json)).toList();
      return content;
    } else {
      throw Exception('Failed to load buscar');
    }
  }

  //SALIRSE DEL DEBATE
  Future<void> salirseDelBate(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.delete(
      Uri.parse('http://10.0.2.2:9000/usuario/salir/del/debate/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 204) {
    } else {
      print(response.body);
      throw Exception('El email y/o contraseña no son correctos');
    }
  }

  //UNIRSE AL DEBATE
  Future<UnirseAlDebate> unirseAlDebate(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse('http://10.0.2.2:9000/usuario/unirse/al/debate/${id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 201) {
      final responseBody = UnirseAlDebate.fromJson(json.decode(response.body));

      return responseBody;
    } else {
      throw Exception('El email y/o contraseña no son correctos');
    }
  }

  //BUSCAR
  Future<List<Buscar>> buscar(BuscarPeticion buscar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    final body = json.encode(buscar.toJson());
    print("Request body: $body");
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9000/usuario/buscar'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(buscar.toJson()),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List;
      final content =
          responseBody.map((json) => Buscar.fromJson(json)).toList();
      return content;
    } else {
      throw Exception('Failed to load buscar');
    }
  }

  //COMENTARIOS

  Future<List<parati.VerComentarioDtos>> verComentarios(String idRepost) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse(
          'http://10.0.2.2:9000/usuario/ver/comentarios/repost/$idRepost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List;
      final content = responseBody
          .map((json) => parati.VerComentarioDtos.fromJson(json))
          .toList();
      return content;
    } else {
      throw Exception('Failed to load comentarios');
    }
  }

//comentar
  Future<List<parati.VerComentarioDtos>> comentarRepost(
      String idRepost, Comentar comentar) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.post(
      Uri.parse('$baseUrl/usuario/comentar/repost/$idRepost'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(comentar.toJson()),
    );

    if (response.statusCode == 201) {
      // Cambia el manejo de la respuesta aquí
      final responseBody = json.decode(response.body);

      // Suponiendo que la respuesta tiene la lista de comentarios bajo una clave como "comentarios"
      if (responseBody['comentarios'] != null) {
        // Accede a la lista de comentarios
        final List<dynamic> comentariosJson = responseBody['comentarios'];
        return comentariosJson
            .map((json) => parati.VerComentarioDtos.fromJson(json))
            .toList();
      } else {
        return []; // Retorna una lista vacía si no hay comentarios
      }
    } else {
      throw Exception('Failed to post comment');
    }
  }

  //LOGIN
  Future<LoginResponse> login(LoginDto loginDto) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9000/auth/login/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
      },
      body: loginDto.toJson(),
    );
    if (response.statusCode == 201) {
      LoginResponse loginResponse = LoginResponse.fromJson(response.body);
      String? token = loginResponse.token;
      String? id = loginResponse.id;
      String? nombreUsuario = loginResponse.email;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token!);
      await prefs.setString('userId', id!);
      await prefs.setString('nombre', nombreUsuario!);

      return loginResponse;
    } else {
      throw Exception('El email y/o contraseña no son correctos');
    }
  }
  //REGISTRO

  Future<RegisterResponse> register(
    RegisterDto registerDto,
  ) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:9000/auth/register/user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: registerDto.toJson(),
    );
    print('usuarioId guardado: ${response.body}');
    if (response.statusCode == 201) {
      return RegisterResponse.fromJson(response.body);
    } else {
      var errorResponse = jsonDecode(response.body);
      throw Exception('${errorResponse['message']}');
    }
  }

  //HOME
  Future<ParaTi> paraTi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:9000/usuario/paraTi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final responseBody = ParaTi.fromJson(json.decode(response.body));
      final content = responseBody;
      print('Response body: ${response.body}'); // <--- Agrega este log

      print(content.verRepostDtos);
      return content;
    } else {
      throw UnimplementedError('Failed to load comercios');
    }
  }
}
