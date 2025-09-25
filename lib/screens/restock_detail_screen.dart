import 'package:flutter/material.dart';
import 'package:myapp/models/shortage_product.dart';

class RestockDetailScreen extends StatelessWidget {
  final ShortageProduct product;

  const RestockDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Name: ${product.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Machine Name: ${product.machineName}'),
            Text('Machine Number: ${product.machineNumber}'),
            Text('Product Number: ${product.productNumber}'),
            Text('Tray Number: ${product.trayNumber}'),
            Text('Available Quantity: ${product.availableQty}'),
            Text('Capacity: ${product.capacity}'),
          ],
        ),
      ),
    );
  }
}
