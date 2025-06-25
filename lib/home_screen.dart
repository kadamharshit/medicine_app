import 'package:flutter/material.dart';
import 'add_medicine_screen.dart';
import 'medicine_details_screen.dart';
import 'db_helper.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override

  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List<Map<String, dynamic>> _medicines = [];

  void _loadMedicines() async {
    final data = await DbHelper().getAllMedicines();
    setState(() {
      _medicines = data;
    });
  }
  @override

  void initState() {
    super.initState();
    _loadMedicines();
  }

  @override

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text('My Medicines')),
      body: _medicines.isEmpty
      ? Center(child: Text('No medicines added yet'))
      : GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _medicines.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index){
          final medicine = _medicines[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MedicineDetailScreen(medicineId: medicine['id']),
                ),
              );
            },
            child: Card(
              elevation: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  medicine['image_path'] != null
                  ? Image.file(File(medicine['image_path']), height: 80)
                  : Icon(Icons.medical_services, size: 60),
                SizedBox(height: 8),
                Text(medicine['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold),),

                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddMedicineScreen()),
          );
          _loadMedicines();
        },
        child: Icon(Icons.add),
         ),
    );
  }

}