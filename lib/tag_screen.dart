import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tag_model.dart'; 
import 'constants.dart';

class TagScreen extends StatefulWidget {
  const TagScreen({super.key});

  @override
  State<TagScreen> createState() => _TagScreenState();
}

class _TagScreenState extends State<TagScreen> {
  List<Tag> tagList = [];
  bool isLoading = true;

  // URL API Laravel
  final String baseUrl = "http://localhost:8000/api/tags";

  @override
  void initState() {
    super.initState();
    fetchTags();
  }

  // --- 1. FUNGSI AMBIL DATA (GET) ---
  Future<void> fetchTags() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        List<dynamic> rawList;

        if (decodedData is Map<String, dynamic> && decodedData.containsKey('data')) {
          rawList = decodedData['data'];
        } else if (decodedData is List) {
          rawList = decodedData;
        } else {
          throw Exception("Format data tidak dikenal");
        }

        setState(() {
          tagList = rawList.map((item) => Tag.fromJson(item)).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error Fetch: $e");
      setState(() => isLoading = false);
      _showSnackBar("Gagal memuat data tag");
    }
  }

  // --- 2. FUNGSI TAMBAH DATA (POST) ---
  Future<void> addTag(String name) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"nama": name}),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        _showSnackBar("Tag telah ditambahkan !");
        fetchTags(); 
      } else {
        _showSnackBar("Gagal menambahkan tag");
      }
    } catch (e) {
      _showSnackBar("Error: $e");
    }
  }

  // --- 3. FUNGSI HAPUS DATA (DELETE) ---
  Future<void> deleteTag(int id) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        _showSnackBar("tag berhasil dihapus");
        fetchTags();
      }
    } catch (e) {
      _showSnackBar("Gagal menghapus tag");
    }
  }

  // --- UI DIALOG KONFIRMASI HAPUS ---
  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("apakah anda yakin ingin menghapus ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              deleteTag(id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Iya", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- UI DIALOG INPUT TAMBAH ---
  void _showAddTagDialog() {
    final TextEditingController tagController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Tambah Tag Baru"),
        content: TextField(
          controller: tagController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Nama Tag",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (tagController.text.isNotEmpty) {
                addTag(tagController.text);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Manage Tags", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: kTextColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : RefreshIndicator(
              onRefresh: fetchTags,
              child: Padding(
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total: ${tagList.length} Tags", style: kTextStyleSubtitle),
                        ElevatedButton.icon(
                          onPressed: _showAddTagDialog,
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text("Add Tag", style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: kPrimaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: tagList.isEmpty
                          ? const Center(child: Text("Belum ada data tag."))
                          : ListView.builder(
                              itemCount: tagList.length,
                              itemBuilder: (context, index) {
                                final tag = tagList[index];
                                return Card(
                                  elevation: 2,
                                  margin: const EdgeInsets.only(bottom: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: ListTile(
                                    leading: const Icon(Icons.label, color: kPrimaryColor),
                                    title: Text(tag.name, 
                                        style: const TextStyle(fontWeight: FontWeight.w600)),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete_sweep, color: Colors.redAccent),
                                      onPressed: () => _showDeleteConfirmation(tag.id!),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}