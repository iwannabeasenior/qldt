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

import '../../../../data/request/files_request.dart';
import '../../../theme/color_style.dart';

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

  // List<String>? _uploadedFileNames; // List of file names
  // List<File>? _files; // List of file paths

  FileRequest? file;

  //pick files
  Future<void> pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      setState(() {
        file = FileRequest(file: result.files.single, fileData: result.files.single.bytes);
      });
    }
  }

  void uploadMaterial(MaterialProvider provider) {
    if (_formKey.currentState!.validate()) {
      if (file == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload at least one file!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }
    final String title = _titleController.text;
    final String description = _descriptionController.text;
    final fileType = file?.file?.extension ?? "unknown";

    final uploadMaterialRequest = UploadMaterialRequest(
        classID: widget.classId,
        title: title,
        description: description,
        materialType: fileType,
        file: file,
        token: UserPreferences.getToken() ?? ""
    );

    provider.uploadMaterial(uploadMaterialRequest).then((_) {
      // Show success message after the request
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload material submitted successfully')),
      );
      Navigator.pop(context, true);
    }).catchError((e) {
      // Show error message if there's an issue
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MaterialProvider>(context);
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Material'),
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
                decoration: const InputDecoration(
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
              const SizedBox(height: 16.0),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),

              // Upload Files Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: pickFiles,
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: Text(
                    file != null ? "Tải tài liệu lên" : "Change Files",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: QLDTColor.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
              //Hiển thị danh sách tài liệu
              if (file != null)
                Text('File: ${file?.file?.name.split('/').last}'),
              const SizedBox(height: 8.0),

              // Display Selected Files
              // if (_uploadedFileNames != null && _uploadedFileNames!.isNotEmpty)
              //   Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text('Selected files:',
              //           style: TextStyle(fontWeight: FontWeight.bold)),
              //       SizedBox(height: 8.0),
              //       ..._uploadedFileNames!
              //           .map((fileName) => Text('• $fileName')),
              //     ],
              //   )
              // else
              //   Text(
              //     'No files selected',
              //     style: TextStyle(color: Colors.red),
              //   ),
              const SizedBox(height: 16.0),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState!.validate()) {
                    //   if (file == null) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Please upload at least one file!'),
                    //         backgroundColor: Colors.red,
                    //       ),
                    //     );
                    //   } else {
                    //     // Process form data
                    //
                    //     controller.uploadMaterial(UploadMaterialRequest(
                    //         classID: classId,
                    //         title: _titleController.text,
                    //         description: _descriptionController.text,
                    //         materialType: "pdf",
                    //         file: file,
                    //         token: UserPreferences.getToken() ?? ""));
                    //
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Text('Material upload successfully!'),
                    //       ),
                    //     );
                    //
                    //   }
                    // }
                    uploadMaterial(provider);
                  },
                  child: const Text('Upload'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
