import 'package:flutter/material.dart';
import '../database_helper.dart';

class SettingsScreen extends StatefulWidget{const SettingsScreen({super.key});@override State<SettingsScreen> createState()=>_SettingsScreenState();}
class _SettingsScreenState extends State<SettingsScreen>{
 final name=TextEditingController(),phone=TextEditingController(),address=TextEditingController();
 @override void initState(){super.initState();load();}
 Future<void> load()async{ name.text=await DatabaseHelper.instance.getSetting('store_name')??'PixelSales'; phone.text=await DatabaseHelper.instance.getSetting('store_phone')??''; address.text=await DatabaseHelper.instance.getSetting('store_address')??''; if(mounted)setState((){});}
 Future<void> save()async{await DatabaseHelper.instance.setSetting('store_name',name.text);await DatabaseHelper.instance.setSetting('store_phone',phone.text);await DatabaseHelper.instance.setSetting('store_address',address.text);if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('تم حفظ الإعدادات')));}
 @override Widget build(BuildContext c)=>Scaffold(appBar:AppBar(title:const Text('الإعدادات')),body:ListView(padding:const EdgeInsets.all(16),children:[
 const Text('بيانات المتجر',style:TextStyle(fontSize:20,fontWeight:FontWeight.bold)),const SizedBox(height:14),
 TextField(controller:name,decoration:const InputDecoration(labelText:'اسم المتجر')),const SizedBox(height:10),
 TextField(controller:phone,decoration:const InputDecoration(labelText:'رقم الهاتف')),const SizedBox(height:10),
 TextField(controller:address,decoration:const InputDecoration(labelText:'العنوان')),const SizedBox(height:20),
 FilledButton.icon(onPressed:save,icon:const Icon(Icons.save),label:const Text('حفظ'))
 ]));
}
