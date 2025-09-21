
class Product {
  final int id;
  final int machine;
  final String name;
  final String salePrice;
  final String costPrice;
  final int trayNumber;
  final int availableQty;
  final int capacity;
  final int soldQty;
  final String lastUpdate;
  final int xyProductId;
  final int productNumber;
  final String picture;
  final String pictureName;

  Product({
    required this.id,
    required this.machine,
    required this.name,
    required this.salePrice,
    required this.costPrice,
    required this.trayNumber,
    required this.availableQty,
    required this.capacity,
    required this.soldQty,
    required this.lastUpdate,
    required this.xyProductId,
    required this.productNumber,
    required this.picture,
    required this.pictureName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      machine: json['machine'],
      name: json['name'],
      salePrice: json['sale_price'],
      costPrice: json['cost_price'],
      trayNumber: json['tray_number'],
      availableQty: json['available_qty'],
      capacity: json['capacity'],
      soldQty: json['sold_qty'],
      lastUpdate: json['last_update'],
      xyProductId: json['xy_product_id'],
      productNumber: json['product_number'],
      picture: json['picture'],
      pictureName: json['picture_name'],
    );
  }
}
