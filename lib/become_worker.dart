import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class BecomeWorkerPage extends StatefulWidget {
  @override
  _BecomeWorkerPageState createState() => _BecomeWorkerPageState();
}

class _BecomeWorkerPageState extends State<BecomeWorkerPage> {
  int _currentStep = 0;

  final _personalFormKey = GlobalKey<FormState>();
  final _professionalFormKey = GlobalKey<FormState>();
  final _verificationFormKey = GlobalKey<FormState>();

  // Controllers
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  String? _selectedGender;
  TextEditingController _contactController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _lastWorkplaceController = TextEditingController();
  String? _selectedIdType;
  TextEditingController _idNumberController = TextEditingController();
  bool _termsAccepted = false;
  String? _selectedProfession;

  final List<String> _availableProfessions = [
    'Babysitter',
    'ac technician'
    'Photographer',
    'Videographer',
    'Fitness & Yoga',
    'DJ Services',
    'Plumber',
    'Mechanic',
    'Developer',
    'Gardener',
    'Chef',
    'Caretaker',
    'Carpentry',
    'Electrician',
    'Security',
    'Men Salon',
    'Women Salon',
  ];

  void _nextStep() {
    if ((_currentStep == 0 && _personalFormKey.currentState!.validate()) ||
        (_currentStep == 1 && _professionalFormKey.currentState!.validate()) ||
        (_currentStep == 2 && _verificationFormKey.currentState!.validate())) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      _dobController.text =
      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
    }
  }

  Future<void> _submitWorkerRequest() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please sign in to submit the form.')),
        );
        return;
      }

      final existingRequest = await FirebaseFirestore.instance
          .collection('worker_requests')
          .where('userId', isEqualTo: user.uid)
          .get();

      if (existingRequest.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You have already submitted a request.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('worker_requests').add({
        'fullName': _fullNameController.text.trim(),
        'dob': _dobController.text.trim(),
        'gender': _selectedGender,
        'contact': _contactController.text.trim(),
        'address': _addressController.text.trim(),
        'skills': _selectedProfession,
        'experience': _experienceController.text.trim(),
        'lastWorkplace': _lastWorkplaceController.text.trim(),
        'idType': _selectedIdType,
        'idNumber': _idNumberController.text.trim(),
        'termsAccepted': _termsAccepted,
        'status': 'pending',
        'submittedAt': Timestamp.now(),
        'userId': user.uid,
        'email': user.email ?? '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request submitted successfully!')),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submission failed. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Become a Worker")),
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _previousStep,
        steps: [
          Step(
            title: Text('Personal Information'),
            content: Form(
              key: _personalFormKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (val) => val!.isEmpty ? 'Enter full name' : null,
                  ),
                  TextFormField(
                    controller: _dobController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    validator: (val) =>
                    val!.isEmpty ? 'Select your birth date' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: InputDecoration(labelText: 'Gender'),
                    items: ['Male', 'Female', 'Other']
                        .map((g) =>
                        DropdownMenuItem(child: Text(g), value: g))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedGender = val),
                    validator: (val) => val == null ? 'Select gender' : null,
                  ),
                  TextFormField(
                    controller: _contactController,
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    keyboardType: TextInputType.phone,
                    validator: (val) {
                      final cleanedVal =
                          val?.replaceAll(RegExp(r'\s+'), '') ?? '';
                      if (cleanedVal.isEmpty) return 'Enter contact number';
                      if (!RegExp(r'^\d{10}$').hasMatch(cleanedVal))
                        return 'Enter valid 10-digit number';
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Home Address'),
                    validator: (val) =>
                    val!.isEmpty ? 'Enter address' : null,
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state:
            _currentStep > 0 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: Text('Professional Information'),
            content: Form(
              key: _professionalFormKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedProfession,
                    decoration: InputDecoration(labelText: 'Select Profession'),
                    items: _availableProfessions.map((profession) {
                      return DropdownMenuItem<String>(
                        value: profession,
                        child: Text(profession),
                      );
                    }).toList(),
                    onChanged: (val) =>
                        setState(() => _selectedProfession = val),
                    validator: (val) =>
                    val == null ? 'Please select a profession' : null,
                  ),
                  TextFormField(
                    controller: _experienceController,
                    decoration:
                    InputDecoration(labelText: 'Experience (years)'),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                    val!.isEmpty ? 'Enter experience' : null,
                  ),
                  TextFormField(
                    controller: _lastWorkplaceController,
                    decoration:
                    InputDecoration(labelText: 'Last Workplace (optional)'),
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 1,
            state:
            _currentStep > 1 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: Text('Identity Verification'),
            content: Form(
              key: _verificationFormKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedIdType,
                    decoration: InputDecoration(labelText: 'ID Type'),
                    items: ['Aadhaar Card', 'Driving License', 'PAN Card']
                        .map((id) => DropdownMenuItem(
                      child: Text(id),
                      value: id,
                    ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedIdType = val),
                    validator: (val) =>
                    val == null ? 'Select ID type' : null,
                  ),
                  TextFormField(
                    controller: _idNumberController,
                    decoration: InputDecoration(labelText: 'ID Number'),
                    validator: (val) =>
                    val!.isEmpty ? 'Enter ID number' : null,
                  ),
                  CheckboxListTile(
                    title: Text('I agree to the terms and conditions'),
                    value: _termsAccepted,
                    onChanged: (val) =>
                        setState(() => _termsAccepted = val ?? false),
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 2,
            state:
            _currentStep > 2 ? StepState.complete : StepState.editing,
          ),
          Step(
            title: Text('Complete'),
            content: Column(
              children: [
                Text('You have completed registration.'),
                SizedBox(height: 12),
                ElevatedButton(
                  child: Text('Finish'),
                  onPressed: () {
                    if (!_termsAccepted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'You must accept the terms & conditions')));
                      return;
                    }

                    if (_personalFormKey.currentState!.validate() &&
                        _professionalFormKey.currentState!.validate() &&
                        _verificationFormKey.currentState!.validate()) {
                      _submitWorkerRequest();
                    }
                  },
                ),
              ],
            ),
            isActive: _currentStep >= 3,
            state: StepState.complete,
          ),
        ],
      ),
    );
  }
}

// ✅ Firebase initialization (only for standalone test)
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: BecomeWorkerPage()));
}
