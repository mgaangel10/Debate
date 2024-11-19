import 'dart:convert';
import 'dart:io';

import 'package:app_debates/models/guardar_repost.dart';
import 'package:app_debates/models/megusta_guardado.dart';
import 'package:app_debates/models/parati.dart' as parati;
import 'package:app_debates/models/parati.dart';
import 'package:app_debates/models/peticion/comentar.dart';
import 'package:app_debates/pages/chat.dart';
import 'package:app_debates/pages/perfil_usuario.dart';

import 'package:app_debates/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ParaTi? paraTiData;
  bool isLoading = true;
  final ApiService _apiService = ApiService();
  late StompClient client;
  bool _isLiked = false;
  bool isSaved = false; // Variable para rastrear el estado del guardado

  @override
  void initState() {
    super.initState();
    fetchParaTiData();
    loquesea();
  }

  void loquesea() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    client = StompClient(
      config: StompConfig(
        url: 'ws://10.0.2.2:9000/gifts',
        onConnect: onConnect,
        onStompError: (dynamic error) => print('STOMP error: $error'),
        onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
        onDisconnect: (frame) {
          Future.delayed(Duration(seconds: 5), () {
            client.activate();
          });
        },
        webSocketConnectHeaders: {'Authorization': 'Bearer $token'},
        stompConnectHeaders: {'Authorization': 'Bearer $token'},
      ),
    );
    client.activate();
  }

  void onConnect(StompFrame frame) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString("nombre");
    // Suscribirse al canal de reposts
    client.subscribe(
      destination: '/topic/messages',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final body = json.decode(frame.body!);
          print('Mensaje recibido desde WebSocket (repost): ${frame.body}');
          final nuevoRepost = parati.VerRepostDtos.fromJson(body);
          _agregarNuevoRepost(nuevoRepost);
        }
      },
    );

    // Suscribirse al canal de "me gusta"
    client.subscribe(
      destination: '/topic/likes',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final body = json.decode(frame.body!);
          print('Mensaje recibido desde WebSocket (me gusta): ${frame.body}');
          final updatedRepost = parati.VerRepostDtos.fromJson(body);
          _actualizarCantidadMegusta(updatedRepost);
        }
      },
    );
    client.subscribe(
      destination: '/topic/guardar',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final body = json.decode(frame.body!);
          print('Mensaje recibido desde WebSocket (guardado): ${frame.body}');
          final updatedRepost = VerRepostDtos.fromJson(body);
          _actualizarCantidadGuardado(updatedRepost);
        }
      },
    );

    client.subscribe(
      destination: '/topic/comentar',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final body = json.decode(frame.body!);
          final nuevoComentario = parati.VerComentarioDtos.fromJson(body);

          // Obtener el repost al que pertenece el nuevo comentario
          final repost = paraTiData?.verRepostDtos?.firstWhere(
            (r) =>
                r.id ==
                nuevoComentario
                    .id, // Cambia a idMensaje si es el identificador correcto
            orElse: () => VerRepostDtos(
              [], // Proporcionar un argumento por defecto
              id: '', // O los demás campos que necesites inicializar
              fotoUsuario: '',
              nombreUsuario: '${nombre}',
              nombreDebate: '',
              imagenDebate: '',
              cantidadPersonasEnElDebate: 0,
              mensajeChat: '',
              tiempoPublicado: '',
              cantidadMegusta: 0,
              cantidadGuardados: 0,
              cantidaComentraios: 0,
              cantidadRespost: 0,
              verComentarioDtos: [],
              idUsuario: '',
              idDebate: '',
              idMensaje: '',
            ),
          );

          // Solo actualiza si el repost no está vacío
          if (repost != null && repost.id != null) {
            setState(() {
              // Asegúrate de inicializar la lista de comentarios si es nula
              repost.verComentarioDtos ??= [];
              repost.verComentarioDtos!
                  .add(nuevoComentario); // Agrega el nuevo comentario
              repost.cantidaComentraios = (repost.cantidaComentraios);
            });
          }
        }
      },
    );
  }

  void _agregarNuevoRepost(VerRepostDtos nuevoRepost) {
    if (!mounted) return;
    print('Agregando nuevo repost: $nuevoRepost');
    setState(() {
      paraTiData ??= ParaTi(verRepostDtos: []);
      paraTiData!.verRepostDtos!.insert(0, nuevoRepost);
    });
  }

  @override
  void dispose() {
    client.deactivate();
    super.dispose();
  }

  Future<void> _repostMessage(String idMensaje) async {
    if (client.connected) {
      final respostResponse = await _apiService.repostear(idMensaje);
      client.send(
          destination: 'app/gifts',
          body: json.encode({'idMensaje con webSocket': idMensaje}));
      print('Mensaje enviado: ${json.encode({'idMensaje': idMensaje})}');
    } else {
      print('Cliente no está conectado');
    }
  }

  void _actualizarCantidadMegusta(VerRepostDtos updatedRepost) {
    if (!mounted) return;
    setState(() {
      // Buscar y actualizar el repost en la lista
      final index = paraTiData?.verRepostDtos
          ?.indexWhere((repost) => repost.id == updatedRepost.id);
      if (index != null && index >= 0) {
        paraTiData!.verRepostDtos![index] = updatedRepost;
      }
    });
  }

  Future<void> _toggleMeGusta(String idRepost) async {
    try {
      if (_isLiked) {
        await _apiService
            .quitarMegusta(idRepost); // Nueva función para quitar "me gusta"
        _isLiked = false;
        client.send(
          destination: '/app/unlike',
          body: json.encode({'idRepost': idRepost}),
        );
      } else {
        await _apiService.darMegustaRepost(idRepost);
        _isLiked = true;
        client.send(
          destination: '/app/likes',
          body: json.encode({'idRepost': idRepost}),
        );
      }
      setState(() {}); // Actualizar la interfaz
    } catch (error) {
      print('Error al cambiar "me gusta": $error');
    }
  }

  void _actualizarCantidadGuardado(VerRepostDtos updatedRepost) {
    if (!mounted) return;
    setState(() {
      // Buscar y actualizar el repost en la lista
      final index = paraTiData?.verRepostDtos
          ?.indexWhere((repost) => repost.id == updatedRepost.id);
      print("Índice de guardado: $index"); // Depuración
      print(
          "Datos de updatedRepost: ${updatedRepost.cantidadGuardados}"); // Depuración
      if (index != null && index >= 0) {
        paraTiData!.verRepostDtos![index] = updatedRepost;
        print("Actualización de guardados realizada");
      } else {
        print("No se encontró el repost para actualizar");
      }
    });
  }

  void _actualizarComentarios(parati.VerComentarioDtos nuevoComentario) {
    if (!mounted) return;
    setState(() {
      var repost = paraTiData?.verRepostDtos?.firstWhere(
        (r) => r.idMensaje == nuevoComentario.id,
        orElse: () => VerRepostDtos([],
            id: '',
            fotoUsuario: '',
            nombreUsuario: '',
            nombreDebate: '',
            imagenDebate: '',
            cantidadPersonasEnElDebate: 0,
            mensajeChat: '',
            tiempoPublicado: '',
            cantidadMegusta: 0,
            cantidadGuardados: 0,
            cantidaComentraios: 0,
            cantidadRespost: 0,
            verComentarioDtos: [],
            idUsuario: '',
            idDebate: '',
            idMensaje: ''),
      );
      if (repost != null) {
        repost.verComentarioDtos ??= [];
        repost.verComentarioDtos!.add(nuevoComentario);
        repost.cantidaComentraios = (repost.cantidaComentraios);
      }
    });
  }

  Future<void> _darMeGusta(String idRepost) async {
    try {
      await _apiService.darMegustaRepost(idRepost);

      _isLiked = true;
      client.send(
        destination: '/app/likes',
        body: json.encode({'idRepost': idRepost}),
      );
      print('Mensaje enviado para me gusta: ${json.encode({
            'idRepost': idRepost
          })}');
    } catch (error) {
      print('Error al dar me gusta: $error');
    }
  }

  void _guardarRepost(String idRepost) async {
    try {
      // Aquí llamas a tu método para guardar el repost
      await _apiService.guardarRepost(idRepost);
      final MegustaGuardado megustaGuardado;

      // Luego actualizas el estado para reflejar que ha sido guardado
      setState(() {
        isSaved = true; // Cambiar a true para indicar que se ha guardado
      });

      // Enviar el mensaje al WebSocket
      client.send(
        destination: '/app/guardar',
        body: json.encode({'idRepost': idRepost}),
      );
    } catch (error) {
      print('Error al guardar el repost: $error');
    }
  }

  void fetchParaTiData() async {
    try {
      ParaTi data = await _apiService.paraTi();
      setState(() {
        paraTiData = data;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _showCommentsModal(String idRepost) async {
    TextEditingController _commentController = TextEditingController();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? nombre = prefs.getString("nombre");
    try {
      List<parati.VerComentarioDtos> comentarios =
          await _apiService.verComentarios(idRepost);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: comentarios.length,
                        itemBuilder: (context, index) {
                          final comentario = comentarios[index];

                          // Maneja el caso donde nombreUsuario puede ser null
                          final nombreUsuario =
                              comentario.nombreUsuario ?? '${nombre}';
                          final contenido = comentario
                              .contenido!; // Manejar el contenido también

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(comentario.foto ??
                                  'default_image_url'), // Imagen por defecto si no hay foto
                            ),
                            title: Text(
                              nombreUsuario,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(contenido),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.favorite,
                                        color: Colors.red, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                        '${comentario.cantidadMegusta ?? 0}'), // Valor predeterminado
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Escribe un comentario...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.blue),
                          onPressed: () async {
                            if (_commentController.text.isNotEmpty) {
                              Comentar nuevoComentario = Comentar(
                                contenido: _commentController.text,
                                // Agrega otros campos necesarios
                              );
                              try {
                                // Enviar el nuevo comentario a la API
                                await _apiService.comentarRepost(
                                    idRepost, nuevoComentario);

                                // Actualizar la lista local de comentarios
                                setState(() {
                                  comentarios.add(parati.VerComentarioDtos(
                                    contenido: nuevoComentario.contenido,
                                    // Agrega otros campos como nombreUsuario, foto, etc.
                                  ));
                                });
                                _commentController.clear();
                              } catch (error) {
                                print('Error posting comment: $error');
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    } catch (error) {
      print('Error loading comments: $error');
    }
  }

  void _actualizarCantidadComentarios(VerRepostDtos updatedRepost) {
    if (!mounted) return;
    setState(() {
      final index = paraTiData?.verRepostDtos
          ?.indexWhere((repost) => repost.id == updatedRepost.id);
      if (index != null && index >= 0) {
        paraTiData!.verRepostDtos![index] = updatedRepost;
        paraTiData!.verRepostDtos![index].cantidaComentraios =
            (paraTiData!.verRepostDtos![index].cantidaComentraios);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Para Ti',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 5,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : paraTiData == null
              ? const Center(child: Text('No data available'))
              : ListView.builder(
                  itemCount: paraTiData!.verRepostDtos?.length ?? 0,
                  itemBuilder: (context, index) {
                    final repost = paraTiData!.verRepostDtos![index];
                    return Dismissible(
                      key: Key(repost.id!),
                      direction: DismissDirection.startToEnd,
                      confirmDismiss: (direction) async {
                        _repostMessage(repost.idMensaje!);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Has reposteado este contenido')),
                        );
                        return false;
                      },
                      background: Container(
                        color: Colors.blue,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20.0),
                        child: const Icon(Icons.repeat,
                            color: Colors.white, size: 30),
                      ),
                      child: Card(
                        color: Color.fromARGB(255, 187, 204, 218),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PerfilUsuario(
                                              id: repost.idUsuario!),
                                        ),
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(repost.fotoUsuario!),
                                      radius: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              repost.nombreUsuario!,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[800],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.repeat,
                                                    size: 16,
                                                    color: Colors.grey[
                                                        600]), // Icono de repost
                                                const SizedBox(width: 2),
                                                Text(
                                                  '${repost.cantidadRespost}', // Cantidad de reposts
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                            height:
                                                4), // Espacio entre el nombre y el tiempo
                                        Text(
                                          repost
                                              .tiempoPublicado!, // Tiempo publicado
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                4), // Espacio entre el tiempo y la imagen
                                        GestureDetector(
                                          onTap: () {
                                            // Navegar a la página del debate
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => ChatPage(
                                                  debateId: repost.idDebate!,
                                                  nombreUsuario:
                                                      repost.nombreUsuario!,
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.grey.shade200,
                                                  Colors.grey.shade300,
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ClipOval(
                                                  child: Image.file(
                                                    File(repost.imagenDebate!),
                                                    width: 24,
                                                    height: 24,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Icon(Icons.error,
                                                          size: 24,
                                                          color: Colors.red);
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Navegar a la página del debate
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ChatPage(
                                                          debateId:
                                                              repost.idDebate!,
                                                          nombreUsuario: repost
                                                              .nombreUsuario!,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.grey.shade200,
                                                          Colors.grey.shade300,
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                          repost.nombreDebate!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey[800],
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    width:
                                                        8), // Espacio entre el botón y el número de personas
                                                // Icono de personas
                                                Row(
                                                  children: [
                                                    Icon(Icons.people,
                                                        size: 16,
                                                        color:
                                                            Colors.grey[600]),
                                                    const SizedBox(
                                                        width:
                                                            4), // Espacio entre el icono y el número
                                                    Text(
                                                      '${repost.cantidadPersonasEnElDebate}', // Número de personas en el debate
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                repost.mensajeChat!,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      _toggleMeGusta(repost.id!);
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            AnimatedScale(
                                              scale: _isLiked ? 1.5 : 1.0,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              child: Icon(
                                                _isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _isLiked
                                                    ? Colors.red
                                                    : Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              '${repost.cantidadMegusta}',
                                              style: TextStyle(
                                                  color: Colors.blueAccent),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showCommentsModal(repost.id!),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.comment,
                                                color: Colors.blueAccent),
                                            const SizedBox(width: 3),
                                            Text('${repost.cantidaComentraios}',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _guardarRepost(repost.id!),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: AnimatedContainer(
                                        duration: Duration(milliseconds: 200),
                                        padding: const EdgeInsets.all(10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade200,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 5,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.bookmark,
                                                color: Colors.amberAccent),
                                            const SizedBox(width: 3),
                                            Text('${repost.cantidadGuardados}',
                                                style: TextStyle(
                                                    color: Colors.blueAccent)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildActionIcon({
    required IconData icon,
    required Color color,
    required int count,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDebatesCard(List<MostrarDebatesDtos> debates) {
    if (debates.length < 3) {
      return const Center(child: Text('Not enough debates available'));
    }
    return Card(
      color: Colors.orange,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: buildDebateItem(debates[0]),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: Column(
                    children: [
                      buildDebateItem(debates[1]),
                      const SizedBox(height: 8.0),
                      buildDebateItem(debates[2]),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDebateItem(MostrarDebatesDtos debate) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(debate.foto!), // Usamos la foto como fondo
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode
                  .darken), // Ajuste de color para mejor visibilidad del texto
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Center(
          child: Text(
            debate.titulo!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }
}
