// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:qldt/presentation/theme/color_style.dart';
//
// class CameraScreen extends StatefulWidget {
//   const CameraScreen({super.key, required this.camera});
//   final CameraDescription camera;
//   @override
//   State<CameraScreen> createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initialControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = CameraController(widget.camera, ResolutionPreset.medium);
//     _initialControllerFuture = _controller.initialize();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a picture'),),
//       body: FutureBuilder(
//           future: _initialControllerFuture.then((_) {
//
//           }).catchError((e) {
//             if (e is CameraException) {
//               switch(e.code) {
//                 case 'CameraAccessDenied':
//                   // dialog popup => ask do you want to ...permission
//                   break;
//                 default:
//                   break;
//               }
//             }
//           }),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return Column(
//                 children: [
//                   CameraPreview(_controller),
//                   IconButton(
//                       onPressed: () {
//                         _controller.takePicture()
//                             .then((value) {
//                               Logger().d("path is: ${value.path}");
//                               File fileSaver = File(value.path);
//                               // save to gallery
//
//                             })
//                               .catchError((e) => Logger().e(e));
//                       },
//                       icon: Icon(Icons.circle, size: 80, color: QLDTColor.green,)
//                   )
//                 ],
//               );
//             } else {
//               return const Center(child: CircularProgressIndicator());
//             }
//           }
//       )
//     );
//   }
// }
