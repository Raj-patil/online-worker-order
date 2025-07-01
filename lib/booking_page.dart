import 'package:flutter/material.dart';
import 'worker_model.dart';
import 'booking_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class BookingPage extends StatefulWidget {
  final Worker? worker;
  final bool isSalonBooking;
  final String? salonServiceName;
  final String? salonImage;
  final String? profession;

  BookingPage({
    this.worker,
    this.isSalonBooking = false,
    this.salonServiceName,
    this.salonImage,
    this.profession,
  });

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _problemController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  String _paymentMethod = 'UPI';

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      final Worker actualWorker = widget.isSalonBooking
          ? Worker(
        name: widget.salonServiceName ?? 'Salon Service',
        image: widget.salonImage ?? '',
        profession: widget.profession ?? 'Salon',
        description: 'Salon service booking',
        gender: 'Unisex',
        price: 0.0,
        rating: 4.5,
        timeDuration: '30 mins',
      )
          : widget.worker!;

      final newBooking = Booking(
        worker: actualWorker,
        name: _nameController.text,
        address: _addressController.text,
        phone: _phoneController.text,
        problem: _problemController.text,
        date: _dateController.text,
        time: _timeController.text,
        paymentMethod: _paymentMethod,
        upiId: _upiController.text,
        cardNumber: _cardNumberController.text,
        email: FirebaseAuth.instance.currentUser?.email ?? '',
        isSalonBooking: widget.isSalonBooking,
        salonServiceName: widget.salonServiceName,
        salonImage: widget.salonImage,
        profession: widget.profession,
      );

      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('bookings')
            .add(newBooking.toMap());
      }

      final prefs = await SharedPreferences.getInstance();
      List<String> storedBookings = prefs.getStringList('bookings') ?? [];
      storedBookings.add(json.encode(newBooking.toMap()));
      await prefs.setStringList('bookings', storedBookings);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
            (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isSalonBooking
        ? widget.salonServiceName ?? 'Salon Booking'
        : widget.worker?.name ?? 'Booking';

    return Scaffold(
      appBar: AppBar(
        title: Text("Book $title"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (widget.isSalonBooking && widget.salonImage != null)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(widget.salonImage!, height: 200, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 12),
                    Text(
                      widget.salonServiceName ?? '',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.profession ?? 'Salon'),
                    SizedBox(height: 20),
                  ],
                ),
              _buildTextField(_nameController, "Full Name", TextInputType.name),
              _buildTextField(_addressController, "Address", TextInputType.streetAddress),
              _buildTextField(_phoneController, "Phone Number", TextInputType.phone),
              _buildTextField(_problemController, "Describe the Problem", TextInputType.text),
              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(child: _buildTextField(_dateController, "Preferred Date", TextInputType.datetime)),
              ),
              GestureDetector(
                onTap: _selectTime,
                child: AbsorbPointer(child: _buildTextField(_timeController, "Preferred Time", TextInputType.datetime)),
              ),
              SizedBox(height: 16),
              Text("Select Payment Method:", style: TextStyle(fontWeight: FontWeight.bold)),
              _buildPaymentRadio("UPI"),
              if (_paymentMethod == "UPI")
                _buildTextField(_upiController, "Enter UPI ID", TextInputType.emailAddress),
              _buildPaymentRadio("Credit/Debit Card"),
              if (_paymentMethod == "Credit/Debit Card") ...[
                _buildTextField(_cardNumberController, "Card Number", TextInputType.number),
                _buildTextField(_expiryController, "Expiry Date (MM/YY)", TextInputType.datetime),
                _buildTextField(_cvvController, "CVV", TextInputType.number),
              ],
              _buildPaymentRadio("Cash on Delivery"),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                onPressed: _submitBooking,
                child: Text("Confirm Booking"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType inputType) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildPaymentRadio(String method) {
    return RadioListTile<String>(
      title: Text(method),
      value: method,
      groupValue: _paymentMethod,
      onChanged: (value) => setState(() => _paymentMethod = value!),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (pickedDate != null) {
      _dateController.text = "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 10, minute: 0),
    );
    if (pickedTime != null) {
      final now = DateTime.now();
      final dt = DateTime(now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);
      _timeController.text = TimeOfDay.fromDateTime(dt).format(context);
    }
  }
}
