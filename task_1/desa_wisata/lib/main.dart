import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6F0E8),
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("Desa Wisata Impian"),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    hintText: "Cari desa atau spot wisata...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: const [
                    CircleAvatar(child: Icon(Icons.person)),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Halo, Tri!",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Mau ke mana hari ini?"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Kategori Wisata",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CategoryItem(icon: Icons.landscape, label: "Alam"),
                  CategoryItem(icon: Icons.restaurant, label: "Kuliner"),
                  CategoryItem(icon: Icons.home, label: "Budaya"),
                  CategoryItem(icon: Icons.directions_bike, label: "Edukasi"),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                "Rekomendasi Spot",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Expanded(
                    child: RecommendationCard(
                      imageUrl: "https://picsum.photos/200",
                      title: "Kuliner Tumpeng Menoreh",
                      location: "Desa Jati Mulyo",
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: RecommendationCard(
                      imageUrl: "https://picsum.photos/201",
                      title: "Rumah Adat Jati Sari",
                      location: "Dusun Krajan",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: "Explore"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Wishlist"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.green),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;

  const RecommendationCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(15),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              color: Colors.green[200],
              child: const Icon(
                Icons.landscape,
                size: 48,
                color: Colors.green,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  location,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
