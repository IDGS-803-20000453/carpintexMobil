import 'package:carpintex/views/widgets/compra_card.dart';
import 'package:carpintex/views/widgets/sort_dropdown.dart'; // Importa el SortDropdown
import 'package:carpintex/views/widgets/search_bar.dart' as myWidgets;
import 'package:carpintex/views/widgets/page_indicator.dart'; // Importa el PageIndicator
import 'package:intl/intl.dart';
import 'package:carpintex/models/compras_models.dart';
import 'package:carpintex/services/compras_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ComprasConNombresPage extends StatefulWidget {
  final ComprasApiService apiService;

  ComprasConNombresPage({required this.apiService});

  @override
  _ComprasConNombresPageState createState() => _ComprasConNombresPageState();
}

class _ComprasConNombresPageState extends State<ComprasConNombresPage> {
  List<CompraConNombres> comprasConNombres = [];
  List<CompraConNombres> filteredCompras = [];
  TextEditingController searchController = TextEditingController();
  String dropdownValue = 'Fecha. Más antiguo';
  int itemsPerPage = 5;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    _fetchComprasConNombres();
  }

  Future<void> _fetchComprasConNombres() async {
    try {
      print('Fetching compras con nombres...');
      List<CompraConNombres> compras = await widget.apiService.getCompraConNombres();
      print('Compras con nombres received: $compras');
      setState(() {
        comprasConNombres = compras;
        filteredCompras = compras;
      });
    } catch (e) {
      print('Error fetching compras con nombres: $e');
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
        appBar: AppBar(
          title: Text("Lista de Compras con Nombres"),
        ),
        body: Column(
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
                      return CompraCard(compraConNombres: filteredCompras[actualIndex]); // Utiliza el componente CompraCard
                    },
                    separatorBuilder: (ctx, index) => Divider(),
                  );
                },
              ),
            ),
            PageIndicator(controller: pageController, count: (filteredCompras.length / itemsPerPage).ceil()), // Utiliza el componente PageIndicator
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Acción para agregar un nuevo elemento
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
