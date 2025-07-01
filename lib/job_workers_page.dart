import 'package:flutter/material.dart';
import 'worker_model.dart';
import 'booking_page.dart'; // Ensure this exists and is correctly set up

class JobWorkersPage extends StatelessWidget {
  final String profession;
  final List<Worker> workers;

  const JobWorkersPage({required this.profession, required this.workers, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profession),
        backgroundColor: Colors.teal,
      ),
      body: ListView.builder(
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(worker.image),
              ),
              title: Text(worker.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(worker.profession),
                  Text('Rating: ${worker.rating}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to booking page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingPage(worker: worker),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
