class Tag {
  final int? id;
  final String name;

  Tag({this.id, required this.name});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      // Gunakan 'nama' karena di JSON Produk sebelumnya Laravel Anda menggunakan 'nama'
      name: json['nama'] ?? json['nama_tag'] ?? 'Tanpa Nama',
    );
  }
}