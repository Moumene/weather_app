import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controller/weather_controller.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String city = "";
  String now = DateFormat("yMMMMd").format(DateTime.now());

  final WeatherController weatherController = Get.put(
    WeatherController(),
    permanent: true,
  );

  @override
  void initState() {
    getAddress(
      weatherController.getLatitude().value,
      weatherController.getLongitude().value,
    );
    super.initState();
  }

  getAddress(lat, lng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(lat, lng, localeIdentifier: "en");
    Placemark place = placemarks[0];
    setState(() {
      city = "${place.locality}, ${place.country}";
      // city = "Algiers, Algeria";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            top: 10,
          ),
          alignment: Alignment.topLeft,
          child: Text(
            city,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(
            left: 20,
            top: 4,
          ),
          alignment: Alignment.topLeft,
          child: Text(
            now,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
