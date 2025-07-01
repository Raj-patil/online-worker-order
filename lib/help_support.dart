import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportPage extends StatelessWidget {
  final String email = "patilraj15563@gmail.com";
  final String phoneNumber = "6352306284";

  // Open email app (mailto)
  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull('subject=Support Needed&body=Hi, I need help with...'),
    );

    try {
      bool launched = await launchUrl(
        Uri.parse("mailto:$email"),
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw 'Email app not available';
      }
    } catch (e) {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No email app found. Please install an email app.')),
        );
      }
    }
  }

  // Open WhatsApp
  Future<void> _launchWhatsApp(BuildContext context) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('WhatsApp is not installed.')),
      );
    }
  }

  // Call phone number
  Future<void> _launchCall(BuildContext context) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to initiate call.')),
      );
    }
  }

  // Open FAQ modal
  void _showFAQs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 300,
        child: ListView(
          children: const [
            Text("FAQs", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text("Q1: How do I reset my password?"),
            Text("A: Go to settings > Change Password."),
            SizedBox(height: 12),
            Text("Q2: How can I contact support?"),
            Text("A: Use the options on this page."),
            SizedBox(height: 12),
            Text("Q3: Can I update my profile?"),
            Text("A: Yes, from settings or profile section."),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support'), backgroundColor: Colors.teal),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "How can we help you?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              "For any questions or issues, you can contact us through the following methods:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.teal),
              title: const Text("Call Us"),
              subtitle: Text(phoneNumber),
              onTap: () => _launchCall(context),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.teal),
              title: const Text("Email Us"),
              subtitle: Text(email),
              onTap: () => _launchEmail(context),
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Colors.teal),
              title: const Text("WhatsApp"),
              subtitle: Text(phoneNumber),
              onTap: () => _launchWhatsApp(context),
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.teal),
              title: const Text("FAQs"),
              onTap: () => _showFAQs(context),
            ),
          ],
        ),
      ),
    );
  }
}
