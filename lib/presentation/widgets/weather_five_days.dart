import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/config/helpers/open_weather.dart';
import 'package:weather_app/infrastructure/models/weather_model.dart';
class WeatherFiveDays extends StatefulWidget {
  const WeatherFiveDays({
    super.key, 
    required this.lat, 
    required this.lon,
  });
  final double lat;
  final double lon;

  @override
  State<WeatherFiveDays> createState() => _WeatherFiveDaysState();
}

class _WeatherFiveDaysState extends State<WeatherFiveDays> {
  OpenWeather apiOpenWeather = OpenWeather();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {   
    return FutureBuilder(
      future: apiOpenWeather.getWeatherForFiveDays(widget.lat, widget.lon),
      builder: (
        BuildContext context, 
        AsyncSnapshot<List<WeatherModel>?> snapshot){
          if(snapshot.hasData) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final weather = snapshot.data![index];
                final String? icon = weather.weather![0].icon;
                return Column( // ? Agregar container para mantener el diseño.
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network('https://openweathermap.org/img/wn/$icon@2x.png'),
                    Text('${(weather.main!.temp! - 273.15).toStringAsFixed(2)}°'),
                    Text(DateFormat('yy-MM-dd').format(weather.dtTxt!)),
                  ],
                );
              }
            );
          } else {
            return const SizedBox(
              height: 50.0,
              width: 50.0,
              child: Center(
                child: CircularProgressIndicator()
              ),
            );
          }
      },
    );
  }
}