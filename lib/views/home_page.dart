import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/utils/custom_colors.dart';
import 'package:weather_app/widgets/comfort_level_widget.dart';
import 'package:weather_app/widgets/current_weather_widget.dart';
import 'package:weather_app/widgets/daily_weather_widget.dart';
import 'package:weather_app/widgets/header_widget.dart';
import 'package:weather_app/widgets/hourly_weather_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final WeatherController weatherController = Get.put(
    WeatherController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          (() => weatherController.checkLoading().isTrue
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/clouds.png",
                        width: 200,
                        height: 200,
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                )
              : ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    const HeaderWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    CurrentWeatherWidget(
                      weatherDataCurrent: weatherController
                          .getWeatherData()
                          .getCurrentWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    HourlyWeatherWidget(
                      weatherDataHourly:
                          weatherController.getWeatherData().getHourlyWeather(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    DailyWeatherWidget(
                      weatherDataDaily:
                          weatherController.getWeatherData().getDailyWeather(),
                    ),
                    Container(
                      height: 1,
                      color: CustomColors.dividerLine,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ComfortLevelWidget(
                      weatherDataCurrent: weatherController
                          .getWeatherData()
                          .getCurrentWeather(),
                    ),
                  ],
                )),
        ),
      ),
    );
  }
}
