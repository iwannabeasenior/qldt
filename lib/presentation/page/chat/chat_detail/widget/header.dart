import 'package:flutter/material.dart';

import '../../../../theme/color_style.dart';
import '../../chat_page.dart';

class Header extends StatelessWidget {
  final Conversation conversation;
  const Header({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), bottomLeft: Radius.circular(30))
        ),
        padding: const EdgeInsets.only(left: 16, top: 16, bottom: 16),
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.chevron_left, size: 30), onPressed: () {
              Navigator.pop(context);
            },),
            const SizedBox(width: 20),
            CircleAvatar(
                radius: 26,
                child: conversation.partnerAvatar != null
                    ? ClipOval(
                  child: Image.network(
                    fit: BoxFit.cover,
                    height: 52,
                    width: 52,
                    // convertToDirectLink(conversation.partnerAvatar!),
                    "https://th.bing.com/th/id/R.78a13c9eb31108addb76f77ada4589ff?rik=b%2fIodCIvyGbxCA&riu=http%3a%2f%2ffiles.all-free-download.com%2fdownloadfiles%2fwallpapers%2f1920_1080%2fpeaceful_lake_wallpaper_landscape_nature_1208.jpg&ehk=6EYMLnN48Cs4mGNjCqvvjwaPz6MF2KRLIUOhJG57Z8g%3d&risl=&pid=ImgRaw&r=0",
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('Failed to load image');
                    },),
                )
                    : Image.asset("assets/images/default.jpg")
            ),
            const SizedBox(width: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween ,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(conversation.partnerName, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                Text("Online", style: TextStyle(fontSize: 14, color: QLDTColor.green))
              ],
            )
          ],
        )
    );
  }
}
