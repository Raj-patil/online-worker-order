import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_worker_profile.dart';

class WorkerProfilePage extends StatefulWidget {
  const WorkerProfilePage({Key? key}) : super(key: key);

  @override
  State<WorkerProfilePage> createState() => _WorkerProfilePageState();
}

class _WorkerProfilePageState extends State<WorkerProfilePage> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('worker_requests')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      setState(() {
        profileData = snapshot.docs.first.data();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildProfileInfo(String title, String? value, IconData icon) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        subtitle: Text(value?.isNotEmpty == true ? value! : 'Not Provided',
            style: const TextStyle(fontSize: 14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = profileData?['profileImage'];
    final fullName = profileData?['fullName'] ?? 'No Name';
    final email = profileData?['email'] ?? 'No Email';
    final phone = profileData?['phoneNumber'] ?? '';
    final skills = profileData?['skills'] ?? '';
    final experience = profileData?['experience'] ?? '';
    final bio = profileData?['bio'] ?? '';
    final city = profileData?['city'] ?? profileData?['location'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileData == null
          ? const Center(child: Text("Profile not found."))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Picture with Edit Icon
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: photoUrl != null
                        ? NetworkImage(photoUrl)
                        : const AssetImage("assets/default_user.png")
                    as ImageProvider,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 18,
                      child: const Icon(Icons.edit,
                          color: Colors.white, size: 18),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fullName,
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditWorkerProfilePage(
                      fullName: fullName,
                      email: email,
                      profileImage: photoUrl ?? '',
                      phone: phone,
                      skills: skills,
                      experience: experience,
                      bio: bio,
                      city: city,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                    horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
            ),
            const SizedBox(height: 30),

            buildProfileInfo("Phone Number", phone, Icons.phone),
            buildProfileInfo("Profession", skills, Icons.work),
            buildProfileInfo("Experience", experience, Icons.timeline),
            buildProfileInfo("Bio", bio, Icons.info_outline),
            buildProfileInfo("City", city, Icons.location_city),
          ],
        ),
      ),
    );
  }
}
