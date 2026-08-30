import 'package:flutter/material.dart';
import '../database_helper.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});
  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<Map<String, dynamic>> data = [];

  Future<void> load() async {
    final x = await DatabaseHelper.instance.getCustomers();
    if (mounted) setState(() => data = x);
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> add() async {
    final n = TextEditingController();
    final p = TextEditingController();
    final a = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('إضافة عميل'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: n, decoration: const InputDecoration(labelText: 'اسم العميل')),
            const SizedBox(height: 8),
            TextField(controller: p, decoration: const InputDecoration(labelText: 'الهاتف')),
            const SizedBox(height: 8),
            TextField(controller: a, decoration: const InputDecoration(labelText: 'العنوان')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () async {
              if (n.text.trim().isEmpty) return;
              await DatabaseHelper.instance.addCustomer(
                n.text.trim(), p.text.trim(), a.text.trim(),
              );
              if (context.mounted) Navigator.pop(context, true);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (ok == true) load();
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('العملاء')),
        body: data.isEmpty
            ? const Center(child: Text('لا يوجد عملاء'))
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (_, i) {
                  final x = data[i];
                  return Card(
                    child: ListTile(
                      title: Text(x['name'].toString()),
                      subtitle: Text('${x['phone'] ?? ''} ${x['address'] ?? ''}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () async {
                          await DatabaseHelper.instance.deleteCustomer(x['id']);
                          load();
                        },
                      ),
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: add,
          icon: const Icon(Icons.person_add),
          label: const Text('إضافة عميل'),
        ),
      );
}
