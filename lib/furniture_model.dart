class Furniture {
  final int? id;
  final String name;
  final String price;
  final String description;
  final int stock;

  Furniture({this.id, required this.name, required this.price, required this.description, required this.stock});

  factory Furniture.fromJson(Map<String, dynamic> json) {
    return Furniture(
      id: json['id'],
      name: json['nama'] ?? '',
      price: json['harga']?.toString() ?? '0',
      description: json['deskripsi'] ?? '',
      stock: json['stok'] ?? 0,
    );
  }
}