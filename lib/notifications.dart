import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<String> notifications = [
    "New booking for Photographer from John Doe",
    "Your Yoga session is confirmed for 2 PM today.",
    "New review for Babysitter: 5 stars!",
    "Mechanic booking for vehicle service at 4 PM.",
    "DJ Services: Your booking for tomorrow is confirmed!",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.teal,
      ),
      body: notifications.isEmpty
          ? Center(child: Text("No notifications"))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.notifications, color: Colors.teal),
            title: Text(notifications[index]),
            subtitle: Text("Tap to view details."),
            onTap: () {
              // Implement any action when a notification is tapped
              _showNotificationDetails(context, notifications[index]);
            },
          );
        },
      ),
    );
  }

  void _showNotificationDetails(BuildContext context, String notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Notification Details"),
        content: Text(notification),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
