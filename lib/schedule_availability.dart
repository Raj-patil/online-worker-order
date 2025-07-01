import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScheduleAvailabilityPage extends StatefulWidget {
  const ScheduleAvailabilityPage({Key? key}) : super(key: key);

  @override
  State<ScheduleAvailabilityPage> createState() => _ScheduleAvailabilityPageState();
}

class _ScheduleAvailabilityPageState extends State<ScheduleAvailabilityPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  Map<String, List<String>> availability = {};
  final List<String> days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  void initState() {
    super.initState();
    if (uid != null) {
      _loadAvailability();
    }
  }

  Future<void> _loadAvailability() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker_requests')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final fetched = Map<String, dynamic>.from(data['availability'] ?? {});
      setState(() {
        availability = {
          for (var key in fetched.keys)
            key: List<String>.from(fetched[key])
        };
      });
    }
  }

  Future<void> _saveAvailability() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('worker_requests')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final docId = snapshot.docs.first.id;
      await FirebaseFirestore.instance
          .collection('worker_requests')
          .doc(docId)
          .update({'availability': availability});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Availability saved successfully!")),
      );
    }
  }

  void _addTimeSlot(String day) {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Add Time Slot for $day'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. 10:00 AM - 2:00 PM'),
        ),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.isNotEmpty) {
                  setState(() {
                    availability[day] = availability[day] ?? [];
                    availability[day]!.add(value);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  void _removeTimeSlot(String day, int index) {
    setState(() {
      availability[day]!.removeAt(index);
      if (availability[day]!.isEmpty) {
        availability.remove(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedule Availability"),
      ),
      body: uid == null
          ? const Center(child: Text("You must be logged in"))
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Tap on a day to add availability:", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          ...days.map((day) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ExpansionTile(
                title: Text(day),
                children: [
                  ...(availability[day] ?? []).asMap().entries.map((entry) {
                    final index = entry.key;
                    final slot = entry.value;
                    return ListTile(
                      title: Text(slot),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTimeSlot(day, index),
                      ),
                    );
                  }),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Time Slot"),
                    onPressed: () => _addTimeSlot(day),
                  )
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text("Save Availability"),
            onPressed: _saveAvailability,
          )
        ],
      ),
    );
  }
}
