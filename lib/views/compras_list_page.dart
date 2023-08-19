import 'package:carpintex/views/AgregarCompraPage.dart';
import 'package:carpintex/views/ConnectionStatus.dart';
import 'package:carpintex/views/EditarCompraPage.dart';
import 'package:carpintex/views/admin_drawer.dart';
import 'package:carpintex/views/widgets/alertas.dart';
import 'package:carpintex/views/widgets/compra_card.dart';
import 'package:carpintex/views/widgets/sort_dropdown.dart'; // Importa el SortDropdown
import 'package:carpintex/views/widgets/search_bar.dart' as myWidgets;
import 'package:carpintex/views/widgets/page_indicator.dart'; // Importa el PageIndicator
import 'package:intl/intl.dart';
import 'package:carpintex/models/compras_models.dart';
import 'package:carpintex/services/compras_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ComprasConNombresPage extends StatefulWidget {

  final ComprasApiService apiService;

  ComprasConNombresPage({required this.apiService});

  @override
  _ComprasConNombresPageState createState() => _ComprasConNombresPageState();
}

class _ComprasConNombresPageState extends State<ComprasConNombresPage> {
  late ConnectionStatus connectionStatus; // Declaración de la variable

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void onEditCompra(CompraConNombres compraConNombres) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarCompraPage(apiService: widget.apiService, compraId: compraConNombres.compra.id), // Pasa los parámetros correctos
      ),
    ).then((result) {
      if (result == true) {
        _fetchComprasConNombres(); // Recarga los registros si se editó una compra
      }
    });
  }

  void onDeleteCompra(int id) {
    // Muestra el diálogo antes de eliminar
    showDeleteDialog(context, () {
      widget.apiService.eliminarCompra(id).then((_) {
        _fetchComprasConNombres(); // Recarga los registros si se eliminó una compra
      }).catchError((error) {
        // Maneja el error si algo sale mal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar la compra: $error')),
        );
      });
    });
  }




  List<CompraConNombres> comprasConNombres = [];
  List<CompraConNombres> filteredCompras = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'Fecha. Más antiguo';
  int itemsPerPage = 5;
  PageController pageController = PageController();
  bool isLoading = true; // Indicador de carga

  @override
  void initState() {
    super.initState();
    // La inicialización de connectionStatus se ha eliminado de aquí
    _fetchComprasConNombres();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    connectionStatus = Provider.of<ConnectionStatus>(context); // Inicialización aquí
    // Puedes continuar usando connectionStatus en este método si es necesario
  }


  Future<void> _fetchComprasConNombres() async {
    setState(() {
      isLoading = true; // Comienza la carga
    });
    try {
      print('Fetching compras con nombres...');
      List<CompraConNombres> compras = await widget.apiService.getCompraConNombres();
      print('Compras con nombres received: $compras');
      setState(() {
        comprasConNombres = compras;
        filteredCompras = compras;
        isLoading = false; // Finaliza la carga
      });
    } catch (e) {
      print('Error fetching compras con nombres: $e');
      setState(() {
        isLoading = false; // Finaliza la carga en caso de error
      });
    }
  }

  void _sortCompras(String? value) {
    if (value == null) return;
    setState(() {
      dropdownValue = value;
      switch (value) {
        case 'Fecha. Más antiguo':
          filteredCompras.sort((a, b) => a.compra.fecha.compareTo(b.compra.fecha));
          break;
        case 'Fecha. Más reciente':
          filteredCompras.sort((a, b) => b.compra.fecha.compareTo(a.compra.fecha));
          break;
        case 'Cantidad. Menos a Más':
          filteredCompras.sort((a, b) => a.compra.cantidad.compareTo(b.compra.cantidad));
          break;
        case 'Cantidad. Más a Menos':
          filteredCompras.sort((a, b) => b.compra.cantidad.compareTo(a.compra.cantidad));
          break;
        case 'Total. Menos a Más':
          filteredCompras.sort((a, b) => a.compra.total.compareTo(b.compra.total));
          break;
        case 'Total. Más a Menos':
          filteredCompras.sort((a, b) => b.compra.total.compareTo(a.compra.total));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey, // Usa la clave aquí

        appBar: AppBar(
          title: Text("Lista de Compras"),
          leading: IconButton(
            icon: Icon(Icons.menu), // Ícono de menú hamburguesa
            onPressed: () => _scaffoldKey.currentState!.openDrawer(), // Abre el drawer usando la clave del Scaffold
          ),
          backgroundColor: Color(0xFF483D8B),
        ),
        drawer: AdminDrawer(),

        body: Container(

          decoration: woodBackground(), // Aplica la decoración aquí
          child: isLoading
            ? Center(child: CircularProgressIndicator()) // Muestra la ruedita de carga si está cargando
            : RefreshIndicator(
          onRefresh: _fetchComprasConNombres, // Recarga los registros al arrastrar hacia abajo
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: myWidgets.SearchBar(controller: searchController, onChanged: (value) { // Utiliza el componente SearchBar
                      setState(() {
                        filteredCompras = comprasConNombres
                            .where((compra) =>
                        compra.nombreMateriaPrima.toLowerCase().contains(value.toLowerCase()) ||
                            compra.nombreProveedor.toLowerCase().contains(value.toLowerCase()) ||
                            compra.compra.cantidad.toString().contains(value) ||
                            compra.compra.total.toString().contains(value))
                            .toList();
                        _sortCompras(dropdownValue);
                      });
                    }),
                  ),
                  SortDropdown(value: dropdownValue, onChanged: _sortCompras), // Utiliza el componente SortDropdown
                ],
              ),
              // Aquí es donde añado la lógica para mostrar el estado de la conexión
              if (!connectionStatus.isConnected)
                Text(connectionStatus.message, style: TextStyle(color: Colors.red))
              else
                Text(connectionStatus.message, style: TextStyle(color: Colors.green)),
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: (filteredCompras.length / itemsPerPage).ceil(),
                  itemBuilder: (ctx, pageIndex) {
                    return ListView.separated(
                      itemCount: itemsPerPage,
                      itemBuilder: (ctx, index) {
                        int actualIndex = pageIndex * itemsPerPage + index;
                        if (actualIndex >= filteredCompras.length) return Container();
                        return CompraCard(
                          compraConNombres: filteredCompras[actualIndex],
                          onEdit: () => onEditCompra(filteredCompras[actualIndex]), // Pasa la función de edición
                          onDelete: () => onDeleteCompra(filteredCompras[actualIndex].compra.id), // Pasa la función de eliminación
                          index: actualIndex, // Pasa el índice actual para los colores alternados
                        );


                      },
                      separatorBuilder: (ctx, index) => Divider(),
                    );
                  },
                ),
              ),
              PageIndicator(controller: pageController, count: (filteredCompras.length / itemsPerPage).ceil()), // Utiliza el componente PageIndicator
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AgregarCompraPage(apiService: widget.apiService),
              ),
            );
            if (result == true) {
              _fetchComprasConNombres(); // Recarga los registros si se agregó una compra
            }
          },
          backgroundColor: Color(0xFF483D8B), // Define el color morado oscuro
          child: Icon(
            Icons.add_shopping_cart, // Cambia el icono a uno que represente añadir una compra
            color: Colors.white, // Define el color del icono como blanco para mayor contraste
          ),
        ),

      ),
    );
  }



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







