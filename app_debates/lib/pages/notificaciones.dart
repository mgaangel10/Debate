import 'package:app_debates/main.dart';
import 'package:app_debates/models/notificion_repost.dart';
import 'package:app_debates/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'dart:convert';

class NotificicacionesPage extends StatefulWidget {
  final Function onNotificationsViewed;

  const NotificicacionesPage({super.key, required this.onNotificationsViewed});

  @override
  State<NotificicacionesPage> createState() => _NotificicacionesPageState();
}

class _NotificicacionesPageState extends State<NotificicacionesPage> {
  final ApiService _apiService = ApiService();
  List<NotificacionRepost> _notificaciones = [];
  bool _isLoading = true;
  late StompClient client;

  @override
  void initState() {
    super.initState();
    _fetchNotificaciones();
    _initializeWebSocket();
  }

  void _fetchNotificaciones() async {
    try {
      final notificaciones = await _apiService.notificacionesRepost();
      setState(() {
        _notificaciones = notificaciones;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching notificaciones: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
          Future.delayed(const Duration(seconds: 5), () {
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
    client.subscribe(
      destination: '/topic/notificacionRepost',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          print('Mensaje recibido desde WebSocket (repost): ${frame.body}');
          if (frame.body!.isNotEmpty) {
            final List<dynamic> body = json.decode(frame.body!);
            final nuevasNotificaciones =
                body.map((json) => NotificacionRepost.fromJson(json)).toList();

            widget
                .onNotificationsViewed(); // Incrementar el contador de notificaciones no leídas

            // Llamar a la función correcta para agregar nuevas notificaciones
            _agregarNuevasNotificaciones(nuevasNotificaciones);

            // Mostrar notificación push
          } else {
            print('El cuerpo de la respuesta está vacío.');
          }
        }
      },
    );
  }

  void _agregarNuevasNotificaciones(
      List<NotificacionRepost> nuevasNotificaciones) {
    if (!mounted) return;
    setState(() {
      print('Actualizando notificaciones...');
      _notificaciones.insertAll(0,
          nuevasNotificaciones); // Agregar las nuevas notificaciones al inicio de la lista
      print('Número total de notificaciones: ${_notificaciones.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones de Repost'),
        backgroundColor: Colors.teal,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _notificaciones.isEmpty
              ? Center(child: Text('No hay notificaciones de repost.'))
              : ListView.builder(
                  itemCount: _notificaciones.length,
                  itemBuilder: (context, index) {
                    final notificacion = _notificaciones[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(notificacion.foto ??
                            'https://example.com/default.jpg'),
                      ),
                      title: Text(notificacion.nombreUsuario ?? 'Sin nombre'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notificacion.concepto ?? 'Sin concepto'),
                          Text(notificacion.tiempo ?? 'Sin tiempo'),
                        ],
                      ),
                      trailing: Icon(Icons.notifications),
                      onTap: () {
                        // Aquí puedes añadir cualquier acción al tocar una notificación
                      },
                    );
                  },
                ),
    );
  }
}
