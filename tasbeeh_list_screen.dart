import 'package:flutter/material.dart';
import 'add_tasbeeh_screen.dart';
import 'tasbeeh_counter_screen.dart';

class TasbeehListScreen extends StatefulWidget {
  const TasbeehListScreen({super.key});

  @override
  State<TasbeehListScreen> createState() => _TasbeehListScreenState();
}

class _TasbeehListScreenState extends State<TasbeehListScreen> {
  final List<Map<String, dynamic>> tasbeehList = [
    {
      'name': 'SubhanAllah',
      'current': 33,
      'target': 100,
      'color': Colors.green,
      'streak': 7,
      'isDaily': true,
    },
    {
      'name': 'Alhamdulillah',
      'current': 67,
      'target': 100,
      'color': Colors.blue,
      'streak': 5,
      'isDaily': true,
    },
    {
      'name': 'Allahu Akbar',
      'current': 25,
      'target': 100,
      'color': Colors.orange,
      'streak': 3,
      'isDaily': true,
    },
    {
      'name': 'Astaghfirullah',
      'current': 50,
      'target': 100,
      'color': Colors.purple,
      'streak': 2,
      'isDaily': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6D3B1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3728),
        title: const Text('My Tasbeehs'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasbeehList.length,
        itemBuilder: (context, index) {
          final tasbeeh = tasbeehList[index];
          final progress = tasbeeh['current'] / tasbeeh['target'];

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TasbeehCounterScreen(
                      tasbeehName: tasbeeh['name'],
                      target: tasbeeh['target'],
                      color: tasbeeh['color'],
                      // 🔧 ADD THESE
                      isDaily: true,
                      enableNotifications: false,
                      reminderTime: const TimeOfDay(hour: 8, minute: 0),
                    ),
                  ),
                );
              },
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: tasbeeh['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.psychology_alt,
                  color: tasbeeh['color'],
                ),
              ),
              title: Text(
                tasbeeh['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3728),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: tasbeeh['color'].withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(tasbeeh['color']),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${tasbeeh['current']}/${tasbeeh['target']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF4A3728).withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            size: 14,
                            color: Colors.orange,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${tasbeeh['streak']} days',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF4A3728).withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: tasbeeh['color'],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTasbeehScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4A3728),
        child: const Icon(Icons.add),
      ),
    );
  }
}
