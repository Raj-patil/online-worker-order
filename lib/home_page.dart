import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'booking_page.dart';
import 'categories.dart';
import 'salon.dart' as salon;
import 'salon_services_page.dart' as salon_services_page;
import 'become_worker.dart';
import 'notifications.dart';
import 'settings.dart';
import 'help_support.dart';
import 'terms_conditions.dart';
import 'worker_model.dart';
import 'my_orders_page.dart';
import 'worker_dashboard.dart';
import 'edit_profile.dart'; // <-- Import added for Edit Profile Page
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Junction',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<Worker> allWorkers = [
    Worker(name: "Babysitter", image: "assets/babysitter.jpg", profession: "Child Care", description: "Experienced babysitter available full-time.", rating: 4.7, price: 300, timeDuration: "2-6 hrs", gender: "female"),
    Worker(name: "Photographer", image: "assets/Photographer.jpg", profession: "Event Photography", description: "Capture your moments professionally.", rating: 4.6, price: 1500, timeDuration: "1-4 hrs", gender: "male"),
    Worker(name: "Videographer", image: "assets/Videographers.jpg", profession: "Video Production", description: "Wedding and event video specialist.", rating: 4.8, price: 2000, timeDuration: "3-6 hrs", gender: "male"),
    Worker(name: "Fitness & Yoga", image: "assets/fitness&yoga.jpg", profession: "Personal Trainer", description: "Custom yoga & fitness sessions.", rating: 4.9, price: 500, timeDuration: "1 hr", gender: "female"),
    Worker(name: "DJ Services", image: "assets/dj_services.jpg", profession: "Entertainment", description: "Professional DJ for events.", rating: 4.5, price: 2500, timeDuration: "3 hrs", gender: "male"),
  ];

  List<Worker> _searchResults = [];
  List<Map<String, dynamic>> approvedWorkers = [];

  User? currentUser;
  bool isWorkerApproved = false;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    fetchApprovedWorkers();
    checkWorkerApprovalStatus();
  }

  Future<void> fetchApprovedWorkers() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('worker_request')
          .where('status', isEqualTo: 'approved')
          .get();

      setState(() {
        approvedWorkers = snapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      print("Error fetching approved workers: $e");
    }
  }

  Future<void> checkWorkerApprovalStatus() async {
    if (currentUser == null) return;
    try {
      final doc = await FirebaseFirestore.instance
          .collection('worker_request')
          .where('userId', isEqualTo: currentUser!.uid)
          .where('status', isEqualTo: 'approved')
          .get();

      setState(() {
        isWorkerApproved = doc.docs.isNotEmpty;
      });
    } catch (e) {
      print('Error checking approval: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeContent(
        onSalonExplore: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => salon_services_page.SalonServicesPage(salonType: 'Men\'s Salon')),
          );
        },
        onWorkerTap: (Worker worker) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookingPage(worker: worker)),
          );
        },
      ),
      CategoriesPage(),
      salon.SalonPage(),
      MyOrdersPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text("Task Junction"),
        actions: _buildAppBarActions(),
        backgroundColor: Colors.teal,
      ),
      drawer: _buildDrawer(),
      body: _isSearching ? _buildSearchResults() : _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.cut), label: 'Salon'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'My Orders'),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search for workers...',
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      onChanged: (value) {
        setState(() {
          _searchResults = allWorkers
              .where((worker) => worker.name.toLowerCase().contains(value.toLowerCase()))
              .toList();
        });
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: Icon(_isSearching ? Icons.close : Icons.search),
        onPressed: () => setState(() {
          _isSearching = !_isSearching;
          _searchController.clear();
          _searchResults.clear();
        }),
      ),
    ];
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) return Center(child: Text("Type a name to search."));
    if (_searchResults.isEmpty) return Center(child: Text("No workers found."));
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final worker = _searchResults[index];
        return ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(worker.image)),
          title: Text(worker.name),
          subtitle: Text(worker.profession),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => BookingPage(worker: worker)),
            );
          },
        );
      },
    );
  }

  Widget _buildDrawer() {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid;

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          final userData = snapshot.data?.data() as Map<String, dynamic>? ?? {};
          final name = userData['name'] ?? user?.displayName ?? 'User';
          final email = userData['email'] ?? user?.email ?? 'No email';
          final imageUrl = userData['profileImage'];

          return ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(name),
                accountEmail: Text(email),
                currentAccountPicture: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EditProfilePage()),
                    );
                    setState(() {}); // Force UI refresh
                  },
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircleAvatar(child: CircularProgressIndicator());
                      }

                      final data = snapshot.data?.data() as Map<String, dynamic>? ?? {};
                      final imageUrl = data['profileImage'];

                      return CircleAvatar(
                        backgroundImage: (imageUrl != null && imageUrl.toString().isNotEmpty)
                            ? NetworkImage('$imageUrl?v=${DateTime.now().millisecondsSinceEpoch}')
                            : AssetImage('assets/profile.png') as ImageProvider,

                      );
                    },
                  ),
                ),


                decoration: BoxDecoration(color: Colors.teal),
              ),
              _buildDrawerItem(Icons.notifications, 'Notifications', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationPage()));
              }),
              _buildDrawerItem(Icons.shopping_bag, 'Orders', () {}),
              _buildDrawerItem(Icons.settings, 'Settings', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsPage()));
              }),
              if (isWorkerApproved)
                _buildDrawerItem(Icons.dashboard, 'Worker Dashboard', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => WorkerDashboardPage()));
                }),
              _buildDrawerItem(Icons.storefront, 'Become a Worker', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => BecomeWorkerPage()));
              }),
              _buildDrawerItem(Icons.support_agent, 'Help & Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => HelpSupportPage()));
              }),
              _buildDrawerItem(Icons.article, 'Terms & Conditions', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TermsConditionsPage()));
              }),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}

class HomeContent extends StatelessWidget {
  final VoidCallback onSalonExplore;
  final Function(Worker) onWorkerTap;

  HomeContent({required this.onSalonExplore, required this.onWorkerTap});

  final List<String> sliderImages = [
    'assets/dj_services.jpg',
    'assets/chef.jpeg',
    'assets/security.jpg',
    'assets/caretaker.jpg',
  ];

  final List<Worker> newArrivals = [
    Worker(name: "Babysitter", image: "assets/babysitter.jpg", profession: "Child Care", description: "Experienced babysitter available full-time.", rating: 4.7, price: 300, timeDuration: "2-6 hrs", gender: "female"),
    Worker(name: "Fitness & Yoga", image: "assets/fitness&yoga.jpg", profession: "Personal Trainer", description: "Yoga and fitness expert at home.", rating: 4.8, price: 500, timeDuration: "1 hr", gender: "female"),
    Worker(name: "Photographer", image: "assets/Photographer.jpg", profession: "Photography", description: "Capture memories for any occasion.", rating: 4.5, price: 1500, timeDuration: "3 hrs", gender: "male"),
  ];

  final List<Worker> popularWorkers = [
    Worker(name: "Plumber", image: "assets/plumber.jpg", profession: "Plumbing", description: "Experienced plumber available for all repairs.", rating: 4.6, price: 500, timeDuration: "1-3 hrs", gender: "male"),
    Worker(name: "Mechanic", image: "assets/mechanic.webp", profession: "Vehicle Repairs", description: "Car and bike mechanic services.", rating: 4.7, price: 700, timeDuration: "2-5 hrs", gender: "male"),
    Worker(name: "Developer", image: "assets/developer.jpeg", profession: "Software Development", description: "Custom software development for your needs.", rating: 4.9, price: 1000, timeDuration: "3-6 hrs", gender: "male"),
    Worker(name: "Gardener", image: "assets/gardener.jpeg", profession: "Landscaping", description: "Professional gardening services for your home.", rating: 4.8, price: 400, timeDuration: "1-4 hrs", gender: "male"),
    Worker(name: "Chef", image: "assets/chef.jpeg", profession: "Cooking", description: "Professional chef for events and personal meals.", rating: 5.0, price: 1500, timeDuration: "3-6 hrs", gender: "male"),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 180,
            child: PageView.builder(
              itemCount: sliderImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(sliderImages[index], fit: BoxFit.cover),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text('New Arrivals', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildWorkerList(newArrivals),
          SizedBox(height: 20),
          Text('Popular Workers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          _buildWorkerList(popularWorkers),
        ],
      ),
    );
  }

  Widget _buildWorkerList(List<Worker> workers) {
    return Container(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return GestureDetector(
            onTap: () => onWorkerTap(worker),
            child: Card(
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(worker.image, width: 150, height: 150, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(worker.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
