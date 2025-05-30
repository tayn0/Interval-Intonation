import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class PracticeScreen extends StatefulWidget {
  final String baseNote;
  final String interval;
  final String difficulty;
  final int repetitions;

  const PracticeScreen({
    super.key,
    required this.baseNote,
    required this.interval,
    required this.difficulty,
    required this.repetitions,
  });

  @override
  State<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends State<PracticeScreen> {
  final AudioPlayer player = AudioPlayer();
  int currentRepetition = 0;
  bool isPlaying = false;
  bool canGuess = false;
  String? correctTuning;
  String? rootPath;
  String? intervalPath;
  String feedbackMessage = "";

  final Map<String, int> intervalSemitones = {
    'Major Second': 2,
    'Major Third': 4,
    'Perfect Fourth': 5,
    'Perfect Fifth': 7,
    'Major Sixth': 9,
    'Major Seventh': 11,
    'Octave': 12,
  };

  final Random random = Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => playNext());
  }

  Future<void> playNext() async {
    if (currentRepetition >= widget.repetitions) return;

    setState(() {
      isPlaying = true;
      canGuess = false;
      feedbackMessage = "";
    });

    final detuneOptions = switch (widget.difficulty) {
      'Easy' => ['flat_25', 'in_tune', 'plus_25'],
      'Medium' => ['flat_13', 'in_tune', 'plus_13'],
      'Hard' => ['flat_5', 'in_tune', 'plus_5'],
      _ => ['in_tune']
    };

    correctTuning = detuneOptions[random.nextInt(detuneOptions.length)];

    final midiBase = noteToMidi(widget.baseNote);
    final semitoneOffset = intervalSemitones[widget.interval] ?? 2;
    final midiInterval = midiBase + semitoneOffset;
    final intervalNote = midiToNote(midiInterval);

    final basePath = 'assets/sounds';
    rootPath = '$basePath/${widget.interval}/original/${widget.baseNote}__root.wav';
    intervalPath = '$basePath/${widget.interval}/$correctTuning/${intervalNote}__interval__vs_${widget.baseNote}.wav';

    try {
      await player.play(DeviceFileSource(rootPath!));
      await Future.delayed(const Duration(seconds: 2));
      await player.play(DeviceFileSource(intervalPath!));
    } catch (e) {
      print("Audio playback error: $e");
    }

    setState(() {
      isPlaying = false;
      canGuess = true;
    });
  }

  Future<void> replayAudio() async {
    if (isPlaying || rootPath == null || intervalPath == null) return;

    setState(() {
      isPlaying = true;
      feedbackMessage = "";
    });

    try {
      await player.play(DeviceFileSource(rootPath!));
      await Future.delayed(const Duration(seconds: 2));
      await player.play(DeviceFileSource(intervalPath!));
    } catch (e) {
      print("Replay audio error: $e");
    }

    setState(() {
      isPlaying = false;
    });
  }

  void handleGuess(String guess) {
    if (!canGuess) return;

    final normalizedGuess = switch (guess) {
      'flat' => 'flat',
      'in_tune' => 'in_tune',
      'sharp' => 'plus',
      _ => guess
    };

    final isCorrect = correctTuning != null && correctTuning!.contains(normalizedGuess);

    if (isCorrect) {
      setState(() {
        feedbackMessage = "🎉 Correct!";
        canGuess = false;
        currentRepetition++;
      });

      Future.delayed(const Duration(seconds: 1), () {
        if (currentRepetition < widget.repetitions) {
          playNext();
        } else {
          setState(() {
            feedbackMessage = "✅ Practice complete!";
          });
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
          });
        }
      });
    } else {
      setState(() {
        feedbackMessage = "❌ Try again.";
      });
    }
  }

  int noteToMidi(String note) {
    final noteMap = {
      'C': 0, 'C#': 1, 'D': 2, 'D#': 3, 'E': 4,
      'F': 5, 'F#': 6, 'G': 7, 'G#': 8, 'A': 9, 'A#': 10, 'B': 11
    };
    final match = RegExp(r'^([A-G]#?)(\d)$').firstMatch(note)!;
    final name = match.group(1)!;
    final octave = int.parse(match.group(2)!);
    return (octave + 1) * 12 + noteMap[name]!;
  }

  String midiToNote(int midi) {
    final names = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
    final note = names[midi % 12];
    final octave = (midi ~/ 12) - 1;
    return "$note$octave";
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amber = const Color(0xFFFFBF00);
    final darkWood = const Color(0xFF4B2E05);
    final mediumWood = const Color(0xFF6F4E37);
    final buttonWood = const Color(0xFF9C661F);

    return Scaffold(
      backgroundColor: darkWood,
      appBar: AppBar(
        title: const Text(
          "🎼 Practice Session",
          style: TextStyle(
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
            shadows: [
              Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 2),
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: mediumWood,
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _infoText("Open String: ${widget.baseNote}", amber),
                _infoText("Interval: ${widget.interval}", amber),
                _infoText("Difficulty: ${widget.difficulty}", amber),
                _infoText("Repetitions: ${widget.repetitions}", amber),
                const SizedBox(height: 24),
                _infoText("Progress: $currentRepetition / ${widget.repetitions}", amber),
                const SizedBox(height: 24),

                Text(
                  "🎧 What did you hear?",
                  style: TextStyle(
                    fontFamily: 'Serif',
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    color: amber,
                    shadows: const [
                      Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildGuessButton("Flat", () => handleGuess("flat"), buttonWood, amber),
                    const SizedBox(width: 8),
                    _buildGuessButton("In Tune", () => handleGuess("in_tune"), buttonWood, amber),
                    const SizedBox(width: 8),
                    _buildGuessButton("Sharp", () => handleGuess("sharp"), buttonWood, amber),
                  ],
                ),
                const SizedBox(height: 12),

                ElevatedButton.icon(
                  onPressed: isPlaying ? null : replayAudio,
                  icon: const Icon(Icons.replay),
                  label: const Text("Replay Audio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonWood,
                    foregroundColor: amber,
                    textStyle: const TextStyle(
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(color: mediumWood, width: 2),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black54,
                    minimumSize: const Size(140, 48),
                  ),
                ),
                const SizedBox(height: 16),

                if (feedbackMessage.isNotEmpty)
                  Text(
                    feedbackMessage,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Serif',
                      color: feedbackMessage.startsWith("🎉") || feedbackMessage.startsWith("✅")
                          ? amber
                          : Colors.redAccent.shade400,
                      shadows: const [
                        Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Serif',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: color,
          shadows: const [
            Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 2),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildGuessButton(String label, VoidCallback onPressed, Color bgColor, Color fgColor) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        textStyle: const TextStyle(
          fontFamily: 'Serif',
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: bgColor.withOpacity(0.7), width: 1.5),
        ),
        elevation: 6,
        shadowColor: Colors.black54,
        minimumSize: const Size(90, 40),
      ),
      child: Text(label),
    );
  }
}
