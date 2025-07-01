import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'home_page.dart';
import 'forgot_password.dart';
import 'admin_dashboard.dart';
import 'worker_dashboard.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String _selectedRole = 'user'; // default selection

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        final uid = userCredential.user!.uid;

        final docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .get();

        if (!docSnapshot.exists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not found in Firestore.')),
          );
          setState(() => _isLoading = false);
          return;
        }

        final userData = docSnapshot.data()!;
        final role = userData['role'] ?? 'user';

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminDashboard()),
          );
        } else if (_selectedRole == 'worker') {
          final approval = await FirebaseFirestore.instance
              .collection('worker_requests') // ✅ correct
              .where('userId', isEqualTo: uid)
              .where('status', isEqualTo: 'approved')
              .get();

          if (approval.docs.isNotEmpty) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => WorkerDashboardPage()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are not approved as a worker yet.')),
            );
          }
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomePage()),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Login failed')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected error occurred')),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(35.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Task\nJunction',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),

                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // 👇 Toggle buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: const Text('User'),
                          selected: _selectedRole == 'user',
                          selectedColor: Colors.green,
                          onSelected: (_) {
                            setState(() => _selectedRole = 'user');
                          },
                          labelStyle: TextStyle(
                            color: _selectedRole == 'user' ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: const Text('Worker'),
                          selected: _selectedRole == 'worker',
                          selectedColor: Colors.green,
                          onSelected: (_) {
                            setState(() => _selectedRole = 'worker');
                          },
                          labelStyle: TextStyle(
                            color: _selectedRole == 'worker' ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign in',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: _login,
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xff4c505b),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Forgot Password',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Color(0xff4c505b),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
