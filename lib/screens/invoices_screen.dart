import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'package:intl/intl.dart';

class InvoicesScreen extends StatefulWidget{const InvoicesScreen({super.key});@override State<InvoicesScreen> createState()=>_InvoicesScreenState();}
class _InvoicesScreenState extends State<InvoicesScreen>{
 List<Map<String,dynamic>> data=[];
 Future<void> load()async{final x=await DatabaseHelper.instance.getInvoices();if(mounted)setState(()=>data=x);}
 @override void initState(){super.initState();load();}
 @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('الفواتير')),body:data.isEmpty?const Center(child:Text('لا توجد فواتير')):ListView.builder(itemCount:data.length,itemBuilder:(_,i){final x=data[i];final date=DateTime.tryParse(x['created_at'])??DateTime.now();return Card(child:ListTile(leading:CircleAvatar(child:Text('${x['id']}')),title:Text('فاتورة #${x['id']}'),subtitle:Text('${x['customer_name']??'نقدي'} • ${DateFormat('yyyy/MM/dd HH:mm').format(date)}'),trailing:Text('${(x['total'] as num).toStringAsFixed(2)} د.ل',style:const TextStyle(fontWeight:FontWeight.bold))));}));
}
