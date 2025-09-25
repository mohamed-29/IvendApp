import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/shortage_product.dart';
import 'package:myapp/screens/restock_detail_screen.dart';

class RestockScreen extends StatelessWidget {
  final List<ShortageProduct> shortageProducts;

  const RestockScreen({super.key, required this.shortageProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Restock Required',
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.7)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: shortageProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.green, size: 80),
                  const SizedBox(height: 20),
                  Text(
                    'All Stocked Up!',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
              itemCount: shortageProducts.length,
              itemBuilder: (context, index) {
                final product = shortageProducts[index];
                return _buildProductCard(context, product);
              },
            ),
    );
  }

  Widget _buildProductCard(BuildContext context, ShortageProduct product) {
    final stockLevel = product.capacity > 0 ? product.availableQty / product.capacity : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 5,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RestockDetailScreen(product: product),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.inventory_2_outlined,
                    size: 30, color: Colors.grey),
              ),
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
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Machine: ${product.machineName}',
                      style: GoogleFonts.inter(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: stockLevel,
                            backgroundColor: Colors.orange.shade100,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${product.availableQty}/${product.capacity}',
                          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
