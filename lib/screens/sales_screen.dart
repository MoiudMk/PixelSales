import 'package:flutter/material.dart';
import '../database_helper.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> customers = [];
  final cart = <Map<String, dynamic>>[];

  int? customerId;
  String? customerName;
  double discount = 0, paid = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    products = await DatabaseHelper.instance.getProducts();
    customers = await DatabaseHelper.instance.getCustomers();
    if (mounted) setState(() {});
  }

  double get subtotal =>
      cart.fold(0, (s, x) => s + (x['price'] as num) * x['sellQuantity']);

  double get total => subtotal - discount;

  void add(Map<String, dynamic> p) {
    final i = cart.indexWhere((x) => x['id'] == p['id']);
    if ((p['quantity'] as int) <= 0) return;

    setState(() {
      if (i >= 0) {
        cart[i]['sellQuantity']++;
      } else {
        cart.add({...p, 'sellQuantity': 1});
      }
    });
  }

  Future<void> checkout() async {
    if (cart.isEmpty) return;

    final d = TextEditingController();
    final pa = TextEditingController(text: total.toStringAsFixed(2));

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد البيع'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('الإجمالي: ${total.toStringAsFixed(2)} د.ل'),
            TextField(
              controller: d,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'الخصم'),
            ),
            TextField(
              controller: pa,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'المدفوع'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () async {
              discount = double.tryParse(d.text) ?? 0;
              paid = double.tryParse(pa.text) ?? total;
              if (discount > subtotal) discount = subtotal;

              await DatabaseHelper.instance.createInvoice(
                customerId: customerId,
                customerName: customerName,
                total: total,
                discount: discount,
                paid: paid,
                createdAt: DateTime.now().toIso8601String(),
                items: cart,
              );

              if (context.mounted) Navigator.pop(context, true);
            },
            child: const Text('حفظ الفاتورة'),
          ),
        ],
      ),
    );

    if (ok == true) {
      cart.clear();
      customerId = null;
      customerName = null;
      discount = 0;
      paid = 0;
      await load();
      if (mounted) {
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ الفاتورة وتحديث المخزون')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext c) => Scaffold(
        appBar: AppBar(title: const Text('المبيعات')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: DropdownButtonFormField<int?>(
                value: customerId,
                decoration: const InputDecoration(
                  labelText: 'العميل (اختياري)',
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('عميل نقدي'),
                  ),
                  ...customers.map(
                    (x) => DropdownMenuItem<int?>(
                      value: x['id'],
                      child: Text(x['name'].toString()),
                    ),
                  ),
                ],
                onChanged: (v) {
                  setState(() {
                    customerId = v;
                    final x = customers.where((e) => e['id'] == v);
                    customerName = x.isEmpty ? null : x.first['name'];
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (_, i) {
                  final p = products[i];
                  return ListTile(
                    title: Text(p['name'].toString()),
                    subtitle: Text(
                      'متوفر: ${p['quantity']} | ${p['price']} د.ل',
                    ),
                    trailing: IconButton(
                      onPressed: () => add(p),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  );
                },
              ),
            ),
            if (cart.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text(
                      'عناصر الفاتورة: ${cart.length} | '
                      'الإجمالي: ${subtotal.toStringAsFixed(2)} د.ل',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 46,
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: checkout,
                        icon: const Icon(Icons.receipt_long),
                        label: const Text('إتمام البيع'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
}
