import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  final String baseUrl = "";

  Future<List<Artisan>> fetchArtisans() async {
    final response = await http.get(Uri.parse('$baseUrl/artisans'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Artisan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load artisans');
    }
  }
}

const List<Artisan> placeholderArtisans = [
  Artisan(
    name: 'Chimdimma Chimdiogo Nwobu',
    number: '07062597307',
    email: 'chimdimma.nwobu@ecr-ts.com',
  ),
  Artisan(
    name: 'Chimdimma Chimdiogo Nwobu',
    number: '07062597307',
    email: 'chimdimma.nwobu@ecr-ts.com',
  ),
  Artisan(
    name: 'Chimdimma Chimdiogo Nwobu',
    number: '07062597307',
    email: 'chimdimma.nwobu@ecr-ts.com',
  ),
  Artisan(
    name: 'Chimdimma Chimdiogo Nwobu',
    number: '07062597307',
    email: 'chimdimma.nwobu@ecr-ts.com',
  ),
  Artisan(
    name: 'Chimdimma Chimdiogo Nwobu',
    number: '07062597307',
    email: 'chimdimma.nwobu@ecr-ts.com',
  ),
];

class Artisan {
  final String name;
  final String number;
  final String email;

  const Artisan({
    required this.name,
    required this.number,
    required this.email,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      name: json['name'],
      number: json['number'],
      email: json['email'],
    );
  }
}

class ArtisanScreen extends StatefulWidget {
  const ArtisanScreen({Key? key}) : super(key: key);

  @override
  ArtisanScreenState createState() => ArtisanScreenState();
}

class ArtisanScreenState extends State<ArtisanScreen> {
  final ApiService apiService = ApiService();
  bool useApi = false;

  List<Artisan> artisans = [];

  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchArtisans();
  }

  Future<void> fetchArtisans() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      List<Artisan> fetchedArtisans;
      if (useApi) {
        fetchedArtisans = await apiService.fetchArtisans();
      } else {
        await Future.delayed(Duration(seconds: 1)); // Simulate network delay
        fetchedArtisans = placeholderArtisans;
      }

      setState(() {
        artisans = fetchedArtisans;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interested Artisans'),
      ),
      body: isLoading
          ? _buildPlaceholderList()
          : errorMessage.isNotEmpty
              ? _buildErrorUI(errorMessage)
              : ListView.builder(
                  itemCount: artisans.length,
                  itemBuilder: (context, index) {
                    final artisan = artisans[index];
                    return ArtisanCard(artisan: artisan);
                  },
                ),
    );
  }

  Widget _buildPlaceholderList() {
    // Placeholder UI while loading
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return const ArtisanCard(
          artisan: Artisan(
            name: 'Loading...',
            number: 'Loading...',
            email: 'Loading...',
          ),
        );
      },
    );
  }

  Widget _buildErrorUI(String message) {
    // UI in case of error
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Failed to load artisans: $message'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: fetchArtisans,
          child: const Text('Retry'),
        ),
      ],
    );
  }
}

class ArtisanCard extends StatelessWidget {
  final Artisan artisan;

  const ArtisanCard({required this.artisan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cheemdee',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text('Name: ${artisan.name}'),
              Text('Number: ${artisan.number}'),
              Text('Email: ${artisan.email}'),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Background color
                    ),
                    child: const Text('VIEW PROFILE'),
                  ),
                  const SizedBox(width: 8.0),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('ADD RATING'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
