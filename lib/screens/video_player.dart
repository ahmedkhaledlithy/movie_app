import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatefulWidget {

 final YoutubePlayerController controller;
 VideoPlayerScreen({@required this.controller});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState(controller);
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {

  final YoutubePlayerController controller;
  _VideoPlayerScreenState( this.controller);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: YoutubePlayer(
              controller: controller,
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: IconButton(icon: Icon(EvaIcons.closeCircle,color: Colors.white,), onPressed: (){
              Navigator.pop(context);
            }),
          ),
        ],
      ),
    );
  }
}
