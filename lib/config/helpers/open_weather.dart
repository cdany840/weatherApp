import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/infrastructure/models/weather_model.dart';

class OpenWeather{
  Uri? link;

  // * Today
  Future<WeatherModel?> getWeatherToday(double lat, double lon) async {
    link = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&cnt=1&appid=586d2ae7c579fc073a27f98d24a38bf4'
    );
    final response = await http.get(link!);
    if(response.statusCode == 200){
      final weather = jsonDecode(response.body)['list'] as List;
      if (weather.isNotEmpty) {
        final fistWeather = WeatherModel.fromJson(weather.first);  
        return fistWeather;
      }      
    }
    return null;
  }

  // * Five Days
  Future<List<WeatherModel>?> getWeatherForFiveDays(double lat, double lon) async {
    link = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=586d2ae7c579fc073a27f98d24a38bf4'
    );
    final response = await http.get(link!);
    final date = DateFormat('yy-MM-dd');
    Map<dynamic, WeatherModel> days = {};
    if(response.statusCode == 200){
      var weatherDays = jsonDecode(response.body)['list'] as List;
      weatherDays = weatherDays
                    .map((popular) => WeatherModel.fromJson(popular))
                    .toList();
      for(final weather in weatherDays){
        if (!days.containsKey(date.format(weather.dtTxt)) && date.format(weather.dtTxt) != date.format(DateTime.now())) {
          days[date.format(weather.dtTxt)] = weather;
        }
      }
      List<MapEntry<dynamic, WeatherModel>> listDays = days.entries.toList();
      return listDays.map((entry) => entry.value).toList();
    }
    return null;
  }

  // * City
  Future<Map<String, dynamic>?> getCityWeather(double lat, double lon) async {
    link = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=586d2ae7c579fc073a27f98d24a38bf4'
    );
    final response = await http.get(link!);
    if(response.statusCode == 200){
      final weather = jsonDecode(response.body)['city'];
      return weather;
    }
    return null;
  }

}