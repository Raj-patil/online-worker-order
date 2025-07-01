import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({Key? key}) : super(key: key);

  @override
  _MyRegisterState createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .set({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'role': 'user',
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registered successfully!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } on FirebaseAuthException catch (e) {
        String message = 'Registration failed';
        if (e.code == 'email-already-in-use') {
          message = 'Email already in use.';
        } else if (e.code == 'weak-password') {
          message = 'Password is too weak.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset('assets/register.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 35),
              child: Material(
                color: Colors.transparent,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 50),
                      TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Name'),
                        validator: (value) =>
                        value!.isEmpty ? 'Enter your name' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: _inputDecoration('Email'),
                        validator: (value) => value!.contains('@')
                            ? null
                            : 'Enter a valid email',
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Password'),
                        validator: (value) => value!.length < 8
                            ? 'Password must be 8+ characters'
                            : null,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700)),
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xff4c505b),
                            child: IconButton(
                              color: Colors.white,
                              onPressed: _register,
                              icon: Icon(Icons.arrow_forward),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.tealAccent),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
