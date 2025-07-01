import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms & Conditions'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to Task Junction. By using our app, you agree to the following terms and conditions:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text('1. Usage Policy', style: _sectionTitleStyle()),
            Text(
              'Task Junction acts as a marketplace for connecting users with service providers. We are not responsible for services delivered by third parties.',
              style: _sectionContentStyle(),
            ),
            SizedBox(height: 10),
            Text('2. Payments', style: _sectionTitleStyle()),
            Text(
              'All payments must be made according to the rates specified by workers. Task Junction is not responsible for refunds or payment disputes.',
              style: _sectionContentStyle(),
            ),
            SizedBox(height: 10),
            Text('3. Cancellation', style: _sectionTitleStyle()),
            Text(
              'Users and workers must communicate cancellations promptly. Task Junction holds no responsibility for cancellation charges.',
              style: _sectionContentStyle(),
            ),
            SizedBox(height: 10),
            Text('4. Liability', style: _sectionTitleStyle()),
            Text(
              'We are not liable for any damages or losses arising from worker services booked through our platform.',
              style: _sectionContentStyle(),
            ),
            SizedBox(height: 10),
            Text('5. Changes to Terms', style: _sectionTitleStyle()),
            Text(
              'Task Junction may update these terms anytime. Please review regularly.',
              style: _sectionContentStyle(),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: Text('Accept & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }

  TextStyle _sectionContentStyle() {
    return TextStyle(fontSize: 16);
  }
}
