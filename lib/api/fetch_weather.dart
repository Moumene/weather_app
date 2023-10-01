import 'dart:convert';

import 'package:weather_app/model/weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_data_current.dart';
import 'package:weather_app/model/weather_data_daily.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import 'package:weather_app/utils/api_url.dart';

class FetchWeather {
  WeatherData? weatherData;

  Future<WeatherData> fetchWeatherData(double lat, double lng) async {
    var response = await http.get(Uri.parse(getApiURL(lat, lng)));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      var data = WeatherData(
        WeatherDataCurrent.fromJson(json),
        WeatherDataHourly.fromJson(json),
        WeatherDataDaily.fromJson(json),
      );
      return data;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
