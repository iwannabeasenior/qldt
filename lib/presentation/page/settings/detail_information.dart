import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailInformation extends StatefulWidget {
  const DetailInformation({super.key});

  @override
  State<DetailInformation> createState() => _DetailInformationState();
}

class _DetailInformationState extends State<DetailInformation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              child: Row(
                children: [
                  GestureDetector(
                    child: Icon(Icons.arrow_back, color: Colors.white,),
                    onTap: (){
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
          body: Placeholder(),
        )
    );
  }
}
