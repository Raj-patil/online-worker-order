import 'package:flutter/material.dart';
import 'booking_page.dart';
import 'job_workers_page.dart';
import 'worker_model.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({Key? key}) : super(key: key);

  final List<Worker> workers = [
    Worker(name: "Plumber", image: "assets/plumber.jpg", profession: "Plumbing", description: "Fixing and installing pipes.", rating: 4.5, price: 300, timeDuration: "1 hour", gender: "male"),
    Worker(name: "Electrician", image: "assets/electrician.jpg", profession: "Electrical", description: "Wiring, circuits, and repairs.", rating: 4.6, price: 400, timeDuration: "1.5 hours", gender: "male"),
    Worker(name: "Gardener", image: "assets/gardener.jpeg", profession: "Gardening", description: "Lawn care and plant maintenance.", rating: 4.4, price: 350, timeDuration: "2 hours", gender: "male"),
    Worker(name: "Security", image: "assets/security.jpg", profession: "Security Guard", description: "24/7 home and event security.", rating: 4.3, price: 500, timeDuration: "8 hours", gender: "male"),
    Worker(name: "Caretaker", image: "assets/caretaker.jpg", profession: "Caretaker", description: "Patient and elderly care.", rating: 4.5, price: 600, timeDuration: "6 hours", gender: "male"),
    Worker(name: "Carpenter", image: "assets/carpentry.jpeg", profession: "Carpentry", description: "Woodwork and repairs.", rating: 4.4, price: 450, timeDuration: "2 hours", gender: "male"),
    Worker(name: "Chef", image: "assets/chef.jpeg", profession: "Chef", description: "Cooking delicious meals at home.", rating: 4.7, price: 800, timeDuration: "3 hours", gender: "male"),
    Worker(name: "Developer", image: "assets/developer.jpeg", profession: "Software Developer", description: "Mobile & web app development.", rating: 4.8, price: 1500, timeDuration: "8 hours", gender: "male"),
    Worker(name: "AC Technician", image: "assets/ac_technician.jpg", profession: "AC Repair", description: "Cooling system maintenance.", rating: 4.5, price: 500, timeDuration: "1.5 hours", gender: "male"),
    Worker(name: "Men's Salon Expert", image: "assets/mens_salon.webp", profession: "Men's Grooming", description: "Haircut and beard styling.", rating: 4.6, price: 500, timeDuration: "1 hour", gender: "male"),
    Worker(name: "Women's Salon Expert", image: "assets/womens_salon.png", profession: "Women's Salon", description: "Hair, nails, and facial.", rating: 4.7, price: 600, timeDuration: "1.5 hours", gender: "female"),
    Worker(name: "Mechanic", image: "assets/mechanic.webp", profession: "Vehicle Mechanic", description: "Bike & car repair services.", rating: 4.3, price: 450, timeDuration: "2 hours", gender: "male"),
    Worker(name: "Washing Machine Repair", image: "assets/washing_machine_repair.jpg", profession: "Appliance Repair", description: "Washing machine fixing.", rating: 4.4, price: 400, timeDuration: "1.5 hours", gender: "male"),
    Worker(name: "Babysitter", image: "assets/babysitter.jpg", profession: "Babysitting", description: "Caring for children at home.", rating: 4.6, price: 500, timeDuration: "4 hours", gender: "male"),
    Worker(name: "Fitness & Yoga", image: "assets/fitness&yoga.jpg", profession: "Fitness Trainer", description: "Yoga and physical training.", rating: 4.7, price: 600, timeDuration: "1 hour", gender: "male"),
    Worker(name: "dj service", image: "assets/dj_services.jpg", profession: "DJ", description: "Music for events and parties.", rating: 4.5, price: 1000, timeDuration: "4 hours", gender: "male"),
    Worker(name: "Photographer", image: "assets/Photographer.jpg", profession: "Photographer", description: "Photoshoots for occasions.", rating: 4.8, price: 1200, timeDuration: "2 hours", gender: "male"),
    Worker(name: "Videographer", image: "assets/Videographers.jpg", profession: "Videographer", description: "Events and video production.", rating: 4.7, price: 1500, timeDuration: "2 hours", gender: "male"),
    Worker(name: "Facial & Cleanup", image: "assets/facial&cleaning.jpg", profession: "Skin Care", description: "Deep facial cleansing.", rating: 4.5, price: 700, timeDuration: "1 hour", gender: "male"),
    Worker(name: "Men's De-tan", image: "assets/mens_detan.jpg", profession: "Men's Skincare", description: "Skin brightening and de-tan.", rating: 4.4, price: 450, timeDuration: "45 minutes", gender: "male"),
    Worker(name: "Women's Facial", image: "assets/facial.jpg", profession: "Women's Facial", description: "Glow & anti-aging treatment.", rating: 4.6, price: 800, timeDuration: "1 hour", gender: "female"),
    Worker(name: "Haircut & Beard", image: "assets/haircut&beard_styling.jpg", profession: "Stylist", description: "Hair and beard design.", rating: 4.7, price: 500, timeDuration: "1 hour", gender: "male"),
    Worker(name: "Hair Cutting", image: "assets/haircutting.webp", profession: "Barber", description: "Men's haircut styles.", rating: 4.4, price: 300, timeDuration: "30 minutes", gender: "male"),
    Worker(name: "Men's Massage", image: "assets/mens_massage.jpg", profession: "Massage Therapist", description: "Relaxing body massage.", rating: 4.6, price: 600, timeDuration: "1 hour", gender: "male"),
    Worker(name: "Men's Pedicure & Manicure", image: "assets/mens_medicure&pedicure.jpg", profession: "Grooming", description: "Nail and foot care.", rating: 4.5, price: 400, timeDuration: "45 minutes", gender: "male"),
    Worker(name: "Threading & Waxing", image: "assets/threading&facewaxing.webp", profession: "Beautician", description: "Eyebrow threading and waxing.", rating: 4.5, price: 250, timeDuration: "30 minutes", gender: "female"),
    Worker(name: "Women's Waxing", image: "assets/waxing.jpg", profession: "Waxing Specialist", description: "Full body waxing service.", rating: 4.6, price: 550, timeDuration: "1 hour", gender: "female"),
    Worker(name: "Women's Pedicure & Manicure", image: "assets/womens_medicure&pedicure.jpg", profession: "Nail Artist", description: "Nail care and polish.", rating: 4.7, price: 500, timeDuration: "1 hour", gender: "female"),
    Worker(name: "Women's Spa Therapist", image: "assets/womens_spa.jpg", profession: "Spa Therapist", description: "Relaxing spa and wellness treatment.", rating: 4.8, price: 900, timeDuration: "1.5 hours", gender: "female"),
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Service Categories"),
        backgroundColor: Colors.teal,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return GestureDetector(
            onTap: () {
              final selectedProfession = worker.profession;
              final relatedWorkers = workers.where((w) => w.profession == selectedProfession).toList();

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => JobWorkersPage(
                    profession: selectedProfession,
                    workers: relatedWorkers,
                  ),
                ),
              );
            },

            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      worker.image,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    worker.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(worker.profession, style: const TextStyle(fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('₹${worker.price} • ${worker.timeDuration}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
