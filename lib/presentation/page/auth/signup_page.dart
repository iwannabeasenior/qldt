import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qldt/presentation/theme/color_style.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _idController = TextEditingController();

  String? _selectedRole;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;


  DateTime? _selectedDate;
  final DateFormat _dateFormatter = DateFormat('dd/MM/yyyy');

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
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Họ và Tên',
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
              const SizedBox(height: 16),
        
              TextFormField(
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Ngày/tháng/năm sinh',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                controller: TextEditingController(
                  text: _selectedDate != null ? _dateFormatter.format(_selectedDate!) : '',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
        
              TextFormField(
                controller: _classController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Lớp/Cơ quan',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.public, color: Colors.white),
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
              const SizedBox(height: 16),
        
              DropdownButtonFormField<String>(
                value: _selectedRole,
                hint: const Text(
                  'Vai trò đăng ký',
                  style: TextStyle(color: Colors.white),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Giảng viên',
                    child: Text('Giảng viên', style: TextStyle(color: Colors.black)),
                  ),
                  DropdownMenuItem(
                    value: 'Sinh viên',
                    child: Text('Sinh viên', style: TextStyle(color: Colors.black)),
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
              const SizedBox(height: 16),
        
              TextFormField(
                controller: _idController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'MSSV/MSCB',
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.confirmation_number, color: Colors.white),
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
                  String email = _emailController.text;
                  String password = _passwordController.text;
                  String name = _nameController.text;
                  String dob = _selectedDate != null ? _dateFormatter.format(_selectedDate!) : '';
                  String className = _classController.text;
                  String id = _idController.text;
        
                  print('Họ tên: $name');
                  print('Email: $email');
                  print('lớp/cơ quan: $className');
                  print('ngày sinh $dob');
                  print('Password: $password');
                  print('id: $id');
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
