import 'package:flutter/material.dart';

class PracticeSetupScreen extends StatefulWidget {
  const PracticeSetupScreen({super.key});

  @override
  State<PracticeSetupScreen> createState() => _PracticeSetupScreenState();
}

class _PracticeSetupScreenState extends State<PracticeSetupScreen> {
  String selectedString = 'A4';
  String selectedDifficulty = 'Easy';
  String selectedInterval = 'Major Second';
  int repetitions = 30; // Default set to 30

  final strings = ['G3', 'D4', 'A4', 'E5'];
  final difficulties = ['Easy', 'Medium', 'Hard'];
  final intervals = ['Major Second'];

  void startPractice() {
    Navigator.pushNamed(
      context,
      '/practiceSession',
      arguments: {
        'string': selectedString,
        'difficulty': selectedDifficulty,
        'repetitions': repetitions,
        'interval': selectedInterval,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4B2E05), // same deep wood brown
      appBar: AppBar(
        title: const Text(
          '🛠️ Practice Setup',
          style: TextStyle(
            fontFamily: 'Serif',
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
            shadows: [
              Shadow(
                color: Colors.black54,
                offset: Offset(1, 1),
                blurRadius: 2,
              )
            ],
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF6F4E37), // lighter wood tone
        elevation: 6,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _sectionTitle("🎻 Select Open String:"),
                const SizedBox(height: 8),
                _buildChoiceChipList(strings, selectedString, (val) {
                  setState(() => selectedString = val);
                }),

                const SizedBox(height: 24),
                _sectionTitle("🎚️ Select Difficulty:"),
                const SizedBox(height: 8),
                _buildChoiceChipList(difficulties, selectedDifficulty, (val) {
                  setState(() => selectedDifficulty = val);
                }),

                const SizedBox(height: 24),
                _sectionTitle("📏 Select Interval: (More coming soon!)"),
                const SizedBox(height: 8),
                _buildChoiceChipList(intervals, selectedInterval, (val) {
                  setState(() => selectedInterval = val);
                }),

                const SizedBox(height: 24),
                _sectionTitle("🔁 Repetitions:"),
                Slider(
                  value: repetitions.toDouble(),
                  min: 1,
                  max: 50,
                  divisions: 49,
                  label: "$repetitions",
                  activeColor: const Color(0xFF9C661F), // amber wood tone
                  inactiveColor: const Color(0xFF6F4E37),
                  onChanged: (val) => setState(() => repetitions = val.toInt()),
                ),

                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: startPractice,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start Practice"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9C661F),
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontFamily: 'Serif',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFF6F4E37), width: 2),
                    ),
                    elevation: 8,
                    shadowColor: Colors.black54,
                    minimumSize: const Size.fromHeight(50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Serif',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.amberAccent,
        shadows: [
          Shadow(
            color: Colors.black45,
            offset: Offset(1, 1),
            blurRadius: 2,
          )
        ],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildChoiceChipList(
      List<String> options, String selected, ValueChanged<String> onSelected) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: options.map((option) {
        final bool isSelected = option == selected;
        return ChoiceChip(
          label: Text(
            option,
            style: TextStyle(
              fontFamily: 'Serif',
              color: isSelected ? Colors.amberAccent : Colors.brown[200],
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          selectedColor: const Color(0xFF9C661F),
          backgroundColor: const Color(0xFF6F4E37),
          side: BorderSide(
            color: isSelected ? Colors.amberAccent : Colors.brown.shade300,
            width: 1.5,
          ),
          onSelected: (_) => onSelected(option),
        );
      }).toList(),
    );
  }
}
