import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../services/weather_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchInitialWeather();
  }

  void _fetchInitialWeather() {
    _controller.text = "Lahore";
    _searchWeather();
  }

  void _searchWeather() async {
    final city = _controller.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await WeatherApi.fetchWeather(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'City not found or network error';
        _isLoading = false;
        _weather = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff1e1e2c),
        centerTitle: true,
        title: Text(
          'SkyZen',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Color(0xff1e1e2c),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 🔍 Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Search city...',
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.1),
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: TextStyle(color: Colors.white),
                      onSubmitted: (_) => _searchWeather(),
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: _searchWeather,
                  )
                ],
              ),
              SizedBox(height: 30),

              // 🌦️ Display Section
              if (_isLoading) CircularProgressIndicator(color: Colors.white),

              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),

              if (_weather != null) ...[
                // 🌇 City & Temp
                Column(
                  children: [
                    Text(
                      _weather!.cityName,
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      '${_weather!.temperature.toStringAsFixed(1)}°C',
                      style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                    Text(
                      _weather!.description,
                      style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70),
                    ),
                    SizedBox(height: 20),

                    // 🌈 Weather Animation
                    Lottie.asset(
                      'assets/animations/${_weather!.icon}.json',
                      height: 150,
                      repeat: true,
                    ),
                  ],
                ),

                SizedBox(height: 30),

                // 🧊 Glass Cards
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3, // example for 3 past days
                    itemBuilder: (context, index) {
                      return GlassCard(
                        day: ['Yesterday', '2 Days Ago', '3 Days Ago'][index],
                        temperature:
                            '${_weather!.temperature - (index + 1) * 2}°C',
                        icon: _weather!.icon,
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final String day;
  final String temperature;
  final String icon;

  const GlassCard({
    Key? key,
    required this.day,
    required this.temperature,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day,
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
                SizedBox(height: 8),
                Lottie.asset(
                  'assets/animations/$icon.json',
                  height: 50,
                  repeat: true,
                ),
                SizedBox(height: 8),
                Text(
                  temperature,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
