import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/presentation/page/auth/signup/signup_provider.dart';
import 'package:qldt/presentation/theme/color_style.dart';




class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    var authRepo = Provider.of<AuthRepository>(context);
    return ChangeNotifierProvider(
        create: (context) => SignUpProvider(authRepo),
        child: SignUpPageInner(),
    );
  }
}

class SignUpPageInner extends StatefulWidget {
  const SignUpPageInner({super.key});

  @override
  State<SignUpPageInner> createState() => _SignUpPageInnerState();
}

class _SignUpPageInnerState extends State<SignUpPageInner> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  String? _selectedRole;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In"),
      ),
      backgroundColor: QLDTColor.red,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Đăng ký tài khoản để sử dụng QLĐT",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Họ',
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Tên',
                        labelStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // TextFormField(
              //   readOnly: true,
              //   style: const TextStyle(color: Colors.white),
              //   decoration: InputDecoration(
              //     labelText: 'Ngày/tháng/năm sinh',
              //     labelStyle: const TextStyle(color: Colors.white),
              //     prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(24),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(24),
              //     ),
              //   ),
              //   controller: TextEditingController(
              //     text: _selectedDate != null ? _dateFormatter.format(_selectedDate!) : '',
              //   ),
              //   onTap: () async {
              //     DateTime? pickedDate = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime(1900),
              //       lastDate: DateTime.now(),
              //     );
              //     if (pickedDate != null) {
              //       setState(() {
              //         _selectedDate = pickedDate;
              //       });
              //     }
              //   },
              // ),
              // const SizedBox(height: 16),

              // TextFormField(
              //   controller: _classController,
              //   style: const TextStyle(color: Colors.white),
              //   decoration: InputDecoration(
              //     labelText: 'Lớp/Cơ quan',
              //     labelStyle: const TextStyle(color: Colors.white),
              //     prefixIcon: const Icon(Icons.public, color: Colors.white),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(24),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(24),
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text(
                  'Vai trò đăng ký',
                  style: TextStyle(color: Colors.white),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'LECTURE',
                    child: Text('LECTURE', style: TextStyle(color: Colors.black)),
                  ),
                  DropdownMenuItem(
                    value: 'STUDENT',
                    child: Text('STUDENT', style: TextStyle(color: Colors.black)),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  prefixIcon: const Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),

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
              // const SizedBox(height: 16),

              // TextFormField(
              //   controller: _idController,
              //   style: const TextStyle(color: Colors.white),
              //   decoration: InputDecoration(
              //     labelText: 'MSSV/MSCB',
              //     labelStyle: const TextStyle(color: Colors.white),
              //     prefixIcon: const Icon(Icons.confirmation_number, color: Colors.white),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(24),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: const BorderSide(color: Colors.white),
              //       borderRadius: BorderRadius.circular(24),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Mật khẩu',
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
              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController2,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Xác nhận mật khẩu',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword2 ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword2 = !_obscurePassword2;
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

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String lastName = _lastNameController.text;
                  String firstName = _firstNameController.text;
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String uuid = "12345";
                  String role = _selectedRole!;
                  Provider.of<SignUpProvider>(context, listen: false).requestSignUp(firstName, lastName, email, password, uuid, role);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Đăng ký',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFFAE2C2C),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/SignInPage');
                  },
                  child: const Text(
                    'Đã có tải khoản: Đăng nhập',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      decoration:
                      TextDecoration.underline,
                      decorationColor: Colors.white,
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
