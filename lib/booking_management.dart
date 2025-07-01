import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingManagementPage extends StatefulWidget {
  const BookingManagementPage({Key? key}) : super(key: key);

  @override
  State<BookingManagementPage> createState() => _BookingManagementPageState();
}

class _BookingManagementPageState extends State<BookingManagementPage> {
  int todayBookings = 0;
  double todayEarnings = 0;
  double monthRevenue = 0;
  List<Map<String, dynamic>> bookingList = [];

  final String userDocId = 'PfGe1PpR1oTCwS4sXXNqPCO1CLq2'; // change this if needed

  @override
  void initState() {
    super.initState();
    fetchUserBookings();
  }

  Future<void> fetchUserBookings() async {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    final startOfMonth = DateTime(now.year, now.month, 1);

    final bookingsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userDocId)
        .collection('bookings')
        .get();

    int tempTodayCount = 0;
    double tempTodayEarnings = 0;
    double tempMonthRevenue = 0;
    List<Map<String, dynamic>> userBookings = [];

    for (var bookingDoc in bookingsSnapshot.docs) {
      final data = bookingDoc.data();

      final bookingDateStr = data['date'] ?? '';
      final bookingTimeStr = data['time'] ?? '';
      final bookingDateTime = DateFormat('yyyy-MM-dd hh:mm a').parse('$bookingDateStr $bookingTimeStr');

      final dateStr = DateFormat('yyyy-MM-dd').format(bookingDateTime);
      final workerMap = data['worker'] ?? {};

      final price = (workerMap['price'] is num) ? (workerMap['price'] as num).toDouble() : 0.0;

      if (dateStr == todayStr) {
        tempTodayCount++;
        tempTodayEarnings += price;
      }

      if (bookingDateTime.isAfter(startOfMonth.subtract(const Duration(days: 1)))) {
        tempMonthRevenue += price;
      }

      userBookings.add({
        'bookingId': bookingDoc.id,
        'customerName': data['name'] ?? 'Unknown',
        'workerName': workerMap['name'] ?? 'Unknown',
        'profession': workerMap['profession'] ?? 'N/A',
        'bookingDate': bookingDateTime,
        'price': price,
        'status': data['status'] ?? 'completed',
        'paymentStatus': data['paymentStatus'] ?? 'N/A',
      });
    }

    setState(() {
      todayBookings = tempTodayCount;
      todayEarnings = tempTodayEarnings;
      monthRevenue = tempMonthRevenue;
      bookingList = userBookings;
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget buildStatCard(String title, String value, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        tileColor: color.withOpacity(0.1),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(value, style: TextStyle(fontSize: 18, color: color)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUserBookings,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          buildStatCard("Today's Bookings", todayBookings.toString(), Colors.blue),
          buildStatCard("Today's Earnings", "₹${todayEarnings.toStringAsFixed(2)}", Colors.green),
          buildStatCard("This Month's Revenue", "₹${monthRevenue.toStringAsFixed(2)}", Colors.purple),
          const Divider(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("Booking List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: bookingList.isEmpty
                ? const Center(child: Text("No bookings found."))
                : ListView.builder(
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final booking = bookingList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text("${booking['customerName']} → ${booking['workerName']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Profession: ${booking['profession']}"),
                        Text("Date: ${DateFormat('dd MMM yyyy, hh:mm a').format(booking['bookingDate'])}"),
                        Text("Payment: ${booking['paymentStatus']}"),
                        Text("Amount: ₹${booking['price']}"),
                        Text("Booking ID: ${booking['bookingId']}"),
                      ],
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: getStatusColor(booking['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        booking['status'].toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
