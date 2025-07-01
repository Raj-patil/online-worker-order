import 'worker_model.dart';

class Booking {
  final Worker? worker;
  final String name;
  final String address;
  final String phone;
  final String problem;
  final String date;
  final String time;
  final String paymentMethod;
  final String upiId;
  final String cardNumber;
  final String email;

  // New fields for salon bookings
  final bool isSalonBooking;
  final String? salonServiceName;
  final String? salonImage;
  final String? profession;

  Booking({
    required this.worker,
    required this.name,
    required this.address,
    required this.phone,
    required this.problem,
    required this.date,
    required this.time,
    required this.paymentMethod,
    required this.upiId,
    required this.cardNumber,
    required this.email,
    this.isSalonBooking = false,
    this.salonServiceName,
    this.salonImage,
    this.profession,
  });

  Map<String, dynamic> toMap() {
    return {
      'worker': worker != null
          ? {
        'name': worker!.name,
        'profession': worker!.profession,
        'description': worker!.description,
        'gender': worker!.gender,
        'rating': worker!.rating,
        'timeDuration': worker!.timeDuration,
        'price': worker!.price,
        'image': worker!.image,
      }
          : null,
      'name': name,
      'address': address,
      'phone': phone,
      'problem': problem,
      'date': date,
      'time': time,
      'paymentMethod': paymentMethod,
      'upiId': upiId,
      'cardNumber': cardNumber,
      'email': email,
      'isSalonBooking': isSalonBooking,
      'salonServiceName': salonServiceName,
      'salonImage': salonImage,
      'profession': profession,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      worker: map['worker'] != null
          ? Worker(
        name: map['worker']['name'],
        profession: map['worker']['profession'],
        description: map['worker']['description'],
        gender: map['worker']['gender'],
        rating: (map['worker']['rating'] as num).toDouble(),
        timeDuration: map['worker']['timeDuration'],
        price: (map['worker']['price'] as num).toDouble(),
        image: map['worker']['image'],
      )
          : null,
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      problem: map['problem'],
      date: map['date'],
      time: map['time'],
      paymentMethod: map['paymentMethod'],
      upiId: map['upiId'],
      cardNumber: map['cardNumber'],
      email: map['email'],
      isSalonBooking: map['isSalonBooking'] ?? false,
      salonServiceName: map['salonServiceName'],
      salonImage: map['salonImage'],
      profession: map['profession'],
    );
  }
}
