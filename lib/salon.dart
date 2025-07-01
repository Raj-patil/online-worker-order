import 'package:flutter/material.dart';
import 'salon_services_page.dart'; // Using this import correctly

class SalonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Salon Services"),
          bottom: TabBar(
            tabs: [
              Tab(text: "Men's Salon"),
              Tab(text: "Women's Salon"),
            ],
          ),
          backgroundColor: Colors.teal,
        ),
        body: TabBarView(
          children: [
            SalonServicesPage(salonType: "Men's Salon"), // Using SalonServicesPage here
            SalonServicesPage(salonType: "Women's Salon"), // Using SalonServicesPage here
          ],
        ),
      ),
    );
  }
}
