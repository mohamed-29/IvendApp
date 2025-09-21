
import 'package:myapp/models/shortage_product.dart';

class DashboardStats {
  final int totalMachines;
  final int onlineMachines;
  final int offlineMachines;
  final int shortageProductsCount;
  final List<ShortageProduct> shortageProducts;

  DashboardStats({
    required this.totalMachines,
    required this.onlineMachines,
    required this.offlineMachines,
    required this.shortageProductsCount,
    required this.shortageProducts,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    var shortageProductsList = json['shortage_products'] as List;
    List<ShortageProduct> products = shortageProductsList.map((i) => ShortageProduct.fromJson(i)).toList();

    return DashboardStats(
      totalMachines: json['total_machines'],
      onlineMachines: json['online_machines'],
      offlineMachines: json['offline_machines'],
      shortageProductsCount: json['shortage_products_count'],
      shortageProducts: products,
    );
  }
}
