import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/presentation/page/settings/user_info/user_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  // Chọn ảnh đại diện
  Future<void> pickAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() {
      });
    } else {
      // User canceled the picker
    }
  }
  @override
  void initState() {
    Logger().d("user id is ${UserPreferences.getToken()} and token: ${UserPreferences.getId()}");
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getUserInfo(UserPreferences.getToken() ?? "", UserPreferences.getId() ?? "");
    });
  }
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    if (userProvider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
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
            Column(
              children: [
                const Text(
                  'HUST',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                  ),
                ),
                userProvider.user.role == "STUDENT"
                  ? const Text(
                  'Thông tin sinh viên',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                )
                  : const Text(
                  'Thông tin giảng viên',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
        backgroundColor: const Color(0xffAE2C2C),
        centerTitle: true,
        toolbarHeight: 115,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.network(
                            convertGoogleDriveUrl(userProvider.user.avatar ?? ""),
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              Logger().d(userProvider.user.avatar);
                              // Hiển thị ảnh mặc định nếu ảnh từ URL không tải được
                              return Image.asset(
                                'assets/images/default.jpg',
                                // Đường dẫn tới ảnh mặc định
                                width: 160,
                                height: 160,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: pickAvatar,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Đổi Avatar"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                // Trường Email
                TextFormField(
                  enabled: false,
                  initialValue: userProvider.user.email,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    label: Text(
                      "Email",
                      style: TextStyle(
                        color: QLDTColor.lightBlack,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                        color: QLDTColor.lightBlack,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Trường Họ và Tên
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        initialValue: userProvider.user.firstName,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                            "Họ",
                            style: TextStyle(
                              color: QLDTColor.lightBlack,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: QLDTColor.lightBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        initialValue: userProvider.user.lastName,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          label: Text(
                            "Tên",
                            style: TextStyle(
                              color: QLDTColor.lightBlack,
                            ),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: QLDTColor.lightBlack,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String convertGoogleDriveUrl(String url) {
    final fileIdRegExp = RegExp(r'd/([a-zA-Z0-9_-]+)');
    final match = fileIdRegExp.firstMatch(url);
    if (match != null) {
      final fileId = match.group(1);
      return 'https://drive.google.com/uc?export=view&id=$fileId';
    }
    return url;
  }
}
