import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/weather_model.dart';
import '../services/weather_api.dart';
import '../utils/weather_animation_helper.dart';
import '../widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Weather? _weather;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller.text = '';
    _searchWeather(city: 'Lahore'); // Default weather on app start
  }

  void _searchWeather({String? city}) async {
    final inputCity = city ?? _controller.text.trim();
    if (inputCity.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final weather = await WeatherApi.fetchWeather(inputCity);
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

  // 🔄 Simulate different past icons for cards
  String getFakePastIcon(int index) {
    final icons = ['02d', '03d', '04d'];
    return icons[index % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // 🔍 Custom Search Bar
              CustomSearchBar(
                controller: _controller,
                focusNode: _focusNode,
                onSearch: _searchWeather,
              ),
              const SizedBox(height: 40),

              // 🌀 Loading Indicator
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              // ❌ Error Message
              else if (_error != null)
                Center(
                  child: Text(
                    _error!,
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                )
              // ✅ Weather Display
              else if (_weather != null)
                Expanded(
                  child: Column(
                    children: [
                      // 🌤️ Weather Animation
                      Lottie.asset(
                        getAnimationForWeather(_weather!.icon),
                        height: 160,
                        repeat: true,
                        fit: BoxFit.cover,
                      ),

                      Text(
                        _weather!.cityName,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_weather!.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _weather!.description,
                        style: const TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 30),

                      // 🧊 Weather Glass Cards
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return GlassCard(
                              day: [
                                'Yesterday',
                                '2 Days Ago',
                                '3 Days Ago'
                              ][index],
                              temperature:
                                  '${(_weather!.temperature - (index + 1) * 2).toStringAsFixed(1)}°C',
                              icon: getFakePastIcon(index),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
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

  static Widget shimmer() => Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white12,
          borderRadius: BorderRadius.circular(20),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Lottie.asset(
                  getAnimationForWeather(icon),
                  height: 50,
                  repeat: true,
                ),
                const SizedBox(height: 8),
                Text(
                  temperature,
                  style: const TextStyle(color: Colors.white, fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
