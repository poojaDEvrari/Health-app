import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:relax_doc/models/product.dart';
import 'package:relax_doc/services/product_service.dart';
import 'package:relax_doc/theme/app_theme.dart';
import 'package:relax_doc/widgets/equipment_product_row.dart';

class EquipmentProductsScreen extends StatefulWidget {
  final String categoryTitle;
  final bool isNewEquipment;
  
  const EquipmentProductsScreen({
    Key? key,
    required this.categoryTitle,
    required this.isNewEquipment,
  }) : super(key: key);

  @override
  State<EquipmentProductsScreen> createState() => _EquipmentProductsScreenState();
}

class _EquipmentProductsScreenState extends State<EquipmentProductsScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _productsFuture = widget.isNewEquipment
          ? ProductService.getNewEquipment()
          : ProductService.getUsedEquipment();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.categoryTitle,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        actions: const [
          Icon(Icons.search_outlined),
          SizedBox(width: 16),
          Icon(Icons.filter_list_outlined),
          SizedBox(width: 12),
        ],
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.lightBgGradient,
          ),
        ),
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load products\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return EquipmentProductRow(product: products[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
