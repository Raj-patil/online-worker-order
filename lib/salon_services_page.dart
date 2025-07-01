import 'package:flutter/material.dart';
import 'booking_page.dart'; // Ensure this exists and accepts the required parameters

class SalonServicesPage extends StatelessWidget {
  final String salonType;

  SalonServicesPage({required this.salonType});

  final List<String> bannerImages = [
    "assets/salon_banner.webp",
    "assets/salon_banner1.jpeg",
    "assets/salon_banner2.jpg",
    "assets/salon_banner3.jpg",
  ];

  final List<Map<String, String>> menServices = [
    {"name": "Hair Cut & Beard Styling", "image": "assets/haircut&beard_styling.jpg"},
    {"name": "Massage", "image": "assets/mens_massage.jpg"},
    {"name": "Manicure & Pedicure", "image": "assets/mens_medicure&pedicure.jpg"},
    {"name": "Facial & Cleaning", "image": "assets/facial&cleaning.jpg"},
    {"name": "Detan", "image": "assets/mens_detan.jpg"},
  ];

  final List<Map<String, String>> womenServices = [
    {"name": "Hair Cut", "image": "assets/haircutting.webp"},
    {"name": "Spa", "image": "assets/womens_spa.jpg"},
    {"name": "Threading & Face Waxing", "image": "assets/threading&facewaxing.webp"},
    {"name": "Waxing", "image": "assets/waxing.jpg"},
    {"name": "Manicure & Pedicure", "image": "assets/womens_medicure&pedicure.jpg"},
    {"name": "Facial", "image": "assets/facial.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> services =
    salonType == "Men's Salon" ? menServices : womenServices;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 180,
            child: PageView.builder(
              itemCount: bannerImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(bannerImages[index]),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            "$salonType Services",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final service = services[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingPage(
                        isSalonBooking: true,
                        salonServiceName: service["name"]!,
                        salonImage: service["image"]!,
                        profession: salonType, // optional: use for Orders grouping
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          service["image"]!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        service["name"]!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
