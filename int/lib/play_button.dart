import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToneButton(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ToneButton extends StatefulWidget {
  const ToneButton({super.key}); // 

  @override
  State<ToneButton> createState() => _ToneButtonState(); // 
}

class _ToneButtonState extends State<ToneButton> {
  final AudioPlayer _player = AudioPlayer();

  void _playTone() async {
    await _player.play(AssetSource('432.wav'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          onPressed: _playTone,
          child: const Text("Play 440 Hz Tone"),
        ),
      ),
    );
  }
}