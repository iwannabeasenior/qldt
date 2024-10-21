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
  final TextEditingController codeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController coinsController = TextEditingController();
  final TextEditingController friendController = TextEditingController();

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
        code: _temporaryData.code,
        description: descriptionController.text,
        address: addressController.text,
        link: linkController.text,
        city: cityController.text,
        country: countryController.text,
        coins: _temporaryData.coins,
        friend: _temporaryData.friend,
      );

      // Cập nhật trạng thái nút Hoàn thành sau khi nạp dữ liệu
      _checkIfDataChanged();
    });
  }

  // Kiểm tra xem dữ liệu có thay đổi so với dữ liệu mặc định không
  void _checkIfDataChanged() {
    setState(() {
      _isButtonEnabled = usernameController.text != _temporaryData.username ||
          descriptionController.text != _temporaryData.description ||
          addressController.text != _temporaryData.address ||
          linkController.text != _temporaryData.link ||
          cityController.text != _temporaryData.city ||
          countryController.text != _temporaryData.country;
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
    // Nạp dữ liệu và thiết lập sự kiện cho các controller
    _loadData();
    usernameController.addListener(_onTextFieldChanged);
    descriptionController.addListener(_onTextFieldChanged);
    addressController.addListener(_onTextFieldChanged);
    linkController.addListener(_onTextFieldChanged);
    cityController.addListener(_onTextFieldChanged);
    countryController.addListener(_onTextFieldChanged);
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ cho các controller
    usernameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    linkController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void _onTextFieldChanged() {
    // Cập nhật trạng thái của nút Hoàn thành khi có sự thay đổi trong các TextField
    _checkIfDataChanged();
  }

  void _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // Ẩn bàn phím khi bấm nút Hoàn thành
      FocusScope.of(context).unfocus();

      // Lưu dữ liệu tạm trước khi lưu vào shared_preferences
      setState(() {
        _temporaryData = Student(
          username: usernameController.text,
          code: _temporaryData.code,
          description: descriptionController.text,
          address: addressController.text,
          link: linkController.text,
          city: cityController.text,
          country: countryController.text,
          coins: _temporaryData.coins,
          friend: _temporaryData.friend,
        );
      });

      await _saveData();

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thông tin đã được lưu thành công!')),
      );

      // Sau khi lưu xong, nút hoàn thành sẽ chuyển sang trạng thái màu xám
      setState(() {
        _isButtonEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Thêm GestureDetector để tap ngoài TextField sẽ ẩn bàn phím
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
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
                          CircleAvatar(
                            radius: 80,
                            backgroundImage: const NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTb7w9NmAGMYRiEzXYPexJmQ3z-xmQAg7cRRg&s',
                            ),
                            onBackgroundImageError: (_, __) => Icon(Icons.error),  // Xử lý khi lỗi tải ảnh
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

                    // Các TextFormField với thêm validation
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa chỉ';
                        }
                        return null;
                      },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập thành phố';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: countryController,
                            decoration: const InputDecoration(labelText: 'Country'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui lòng nhập quốc gia';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),

                    // Nút Hoàn thành
                    ElevatedButton(
                      onPressed: _isButtonEnabled ? _onSubmit : null, // Vô hiệu hóa nút nếu không có thay đổi
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 14,
                        ),
                        shape: const StadiumBorder(),
                        backgroundColor: _isButtonEnabled ? Colors.green : Colors.grey,  // Đổi màu khi vô hiệu hóa
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Hoàn thành'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
