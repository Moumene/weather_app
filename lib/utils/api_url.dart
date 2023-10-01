import 'package:weather_app/api/api_key.dart';

String getApiURL(var lat, var lng) {
  return 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lng&appid=$apiKey&units=metric&exclude=minutely';
}
