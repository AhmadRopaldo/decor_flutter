// login_screen.dart

import 'package:flutter/material.dart';
import 'dashboard_screen.dart'; 
import 'constants.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(kDefaultPadding * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            // Judul "Login into Your Account"
            const Text(
              'Login into Your\nAccount',
              style: kTextStyleTitle,
            ),
            const SizedBox(height: 50),
            
            // Field Email
            const Text('Email', style: kTextStyleSubtitle),
            const SizedBox(height: 4),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'hello@gmail.com',
                contentPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            
            const SizedBox(height: kDefaultPadding),

            // Field Password
            const Text('Password', style: kTextStyleSubtitle),
            const SizedBox(height: 4),
            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'your password',
                contentPadding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 12),
                suffixIcon: const Icon(Icons.visibility),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),

            const SizedBox(height: 8),
            
            // Lupa Password
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Forgot Password ?',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),

            const SizedBox(height: kDefaultPadding * 2),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Navigasi ke Dashboard setelah Login berhasil
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const DashboardScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: kBackgroundColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}