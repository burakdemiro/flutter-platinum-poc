import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:scratcher/scratcher.dart';

void main() {
  runApp(MaterialApp(home: SplashVideo()));
}

class SplashVideo extends StatefulWidget {
  SplashVideo() : super();

  @override
  SplashVideoState createState() => SplashVideoState();
}

class SplashVideoState extends State<SplashVideo> {
  bool _isVideoComplete = false;

  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  Scratcher scratcherWater;
  Image imageWaterBg =
      Image(image: AssetImage('images/bg_water.jpg'), fit: BoxFit.fill);

  @override
  void initState() {
    _controller = VideoPlayerController.asset('videos/bosphorus.mp4');
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setVolume(0.0);

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isVideoComplete = true;
        });
      }
    });

    scratcherWater = getScratcherSplash();

    _controller.play();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        appBar: AppBar(
          title: Text("Flutter Platinum"),
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: imageWaterBg,
            ),
            Container(
                width: double.infinity,
                height: double.infinity,
                child: _isVideoComplete == false
                    ? getFutureSplashVideo()
                    : scratcherWater)
          ],
        ));
    return MaterialApp(home: scaffold);
  }

  FutureBuilder<void> getFutureSplashVideo() {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Scratcher getScratcherSplash() {
    return Scratcher(
        brushSize: 30,
        threshold: 30,
        accuracy: ScratchAccuracy.low,
        image: imageWaterBg,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
                child: Text(
              "TURKCELL PLATINUM\nBOSPHORUS CUP\nHEYECANI BAŞLIYOR.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: Colors.white,
              ),
            )),
            color: Color.fromARGB(255, 52, 72, 92)),
        onThreshold: () => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomeRoute()))
            });
  }
}

class HomeRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: Center(child: Text('Hello Platinum')),
    );
  }
}
