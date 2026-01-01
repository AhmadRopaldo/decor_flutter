import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'admin_drawer.dart';
import 'constants.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Variabel untuk menampung data dari Database
  int furnitureCount = 0;
  int customerCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  // Fungsi untuk mengambil data dari Laravel
  Future<void> fetchDashboardData() async {
    // SESUAIKAN IP: Gunakan 10.0.2.2 untuk emulator atau IP Laptop untuk HP fisik
    final String url = "http://127.0.0.1:8000/api/produks"; 

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          furnitureCount = data.length; // Mengupdate angka sesuai jumlah baris di database
          customerCount = 100; // Contoh statis, bisa buat API serupa untuk User
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      drawer: const AdminDrawer(),
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Good morning 👋', style: kTextStyleSubtitle),
                Text('Admin123', style: kTextStyleTitle),
              ],
            ),
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: kTextColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ],
        ),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : RefreshIndicator(
              onRefresh: fetchDashboardData, // Tarik layar ke bawah untuk refresh
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            title: 'Furniture', 
                            value: furnitureCount.toString(), // Data Dinamis
                          ),
                        ),
                        const SizedBox(width: kDefaultPadding),
                        Expanded(
                          child: StatCard(
                            title: 'Customer', 
                            value: customerCount.toString(), // Data Dinamis
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: kDefaultPadding * 1.5),
                    const Text('Income', style: kTextStyleSubtitle),
                    const SizedBox(height: 4),
                    const Text(
                      'Rp 000.000.000',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: kTextColor),
                    ),
                    const SizedBox(height: kDefaultPadding * 1.5),
                    const Text('Orders', style: kTextStyleHeaderCard),
                    const OrdersTable(),
                  ],
                ),
              ),
            ),
    );
  }
}

// Widget StatCard tetap sama (Stateless)
class StatCard extends StatelessWidget {
  final String title;
  final String value;
  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: kTextStyleSubtitle),
          const SizedBox(height: 4),
          Text(value, style: kTextStyleHeaderCard),
        ],
      ),
    );
  }
}

// Widget OrdersTable tetap sama
class OrdersTable extends StatelessWidget {
  const OrdersTable({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(/* ... isi tabel tetap sama seperti kode Anda ... */);
  }
}