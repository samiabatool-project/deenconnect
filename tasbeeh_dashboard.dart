import 'package:flutter/material.dart';
import 'package:deen_connect/features/tasbeeh/add_tasbeeh_screen.dart';
import 'package:deen_connect/features/tasbeeh/tasbeeh_counter_screen.dart';
import 'package:deen_connect/features/tasbeeh/tasbeeh_list_screen.dart';

class TasbeehDashboard extends StatelessWidget {
  const TasbeehDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6D3B1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3728),
        title: const Text('Tasbeeh Dashboard'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 20),

            // Quick Stats
            _buildStatsRow(),
            const SizedBox(height: 20),

            // Active Tasbeehs
            _buildActiveTasbeehs(context),
            const SizedBox(height: 20),

            // Quick Actions
            _buildQuickActions(context)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTasbeehScreen(),
            ),
          );
        },
        backgroundColor: const Color(0xFF4A3728),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF4A3728),
            Color(0xFF806254),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4A3728).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.psychology_alt, color: Colors.white, size: 28),
              SizedBox(width: 10),
              Text(
                'Tasbeeh Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    '7',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Day Streak',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '85%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Today Progress',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    '5',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Active',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to all tasbeehs
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF4A3728),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: const Text('View All Tasbeehs'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Count',
            '1,234',
            Icons.numbers,
            Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'Completed',
            '12',
            Icons.check_circle,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            'Time Spent',
            '45m',
            Icons.timer,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3728),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: const Color(0xFF4A3728).withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTasbeehs(BuildContext context) {
    final List<Map<String, dynamic>> activeTasbeehs = [
      {
        'name': 'SubhanAllah',
        'progress': 0.33,
        'color': Colors.green,
        'current': 33,
        'target': 100,
      },
      {
        'name': 'Alhamdulillah',
        'progress': 0.67,
        'color': Colors.blue,
        'current': 67,
        'target': 100,
      },
      {
        'name': 'Allahu Akbar',
        'progress': 0.25,
        'color': const Color.fromARGB(255, 0, 255, 98),
        'current': 25,
        'target': 100,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Active Tasbeehs',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4A3728),
          ),
        ),
        const SizedBox(height: 15),
        ...activeTasbeehs.map((tasbeeh) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
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
                    value: tasbeeh['progress'],
                    backgroundColor: tasbeeh['color'].withOpacity(0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(tasbeeh['color']),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${tasbeeh['current']}/${tasbeeh['target']} (${(tasbeeh['progress'] * 100).toInt()}%)',
                    style: TextStyle(
                      fontSize: 12,
                      color: const Color(0xFF4A3728).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: tasbeeh['color'],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3728),
            ),
          ),
          const SizedBox(height: 15),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1.8,
            children: [
              _buildActionCard(
                'New Tasbeeh',
                Icons.add_circle,
                Colors.green,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AddTasbeehScreen(),
                    ),
                  );
                },
              ),
              _buildActionCard(
                'All Tasbeehs',
                Icons.list,
                Colors.blue,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TasbeehListScreen(),
                    ),
                  );
                },
              ),
              _buildActionCard(
                'Daily Target',
                Icons.flag,
                Colors.orange,
                () {
                  // Daily target screen
                },
              ),
              _buildActionCard(
                'Settings',
                Icons.settings,
                Colors.purple,
                () {
                  // Settings screen
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
