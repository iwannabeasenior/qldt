import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import 'package:qldt/main.dart';
import 'package:qldt/presentation/page/class/material/material_provider.dart';



class EditMaterialPage extends StatefulWidget {
  @override
  _EditMaterialPageState createState() => _EditMaterialPageState();
}

class _EditMaterialPageState extends State<EditMaterialPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _uploadedFileName;
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<MaterialProvider>();
        
    return Scaffold(
      appBar: AppBar(
        title: Text('Form with File Picker'),
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

              // Upload File Button
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // File picker logic
                      FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                      if (result != null) {
                        setState(() {
                          _filePath = result.files.single.path;
                          _uploadedFileName = result.files.single.name;
                        });
                      } else {
                        // User canceled the picker
                        setState(() {
                          _filePath = null;
                          _uploadedFileName = null;
                        });
                      }
                    },
                    child: Text('Upload File'),
                  ),
                  SizedBox(width: 16.0),
                  if (_uploadedFileName != null)
                    Expanded(
                      child: Text(
                        'Selected file: $_uploadedFileName',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
              if (_uploadedFileName == null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'No file selected',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 16.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_filePath == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please upload a file!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        // Process form data

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Form submitted successfully!'),
                          ),
                        );

                        // Debug log for form data
                        print('Title: ${_titleController.text}');
                        print('Description: ${_descriptionController.text}');
                        print('File path: $_filePath');
                      }
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
