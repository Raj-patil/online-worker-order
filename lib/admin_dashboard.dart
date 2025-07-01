import 'package:flutter/material.dart';
import 'worker_request_page.dart';
import 'login.dart';
import 'booking_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final String adminName = "Raj Patil";
  final String adminEmail = "patilraj15563@gmail.com";

  void _onCardTap(BuildContext context, String feature) {
    switch (feature) {
      case 'Worker Management':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WorkerRequestsPage()),
        );
        break;

      case 'Booking Management':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) =>  BookingManagementPage()),
        );
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tapped: $feature (navigation not implemented)')),
        );
    }
  }

  void _onExit(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyLogin()),
          (route) => false,
    );
  }

  void _refreshDashboard() {
    setState(() {
      // If you want to reload data in future, call it here
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dashboard refreshed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> dashboardItems = [
      {
        'title': 'Worker Management',
        'subtitle': 'Approve, view, edit, or suspend workers',
        'icon': Icons.people,
        'feature': 'Worker Management',
      },
      {
        'title': 'Booking Management',
        'subtitle': 'View and manage all bookings',
        'icon': Icons.book_online,
        'feature': 'Booking Management',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _refreshDashboard,
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            tooltip: 'Logout',
            onPressed: () => _onExit(context),
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dashboardItems.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Text(adminName[0], style: const TextStyle(color: Colors.white)),
                ),
                title: Text("Welcome, $adminName", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(adminEmail),
              ),
            );
          } else {
            final item = dashboardItems[index - 1];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(item['icon'], color: Colors.teal),
                title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['subtitle']),
                trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                onTap: () => _onCardTap(context, item['feature']),
              ),
            );
          }
        },
      ),
    );
  }
}
