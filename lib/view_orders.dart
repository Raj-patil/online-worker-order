import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewOrders extends StatefulWidget {
  final String workerProfession;

  const ViewOrders({Key? key, required this.workerProfession}) : super(key: key);

  @override
  _ViewOrdersState createState() => _ViewOrdersState();
}

class _ViewOrdersState extends State<ViewOrders> {
  final String bookingsDocId = 'PfGe1PpR1oTCwS4sXXNqPCO1CLq2';

  Future<void> updateStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(bookingsDocId)
        .collection('bookings')
        .doc(bookingId)
        .update({'status': status});
    setState(() {}); // Refresh UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("View Orders")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(bookingsDocId)
            .collection('bookings')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data!.docs.where((doc) {
            final worker = doc['worker'];
            return worker['name'] == widget.workerProfession;
          }).toList();

          if (bookings.isEmpty) {
            return const Center(child: Text('No orders available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              final worker = booking['worker'] ?? {};
              final bookingId = bookings[index].id;
              final status = booking['status'] ?? 'PENDING';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Customer: ${booking['name'] ?? 'Unknown'}",
                          style: const TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text("Date: ${booking['date']} | Time: ${booking['time'] ?? '--'}"),
                      const SizedBox(height: 4),
                      Text("Status: $status"),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\u20B9${worker['price'] ?? '0'}",
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                          if (status == 'PENDING')
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check_circle, color: Colors.green),
                                  onPressed: () => updateStatus(bookingId, 'ACCEPTED'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel, color: Colors.red),
                                  onPressed: () => updateStatus(bookingId, 'REJECTED'),
                                ),
                              ],
                            )
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}