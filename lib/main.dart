import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ReelScreen(),
    );
  }
}

class ReelData {
  final String url;
  final bool isVideo;
  final String  description;

  ReelData({required this.url, required this.isVideo,required this.description});
}

class ReelScreen extends StatelessWidget {
  final List<ReelData> reels = [
    ReelData(
        description : "Tears of Steel was realized with crowd-funding by users of the open source 3D creation tool Blender. Target was to improve and test a complete open and free pipeline for visual effects in film - and to make a compelling sci-fi film in Amsterdam, the Netherlands.  The film itself, and all raw material used for making it, have been released under the Creatieve Commons 3.0 Attribution license. Visit the tearsofsteel.org website to find out more about this, or to purchase the 4-DVD box with a lot of extras.  (CC) Blender Foundation - http://www.tearsofsteel.org",
        sources :  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4" ,
        subtitle : "By Blender Foundation",
        thumb : "images/TearsOfSteel.jpg",
        title : "Tears of Steel",
      isVideo: true,
    ),
    ReelData(
      url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerJoyrides.jpg',
      isVideo: false,
    ),
    ReelData(
      url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerMeltdowns.jpg',
      isVideo: false,
    ),
    ReelData(
      url: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4',
      isVideo: true,
    ),
    // Add more sample data here if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reels'),
      ),
      body: PageView.builder(
        scrollDirection: Axis.vertical, // Set the scroll direction to vertical
        itemCount: reels.length,
        itemBuilder: (context, index) {
          final reel = reels[index];
          return reel.isVideo
              ? VideoReel(url: reel.url)
              : ImageReel(url: reel.url);
        },
      ),
    );
  }
}

class VideoReel extends StatefulWidget {
  final String url;

  VideoReel({required this.url});

  @override
  _VideoReelState createState() => _VideoReelState();
}

class _VideoReelState extends State<VideoReel> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isPlaying = !_isPlaying;
          if (_isPlaying) {
            _controller.play();
          } else {
            _controller.pause();
          }
        });
      },
      child: Stack(
        children: [
          if (_controller.value.isInitialized)
            Positioned.fill(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
          if (!_isPlaying)
            Center(
              child: Icon(
                Icons.play_arrow,
                size: 50,
                color: Colors.white,
              ),
            ),
          if (!_isPlaying)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
          if (!_isPlaying)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomAppBar(
                color: Colors.transparent,
                elevation: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Your caption goes here', // Add a caption or any overlay content
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


class ImageReel extends StatelessWidget {
  final String url;

  ImageReel({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      height: 300,
    );
  }
}
