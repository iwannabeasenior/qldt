import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:qldt/presentation/theme/color_style.dart';
import 'package:file_picker/file_picker.dart';

class SubmitAssignmentPage extends StatefulWidget {
  const SubmitAssignmentPage({super.key});

  @override
  State<SubmitAssignmentPage> createState() => _SubmitAssignmentPageState();
}

class _SubmitAssignmentPageState extends State<SubmitAssignmentPage> {
  List<String> selectedFilePaths = [];

  // Hàm chọn nhiều tệp
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      setState(() {
        selectedFilePaths = result.paths.whereType<String>().toList();
      });
    } else {
      setState(() {
        selectedFilePaths = ["Không có tệp nào được chọn."];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const Spacer(),
              const Column(
                children: [
                  Text(
                    'HUST',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                  Text(
                    'Nộp bài tập',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  )
                ],
              ),
              const Spacer(),
            ],
          ),
          backgroundColor: QLDTColor.red,
          centerTitle: true,
          toolbarHeight: 115,
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Tiêu đề bài tập
              const Text(
                'Participant Exercise',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              //Mô tả bài tập
              // Trường mô tả
              TextFormField(
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: "Mô tả",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: QLDTColor.red),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(16),
                width: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: selectedFilePaths.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tệp đã chọn:',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    ...selectedFilePaths.map((filePath) => Text(
                      '- $filePath',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black),
                    )),
                  ],
                )
                    : const Text(
                  "Tài liệu đính kèm",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),

              const SizedBox(height: 15),

              //Xem tài liệu và nộp bài
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Tải tài liệu lên
                    ElevatedButton(
                      onPressed: pickFiles,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QLDTColor.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Tải tài liệu lên',
                        style: TextStyle(fontSize: 16, color: QLDTColor.white),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    //Submit
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: QLDTColor.red,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 16,
                          color: QLDTColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}