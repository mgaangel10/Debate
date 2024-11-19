import 'package:app_debates/pages/buscar.dart';
import 'package:app_debates/pages/chats.dart';
import 'package:app_debates/pages/home.dart';
import 'package:app_debates/pages/inicio_sesion.dart';
import 'package:app_debates/pages/notificaciones.dart';
import 'package:app_debates/pages/perfil.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const InicioSesionPage());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  int _unreadCount = 0;
  final List<Widget> _pages = [];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 3) {
        _resetUnreadCount();
      }
    });
  }

  void _incrementUnreadCount() {
    setState(() {
      _unreadCount += 1;
    });
  }

  void _resetUnreadCount() {
    setState(() {
      _unreadCount = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages.addAll([
      const HomePage(),
      const ChatsPage(),
      const BuscarPage(),
      NotificicacionesPage(onNotificationsViewed: _resetUnreadCount),
      const PerfilPage(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined,
                color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Chats',
          ),
          const BottomNavigationBarItem(
            icon:
                Icon(Icons.search_rounded, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_on_rounded,
                    color: Color.fromARGB(255, 0, 0, 0)),
                if (_unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '$_unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Notificaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromARGB(255, 0, 0, 0)),
            label: 'Perfil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        onTap: _onItemTapped,
      ),
    );
  }
}
