import 'package:app_debates/models/parati.dart' as parati;
import 'package:app_debates/models/parati.dart';
import 'package:app_debates/models/perfil_usuarios.dart';
import 'package:app_debates/models/peticion/comentar.dart';
import 'package:app_debates/pages/chat.dart';
import 'package:app_debates/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilUsuario extends StatefulWidget {
  final String id; // Recibe el ID del usuario
  const PerfilUsuario({super.key, required this.id});

  @override
  State<PerfilUsuario> createState() => _PerfilUsuarioState();
}

class _PerfilUsuarioState extends State<PerfilUsuario> {
  ApiService apiService = ApiService();
  PerfilUSuariosREsponse? perfil;
  bool isLoading = true;
  ParaTi? paraTiData;
  String? userId;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    cargarPerfilUsuario();
    _getUserId();
  }

  Future<void> cargarPerfilUsuario() async {
    try {
      PerfilUSuariosREsponse perfilResponse =
          await apiService.verPerfilUsuario(widget.id);
      setState(() {
        perfil = perfilResponse;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar el perfil: $e');
    }
  }

  Future<void> toggleSeguir() async {
    // Cambiar el estado del botón inmediatamente para reflejar la acción
    setState(() {
      perfil!.siguiendo = !perfil!.siguiendo!;
    });

    try {
      // Llamada a la API para seguir o dejar de seguir al usuario
      if (perfil!.siguiendo!) {
        await apiService.SeguirAUsuario(widget.id); // Seguir al usuario
      } else {
        await apiService
            .dejarDeSeguirUsuario(widget.id); // Dejar de seguir al usuario
      }
      print(perfil!.siguiendo!
          ? "Siguiendo al usuario"
          : "Dejando de seguir al usuario");
    } catch (e) {
      // Si falla, revertimos el estado para mantener la UI consistente
      setState(() {
        perfil!.siguiendo = !perfil!.siguiendo!;
      });
      print('Error al intentar seguir/dejar de seguir: $e');
    }
  }

  Future<void> _darMeGusta(String idRepost) async {
    try {
      await _apiService.darMegustaRepost(idRepost);
      // Actualiza la UI, puedes incrementar la cantidad de "me gusta" aquí
      setState(() {
        // Busca el repost y actualiza la cantidad de "me gusta"
        var repost =
            paraTiData?.verRepostDtos?.firstWhere((r) => r.id == idRepost);
        if (repost != null) {
          repost.cantidadMegusta; // Incrementa la cantidad de "me gusta"
        }
      });
    } catch (error) {
      print('Error al dar me gusta: $error');
    }
  }

  Future<void> _guardarRepost(String idRepost) async {
    try {
      await _apiService.guardarRepost(idRepost);
      // Actualiza la UI, puedes incrementar la cantidad de "me gusta" aquí
      setState(() {
        // Busca el repost y actualiza la cantidad de "me gusta"
        var repost =
            paraTiData?.verRepostDtos?.firstWhere((r) => r.id == idRepost);
        if (repost != null) {
          repost.cantidadMegusta; // Incrementa la cantidad de "me gusta"
        }
      });
    } catch (error) {
      print('Error al dar me gusta: $error');
    }
  }

  Future<void> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString(
          'userId'); // Cambia 'userId' según el nombre que usaste para guardar el ID
    });
  }

  Future<void> _showCommentsModal(String idRepost) async {
    TextEditingController _commentController = TextEditingController();

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
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(comentarios[index].foto!),
                            ),
                            title: Text(
                              comentarios[index].nombreUsuario!,
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
                                  child: Text(comentarios[index].contenido!),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.favorite,
                                        color: Colors.red, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                        '${comentarios[index].cantidadMegusta}'),
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
                                List<parati.VerComentarioDtos>
                                    updatedComentarios =
                                    await _apiService.comentarRepost(
                                        idRepost, nuevoComentario);
                                setState(() {
                                  comentarios = updatedComentarios;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : perfil != null
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Imagen del usuario
                      perfil!.foto != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(perfil!.foto!),
                              radius: 50.0,
                            )
                          : const CircleAvatar(
                              radius: 50.0,
                              child: Icon(Icons.person, size: 50),
                            ),
                      const SizedBox(height: 16),

                      // Nombre completo y nombre de usuario
                      Text(
                        '${perfil!.name ?? ''} ${perfil!.lastName ?? ''}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '@${perfil!.nombreUsuario ?? ''}',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Información de Seguidores y Seguidos
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                perfil!.seguidores.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Seguidores'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                perfil!.seguidos.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Seguidos'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Información de Debates Unidos y Reposts
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                perfil!.debatesUnidos.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Debates Unidos'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                perfil!.repost.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Reposts'),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                      const Divider(thickness: 1, color: Colors.grey),
                      const SizedBox(height: 10),

                      // Botón de Seguir/Siguiendo
                      if (userId != widget.id)
                        ElevatedButton(
                          onPressed: toggleSeguir,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: perfil!.siguiendo!
                                ? const Color.fromARGB(255, 226, 92, 92)
                                : Colors.blue,
                          ),
                          child: Text(perfil!.siguiendo!
                              ? 'Dejar de seguir'
                              : 'Seguir'),
                        ),
                      const SizedBox(height: 20),

                      // Mostrar la lista de reposts
                      perfil!.verRepostDtos != null &&
                              perfil!.verRepostDtos!.isNotEmpty
                          ? Expanded(
                              child: ListView(children: [
                                ...?perfil!.verRepostDtos?.map((repost) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  repost.fotoUsuario!),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  repost.nombreUsuario!,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    // Navega a la página de chat pasando el id del debate
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChatPage(
                                                                  debateId: repost
                                                                      .idDebate!,
                                                                  nombreUsuario:
                                                                      repost
                                                                          .nombreUsuario!)),
                                                    );
                                                  },
                                                  child: Card(
                                                    color:
                                                        Colors.green.shade100,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 8.0),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              12.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                repost
                                                                    .nombreDebate!,
                                                                style:
                                                                    const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  const Icon(
                                                                      Icons
                                                                          .person,
                                                                      size: 16,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0)),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  Text(
                                                                    '${repost.cantidadPersonasEnElDebate}',
                                                                    style: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                                  ),
                                                                  const Icon(
                                                                      Icons
                                                                          .sync,
                                                                      size: 16,
                                                                      color: Color
                                                                          .fromARGB(
                                                                              255,
                                                                              0,
                                                                              0,
                                                                              0)),
                                                                  const SizedBox(
                                                                      width: 5),
                                                                  Text(
                                                                    '${repost.cantidadRespost}',
                                                                    style: const TextStyle(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                          const Divider(),
                                                          Text(
                                                              '->  ${repost.mensajeChat!}'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Botones de interacción: me gusta, comentar, guardar
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 60.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  _darMeGusta(repost.id!),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.favorite,
                                                      color: Colors.red),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                      '${repost.cantidadMegusta}'),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () => _showCommentsModal(
                                                  repost.id!),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.comment,
                                                      color: Colors.blue),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                      '${repost.cantidaComentraios}'),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            GestureDetector(
                                              onTap: () =>
                                                  _guardarRepost(repost.id!),
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.bookmark,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0)),
                                                  const SizedBox(width: 3),
                                                  Text(
                                                      '${repost.cantidadGuardados}'),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ]),
                            )
                          : const Text('No hay reposts disponibles'),
                    ],
                  ),
                )
              : const Center(
                  child: Text('Error al cargar el perfil'),
                ),
    );
  }
}
