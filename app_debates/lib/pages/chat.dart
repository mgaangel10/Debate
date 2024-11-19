import 'dart:convert';
import 'dart:io';

import 'package:app_debates/main.dart';
import 'package:app_debates/models/details_debates.dart';
import 'package:app_debates/models/peticion/enviar_mensaje.dart';
import 'package:app_debates/models/ver_mensajes.dart';
import 'package:app_debates/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatPage extends StatefulWidget {
  final String debateId;
  final String nombreUsuario;

  const ChatPage({
    required this.debateId,
    required this.nombreUsuario,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<VerMensajes> _messages = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  final ApiService _apiService = ApiService();
  DetallesDebates? _detallesDebates;
  String _loggedInUser = '';
  late StompClient client;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _fetchDebateDetails();
    _loadLoggedInUser();
    _initializeWebSocket();
  }

  void _initializeWebSocket() async {
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

  void onConnect(StompFrame frame) {
    // Suscríbete al canal de mensajes del debate
    client.subscribe(
      destination: '/topic/chatear',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final body = json.decode(frame.body!);
          print('Nuevo mensaje recibido: ${frame.body}');
          final nuevoMensaje = VerMensajes.fromJson(body);
          _agregarNuevoMensaje(nuevoMensaje);
        }
      },
    );
  }

  void _agregarNuevoMensaje(VerMensajes nuevoMensaje) {
    if (!mounted) return;
    setState(() {
      _messages.add(nuevoMensaje); // Agregar el mensaje al final de la lista
    });
    // Desplazarse al final de la lista
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _loadLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedInUser = prefs.getString('nombre') ?? '';
    });
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _apiService.verMensajes(widget.debateId);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _showCommentsModal(String idRepost) async {
    try {
      DetallesDebates details =
          await _apiService.detallesDebates(widget.debateId);
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      details.titulo ?? 'Detalles del Debate',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(details.descripcion ?? 'Descripción del debate'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (details.unido == true) {
                          await _apiService.salirseDelBate(widget.debateId!);
                          setState(() {
                            details.unido = false;
                          });

                          // Mostrar Snackbar indicando que el usuario ha salido del debate
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Has salido del debate'),
                            ),
                          );
                        } else {
                          await _apiService.unirseAlDebate(details.id!);
                          setState(() {
                            details.unido = true;
                          });

                          // Mostrar Snackbar indicando que el usuario se ha unido al debate
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Te has unido al debate'),
                            ),
                          );
                        }
                      },
                      child: Text(details.unido == true
                          ? 'Salir del debate'
                          : 'Unirte al debate'),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Número de personas unidas: ${details.numeroPersonasUnidas}',
                      style: const TextStyle(fontSize: 16),
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

  Future<void> _fetchDebateDetails() async {
    try {
      final details = await _apiService.detallesDebates(widget.debateId);
      setState(() {
        _detallesDebates = details;
      });
    } catch (e) {
      print('Error fetching debate details: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final mensaje = EnviarMensaje(contenido: _messageController.text);
      try {
        if (_loggedInUser.isEmpty) {
          await _loadLoggedInUser();
        }

        // Enviar el mensaje usando la API (también puedes enviarlo por WebSocket)
        await _apiService.enviarMensaje(mensaje, widget.debateId);

        // Enviar el mensaje a través de WebSocket para que se refleje en todos
        client.send(
          destination: '/app/sendMessage',
          body: json.encode({
            'contenido': _messageController.text,
            'debateId': widget.debateId,
            'usuario': _loggedInUser,
          }),
        );

        // Limpiar el controlador de texto después de enviar el mensaje
        _messageController.clear();
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: GestureDetector(
          onTap: () => _showCommentsModal(widget.debateId),
          child: _detallesDebates == null
              ? const CircularProgressIndicator()
              : Row(
                  children: [
                    ClipOval(
                      child: Image.file(
                        File(_detallesDebates!.imagen!),
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.error, size: 24, color: Colors.red);
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _detallesDebates!.titulo ?? 'Nombre del chat debate',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.person),
                    const SizedBox(width: 5),
                    Text('${_detallesDebates!.numeroPersonasUnidas ?? 100}'),
                  ],
                ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final bool isMe =
                            message.nombreDelAutorDelMensaje == _loggedInUser;
                        return Dismissible(
                          key: Key(message.id ?? index.toString()),
                          direction: DismissDirection.startToEnd,
                          background: Container(
                            color: Colors.green,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(left: 20.0),
                            child: const Icon(Icons.repeat,
                                color: Colors.white, size: 30),
                          ),
                          confirmDismiss: (direction) async {
                            try {
                              final respostResponse =
                                  await _apiService.repostear(message.id!);

                              print('Repost completado: $respostResponse');
                              return false; // Mantiene el mensaje visible después del repost
                            } catch (e) {
                              print('Error reposting message: $e');
                              return false; // Manejo del error en caso de fallo
                            }
                          },
                          child: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.teal.shade100
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    spreadRadius: 1,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        message.nombreDelAutorDelMensaje!,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: isMe
                                              ? Colors.teal
                                              : Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    message.contenido ?? '',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {},
                                        child: Row(
                                          children: [
                                            Icon(Icons.repeat,
                                                color: Colors.teal),
                                            SizedBox(width: 5),
                                            Text(
                                              '${message.personasReposteadas ?? 0}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.teal),
                                            ),
                                          ],
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Escribe un mensaje...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: Colors.teal),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.send, color: Colors.teal),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
