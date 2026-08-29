import 'package:flutter/material.dart';
import 'products_screen.dart';
import 'sales_screen.dart';
import 'customers_screen.dart';
import 'invoices_screen.dart';
import 'expenses_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('المنتجات', Icons.inventory_2_outlined, const ProductsScreen()),
      ('المبيعات', Icons.point_of_sale_outlined, const SalesScreen()),
      ('العملاء', Icons.people_outline, const CustomersScreen()),
      ('الفواتير', Icons.receipt_long_outlined, const InvoicesScreen()),
      ('المصروفات', Icons.payments_outlined, const ExpensesScreen()),
      ('التقارير', Icons.bar_chart_outlined, const ReportsScreen()),
      ('الإعدادات', Icons.settings_outlined, const SettingsScreen()),
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('PixelSales'),
          centerTitle: true,
        ),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.15),
          itemCount: items.length,
          itemBuilder: (_, i) => Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => items[i].$3)),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(items[i].$2, size: 42),
                const SizedBox(height: 10),
                Text(items[i].$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
