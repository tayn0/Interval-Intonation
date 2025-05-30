import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Warm wood-tone background color
      backgroundColor: const Color(0xFF4B2E05), // dark warm brown

      appBar: AppBar(
        backgroundColor: const Color(0xFF6F4E37), // lighter wood tone
        elevation: 6,
        title: const Text(
          '🎻 Intonation Trainer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Serif',
            fontSize: 24,
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
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Main Buttons
            Column(
              children: [
                _buildMenuButton(
                  context,
                  label: '🗡️ Adventure Mode (Coming Soon!)',
                  onTap: () {
                    Navigator.pushNamed(context, '/adventure');
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  label: '🧠 Practice Mode',
                  onTap: () {
                    Navigator.pushNamed(context, '/practiceSetup');
                  },
                ),
                const SizedBox(height: 20),
                _buildMenuButton(
                  context,
                  label: '📚 Stats & Progress (Coming Soon!)',
                  onTap: () {
                    Navigator.pushNamed(context, '/stats');
                  },
                ),
              ],
            ),

            // Footer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/settings'),
                  icon: const Icon(Icons.settings, color: Colors.amberAccent),
                  label: const Text(
                    "Settings",
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/help'),
                  icon: const Icon(Icons.help_outline, color: Colors.amberAccent),
                  label: const Text(
                    "Help",
                    style: TextStyle(color: Colors.amberAccent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF9C661F), // warm amber wood tone
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF6F4E37), width: 2), // darker border like carved wood edge
          ),
          elevation: 8,
          shadowColor: Colors.black54,
          textStyle: const TextStyle(
            fontSize: 18,
            fontFamily: 'Serif',
            fontWeight: FontWeight.w600,
            letterSpacing: 1.1,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}