import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedLanguage = 'English';
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = user.email ?? '';
          _phoneController.text = data['phone'] ?? '';
          _addressController.text = data['address'] ?? '';
          _selectedLanguage = data['language'] ?? 'English';
          existingImageUrl = data['profileImage'];
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    final apiKey = '7f3396bd3e508c5e5291abcd05605936'; // 🔐 Replace this with your actual API key

    try {
      final url = Uri.parse('https://api.imgbb.com/1/upload?key=$apiKey');
      final base64Image = base64Encode(image.readAsBytesSync());

      final response = await http.post(url, body: {
        'image': base64Image,
      });

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['data']['url'];
      } else {
        print("❌ ImgBB Upload failed: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception uploading to ImgBB: $e");
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      print("Form validation failed");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("User is not logged in");
      return;
    }

    String? imageUrl = existingImageUrl;

    if (_profileImage != null) {
      print("📷 Uploading image to ImgBB...");
      final uploadedUrl = await _uploadImage(_profileImage!);
      if (uploadedUrl != null) {
        imageUrl = uploadedUrl;
        print("✅ Image uploaded: $imageUrl");
      } else {
        print("❌ Image upload failed");
      }
    }

    try {
      if (_emailController.text.trim() != user.email) {
        print("🔐 Updating email...");
        await user.verifyBeforeUpdateEmail(_emailController.text.trim());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification email sent to ${_emailController.text.trim()}')),
        );
      }

      print("💾 Saving profile to Firestore...");
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'language': _selectedLanguage,
        'profileImage': imageUrl,
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      print("❌ Error saving profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : (existingImageUrl != null
                      ? NetworkImage(existingImageUrl!)
                      : AssetImage('assets/profile.png') as ImageProvider),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.camera_alt, size: 20, color: Colors.teal),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your phone number';
                  if (value.length != 10) return 'Phone number must be 10 digits';
                  return null;
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter your address' : null,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  labelText: 'Preferred Language',
                  border: OutlineInputBorder(),
                ),
                items: ['English', 'Hindi', 'Marathi', 'Gujarati']
                    .map((lang) => DropdownMenuItem(
                  child: Text(lang),
                  value: lang,
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLanguage = value!;
                  });
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
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
