import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart';

class ExpensesScreen extends StatefulWidget{const ExpensesScreen({super.key});@override State<ExpensesScreen> createState()=>_ExpensesScreenState();}
class _ExpensesScreenState extends State<ExpensesScreen>{
 List<Map<String,dynamic>> data=[];
 Future<void> load()async{final x=await DatabaseHelper.instance.getExpenses();if(mounted)setState(()=>data=x);}
 @override void initState(){super.initState();load();}
 Future<void> add()async{final t=TextEditingController(),a=TextEditingController();final ok=await showDialog<bool>(context:context,builder:(_)=>AlertDialog(title:const Text('إضافة مصروف'),content:Column(mainAxisSize:MainAxisSize.min,children:[TextField(controller:t,decoration:const InputDecoration(labelText:'بيان المصروف')),TextField(controller:a,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'المبلغ'))]),actions:[TextButton(onPressed:()=>Navigator.pop(context,false),child:const Text('إلغاء')),FilledButton(onPressed:()async{final v=double.tryParse(a.text);if(t.text.trim().isEmpty||v==null)return;await DatabaseHelper.instance.addExpense(t.text.trim(),v,DateTime.now().toIso8601String());if(context.mounted)Navigator.pop(context,true);},child:const Text('حفظ'))]));if(ok==true)load();}
 @override
Widget build(BuildContext c) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('المصروفات'),
    ),
    body: data.isEmpty
        ? const Center(
            child: Text('لا توجد مصروفات'),
          )
        : ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, i) {
              final x = data[i];

              return ListTile(
                title: Text(x['title']),
                subtitle: Text(
                  DateFormat('yyyy/MM/dd').format(
                    DateTime.parse(x['created_at']),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(x['amount'] as num).toStringAsFixed(2)} د.ل',
                    ),
                    IconButton(
                      onPressed: () async {
                        await DatabaseHelper.instance
                            .deleteExpense(x['id']);
                        load();
                      },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              );
            },
          ),
    floatingActionButton: FloatingActionButton.extended(
      onPressed: add,
      icon: const Icon(Icons.add),
      label: const Text('إضافة مصروف'),
    ),
  );
}
