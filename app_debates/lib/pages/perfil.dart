import 'package:app_debates/models/parati.dart' as parati;
import 'package:app_debates/models/parati.dart';
import 'package:app_debates/models/perfil_response.dart' as perfil;
import 'package:app_debates/models/peticion/comentar.dart' as peticion;
import 'package:app_debates/pages/chat.dart';
import 'package:app_debates/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  ParaTi? paraTiData;
  ApiService apiService = ApiService();
  List<perfil.VerRepostDtos> _reposts = [];
  perfil.PerfilResponse? perfil1;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarPerfil();
  }

  Future<void> cargarPerfil() async {
    try {
      perfil.PerfilResponse perfilResponse = await apiService.verPerfil();
      setState(() {
        perfil1 = perfilResponse;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error al cargar el perfil: $e');
    }
  }

  Future<void> _darMeGusta(String idRepost) async {
    try {
      await apiService.darMegustaRepost(idRepost);
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
      await apiService.guardarRepost(idRepost);
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

  Future<void> _showCommentsModal(String idRepost) async {
    TextEditingController _commentController = TextEditingController();

    try {
      List<VerComentarioDtos> comentarios =
          await apiService.verComentarios(idRepost);
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(comentarios[index].contenido!),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.favorite,
                                        color: Colors.red, size: 16),
                                    const SizedBox(width: 4),
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
                            decoration: const InputDecoration(
                              hintText: 'Escribe un comentario...',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.blue),
                          onPressed: () async {
                            if (_commentController.text.isNotEmpty) {
                              peticion.Comentar nuevoComentario =
                                  peticion.Comentar(
                                contenido: _commentController.text,
                              );
                              try {
                                List<parati.VerComentarioDtos>
                                    updatedComentarios =
                                    await apiService.comentarRepost(
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

  void _showPopupMenu(BuildContext context) async {
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 80, 0, 100),
      items: [
        const PopupMenuItem<String>(
          value: '1',
          child: Row(
            children: [
              Icon(Icons.favorite, color: Color.fromARGB(255, 252, 17, 0)),
              SizedBox(width: 10),
              Text('Ver Me Gustas'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: '2',
          child: Row(
            children: [
              Icon(Icons.bookmark, color: Colors.green),
              SizedBox(width: 10),
              Text('Ver Guardados'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: '3',
          child: Row(
            children: [
              Icon(Icons.campaign, color: Colors.orange),
              SizedBox(width: 10),
              Text('Publicitar Debate o Repost'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: '4',
          child: Row(
            children: [
              Icon(Icons.edit, color: Color.fromARGB(255, 54, 206, 244)),
              SizedBox(width: 10),
              Text('Editar Perfil'),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: '5',
          child: Row(
            children: [
              Icon(Icons.logout, color: Color.fromARGB(255, 252, 17, 0)),
              SizedBox(width: 10),
              Text('Cerra Sesion'),
            ],
          ),
        ),
      ],
      elevation: 8.0,
      color: Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ).then((value) {
      if (value != null) {
        print('Has seleccionado: $value');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : perfil1 != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        perfil1!.foto != null
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(perfil1!.foto!),
                                radius: 50.0,
                              )
                            : const CircleAvatar(
                                radius: 50.0,
                                child: Icon(Icons.person, size: 50),
                              ),
                        const SizedBox(height: 16),
                        Text(
                          '${perfil1!.name ?? ''} ${perfil1!.lastName ?? ''}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '@${perfil1!.nombreUsuario ?? ''}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  perfil1!.seguidores.toString(),
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
                                  perfil1!.seguidos.toString(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  perfil1!.debatesUnidos.toString(),
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
                                  perfil1!.repost.toString(),
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
                        const Divider(),
                        Text("Tus Repost"),
                        const SizedBox(height: 20),
                        if (perfil1!.verRepostDtos != null &&
                            perfil1!.verRepostDtos!.isNotEmpty)
                          Column(
                            children: perfil1!.verRepostDtos!
                                .map((repost) => Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  repost.fotoUsuario!),
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
                                                            builder: (context) => ChatPage(
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
                                                            const EdgeInsets
                                                                .all(12.0),
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
                                                                        size:
                                                                            16,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
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
                                                                        size:
                                                                            16,
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            0,
                                                                            0,
                                                                            0)),
                                                                    const SizedBox(
                                                                        width:
                                                                            5),
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
                                                            Row(
                                                              children: [
                                                                const Icon(
                                                                    Icons
                                                                        .access_time,
                                                                    size: 16,
                                                                    color: Colors
                                                                        .grey),
                                                                const SizedBox(
                                                                    width: 5),
                                                                Text(
                                                                  repost
                                                                      .tiempoPublicado!, // Asegúrate de que este atributo exista
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .grey),
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
                                    ))
                                .toList(),
                          ),
                      ],
                    ),
                  ),
                )
              : const Center(
                  child: Text('No se pudo cargar el perfil'),
                ),
    );
  }
}
