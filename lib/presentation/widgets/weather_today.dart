import 'package:flutter/material.dart';
import 'package:weather_app/infrastructure/models/weather_model.dart';

class WeatherToday extends StatefulWidget {
  const WeatherToday({
    super.key, 
    required this.weatherModel,
  });

  final WeatherModel weatherModel;

  @override
  State<WeatherToday> createState() => _WeatherTodayState();
}

class _WeatherTodayState extends State<WeatherToday> {
  @override
  Widget build(BuildContext context) {    
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage('https://openweathermap.org/img/wn/${widget.weatherModel.weather![0].icon}@2x.png'),
          fit: BoxFit.contain, // Ajusta la imagen para cubrir todo el Container
        ),
      ),
      child: Column(
        children: [
          Text(
            '${(widget.weatherModel.main!.temp! - 273.15).toStringAsFixed(2)}°',
            style: const TextStyle( fontSize: 84 ),
          ),
          Text(widget.weatherModel.weather![0].description!.toUpperCase()),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextBold(
                textBold: 'Min',
                text: '${(widget.weatherModel.main!.tempMin! - 273.15).toStringAsFixed(2)}°'
              ),
              TextBold(
                textBold: 'Max',
                text: '${(widget.weatherModel.main!.tempMax! - 273.15).toStringAsFixed(2)}°'
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TextBold extends StatelessWidget {
  const TextBold({
    super.key,
    required this.textBold,
    required this.text,
  });

  final String textBold;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(text: '$textBold ', style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: text),
        ],
      ),
    );
  }
}