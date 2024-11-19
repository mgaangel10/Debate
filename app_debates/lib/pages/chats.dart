import 'dart:convert';
import 'dart:io';

import 'package:app_debates/models/peticion/crear_debate_peticion.dart';
import 'package:app_debates/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:app_debates/service/api_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_debates/models/debates_unidos.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  final ApiService _apiService = ApiService();
  List<DebatesUnidos> _debates = [];
  bool _isLoading = true;
  late StompClient client;
  String? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchDebates();
    _initializeWebSocket();
    _creadoPorELUSuario();
  }

  // Inicializar WebSocket para recibir actualizaciones en tiempo real de debates creados
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

  // Función para manejar la conexión y suscripciones
  void onConnect(StompFrame frame) {
    // Suscribirse al canal de creación de debates
    client.subscribe(
      destination: '/topic/debate',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final body = json.decode(frame.body!);
          print('Nuevo debate recibido desde WebSocket: ${frame.body}');
          final nuevoDebate = DebatesUnidos.fromJson(body);
          _agregarNuevoDebate(nuevoDebate);
        }
      },
    );
  }

  // Actualizar la lista de debates al recibir un nuevo debate
  void _agregarNuevoDebate(DebatesUnidos nuevoDebate) {
    if (!mounted) return;
    setState(() {
      _debates.insert(
          0, nuevoDebate); // Agregar el nuevo debate al inicio de la lista
    });
  }

  // Función para obtener los debates existentes
  Future<void> _fetchDebates() async {
    try {
      List<DebatesUnidos> debates = await _apiService.debatesUnidos();
      setState(() {
        _debates = debates;
        _isLoading = false;
      });
    } catch (error) {
      print('Error fetching debates: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _creadoPorELUSuario() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('nombre') ?? 'Unknown User';
    });
  }

  // Modal para crear un nuevo debate
  Future<void> _showCreateDebateModal() async {
    TextEditingController _tituloController = TextEditingController();
    TextEditingController _descripcionController = TextEditingController();
    TextEditingController _categoriasController = TextEditingController();
    File? _selectedImage;

    final picker = ImagePicker();

    Future<void> _pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 12.0,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  decoration: InputDecoration(hintText: 'Título del debate'),
                ),
                const SizedBox(height: 8.0),

                // Botón para seleccionar imagen
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Seleccionar Imagen'),
                ),

                // Vista previa de la imagen seleccionada
                if (_selectedImage != null)
                  Image.file(
                    _selectedImage!,
                    height: 150,
                  ),

                const SizedBox(height: 8.0),
                TextField(
                  controller: _descripcionController,
                  decoration: InputDecoration(hintText: 'Descripción'),
                ),
                TextField(
                  controller: _categoriasController,
                  decoration: InputDecoration(hintText: 'Categorías'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    CrearDebatePeticion nuevoDebate = CrearDebatePeticion(
                      titulo: _tituloController.text,
                      descripcion: _descripcionController.text,
                      categorias: _categoriasController.text,
                      imagen:
                          _selectedImage != null ? _selectedImage!.path : null,
                    );

                    try {
                      await _apiService.crearDebate(nuevoDebate);
                      _fetchDebates();
                      Navigator.pop(context);
                    } catch (error) {
                      print('Error al crear el debate: $error');
                    }
                  },
                  child: Text('Crear Debate'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToDetails(String debateId) {
    String nombreUsuario =
        'UsuarioEjemplo'; // Replace with actual user data if needed

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          debateId: debateId,
          nombreUsuario: nombreUsuario,
        ),
      ),
    );
  }

  @override
  void dispose() {
    client.deactivate(); // Desactivar WebSocket al cerrar la página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tus Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateDebateModal,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: _debates.length,
                      itemBuilder: (context, index) {
                        final debate = _debates[index];
                        bool isCreator = _currentUser == debate.nombreCreador;
                        return GestureDetector(
                          onTap: () {
                            _navigateToDetails(debate.id!);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCreator
                                  ? Colors.lightBlueAccent
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.file(
                                    File(debate.imagen!),
                                    width: 35,
                                    height: 35,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error,
                                          size: 24, color: Colors.red);
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        debate.titulo ??
                                            'Nombre del chat debate',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        debate.ultimoMensaje ??
                                            'Último mensaje del chat',
                                        style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
