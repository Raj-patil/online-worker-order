import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditWorkerProfilePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String profileImage;
  final String phone;
  final String skills;
  final String experience;
  final String bio;
  final String city;

  const EditWorkerProfilePage({
    Key? key,
    required this.fullName,
    required this.email,
    required this.profileImage,
    required this.phone,
    required this.skills,
    required this.experience,
    required this.bio,
    required this.city,
  }) : super(key: key);

  @override
  _EditWorkerProfilePageState createState() => _EditWorkerProfilePageState();
}

class _EditWorkerProfilePageState extends State<EditWorkerProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _skillsController;
  late TextEditingController _experienceController;
  late TextEditingController _bioController;
  late TextEditingController _cityController;

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.fullName);
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _skillsController = TextEditingController(text: widget.skills);
    _experienceController = TextEditingController(text: widget.experience);
    _bioController = TextEditingController(text: widget.bio);
    _cityController = TextEditingController(text: widget.city);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isSaving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final query = await FirebaseFirestore.instance
        .collection('worker_requests')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;

      await FirebaseFirestore.instance
          .collection('worker_requests')
          .doc(docId)
          .update({
        'fullName': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'skills': _skillsController.text.trim(),
        'experience': _experienceController.text.trim(),
        'bio': _bioController.text.trim(),
        'city': _cityController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      Navigator.pop(context); // Go back to profile page
    }

    setState(() => isSaving = false);
  }

  Widget buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Please enter $label'
            : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: isSaving
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              buildTextField("Full Name", _nameController),
              buildTextField("Email", _emailController, keyboardType: TextInputType.emailAddress),
              buildTextField("Phone Number", _phoneController, keyboardType: TextInputType.phone),
              buildTextField("Profession", _skillsController),
              buildTextField("Experience", _experienceController),
              buildTextField("Bio", _bioController, maxLines: 3),
              buildTextField("City", _cityController),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
