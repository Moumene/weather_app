import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:weather_app/api/fetch_weather.dart';
import 'package:weather_app/model/weather_data.dart';

class WeatherController extends GetxController {
  final RxBool _isLoading = true.obs;
  final RxDouble _latitude = 0.0.obs;
  final RxDouble _longitude = 0.0.obs;
  final RxInt _currentIndex = 0.obs;

  RxBool checkLoading() => _isLoading;
  RxDouble getLatitude() => _latitude;
  RxDouble getLongitude() => _longitude;

  final weatherData = WeatherData().obs;

  @override
  void onInit() {
    if (_isLoading.isTrue) {
      getLocation();
    } else {
      getCurrentIndex();
    }
    super.onInit();
  }

  getLocation() async {
    bool isServiceEnabled;

    isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      return Future.error(
        'Location services are disabled.',
      );
    }

    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();

      if (locationPermission != LocationPermission.whileInUse &&
          locationPermission != LocationPermission.always) {
        return Future.error(
          'Location permissions are denied (actual value: $locationPermission).',
        );
      }
    }

    // get the position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then(
      (value) => {
        _latitude.value = value.latitude,
        _longitude.value = value.longitude,
        FetchWeather().fetchWeatherData(value.latitude, value.longitude).then(
              (value) => {
                weatherData.value = value,
                _isLoading.value = false,
              },
            )
      },
    );
  }

  WeatherData getWeatherData() {
    return weatherData.value;
  }

  RxInt getCurrentIndex() {
    return _currentIndex;
  }
}
