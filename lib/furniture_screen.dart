import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'furniture_model.dart';
import 'constants.dart';

class FurnitureScreen extends StatefulWidget {
  const FurnitureScreen({super.key});

  @override
  State<FurnitureScreen> createState() => _FurnitureScreenState();
}

class _FurnitureScreenState extends State<FurnitureScreen> {
  List<Furniture> furnitureList = [];
  bool isLoading = true;
  // Gunakan localhost:8000 untuk Chrome, atau 10.0.2.2:8000 untuk Emulator Android
  final String baseUrl = "http://localhost:8000/api/produks";

  @override
  void initState() {
    super.initState();
    fetchFurniture();
  }

  // --- FUNGSI API ---

  Future<void> fetchFurniture() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List rawData = responseData['data'];
        setState(() {
          furnitureList = rawData.map((item) => Furniture.fromJson(item)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      _showSnackBar("Gagal memuat data: $e");
    }
  }

  Future<void> addFurniture(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar("Produk berhasil ditambahkan!");
        fetchFurniture();
      }
    } catch (e) {
      _showSnackBar("Gagal menambah produk");
    }
  }

  Future<void> editFurniture(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        _showSnackBar("Produk berhasil diedit!");
        fetchFurniture();
      }
    } catch (e) {
      _showSnackBar("Gagal mengedit produk");
    }
  }

  // --- FUNGSI HAPUS (DELETE) ---
  Future<void> deleteFurniture(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        _showSnackBar("produk berhasil dihapus"); // Notifikasi sesuai instruksi
        fetchFurniture(); // Refresh data
      }
    } catch (e) {
      _showSnackBar("Gagal menghapus produk");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // --- UI DIALOG KONFIRMASI HAPUS ---
  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("apakah anda yakin ingin menghapus produk ini?"), // Pesan sesuai instruksi
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              deleteFurniture(id);    // Jalankan fungsi hapus
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Iya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- UI DIALOG FORM (ADD/EDIT) ---
  void _showFormDialog({Furniture? furniture}) {
    final isEdit = furniture != null;
    final nameController = TextEditingController(text: isEdit ? furniture.name : "");
    final descController = TextEditingController(text: isEdit ? furniture.description : "");
    final priceController = TextEditingController(text: isEdit ? furniture.price.toString() : "");
    final stockController = TextEditingController(text: isEdit ? furniture.stock.toString() : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Produk" : "Tambah Produk"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nama Produk")),
              TextField(controller: descController, decoration: const InputDecoration(labelText: "Deskripsi")),
              TextField(controller: priceController, decoration: const InputDecoration(labelText: "Harga"), keyboardType: TextInputType.number),
              TextField(controller: stockController, decoration: const InputDecoration(labelText: "Stok"), keyboardType: TextInputType.number),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final data = {
                "nama": nameController.text,
                "deskripsi": descController.text,
                "harga": priceController.text,
                "stok": stockController.text,
              };
              if (isEdit) {
                editFurniture(furniture.id!, data);
              } else {
                addFurniture(data);
              }
              Navigator.pop(context);
            },
            child: Text(isEdit ? "Simpan" : "Tambah"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Furniture List", style: TextStyle(fontWeight: FontWeight.bold)), 
        backgroundColor: Colors.white,
        foregroundColor: kTextColor,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(),
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : ListView.builder(
              itemCount: furnitureList.length,
              itemBuilder: (context, index) {
                final item = furnitureList[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Rp ${item.price} | Stok: ${item.stock}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol Edit
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue), 
                          onPressed: () => _showFormDialog(furniture: item)
                        ),
                        // Tombol Hapus dengan Konfirmasi
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red), 
                          onPressed: () => _showDeleteConfirmation(item.id!)
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}