import 'dart:convert';
import 'dart:typed_data';

import 'package:carpintex/models/productos_models.dart';
import 'package:carpintex/services/productos_api_service.dart';
import 'package:carpintex/views/ConnectionStatus.dart';
import 'package:carpintex/views/user_drawer.dart';
import 'package:carpintex/views/widgets/page_indicator.dart';
import 'package:carpintex/views/widgets/producto_card.dart';
import 'package:carpintex/views/widgets/sort_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carpintex/views/widgets/search_bar.dart' as myWidgets;


class ProductosListPage extends StatefulWidget {
  final ProductosApiService apiService;

  ProductosListPage({required this.apiService});

  @override
  _ProductosListPageState createState() => _ProductosListPageState();
}

class _ProductosListPageState extends State<ProductosListPage> {
  late ConnectionStatus connectionStatus; // Declaración de la variable
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Producto> productos = [];
  List<Producto> filteredProductos = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'Nombre. A-Z'; // Debe coincidir con uno de los valores en ProductSortDropdown
  int itemsPerPage = 5;
  PageController pageController = PageController();
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    _fetchProductos();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    connectionStatus =
        Provider.of<ConnectionStatus>(context); // Inicialización aquí
  }

  Future<void> _fetchProductos() async {
    setState(() {
      isLoading = true;
    });
    try {
      print('Fetching productos con nombres...');
      List<Producto> producto = await widget.apiService.getProductos();
      print('Productos con nombres received: $producto');
      setState(() {
        productos = producto;
        filteredProductos = producto;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching productos con nombres: $e');
      setState(() {
        isLoading = false; // Si hay un error, isLoading se establece en false
      });
    }
  }
  void _sortProductos(String? value){
    if(value == null) return;
    setState(() {
      dropdownValue = value;
      switch(value){
        case 'Nombre. A-Z':
          filteredProductos.sort((a, b) => a.nombre.compareTo(b.nombre));
          break;
        case 'Nombre. Z-A':
          filteredProductos.sort((a, b) => b.nombre.compareTo(a.nombre));
          break;

        case 'Stock. Menos a Más':
          filteredProductos.sort((a, b) => a.stock.compareTo(b.stock));
          break;
        case 'Stock. Más a Menos':
          filteredProductos.sort((a, b) => b.stock.compareTo(a.stock));
          break;
        case 'Stock. Más a Menos':
          filteredProductos.sort((a, b) => b.stock.compareTo(a.stock));
          break;
        case 'Total. Más a Menos':
          filteredProductos.sort((a, b) => b.total.compareTo(a.total));
          break;
      }

    });
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,

        appBar: AppBar(
          title: Text("Lista de Productos"),
          backgroundColor: Color(0xFF483D8B), // Cambia el color del AppBar

          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState!.openDrawer(),
          ),
        ),

        drawer: UserDrawer(),
        body: Container(
          decoration: woodBackground(),
          child: isLoading
              ?Center(child: CircularProgressIndicator())
              :RefreshIndicator(
            onRefresh: _fetchProductos,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: myWidgets.SearchBar(controller: searchController, onChanged:(value){
                        setState(() {
                          filteredProductos = productos
                              .where((producto) =>
                          producto.nombre.toLowerCase().contains(value.toLowerCase()) ||
                              producto.stock.toString().contains(value) ||
                              producto.altura.toString().contains(value))
                              .toList();
                          _sortProductos(dropdownValue);
                        });
                      }),
                    ),

                    ProductSortDropdown(value: dropdownValue, onChanged: _sortProductos),
                  ],
                ),
                if(!connectionStatus.isConnected)
                  Text(connectionStatus.message, style: TextStyle(color: Colors.red, fontSize: 20))
                else
                  Text(connectionStatus.message, style: TextStyle(color: Colors.green, fontSize: 20)),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: (filteredProductos.length / itemsPerPage).ceil(),
                    itemBuilder: (ctx, pageIndex) {
                      return ListView.separated(
                        itemCount: itemsPerPage,
                        itemBuilder: (ctx, index) {
                          int actualIndex = pageIndex * itemsPerPage + index;
                          if (actualIndex >= filteredProductos.length) return Container();
                          return ProductoCard(
                            producto: filteredProductos[actualIndex],
                            index: actualIndex,
                            onTap: () => _showProductDetails(context, filteredProductos[actualIndex]), // Agregar esta línea


                          );
                        },
                        separatorBuilder: (ctx, index) => Divider(),
                      );

                    },
                  ),
                ),
                PageIndicator(controller: pageController, count: (filteredProductos.length / itemsPerPage).ceil()),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

void _showProductDetails(BuildContext context, Producto producto) {
  Uint8List? bytes;
  if (producto.imagen != null) {
    bytes = base64Decode(producto.imagen!);
  }

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(producto.nombre),
        content: SingleChildScrollView( // Agregar esto para permitir desplazamiento si el contenido es grande
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (bytes != null) // Agregar esta condición para mostrar la imagen si está disponible
                Image.memory(bytes, width: 100, height: 100), // Puedes ajustar el tamaño según tus necesidades
              Text('Descripción: ${producto.descripcion}'),
              Text('Stock: ${producto.stock}'),
              // Puedes agregar más detalles aquí
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cerrar'),
          ),
        ],
      );
    },
  );
}


BoxDecoration woodBackground() {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFebeaea), // Color principal
        Color(0xFFdcdcdc), // Ligeramente más oscuro para el degradado
      ],
    ),
  );
}