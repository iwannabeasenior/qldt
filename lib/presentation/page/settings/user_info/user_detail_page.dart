import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:qldt/data/request/files_request.dart';
import 'package:qldt/presentation/page/settings/user_info/user_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class UserDetailPage extends StatefulWidget {
  const UserDetailPage({super.key});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  FileRequest? _avatar;
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        // Đọc dữ liệu dưới dạng bytes
        final Uint8List fileData = await pickedFile.readAsBytes();

        // Tạo PlatformFile
        PlatformFile platformFile = PlatformFile(
          name: pickedFile.name,
          size: fileData.length,
          bytes: fileData,
        );

        setState(() {
          _imageBytes = fileData;
          _avatar = FileRequest(fileData: fileData, file: platformFile);
        });
      } else {
        Logger().d('Người dùng không chọn ảnh.');
      }
    } catch (e) {
      Logger().e('Lỗi khi đọc file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().getUserInfo(
          UserPreferences.getToken() ?? "", UserPreferences.getId() ?? "");
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
                          child: _imageBytes != null
                              ? Image.memory(
                                  _imageBytes!,
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  userProvider.user.avatar!.split('?')[0],
                                  width: 160,
                                  height: 160,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/images/default.jpg',
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _pickImage,
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
                _avatar != null ? ElevatedButton(
                    onPressed: () async {
                      try {
                        await userProvider.changeInfoAfterSignup(
                            UserPreferences.getToken() ?? "",
                            _avatar!
                        );
                        setState(() {
                          //Cập nhật laị api mới ở đây
                          _avatar = null;
                        });
                      } catch (e) {
                        Logger().e(e);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green
                    ),
                    child: const Text('Lưu'),
                ) : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
