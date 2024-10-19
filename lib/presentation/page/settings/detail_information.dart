import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FakeData {
  String username = "Nguyen Huy Hoang";
  String code = "20211012";
  String description = "abcxyz";
  String address = "Hanoi";
  String link = "fb.com";
  String city = "Vinh";
  String country = "Vietnam";
  int coins = 10000;
  int friend = 25;
}

class DetailInformation extends StatefulWidget {
  const DetailInformation({super.key});

  @override
  State<DetailInformation> createState() => _DetailInformationState();
}

class _DetailInformationState extends State<DetailInformation> {
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
  final TextEditingController friendsController = TextEditingController();

  // Khởi tạo dữ liệu cho Fake Data
  final fakeData = FakeData();

  // Gán dữ liệu
  @override
  void initState() {
    super.initState();
    usernameController.text = fakeData.username;
    codeController.text = fakeData.code;
    descriptionController.text = fakeData.description;
    addressController.text = fakeData.address;
    linkController.text = fakeData.link;
    cityController.text = fakeData.city;
    countryController.text = fakeData.country;
    coinsController.text = fakeData.coins.toString();
    friendsController.text = fakeData.friend.toString();
  }

  @override
  Widget build(BuildContext context) {

  return SafeArea(
    child: Scaffold(
      appBar: AppBar(
        title: Container(
          child: Row(
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
                          // Logic chuyển hướng
                          Navigator.pushNamed(context, '/EditInformation');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: StadiumBorder(),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Chỉnh sửa'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Trường Username
                TextFormField(
                  enabled: false,
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),

                // Trường Description
                TextFormField(
                  enabled: false,
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 10),

                // Trường Address
                TextFormField(
                  enabled: false,
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                SizedBox(height: 10),

                // Trường Link
                TextFormField(
                  enabled: false,
                  controller: linkController,
                  decoration: InputDecoration(labelText: 'Link'),
                ),
                SizedBox(height: 10),

                // Trường City và Country
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        controller: cityController,
                        decoration: InputDecoration(labelText: 'City'),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        controller: countryController,
                        decoration: InputDecoration(labelText: 'Country'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50)
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
