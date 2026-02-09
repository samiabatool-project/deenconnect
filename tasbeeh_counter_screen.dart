import 'package:flutter/material.dart';

class TasbeehCounterScreen extends StatefulWidget {
  final String tasbeehName;
  final int target;
  final Color color;
  final bool isDaily;
  final bool enableNotifications;
  final TimeOfDay reminderTime;

  const TasbeehCounterScreen({
    super.key,
    required this.tasbeehName,
    required this.target,
    required this.color,
    required this.isDaily,
    required this.enableNotifications,
    required this.reminderTime,
  });

  @override
  State<TasbeehCounterScreen> createState() => _TasbeehCounterScreenState();
}

class _TasbeehCounterScreenState extends State<TasbeehCounterScreen> {
  int count = 0;

  void increment() {
    if (count < widget.target) {
      setState(() {
        count++;
      });
    }
  }

  void reset() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Counter'),
        content: const Text('Are you sure you want to reset?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() => count = 0);
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = count / widget.target;

    return Scaffold(
      backgroundColor: const Color(0xFFE6D3B1),
      appBar: AppBar(
        backgroundColor: widget.color,
        title: Text(widget.tasbeehName),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular Progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 220,
                  height: 220,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: AlwaysStoppedAnimation(widget.color),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3728),
                      ),
                    ),
                    Text(
                      '/ ${widget.target}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4A3728),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Tap to Count Button
            GestureDetector(
              onTap: increment,
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'TAP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Reset Button
            TextButton.icon(
              onPressed: reset,
              icon: Icon(Icons.refresh, color: widget.color),
              label: Text(
                'Reset Counter',
                style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Completed badge
            if (count >= widget.target)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 124, 100, 73).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '✓ Tasbeeh Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
