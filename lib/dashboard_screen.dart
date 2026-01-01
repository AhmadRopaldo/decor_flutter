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
  int furnitureCount = 0;
  int customerCount = 0;
  List<dynamic> ordersList = []; 
  bool isLoading = true;

  // Endpoint sesuai dengan api.php Anda (image_4796cd.png)
  final String url = "http://localhost:8000/api/admin-orders"; 

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        setState(() {
          // BOLD: Gunakan .toInt() atau ?? 0 untuk mencegah null pointer
          furnitureCount = responseData['summary']['total_furniture'] ?? 0;
          customerCount = responseData['summary']['total_customer'] ?? 0;
          ordersList = responseData['data'] ?? [];
          isLoading = false; 
        });
      } else {
        throw Exception("Server Error");
      }
    } catch (e) {
      debugPrint("Error Dashboard: $e");
      // TETAP MATIKAN LOADING agar aplikasi tidak berputar terus jika terjadi error
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data: $e")),
        );
      }
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : RefreshIndicator(
              onRefresh: fetchDashboardData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: StatCard(title: 'Furniture', value: furnitureCount.toString())),
                        const SizedBox(width: kDefaultPadding),
                        Expanded(child: StatCard(title: 'Customer', value: customerCount.toString())),
                      ],
                    ),
                    const SizedBox(height: kDefaultPadding * 1.5),
                    const Text('Orders', style: kTextStyleHeaderCard),
                    const SizedBox(height: 10),
                    // Tabel Orders Dinamis
                    OrdersTable(orders: ordersList),
                  ],
                ),
              ),
            ),
    );
  }
}

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

class OrdersTable extends StatelessWidget {
  final List<dynamic> orders;
  const OrdersTable({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: orders.isEmpty 
          ? const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Tidak ada pesanan terbaru."),
            ))
          : Table(
              columnWidths: const {
                0: FlexColumnWidth(1), // ID
                1: FlexColumnWidth(2), // Status
                2: FlexColumnWidth(2), // Total
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(color: Color(0xFFF5F5F5)),
                  children: [
                    Padding(padding: EdgeInsets.all(8.0), child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8.0), child: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                ),
                ...orders.map((order) {
                  return TableRow(
                    children: [
                      // Sesuai field database 'id' (image_478ba8.jpg)
                      Padding(padding: const EdgeInsets.all(8.0), child: Text("#${order['id']}")),
                      // Sesuai field database 'status'
                      Padding(padding: const EdgeInsets.all(8.0), child: Text(order['status'] ?? '-')),
                      // Sesuai field database 'total_harga'
                      Padding(padding: const EdgeInsets.all(8.0), child: Text("Rp ${order['total_harga']}")),
                    ],
                  );
                }).toList(),
              ],
            ),
    );
  }
}