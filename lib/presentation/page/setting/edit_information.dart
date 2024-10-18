// import 'package:flutter/material.dart';
// import 'package:qldt/data/model/fake_data.dart';
//
// class EditInformation extends StatefulWidget {
//   const EditInformation({super.key});
//
//   @override
//   State<EditInformation> createState() => _EditInformationState();
// }
//
// class _EditInformationState extends State<EditInformation> {
//   final _formKey = GlobalKey<FormState>();
//
//   // Controllers cho các trường nhập liệu
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController linkController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//   final TextEditingController countryController = TextEditingController();
//   final TextEditingController coinsController = TextEditingController();
//   final TextEditingController friendsController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Nạp dữ liệu giả lập vào các controller khi khởi tạo
//     usernameController.text = FakeData.username;
//     descriptionController.text = FakeData.description;
//     addressController.text = FakeData.address;
//     linkController.text = FakeData.link;
//     cityController.text = FakeData.city;
//     countryController.text = FakeData.country;
//     coinsController.text = FakeData.coins.toString();
//     friendsController.text = FakeData.friends.toString();
//   }
//
//   @override
//   void dispose() {
//     // Giải phóng bộ nhớ cho các controller khi không cần thiết nữa
//     usernameController.dispose();
//     descriptionController.dispose();
//     addressController.dispose();
//     linkController.dispose();
//     cityController.dispose();
//     countryController.dispose();
//     super.dispose();
//   }
//
//   // Hàm cập nhật dữ liệu khi người dùng nhấn nút hoàn thành
//   void updateData() {
//     FakeData.username = usernameController.text;
//     FakeData.description = descriptionController.text;
//     FakeData.address = addressController.text;
//     FakeData.link = linkController.text;
//     FakeData.city = cityController.text;
//     FakeData.country = countryController.text;
//
//     // Hiển thị thông báo
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Dữ liệu đã được cập nhật')),
//     );
//   }
//
//   // Hàm làm mới form
//   void resetForm() {
//     usernameController.text = FakeData.username;
//     descriptionController.text = FakeData.description;
//     addressController.text = FakeData.address;
//     linkController.text = FakeData.link;
//     cityController.text = FakeData.city;
//     countryController.text = FakeData.country;
//
//     // Cập nhật lại giao diện
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Column(
//           children: [
//             Text(
//               'HUST',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 35,
//               ),
//             ),
//             Text(
//               'Chỉnh sửa',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 25,
//               ),
//             )
//           ],
//         ),
//         backgroundColor: const Color(0xffAE2C2C),
//         centerTitle: true,
//         toolbarHeight: 115,
//         automaticallyImplyLeading: false,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Center(
//                   child: Stack(
//                     alignment: Alignment.bottomCenter,
//                     children: [
//                       const CircleAvatar(
//                         radius: 80,
//                         backgroundImage: NetworkImage(
//                           'https://example.com/your-avatar-url.jpg',
//                         ),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Logic chuyển hướng
//                           Navigator.pushNamed(context, '');
//                         },
//                         style: ElevatedButton.styleFrom(
//                           shape: StadiumBorder(),
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text('Chỉnh sửa'),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 20),
//
//                 // Trường Username
//                 TextFormField(
//                   enabled: false,
//                   controller: usernameController,
//                   decoration: InputDecoration(labelText: 'Username'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Vui lòng nhập username';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 10),
//
//                 // Trường Description
//                 TextFormField(
//                   enabled: false,
//                   controller: descriptionController,
//                   decoration: InputDecoration(labelText: 'Description'),
//                 ),
//                 SizedBox(height: 10),
//
//                 // Trường Address
//                 TextFormField(
//                   enabled: false,
//                   controller: addressController,
//                   decoration: InputDecoration(labelText: 'Address'),
//                 ),
//                 SizedBox(height: 10),
//
//                 // Trường Link
//                 TextFormField(
//                   enabled: false,
//                   controller: linkController,
//                   decoration: InputDecoration(labelText: 'Link'),
//                 ),
//                 SizedBox(height: 10),
//
//                 // Trường City và Country
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         enabled: false,
//                         controller: cityController,
//                         decoration: InputDecoration(labelText: 'City'),
//                       ),
//                     ),
//                     SizedBox(width: 10),
//                     Expanded(
//                       child: TextFormField(
//                         enabled: false,
//                         controller: countryController,
//                         decoration: InputDecoration(labelText: 'Country'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 50),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() == true) {
//                       updateData();  // Cập nhật dữ liệu
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                   child: Text('Hoàn thành'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }