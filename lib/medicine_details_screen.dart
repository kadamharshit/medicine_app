import 'dart:io';
import 'package:flutter/material.dart';
import 'db_helper.dart';

class MedicineDetailScreen extends StatelessWidget {
  final int medicineId;

  const MedicineDetailScreen({super.key, required this.medicineId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DbHelper().getMedicineById(medicineId),
      builder: (context, snapshot) {
        // Show loading spinner while waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text('Medicine Details')),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Handle null or empty data
        if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: Text('Medicine Details')),
            body: Center(child: Text('Medicine not found.')),
          );
        }

        // Display the medicine data
        final medicine = snapshot.data as Map<String, dynamic>;

        return Scaffold(
          appBar: AppBar(title: Text(medicine['name'] ?? '')),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (medicine['image_path'] != null)
                  Image.file(
                    File(medicine['image_path']),
                    height: 150,
                  ),
                SizedBox(height: 20),
                Text(
                  'When to Take: ${medicine['when_to_take'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Text(
                  'Why to Take: ${medicine['why_to_take'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
