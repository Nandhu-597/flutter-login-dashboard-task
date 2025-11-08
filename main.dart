import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login to Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Arial',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // 🌊 Wave Background
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF74ABE2), Color(0xFF5563DE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // Centered Login Box
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width * 0.8, // smaller width
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_circle,
                        color: Colors.indigo, size: 70),
                    const SizedBox(height: 10),
                    const Text(
                      "Let's Get Started",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter your name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                      ),
                      style: const TextStyle(fontSize: 14),
                      maxLength: 9,
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo.shade400,
                        foregroundColor: Colors.white,
                        minimumSize:
                            const Size(double.infinity, 40), // smaller button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        String name = _nameController.text.trim();

                        if (name.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter your name first!')),
                          );
                        } else if (RegExp(r'[0-9]').hasMatch(name)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Invalid username — letters only allowed.')),
                          );
                        } else if (name.length > 9) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Name should be up to 9 characters only.')),
                          );
                        } else {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (_, __, ___) =>
                                  DashboardPage(name: name),
                              transitionsBuilder:
                                  (_, animation, __, child) => FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          ).then((result) {
                            if (result == 'logout') {
                              _nameController.clear();
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🌊 Custom Wave Clipper
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 60);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 40);
    var secondControlPoint =
        Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 60);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 🏠 Dashboard Page (unchanged)
class DashboardPage extends StatelessWidget {
  final String name;
  const DashboardPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1522202176988-66273c2fd55f',
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.3)),
          Center(
            child: Card(
              elevation: 12,
              color: Colors.white.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.emoji_emotions,
                        size: 80, color: Colors.indigo),
                    const SizedBox(height: 15),
                    Text(
                      'Welcome, $name!',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This is your personal dashboard',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'You have successfully logged in 🎉',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        Navigator.pop(context, 'logout');
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}