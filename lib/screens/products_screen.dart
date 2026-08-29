import 'package:flutter/material.dart';
import '../database_helper.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  @override State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Map<String,dynamic>> products = [];
  String search = '';

  Future<void> load() async {
    final data = await DatabaseHelper.instance.getProducts();
    if (mounted) setState(() => products = data);
  }

  @override void initState(){ super.initState(); load(); }

  Future<void> form([Map<String,dynamic>? p]) async {
    final n=TextEditingController(text:p?['name']?.toString()??'');
    final pr=TextEditingController(text:p?['price']?.toString()??'');
    final q=TextEditingController(text:p?['quantity']?.toString()??'');
    final b=TextEditingController(text:p?['barcode']?.toString()??'');
    final ok=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(
      title:Text(p==null?'إضافة منتج':'تعديل منتج'),
      content:SingleChildScrollView(child:Column(children:[
        TextField(controller:n,decoration:const InputDecoration(labelText:'اسم المنتج')),
        const SizedBox(height:10), TextField(controller:pr,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'السعر')),
        const SizedBox(height:10), TextField(controller:q,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'الكمية')),
        const SizedBox(height:10), TextField(controller:b,decoration:const InputDecoration(labelText:'الباركود (اختياري)')),
      ])),
      actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('إلغاء')),
        FilledButton(onPressed:()async{
          final price=double.tryParse(pr.text); final qty=int.tryParse(q.text);
          if(n.text.trim().isEmpty||price==null||qty==null){return;}
          if(p==null) await DatabaseHelper.instance.addProduct(n.text.trim(),price,qty,barcode:b.text.trim());
          else await DatabaseHelper.instance.updateProduct(p['id'],n.text.trim(),price,qty,barcode:b.text.trim());
          if(context.mounted) Navigator.pop(context,true);
        },child:const Text('حفظ'))]
    ));
    if(ok==true) load();
  }

  @override Widget build(BuildContext context){
    final list=products.where((p)=>p['name'].toString().toLowerCase().contains(search.toLowerCase())).toList();
    return Scaffold(appBar:AppBar(title:const Text('المنتجات')),
      body:Column(children:[
        Padding(padding:const EdgeInsets.all(12),child:TextField(onChanged:(v)=>setState(()=>search=v),decoration:const InputDecoration(prefixIcon:Icon(Icons.search),hintText:'بحث عن منتج'))),
        Expanded(
  child: list.isEmpty
      ? const Center(child: Text('لا توجد منتجات'))
      : ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final p = list[i];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 5,
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.inventory_2_outlined),
                ),
                title: Text(p['name']),
                subtitle: Text('المخزون: ${p['quantity']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(p['price'] as num).toStringAsFixed(2)} د.ل',
                    ),
                    IconButton(
                      onPressed: () => form(p),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .deleteProduct(p['id']);
                        load();
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
),
