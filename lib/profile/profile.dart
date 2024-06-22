import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 20.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Text(
                'Chimdima C. Nwobu',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            ProfileOption(
              text: 'Edit Profile',
              iconPath:
                  'assets/Buttons/edit.png', // Replace with your custom icon path
              onTap: () {
                // Handle Edit Profile tap
              },
            ),
            const SizedBox(height: 20.0),
            ProfileOption(
              text: 'Change Password',
              iconPath:
                  'assets/Buttons/password.png', // Replace with your custom icon path
              onTap: () {
                // Handle Change Password tap
              },
            ),
            const SizedBox(height: 20.0),
            ProfileOption(
              text: 'Information',
              iconPath:
                  'assets/Buttons/info.png', // Replace with your custom icon path
              onTap: () {
                // Handle Information tap
              },
            ),
            const SizedBox(height: 20.0),
            ProfileOption(
              text: 'Update',
              iconPath:
                  'assets/Buttons/update.png', // Replace with your custom icon path
              onTap: () {
                // Handle Update tap
              },
            ),
            const SizedBox(height: 20.0),
            ProfileOption(
              text: 'Log Out',
              iconPath:
                  'assets/Buttons/logout.png', // Replace with your custom icon path
              onTap: () {
                // Handle Log Out tap
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // Assuming the Profile tab is the fourth one
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String text;
  final String iconPath; // Custom icon path
  final VoidCallback onTap;

  const ProfileOption({
    Key? key,
    required this.text,
    required this.iconPath, // Custom icon path
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60.0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4,
        child: ListTile(
          title: Text(text),
          trailing: Image.asset(iconPath, width: 24, height: 24), // Custom icon
          onTap: onTap,
        ),
      ),
    );
  }
}
