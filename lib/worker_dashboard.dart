import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import 'login.dart';
import 'view_orders.dart';
import 'schedule_availability.dart';
import 'worker_profile.dart';


class WorkerDashboardPage extends StatefulWidget {
  const WorkerDashboardPage({Key? key}) : super(key: key);

  @override
  State<WorkerDashboardPage> createState() => _WorkerDashboardPageState();
}

class _WorkerDashboardPageState extends State<WorkerDashboardPage> {
  int todayOrders = 0;
  double todayEarnings = 0.0;
  int totalOrders = 0;
  double totalEarnings = 0.0;
  String workerName = '';
  String workerProfession = '';

  final String bookingsDocId = 'PfGe1PpR1oTCwS4sXXNqPCO1CLq2';

  @override
  void initState() {
    super.initState();
    _loadWorkerDetails();
  }

  Future<void> _loadWorkerDetails() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final workerSnapshot = await FirebaseFirestore.instance
        .collection('worker_requests')
        .where('userId', isEqualTo: uid)
        .where('status', isEqualTo: 'approved')
        .limit(1)
        .get();

    if (workerSnapshot.docs.isNotEmpty) {
      final data = workerSnapshot.docs.first.data();
      setState(() {
        workerName = data['fullName'] ?? 'Worker';
        workerProfession = data['skills'] ?? 'Unknown';
      });

      _fetchWorkerBookings();
    }
  }

  Future<void> _fetchWorkerBookings() async {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(bookingsDocId)
        .collection('bookings')
        .get();

    int tempTodayOrders = 0;
    double tempTodayEarnings = 0.0;
    int tempTotalOrders = 0;
    double tempTotalEarnings = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final worker = data['worker'];
      final bookingDate = data['date'];

      if (worker == null || worker['name'] != workerProfession) continue;

      final price = (worker['price'] ?? 0).toDouble();

      tempTotalOrders += 1;
      tempTotalEarnings += price;

      if (bookingDate == todayStr) {
        tempTodayOrders += 1;
        tempTodayEarnings += price;
      }
    }

    setState(() {
      todayOrders = tempTodayOrders;
      todayEarnings = tempTodayEarnings;
      totalOrders = tempTotalOrders;
      totalEarnings = tempTotalEarnings;
    });
  }

  void _logoutAndExit() {
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MyLogin()),
          (route) => false,
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      color: color,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(value, style: const TextStyle(color: Colors.white, fontSize: 20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Worker Dashboard"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40),
              ),
              accountName: Text(workerName),
              accountEmail: Text(workerProfession),
              decoration: const BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const WorkerProfilePage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.list_alt),
              title: const Text("View Orders"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewOrders(workerProfession: workerProfession),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text("Schedule Availability"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScheduleAvailabilityPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text("Logout"),
              onTap: _logoutAndExit,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchWorkerBookings,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              "Welcome, $workerName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text(
              "Profession: $workerProfession",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            const Text("Today's Summary", style: TextStyle(fontSize: 18)),
            _buildStatCard("Today's Orders", "$todayOrders", Colors.green),
            _buildStatCard("Today's Earnings", "₹${todayEarnings.toStringAsFixed(2)}", Colors.teal),
            const SizedBox(height: 16),
            const Text("Overall Summary", style: TextStyle(fontSize: 18)),
            _buildStatCard("Total Orders", "$totalOrders", Colors.orange),
            _buildStatCard("Total Earnings", "₹${totalEarnings.toStringAsFixed(2)}", Colors.deepOrange),
          ],
        ),
      ),
    );
  }
}
