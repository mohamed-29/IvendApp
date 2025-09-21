
class ShortageProduct {
  final int id;
  final String name;
  final int productNumber;
  final int trayNumber;
  final int availableQty;
  final int capacity;
  final String machineName;
  final String machineNumber;

  ShortageProduct({
    required this.id,
    required this.name,
    required this.productNumber,
    required this.trayNumber,
    required this.availableQty,
    required this.capacity,
    required this.machineName,
    required this.machineNumber,
  });

  factory ShortageProduct.fromJson(Map<String, dynamic> json) {
    return ShortageProduct(
      id: json['id'],
      name: json['name'],
      productNumber: json['product_number'],
      trayNumber: json['tray_number'],
      availableQty: json['available_qty'],
      capacity: json['capacity'],
      machineName: json['machine_name'],
      machineNumber: json['machine_number'],
    );
  }
}
