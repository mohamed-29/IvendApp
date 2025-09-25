import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/models/shortage_product.dart';

class RestockDetailScreen extends StatelessWidget {
  final ShortageProduct product;

  const RestockDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          product.name,
          style: GoogleFonts.oswald(fontWeight: FontWeight.bold, color:Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
                Theme.of(context).primaryColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildInfoCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final stockLevel = product.capacity > 0 ? product.availableQty / product.capacity : 0.0;
    final int restockNeeded = product.capacity - product.availableQty;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child:
                const Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Chip(
            label: Text(
              '${product.availableQty} / ${product.capacity} Available',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: Color.lerp(Colors.red, Colors.green, stockLevel),
          ),
          const SizedBox(height: 16),
          if (restockNeeded > 0)
            Text(
              'Needs $restockNeeded units to be fully stocked.',
              style: GoogleFonts.inter(
                  color: Colors.orange.shade800, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            _buildInfoRow(
              context,
              icon: Icons.memory,
              label: 'Machine Name',
              value: product.machineName,
            ),
            _buildInfoRow(
              context,
              icon: Icons.qr_code,
              label: 'Machine Number',
              value: product.machineNumber,
            ),
            _buildInfoRow(
              context,
              icon: Icons.format_list_numbered,
              label: 'Product Number',
              value: product.productNumber.toString(),
            ),
            _buildInfoRow(
              context,
              icon: Icons.view_module,
              label: 'Tray Number',
              value: product.trayNumber.toString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  value,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
