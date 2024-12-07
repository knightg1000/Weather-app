import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather.dart';
import '../../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? weather;
  bool isLoading = false;

  // List to store recent searches
  final List<Map<String, dynamic>> recentSearches = [];

  Future<void> getWeather(String city) async {
    try {
      isLoading = true;
      notifyListeners();
      weather = await _weatherService.fetchWeather(city);

      if (weather != null) {
        final now = DateTime.now();
        final formattedDateTime = DateFormat('dd/MM/yyyy HH:mm').format(now);
        addToRecentSearches(
          city: weather!.city,
          temperature: weather!.temperature,
          description: weather!.description,
          dateTime: formattedDateTime,
        );
      }
    } catch (e) {
      weather = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Add a new search to the recent searches list
  void addToRecentSearches({
    required String city,
    required double temperature,
    required String description,
    required String dateTime,
  }) {
    recentSearches.insert(
      0,
      {
        'city': city,
        'temperature': temperature,
        'description': description,
        'dateTime': dateTime,
      },
    );

    // Keep only the 5 most recent searches
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }

    notifyListeners();
  }

  // Update the current weather with the selected city's data from recent searches
  void updateCurrentWeather(Map<String, dynamic> searchData) {
    weather = Weather(
      city: searchData['city'],
      temperature: searchData['temperature'],
      description: searchData['description'],
    );
    notifyListeners();
  }

  // Clear all recent searches
  void clearRecentSearches() {
    recentSearches.clear();
    notifyListeners();
  }
}
