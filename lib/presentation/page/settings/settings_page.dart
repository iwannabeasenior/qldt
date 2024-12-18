import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qldt/presentation/page/settings/settings_provider.dart';
import 'package:qldt/presentation/page/settings/user_info/user_detail_page.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Column(
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
                'Cài đặt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              )
            ],
          ),
          backgroundColor: const Color(0xffAE2C2C),
          centerTitle: true,
          toolbarHeight: 115,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            //SHARED
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chung',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  //Detai Information
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserDetailPage()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.person,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: Center(
                            child: Text(
                              'Chỉnh sửa thông tin cá nhân',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Version Infor
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/VersionInfoPage");
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.info,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: Center(
                            child: Text(
                              'Thông tin phiên bản mới',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Language
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/LanguagePage");
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.language,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: Center(
                            child: Text(
                              'Ngôn ngữ',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  //Change Password
                  GestureDetector(
                    onTap: _showChangePasswordDialog,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: Center(
                            child: Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
              width: double.infinity,
              child: Divider(),
            ),

            //ABOUT
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/AboutAppPage");
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.info,
                          size: 25,
                          color: Color(0xff078CD6),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 280,
                          child: Center(
                            child: Text(
                              'About App',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 25,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 2,
              width: double.infinity,
              child: Divider(),
            ),

            //Logout
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              child: GestureDetector(
                onTap: _showLogoutConfirmDialog,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.logout,
                      size: 25,
                      color: Color(0xffAE2C2C),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 280,
                      child: Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 25,
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  //Logout Dialog
  void _showLogoutConfirmDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Xác nhận"),
            content: const Text("Bạn có chắc muốn đăng xuất?"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushNamed(context, "/LoginPage");
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red,
                ),
                child: const Text("Đồng ý"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.grey,
                ),
                child: const Text("Hủy"),
              ),
            ],
          );
        });
  }

  //Change Password Dialog
  // Thêm phương thức mới
  void _showChangePasswordDialog() {
    final TextEditingController oldPasswordController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đổi mật khẩu"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Mật khẩu cũ",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Mật khẩu mới",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Nhập lại mật khẩu mới",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String oldPassword = oldPasswordController.text.trim();
                String newPassword = newPasswordController.text.trim();
                String confirmPassword = confirmPasswordController.text.trim();

                if (oldPassword.isEmpty ||
                    newPassword.isEmpty ||
                    confirmPassword.isEmpty) {
                  showOverlayFillout(context, "BLANK");
                } else if (newPassword != confirmPassword) {
                  showOverlayFillout(context, "MISMATCH");
                } else if (newPassword == oldPassword) {
                  showOverlayFillout(context, "DUPLICATE");
                } else {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const Center(child: CircularProgressIndicator());
                    },
                  );

                  final settingsProvider =
                      Provider.of<SettingsProvider>(context, listen: false);
                  await settingsProvider.changePassword(
                    UserPreferences.getToken() ?? "",
                    oldPassword,
                    newPassword,
                  );

                  Navigator.of(context).pop(); // Đóng Loading Indicator

                  if (settingsProvider.isSuccess) {
                    Navigator.of(context).pop(); // Đóng Dialog
                    showOverlayFillout(context, "SUCCESS");
                  } else {
                    showOverlayFillout(context, "ERROR");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              child: const Text("Xác nhận"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
              child: const Text("Hủy"),
            ),
          ],
        );
      },
    );
  }

  void showOverlayFillout(BuildContext context, String type) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).size.height * 0.15,
        left: MediaQuery.of(context).size.width * 0.12,
        right: MediaQuery.of(context).size.width * 0.12,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: QLDTColor.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10),
              ],
            ),
            child: type == "BLANK"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.yellow,
                      ),
                      Text(
                        "Vui lòng điền đầy đủ thông tin!",
                        style: TextStyle(color: QLDTColor.lightBlack),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                : type == "SUCCESS"
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.check_box_outlined,
                            color: Colors.green,
                          ),
                          Text(
                            "Đổi mật khẩu thành công!",
                            style: TextStyle(color: QLDTColor.lightBlack),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : type == "MISMATCH"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.yellow,
                              ),
                              Text(
                                "Mật khẩu mới không trùng nhau!",
                                style: TextStyle(color: QLDTColor.lightBlack),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          )
                        : type == "DUPLICATE"
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    "Mật khẩu mới trùng mật khẩu cũ!",
                                    style:
                                        TextStyle(color: QLDTColor.lightBlack),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
