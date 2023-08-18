import 'package:carpintex/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carpintex/services/compras_api_service.dart';
import 'package:carpintex/views/compras_list_page.dart';

class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}

class _AdminDrawerState extends State<AdminDrawer> {
  String userName = 'Nombre de Usuario';
  String userEmail = 'email@dominio.com';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? 'Nombre de Usuario';
      userEmail = prefs.getString('email') ?? 'email@dominio.com';
    });
  }

  _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpia todos los datos de SharedPreferences
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Login(), // Redirige a la página de inicio de sesión
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(userName),
            accountEmail: Text(userEmail),
            // Otros parámetros si los necesitas
          ),

          ListTile(
            title: Text('Compras'),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ComprasConNombresPage(apiService: ComprasApiService()),
                ),
              );
            },
          ),
          // Agrega más opciones aquí

          ListTile(
            title: Text('Cerrar Sesión'),
            leading: Icon(Icons.logout),
            onTap: _logout, // Llama a la función de cierre de sesión
          ),
        ],
      ),
    );
  }
}
