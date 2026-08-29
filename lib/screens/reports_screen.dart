import 'package:flutter/material.dart';
import '../database_helper.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Map<String, dynamic>? s;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final x = await DatabaseHelper.instance.dashboardStats();
    if (mounted) {
      setState(() => s = x);
    }
  }

  @override
  Widget build(BuildContext c) {
    if (s == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final sales = (s!['sales'] as num).toDouble();
    final expenses = (s!['expenses'] as num).toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('التقارير')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card('عدد المنتجات', '${s!['products']}'),
          _card('عدد العملاء', '${s!['customers']}'),
          _card('إجمالي المبيعات', '${sales.toStringAsFixed(2)} د.ل'),
          _card('إجمالي المصروفات', '${expenses.toStringAsFixed(2)} د.ل'),
          _card(
            'الصافي',
            '${(sales - expenses).toStringAsFixed(2)} د.ل',
          ),
        ],
      ),
    );
  }

  Widget _card(String a, String b) {
    return Card(
      child: ListTile(
        title: Text(a),
        trailing: Text(
          b,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
