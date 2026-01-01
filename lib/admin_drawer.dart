import 'package:flutter/material.dart';
import 'constants.dart';
import 'dashboard_screen.dart'; // Import Dashboard (untuk navigasi kembali)
import 'furniture_screen.dart'; // Import halaman Furniture
import 'tag_screen.dart'; // Import halaman Tag

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // Data untuk item-item di menu sidebar
    final List<String> menuItems = [
      'Dashboard',
      'Furniture',
      'Orders',
      'Complain',
      'Review',
      'Tag',
      'User'
    ];

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75, // Lebar drawer
      backgroundColor: kBackgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Header Drawer
          Container(
            padding: const EdgeInsets.only(top: 40, bottom: 20, left: kDefaultPadding, right: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Decor',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
                // Tombol Close 'x'
                IconButton(
                  icon: const Icon(Icons.close, color: kTextColor),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.grey, height: 1),

          // Menu Item
          ...menuItems.map((item) {
            Widget? destination;
            if (item == 'Dashboard') {
                destination = const DashboardScreen();
            } else if (item == 'Furniture') {
                destination = const FurnitureScreen();
            } else if (item == 'Tag') {
                destination = const TagScreen();
            }
            // TODO: Tambahkan navigasi untuk Orders, Complain, Review, User

            return ListTile(
              title: Text(
                item,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kTextColor,
                ),
              ),
              onTap: () {
                Navigator.pop(context); // Tutup drawer
                if (destination != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => destination!),
                    );
                }
              },
            );
          }).toList(),
          
          const SizedBox(height: 50),
          
          // Bagian User di bawah
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.grey, height: 1),
                const SizedBox(height: kDefaultPadding),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orange, // Placeholder warna
                      // backgroundImage: AssetImage('assets/images/admin_avatar.png'), // Gunakan jika sudah ada aset
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Admin123', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('admin123@gmail.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}