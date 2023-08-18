import 'package:carpintex/views/admin_drawer.dart';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserListPage extends StatefulWidget {
  final ApiService apiService;

  UserListPage({required this.apiService});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> allUsers = []; // Lista que contiene todos los usuarios
  List<User> filteredUsers = []; // Lista que contendrá los usuarios filtrados

  @override
  void initState() {
    super.initState();
    widget.apiService.loadCertificate();
    _fetchUsers();
  }

  // Función para obtener la lista de usuarios
  Future<void> _fetchUsers() async {
    try {
      List<User> users = await widget.apiService.getRequest();
      setState(() {
        allUsers = users;
        filteredUsers = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  // Función para filtrar la lista de usuarios
  void _filterUsers(String query) {
    List<User> filteredList = allUsers.where((user) {
      final nameLower = user.name.toLowerCase();
      final emailLower = user.email.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) || emailLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredUsers = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lista de usuarios"),

          leading: IconButton(
            icon: Icon(Icons.menu), // Ícono de menú hamburguesa
            onPressed: () => Scaffold.of(context).openDrawer(), // Abre el drawer
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String? result = await showSearch(
                  context: context,
                  delegate: UserSearchDelegate(allUsers),
                );
                if (result != null) {
                  _filterUsers(result);
                }
              },
            ),
          ],
        ),
          drawer: AdminDrawer(),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: filteredUsers.length,
            itemBuilder: (ctx, index) => GridTile(
              child: Card(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(filteredUsers[index].name),
                      Text(filteredUsers[index].email),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Clase para implementar el SearchDelegate
class UserSearchDelegate extends SearchDelegate<String> {
  final List<User> allUsers; // Referencia a la lista de todos los usuarios

  UserSearchDelegate(this.allUsers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // No se muestra ningún resultado aquí, ya que se maneja en _filterUsers
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<User> suggestionList = query.isEmpty
        ? []
        : allUsers.where((user) {
      final nameLower = user.name.toLowerCase();
      final emailLower = user.email.toLowerCase();
      final queryLower = query.toLowerCase();

      return nameLower.contains(queryLower) ||
          emailLower.contains(queryLower);
    }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (ctx, index) => ListTile(
        title: Text(suggestionList[index].name),
        subtitle: Text(suggestionList[index].email),
        onTap: () {
          // Aquí puedes realizar alguna acción cuando el usuario toque un elemento de la búsqueda en vivo
        },
      ),
    );
  }
}
