import 'package:check_artisan/loginsignupclient/home_Screen.dart';
import 'package:flutter/material.dart';

class Splash4 extends StatelessWidget {
  const Splash4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                const Spacer(),
                Image.asset(
                  'assets/icons/pana.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Have your essential needs met promptly, either immediately or at a scheduled time.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat-Light.ttf',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C6B58),
                    ),
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 32.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xfffefefe),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFF2C6B58),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                        radius: 5,
                        backgroundColor: Color(0xFFD8D8D8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: MediaQuery.of(context).size.height / 2 + 200,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
              child: Image.asset(
                'assets/Buttons/Group 1.png',
                width: 114,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
