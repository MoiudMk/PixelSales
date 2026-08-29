import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PixelSales'),
        centerTitle: true,
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          _MenuCard(
            icon: Icons.inventory_2_outlined,
            title: 'المنتجات',
          ),
          _MenuCard(
            icon: Icons.point_of_sale_outlined,
            title: 'المبيعات',
          ),
          _MenuCard(
            icon: Icons.people_outline,
            title: 'العملاء',
          ),
          _MenuCard(
            icon: Icons.receipt_long_outlined,
            title: 'الفواتير',
          ),
          _MenuCard(
            icon: Icons.bar_chart_outlined,
            title: 'التقارير',
          ),
          _MenuCard(
            icon: Icons.settings_outlined,
            title: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _MenuCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}