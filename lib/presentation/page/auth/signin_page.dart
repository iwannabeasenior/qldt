import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
        
              TextFormField(
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
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                obscureText: _obscurePassword, // Ẩn mật khẩu
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện khi nhấn nút đăng nhập
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  Navigator.pushNamed(context, '/HomePage');
                  // In ra thông tin đăng nhập (có thể thay bằng logic đăng nhập thực tế)
                  print('Email: $email');
                  print('Password: $password');
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
        
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/ForgotPassword');
                  },
                  child: const Text(
                    'Quên mật khẩu?',
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
}
