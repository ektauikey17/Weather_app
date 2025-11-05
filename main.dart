import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "5957a7a05071450c82595426250511"; // your key

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light),
      home: WeatherHome(),
    );
  }
}

class WeatherHome extends StatefulWidget {
  @override
  _WeatherHomeState createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {
  TextEditingController cityController = TextEditingController();
  String temperature = "";
  String condition = "";
  String city = "";
  String iconUrl = "";

  Future<void> getWeather() async {
    String cityName = cityController.text.trim();
    if (cityName.isEmpty) return;

    final url =
        "https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$cityName";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        city = data["location"]["name"];
        temperature = "${data["current"]["temp_c"]}°C";
        condition = data["current"]["condition"]["text"];
        iconUrl = "https:${data["current"]["condition"]["icon"]}";
      });
    } else {
      setState(() {
        city = "City not found";
        temperature = "";
        condition = "";
        iconUrl = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8AB6F9),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: "Enter city name",
                labelStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 18),

            ElevatedButton(
              onPressed: getWeather,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8AB6F9),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Get Weather",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),

            const SizedBox(height: 40),

            if (iconUrl.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.network(iconUrl, width: 110),
                    const SizedBox(height: 10),
                    Text(
                      city,
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      temperature,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      condition,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black54),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}