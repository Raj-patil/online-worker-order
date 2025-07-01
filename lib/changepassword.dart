import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Here you would normally integrate your backend to change the password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password changed successfully!')),
      );
      // Clear fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Current Password
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureCurrentPassword = !_obscureCurrentPassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                value!.isEmpty ? 'Please enter your current password' : null,
              ),
              SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a new password';
                  if (value.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              SizedBox(height: 16),

              // Confirm New Password
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              SizedBox(height: 30),

              ElevatedButton(
                onPressed: _changePassword,
                child: Text('Save Changes', style: TextStyle(fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
