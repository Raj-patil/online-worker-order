import 'package:flutter/material.dart';
import 'booking_model.dart';
import 'worker_model.dart'; // ✅ Actively used via Booking.worker
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<Booking> bookings = [];

  @override
  void initState() {
    super.initState();
    loadBookings();
  }

  Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> bookingStrings = prefs.getStringList('bookings') ?? [];
    setState(() {
      bookings = bookingStrings
          .map((jsonStr) => Booking.fromMap(json.decode(jsonStr)))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Orders"), backgroundColor: Colors.teal),
      body: bookings.isEmpty
          ? const Center(child: Text("No bookings yet."))
          : ListView.builder(
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final Booking booking = bookings[index];
          final Worker worker = booking.worker!;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(worker.image),
              ),
              title: Text(worker.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Profession: ${worker.profession}"),
                  Text("Gender: ${worker.gender}"),
                  Text("Rating: ${worker.rating}"),
                  Text("Duration: ${worker.timeDuration}"),
                  Text("Description: ${worker.description}"),
                  const SizedBox(height: 6),
                  Text("Booked for: ${booking.date} at ${booking.time}"),
                  Text("Address: ${booking.address}"),
                  Text("Payment Mode: ${booking.paymentMethod}"),
                ],
              ),
              trailing: Text('₹${worker.price}'),
            ),
          );
        },
      ),
    );
  }
}
