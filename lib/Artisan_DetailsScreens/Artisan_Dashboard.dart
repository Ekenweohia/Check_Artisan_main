import 'package:check_artisan/Jobs/Job_list_screen.dart';
import 'package:check_artisan/Jobs/Quote_request_screen.dart';
import 'package:check_artisan/Jobs/reviews_screen.dart';
import 'package:check_artisan/profile/profile.dart';

import 'package:flutter/material.dart';

class ArtisanDashboard extends StatelessWidget {
  const ArtisanDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(''),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArtisanDashboard()));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArtisanDashboard()));
              break;
            case 3:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color(0xFF004D40)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on, color: Color(0xFF004D40)),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build, color: Color(0xFF004D40)),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color(0xFF004D40)),
            label: 'Profile',
          ),
        ],
        selectedItemColor: const Color(0xFF004D40),
        unselectedItemColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back Artisan,',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/Rectangle 444.png',
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/profile_placeholder.png'), // Replace with actual image from profile
                        radius: 40,
                      ),
                      title: Row(
                        children: [
                          const Text(
                            'Cheemdee',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          const SizedBox(width: 30),
                          Row(
                            children: buildStarRating(
                                4), // Replace 4 with actual rating
                          ),
                        ],
                      ),
                      subtitle: const Text(
                        'Event Planners & Caterers',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 70),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  buildCard(
                      context, '0 New Job(s)', Icons.work, 'NewJobsScreen'),
                  buildCard(
                      context, '0 Job Lists', Icons.list, 'JobListsScreen'),
                  buildCard(
                      context, '0 Review(s)', Icons.message, 'ReviewsScreen'),
                  buildCard(context, '0 Quote(s)', Icons.edit, 'QuotesScreen'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildStarRating(int rating) {
    return List<Widget>.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 20,
      );
    });
  }

  Widget buildCard(
      BuildContext context, String title, IconData icon, String routeName) {
    return GestureDetector(
      onTap: () {
        switch (routeName) {
          case 'NewJobsScreen':
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ArtisanDashboard()));
            break;
          case 'JobListsScreen':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => JobListScreen()));
            break;
          case 'ReviewsScreen':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReviewsScreen()));
            break;
          case 'QuotesScreen':
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => QuoteRequestsScreen()));
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 16),
            Text(title),
          ],
        ),
      ),
    );
  }
}
