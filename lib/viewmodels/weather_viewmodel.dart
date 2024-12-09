import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/weather.dart';
import '../../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  Weather? weather;
  bool isLoading = false;

  // เก็บรายการที่ค้นหาไว้
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

  // ทำการเพิ่มรายการค้นหาล่าสุดเข้าไปในลิสท์
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

    // เก็บรายการค้นหาล่าสุดไว้ 5 รายการ
    if (recentSearches.length > 5) {
      recentSearches.removeLast();
    }

    notifyListeners();
  }

  // อัพเดทข้อมูลสภาพอากาศจากการค้นหาล่าสุด
  void updateCurrentWeather(Map<String, dynamic> searchData) {
    weather = Weather(
      city: searchData['city'],
      temperature: searchData['temperature'],
      description: searchData['description'],
    );
    notifyListeners();
  }

  // Clear ประวัติการค้นหา
  void clearRecentSearches() {
    recentSearches.clear();
    notifyListeners();
  }
}
