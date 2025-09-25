import 'package:flutter/material.dart';
import 'package:myapp/models/shortage_product.dart';
import 'package:myapp/screens/restock_detail_screen.dart';

class RestockScreen extends StatelessWidget {
  final List<ShortageProduct> shortageProducts;

  const RestockScreen({super.key, required this.shortageProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To Restock'),
      ),
      body: shortageProducts.isEmpty
          ? const Center(child: Text('No products to restock.'))
          : ListView.builder(
              itemCount: shortageProducts.length,
              itemBuilder: (context, index) {
                final product = shortageProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Machine: ${product.machineName} in ${product.trayNumber}'),
                  trailing:
                      Text('Qty: ${product.availableQty}/${product.capacity}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RestockDetailScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
