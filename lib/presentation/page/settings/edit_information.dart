import 'package:flutter/material.dart';
import 'package:qldt/data/model/student.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInformation extends StatefulWidget {
  const EditInformation({super.key});

  @override
  State<EditInformation> createState() => _EditInformationState();
}

class _EditInformationState extends State<EditInformation> {
  final _formKey = GlobalKey<FormState>();

  // Controllers cho các trường nhập liệu
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool _isButtonEnabled = false;
  Student _temporaryData = Student.defaultData;  // Biến tạm để lưu dữ liệu trên giao diện

  // Lấy dữ liệu từ shared_preferences hoặc gán dữ liệu mặc định
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      usernameController.text = prefs.getString('username') ?? Student.defaultData.username;
      descriptionController.text = prefs.getString('description') ?? Student.defaultData.description;
      addressController.text = prefs.getString('address') ?? Student.defaultData.address;
      linkController.text = prefs.getString('link') ?? Student.defaultData.link;
      cityController.text = prefs.getString('city') ?? Student.defaultData.city;
      countryController.text = prefs.getString('country') ?? Student.defaultData.country;

      // Cập nhật dữ liệu tạm để dùng trên giao diện
      _temporaryData = Student(
        username: usernameController.text,
        description: descriptionController.text,
        address: addressController.text,
        link: linkController.text,
        city: cityController.text,
        country: countryController.text,
      );
    });
  }

  // Lưu dữ liệu vào shared_preferences
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('description', descriptionController.text);
    await prefs.setString('address', addressController.text);
    await prefs.setString('link', linkController.text);
    await prefs.setString('city', cityController.text);
    await prefs.setString('country', countryController.text);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    usernameController.addListener(_onTextFieldChanged);
    descriptionController.addListener(_onTextFieldChanged);
    addressController.addListener(_onTextFieldChanged);
    linkController.addListener(_onTextFieldChanged);
    cityController.addListener(_onTextFieldChanged);
    countryController.addListener(_onTextFieldChanged);
  }

  void _onTextFieldChanged() {
    // So sánh giá trị hiện tại của TextField với dữ liệu trên giao diện (biến tạm)
    setState(() {
      _isButtonEnabled = usernameController.text != _temporaryData.username ||
          descriptionController.text != _temporaryData.description ||
          addressController.text != _temporaryData.address ||
          linkController.text != _temporaryData.link ||
          cityController.text != _temporaryData.city ||
          countryController.text != _temporaryData.country;
    });
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Lưu dữ liệu vào biến tạm trước khi lưu vào shared_preferences
      setState(() {
        _temporaryData = Student(
          username: usernameController.text,
          description: descriptionController.text,
          address: addressController.text,
          link: linkController.text,
          city: cityController.text,
          country: countryController.text,
        );
      });

      await _saveData();

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông tin đã được lưu thành công!')),
      );

      // Reload lại trang mà vẫn giữ dữ liệu đã thay đổi
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => const EditInformation()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                    'Chỉnh sửa thông tin cá nhân',
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        const CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb7w9NmAGMYRiEzXYPexJmQ3z-xmQAg7cRRg&s',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            shape: const StadiumBorder(),
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Đổi avatar'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Các TextFormField như cũ
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  const SizedBox(height: 10),

                  TextFormField(
                    controller: linkController,
                    decoration: const InputDecoration(labelText: 'Link'),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: cityController,
                          decoration: const InputDecoration(labelText: 'City'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: countryController,
                          decoration: const InputDecoration(labelText: 'Country'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),

                  ElevatedButton(
                    onPressed: _isButtonEnabled ? _onSubmit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isButtonEnabled ? Colors.green : Colors.grey,
                      foregroundColor: _isButtonEnabled ? Colors.white : Colors.blueGrey,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      'Hoàn thành',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
