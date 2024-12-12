import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/presentation/page/settings/user_info/user_provider.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late TextEditingController _firstnameController = TextEditingController();
  late TextEditingController _lastnameController = TextEditingController();
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _avatarController = TextEditingController();
  // final _formKey = GlobalKey<FormState>();
  // late final String token;
  // late final String userId;
  // Chọn ảnh đại diện
  Future<void> pickAvatar() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        _avatarController.text = File(result.files.single.path!).toString();
      });
    } else {
      // User canceled the picker
    }
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) =>
            UserProvider(Provider.of<AuthRepository>(context, listen: false)),
        builder: (context, _) {
          return Consumer<UserProvider>(builder: (context, controller, _) {
            if (!controller.isLoadUserData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                userProvider.getUserInfo(userProvider.token!, userProvider.userId!);
                userProvider.addListener(() {
                  if (userProvider.user != null) {
                    setState(() {
                      _firstnameController.text =
                          userProvider.user!.firstName ?? "";
                      _lastnameController.text =
                          userProvider.user!.lastName ?? "";
                      _emailController.text = userProvider.user!.email ?? "";
                      _avatarController.text = userProvider.user!.avatar ?? "";
                    });
                  }
                });
                controller.setLoadUserData = false;
              });
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
                          'Thông tin sinh viên',
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
                                    _avatarController.text,
                                    width: 160,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
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
                          // controller: _emailController,
                          initialValue: "thanhxxx@hust.edu.vn",
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
                                // controller: _firstnameController,
                                initialValue: "Nguyen",
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
                                // controller: _lastnameController,
                                initialValue: "Trung Thanh",
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
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }
}
