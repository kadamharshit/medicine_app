import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'db_helper.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _nameController = TextEditingController();
  final _whenController = TextEditingController();
  final _whyController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = p.basename(picked.path);
      final savedImage = await File(picked.path).copy('${appDir.path}/$fileName');
      setState(() {
        _image = savedImage;
      });
    }
  }

  void _saveData() async {
    if (_nameController.text.isEmpty || _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields and pick an image')),
      );
      return;
    }

    await DbHelper().insertMedicine({
      'name': _nameController.text.trim(),
      'when_to_take': _whenController.text.trim(),
      'why_to_take': _whyController.text.trim(),
      'image_path': _image!.path,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Medicine Saved!')),
    );

    Navigator.pop(context); // This returns to HomeScreen and triggers _loadMedicines
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Medicine')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Medicine Name'),
            ),
            TextField(
              controller: _whenController,
              decoration: InputDecoration(labelText: 'When to Take'),
            ),
            TextField(
              controller: _whyController,
              decoration: InputDecoration(labelText: 'Why to Take'),
            ),
            SizedBox(height: 10),
            _image != null
                ? Image.file(_image!, height: 100)
                : TextButton.icon(
                    onPressed: _pickImage,
                    icon: Icon(Icons.photo),
                    label: Text('Pick Image'),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
