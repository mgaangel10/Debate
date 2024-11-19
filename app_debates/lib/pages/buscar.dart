import 'package:app_debates/models/peticion/buscar_peticion.dart';
import 'package:app_debates/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:app_debates/service/api_service.dart';
import 'package:app_debates/models/buscar.dart';
import 'perfil_usuario.dart'; // Importa la página de perfil

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  List<MostrarDebatesDtos> _debatesResults = [];
  List<Usuarios> _usuariosResults = [];
  bool _isLoading = false;

  Future<void> _search() async {
    setState(() {
      _isLoading = true;
    });

    try {
      BuscarPeticion buscarPeticion =
          BuscarPeticion(palabra: _searchController.text, query: '');
      List<Buscar> results = await _apiService.buscar(buscarPeticion);
      setState(() {
        _debatesResults = results
            .expand((buscar) => buscar.mostrarDebatesDtos ?? [])
            .cast<MostrarDebatesDtos>()
            .toList();
        _usuariosResults = results
            .expand((buscar) => buscar.usuarios ?? [])
            .cast<Usuarios>()
            .toList();
      });
    } catch (error) {
      print('Error searching: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleFollow(Usuarios usuario) {
    setState(() {
      usuario.siguiendo = !usuario.siguiendo!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search, // Actualiza los datos al pulsar el icono
                ),
              ),
              onSubmitted: (_) => _search(),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView(
                      children: [
                        const Text('Debates',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        ..._debatesResults.map((debate) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.green
                                    .shade100, // Color de fondo verde claro
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(debate.titulo ?? 'Sin título',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle:
                                    Text(debate.ultimoMensaje ?? 'Sin mensaje'),
                                onTap: () {
                                  // Navegar a la página ChatPage al pulsar un debate
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatPage(
                                        debateId:
                                            debate.id!, // Pasa el ID del debate
                                        nombreUsuario:
                                            'usuarioActual', // Pasa el nombre del usuario (modifícalo según sea necesario)
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                        const Divider(),
                        const Text('Usuarios',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        ..._usuariosResults.map((usuario) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black, // Color de fondo negro
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: usuario.foto != null
                                    ? CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(usuario.foto!))
                                    : const CircleAvatar(
                                        child: Icon(Icons.person)),
                                title: Text(
                                    usuario.nombreUsuario ?? 'Sin nombre',
                                    style: const TextStyle(
                                        color: Colors.white)), // Texto blanco
                                subtitle: Text(
                                    '${usuario.name ?? ''} ${usuario.lastName ?? ''}',
                                    style: const TextStyle(
                                        color: Colors
                                            .white70)), // Texto gris claro
                                onTap: () {
                                  // Navega a la página PerfilUsuario
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PerfilUsuario(
                                        id: usuario
                                            .id!, // Pasa el ID del usuario
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
