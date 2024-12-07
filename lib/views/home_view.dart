import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import '../../viewmodels/weather_viewmodel.dart';

class HomeView extends StatelessWidget {
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/Sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clear sky':
      case 'sunny':
        return 'assets/Sunny.json';
      case 'overcast clouds':
      case 'cloudy':
      case 'few clouds':
        return 'assets/Cloud.json';
      case 'rain':
      case 'light rain':
      case 'moderate rain':
        return 'assets/Rain.json';
      case 'storm':
      case 'thunderstorm':
      case 'heavy intensity rain':
        return 'assets/Storm.json';
      default:
        return 'assets/Sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = WeatherViewModel();

    return ChangeNotifierProvider(
      create: (_) => weatherViewModel,
      child: Scaffold(
        appBar: AppBar(title: Text('Weather App')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter City Name'),
                onSubmitted: (value) {
                  weatherViewModel.getWeather(value);
                },
              ),

              
              SizedBox(height: 20),
              Expanded(
                child: Consumer<WeatherViewModel>(
                  builder: (_, viewModel, __) {
                    if (viewModel.isLoading) {
                      return Center(child: CircularProgressIndicator());

                    } else if (viewModel.weather != null) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('City: ${viewModel.weather!.city}'),
                          Text('Temperature: ${viewModel.weather!.temperature}°C'),
                          Text('${viewModel.weather!.description}'),
                          SizedBox(
                            height: 200,
                            child: Lottie.asset(getWeatherAnimation(viewModel.weather!.description)),
                          ),
                          SizedBox(height: 20),
                          Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: ListView.builder(
                              itemCount: viewModel.recentSearches.length,
                              itemBuilder: (context, index) {
                                final item = viewModel.recentSearches[index];
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  child: ListTile(
                                    title: Text(item['city']),
                                    subtitle: Text(
                                      'Temp: ${item['temperature']}°C, ${item['description']}\n${item['dateTime']}',
                                    ),
                                    onTap: () {
                                      // อัปเดตข้อมูลเมื่อคลิกที่รายการ
                                      viewModel.updateCurrentWeather(item);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
        // ดักกรณีไม่มีชื่อเมือง หรือชื่อผิด
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Enter a valid city name')),
            
            SizedBox(height: 20),
            Text('Recent Searches', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.recentSearches.length,
                itemBuilder: (context, index) {
                  final item = viewModel.recentSearches[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(item['city']),
                      subtitle: Text(
                        'Temp: ${item['temperature']}°C, ${item['description']}\n${item['dateTime']}',
                      ),
                      onTap: () {
                        // อัปเดตข้อมูลเมื่อคลิกที่รายการ
                        viewModel.updateCurrentWeather(item);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
