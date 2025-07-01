import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            '''
**Privacy Policy**

Effective Date: April 28, 2025

We are committed to protecting your personal information and your right to privacy. If you have any questions or concerns about this policy or our practices, please contact us.

**1. Information We Collect**

We collect personal information that you voluntarily provide to us when registering on the app, such as:
- Full name
- Email address
- Phone number
- Address
- Profile picture

**2. How We Use Your Information**

We use the collected information for purposes including:
- To create and manage user accounts
- To provide customer support
- To improve user experience
- To send you important updates or security notices

**3. Sharing of Information**

We do **not** share your information with any third parties unless required by law.

**4. Data Retention**

We retain your information as long as necessary to provide you services or comply with legal obligations.

**5. Data Security**

We implement technical and organizational measures to protect your personal information. However, no electronic transmission or storage method is 100% secure.

**6. Your Privacy Rights**

You may review, update, or delete your personal data at any time through your account settings.

**7. Contact Us**

If you have any questions about this privacy policy, please contact us at:

support@example.com

Thank you for using our services!
            ''',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ),
      ),
    );
  }
}
