import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/presentation/page/auth/login/login_provider.dart';
import 'package:qldt/presentation/pref/user_preferences.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final deviceId = 123;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => LoginProvider(Provider.of<AuthRepository>(context, listen: false)),
        //child can not use this value of provider, only builder
        builder: (context, _) {
          return Consumer<LoginProvider>(
            builder: (context, controller, _) {
              if (controller.isLoginSuccess) {
                WidgetsBinding.instance.addPostFrameCallback( (_) {
                    Navigator.pushNamed(context, '/HomePage');
                    controller.setLoginState = false;
                  }
                );
              }
              if (controller.errorMessage != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(controller.errorMessage!),
                      backgroundColor: Colors.red,
                    ),
                  );
                  controller.clearError(); // Reset trạng thái lỗi
                });
              }

              return Scaffold(
                backgroundColor: const Color(0xFFAE2C2C), // Màu nền nhẹ nhàng

                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Image.asset("assets/title.png"),
                        const Text(
                          "Đăng nhập với tài khoản QLĐT",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(color: Colors.white),
                                  prefixIcon: const Icon(Icons.email, color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  errorBorder:  OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.white,
                                  )
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your email';
                                  }
                                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },

                              ),
                              const SizedBox(height: 16),

                              TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter your password';
                                  }
                                  return null;
                                },
                                controller: _passwordController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(color: Colors.white),
                                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  errorBorder:  OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  errorStyle: TextStyle(
                                    color: Colors.white
                                  )
                                ),
                                obscureText: _obscurePassword, // Ẩn mật khẩu
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            // Xử lý sự kiện khi nhấn nút đăng nhập
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            // if (!_formKey.currentState!.validate()) {
                            //   return;
                            // }
                            controller.login(email, password, deviceId, UserPreferences.getFCMToken());
                            // In ra thông tin đăng nhập (có thể thay bằng logic đăng nhập thực tế)
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 80, vertical: 16), // Kích thước nút
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Bo góc nút
                            ),
                          ),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFFAE2C2C), // Màu chữ nút
                            ),
                          ),
                        ),
                        const SizedBox(height: 24), // Khoảng cách trước nút đăng nhập

                        // Align(
                        //   alignment: Alignment.center,
                        //   child: InkWell(
                        //     onTap: () {
                        //       Navigator.pushNamed(context, '/ForgotPassword');
                        //     },
                        //     child: const Text(
                        //       'Quên mật khẩu?',
                        //       style: TextStyle(
                        //         fontSize: 18,
                        //         color: Colors.white, // Màu chữ trắng cho liên kết
                        //         decoration:
                        //             TextDecoration.underline, // Thêm gạch chân cho liên kết
                        //         decorationColor: Colors.white, // Màu gạch chân trắng
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        const SizedBox(height: 24), // Khoảng cách trước nút đăng nhập

                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/SignUpPage');
                            },
                            child: const Text(
                              'Chưa có tải khoản: Đăng ký',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white, // Màu chữ trắng cho liên kết
                                decoration:
                                    TextDecoration.underline, // Thêm gạch chân cho liên kết
                                decorationColor: Colors.white, // Màu gạch chân trắng
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
      }
    );
  }
}
