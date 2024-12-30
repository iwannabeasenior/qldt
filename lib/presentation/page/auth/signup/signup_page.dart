import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:qldt/data/repo/auth_repository.dart';
import 'package:qldt/presentation/page/auth/signup/signup_provider.dart';
import 'package:qldt/presentation/theme/color_style.dart';




class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  String? _selectedRole;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var authRepo = Provider.of<AuthRepository>(context);
    return ChangeNotifierProvider(
      create: (context) => SignUpProvider(authRepo),
      child: Consumer<SignUpProvider>(
        builder: (context, signupProvider, _) {
          if (signupProvider.isSignupSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushNamed(context, '/LoginPage');
              signupProvider.setSignupState = false;
            });
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text("Sign In"),
            ),
            backgroundColor: QLDTColor.red,

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter your first name';
                                }
                              },
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
                            ),
                          ),
                          Expanded(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter your last name';
                                }
                              },
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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please pick a role';
                          }
                          return null;
                        },
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
                          errorBorder:  OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          prefixIcon: const Icon(Icons.person, color: Colors.white),
                          errorStyle: TextStyle(

                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Plese Enter your email';
                          }
                          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
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
                              color: Colors.white
                          )

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
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your password';
                          }
                          return null;
                        },
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
                      const SizedBox(height: 16),

                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your password';
                          }
                          return null;
                        },
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

                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          String lastName = _lastNameController.text;
                          String firstName = _firstNameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          String uuid = "12345";
                          String role = _selectedRole!;

                          signupProvider.requestSignUp(firstName, lastName, email, password, uuid, role).then((success) {
                            if (success) {
                              // If signup was successful, pop the page (go back)
                              Navigator.pop(context);
                            } else {

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Đăng ký thất bại"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              // Handle any signup failure (optional)
                              // You might want to show an error message here
                            }
                          });
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
                            Navigator.pop(context);
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
            ),
          );
        }
      ),
    );
  }
}
