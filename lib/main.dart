import 'dart:math';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(
    MaterialApp(
      title: 'Ball',
      debugShowCheckedModeBanner: false,
      home: BallPage(),
    ),
  );
}

class BallPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          'Ask Me Anything!',
          style: TextStyle(fontSize: 30),
        ),
      ),
      body: Center(
        child: Ball(),
      ),
    );
  }
}

class Ball extends StatefulWidget {
  Ball({Key? key}) : super(key: key);

  @override
  _BallState createState() => _BallState();
}

class _BallState extends State<Ball> {
  int ballNumber = 1;
  int imagesTotal = 5;
  List<Image> images = [];
  String voice = '';
  bool thinking = false;

  void changeBallNumber() async {
    int number = Random().nextInt(imagesTotal);

    setState(() {
      thinking = true;
    });

    await recordVoice();

    await ballThinking();

    setState(() {
      ballNumber = number;
      thinking = false;
    });
  }

  Future<dynamic> recordVoice() async {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize();
    if (available) {
      speech.listen(onResult: (result) {
        setState(() {
          voice = result.recognizedWords;
          print(result.recognizedWords);
        });
      });
    } else {
      setState(() {
        voice = "The user has denied the use of speech recognition.";
      });
    }
    // some time later...
    speech.stop();
  }

  Future<int> ballThinking() async {
    int seconds = Random().nextInt(4) + 1;
    return Future.delayed(Duration(seconds: seconds), () => seconds);
  }

  @override
  void initState() {
    for (int i = 0; i < imagesTotal; i++) {
      images.add(Image.asset('assets/images/ball${i + 1}.png'));
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    images.forEach((photo) {
      precacheImage(photo.image, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        thinking
            ? Column(
                children: [
                  Text(
                    '$voice I am thinking... ',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  LinearProgressIndicator()
                ],
              )
            : SizedBox(height: 40.0),
        Center(
          child: TextButton(
              child: images[ballNumber], onPressed: changeBallNumber),
        ),
      ],
    );
  }
}
