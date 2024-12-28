import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/model/materials.dart';
import 'package:qldt/data/request/material_request.dart';
import 'package:qldt/presentation/page/class/material/action_type.dart';
import 'package:qldt/presentation/page/class/material/material_provider.dart';
import 'package:qldt/presentation/page/home_page.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';




class UploadMaterialPage extends StatefulWidget {
  final String classId;
  const UploadMaterialPage({super.key, required this.classId});
  @override
  _UploadMaterialPageState createState() => _UploadMaterialPageState();
}

class _UploadMaterialPageState extends State<UploadMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String>? _uploadedFileNames; // List of file names
  List<File>? _files; // List of file paths

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MaterialProvider>();

    final String classId = widget.classId;

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Material'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Upload Files Button
              ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);

                  if (result != null) {
                    setState(() {
                      _files = result.files
                          .where((file) => file.path != null)
                          .map((file) => File(file.path!))
                          .toList();

                      _uploadedFileNames =
                          result.files.map((file) => file.name).toList();
                    });
                  } else {
                    // User canceled the picker
                    setState(() {
                      _files = null;
                      _uploadedFileNames = null;
                    });
                  }
                },
                child: Center(child: Text((_uploadedFileNames == null || _uploadedFileNames?.isEmpty == true) ? 'Upload Files' : 'Change Files')),
              ),
              SizedBox(height: 8.0),

              // Display Selected Files
              if (_uploadedFileNames != null && _uploadedFileNames!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected files:', style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.0),
                    ..._uploadedFileNames!.map((fileName) => Text('• $fileName')),
                  ],
                )
              else
                Text(
                  'No files selected',
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 16.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_files == null || _files!.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please upload at least one file!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Process form data

                        controller.uploadMaterial(UploadMaterialRequest(classID: classId, title: _titleController.text, description: _descriptionController.text, materialType: "pdf", files: _files ?? List.empty(), token: UserPreferences.getToken() ?? ""));

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Material upload successfully!'),
                          ),
                        );
                      }
                    }
                  },
                  child: Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
