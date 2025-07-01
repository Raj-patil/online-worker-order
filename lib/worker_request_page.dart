import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WorkerRequestsPage extends StatelessWidget {
  const WorkerRequestsPage({super.key});

  Future<void> updateStatus(BuildContext context, String docId, String status) async {
    try {
      await FirebaseFirestore.instance.collection('worker_requests').doc(docId).update({
        'status': status,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Worker ${status == 'approved' ? 'approved' : 'rejected'}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e')),
      );
    }
  }

  Future<void> showConfirmationDialog(BuildContext context, String docId, String action) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$action Worker'),
        content: Text('Are you sure you want to $action this worker?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(action),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // ✅ Fix: Use correct status value instead of `action.toLowerCase()`
      String statusValue = action.toLowerCase() == 'approved' ? 'approved' : 'rejected';
      await updateStatus(context, docId, statusValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Worker Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('worker_requests')
            .where('status', isEqualTo: 'pending')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading data.'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No pending requests'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final docId = docs[index].id;

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(data['fullName'] ?? 'Unnamed'),
                  subtitle: Text(
                      'Skills: ${data['skills'] ?? 'N/A'}\nContact: ${data['contact'] ?? 'N/A'}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check_circle, color: Colors.green),
                        onPressed: () => showConfirmationDialog(context, docId, 'Approved'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => showConfirmationDialog(context, docId, 'Reject'),
                      ),
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
