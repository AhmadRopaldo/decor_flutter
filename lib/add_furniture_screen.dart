import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'constants.dart';
import 'furniture_model.dart'; // Pastikan file ini ada

class AddFurnitureScreen extends StatefulWidget {
  const AddFurnitureScreen({super.key});

  @override
  State<AddFurnitureScreen> createState() => _AddFurnitureScreenState();
}

class _AddFurnitureScreenState extends State<AddFurnitureScreen> {
  // Pindahkan controller ke dalam State agar stabil
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSubmitting = false;

  Future<void> _submitData() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isSubmitting = true);

    // URL Laravel API
    // Emulator Android: 10.0.2.2 | HP Fisik: IP Laptop Anda
    final String url = "http://10.0.2.2:8000/api/produks"; 

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "nama_produk": nameController.text,
          "harga": priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
          "deskripsi": descriptionController.text,
          "stok": int.tryParse(stockController.text) ?? 0,
          "tags": tagsController.text,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk Decor Berhasil Ditambahkan!')),
        );
        Navigator.pop(context, true); // Kirim 'true' agar layar sebelumnya refresh
      } else {
        throw Exception('Gagal menyimpan ke server: ${response.body}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: const Text('Add Furniture', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding * 2),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Name'),
              TextFormField(
                controller: nameController,
                validator: (v) => v!.isEmpty ? 'Nama wajib diisi' : null,
                decoration: _buildInputDecoration(),
              ),
              const SizedBox(height: kDefaultPadding),
              
              _buildLabel('Price'),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Harga wajib diisi' : null,
                decoration: _buildInputDecoration(hint: "Contoh: 150000"),
              ),
              const SizedBox(height: kDefaultPadding),

              _buildLabel('Description'),
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _buildInputDecoration(),
              ),
              const SizedBox(height: kDefaultPadding),

              _buildLabel('Stock'),
              TextFormField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(),
              ),
              const SizedBox(height: kDefaultPadding),

              _buildLabel('Tags'),
              TextFormField(
                controller: tagsController,
                decoration: _buildInputDecoration(hint: "Contoh: Kursi, Kayu"),
              ),
              const SizedBox(height: kDefaultPadding * 2),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Add', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(label, style: kTextStyleSubtitle),
  );

  InputDecoration _buildInputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
  );
}