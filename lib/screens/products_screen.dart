import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/api/api_service.dart';
import 'package:myapp/models/machine.dart';
import 'package:myapp/models/product.dart';
import 'package:myapp/utils/time_ago.dart';

class ProductsScreen extends StatefulWidget {
  final Machine machine;

  const ProductsScreen({super.key, required this.machine});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ApiService _apiService = ApiService();
  Future<List<Product>>? _products;

  @override
  void initState() {
    super.initState();
    _products = _fetchProducts();
  }

  Future<List<Product>> _fetchProducts() async {
    final data = await _apiService.getProductsForMachine(widget.machine.id);
    return (data as List).map((product) => Product.fromJson(product)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/dashboard");
          },
        ),
        title: Text(
          widget.machine.name,
          style: GoogleFonts.oswald(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme: IconThemeData(color: Colors.grey.shade800),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMachineDetails(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Products in Machine',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildProductsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMachineDetails() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildDetailRow('Machine Number', widget.machine.machineNumber, Icons.qr_code_scanner),
            _buildDetailRow('Temperature', '${widget.machine.temperature}°C', Icons.thermostat),
            _buildDetailRow('Status', widget.machine.isOnline ? 'Online' : 'Offline', widget.machine.isOnline ? Icons.check_circle : Icons.cancel),
            _buildDetailRow('Last Update', timeAgo(widget.machine.lastUpdate), Icons.access_time),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList() {
    return FutureBuilder<List<Product>>(
      future: _products,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading products: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found for this machine'));
        }

        final products = snapshot.data!;

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    _buildProductImage(product.picture),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Price: ${product.salePrice} EGP',
                            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700),
                          ),
                          Text(
                            'Stock: ${product.availableQty} / ${product.capacity}',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: product.availableQty <= 2 ? Colors.red.shade700 : Colors.green.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Tray: ${product.trayNumber}',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sold: ${product.soldQty}',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildProductImage(String base64String) {
    if (base64String.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey.shade600, size: 30),
      );
    }

    try {
      final UriData? data = Uri.parse(base64String).data;
      if (data != null) {
        Uint8List imageBytes = data.contentAsBytes();
        return Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: MemoryImage(imageBytes),
              fit: BoxFit.cover,
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error decoding image: $e');
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.broken_image, color: Colors.red.shade400, size: 30),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

