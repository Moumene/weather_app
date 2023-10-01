import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/model/weather_data_hourly.dart';
import 'package:weather_app/utils/custom_colors.dart';

class HourlyWeatherWidget extends StatelessWidget {
  final WeatherDataHourly? weatherDataHourly;

  final RxInt cardIndex = WeatherController().getCurrentIndex();

  HourlyWeatherWidget({
    Key? key,
    required this.weatherDataHourly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          alignment: Alignment.topCenter,
          child: const Text("Today", style: TextStyle(fontSize: 20)),
        ),
        const SizedBox(
          height: 10,
        ),
        hourlyList(),
      ],
    );
  }

  Widget hourlyList() {
    return Container(
      height: 150,
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: weatherDataHourly!.hourly.length > 12
            ? 12
            : weatherDataHourly!.hourly.length,
        itemBuilder: (context, index) {
          return hourlyItem(weatherDataHourly!.hourly[index], index);
        },
      ),
    );
  }

  Widget hourlyItem(Hourly hourly, int index) {
    return Obx(
      (() => GestureDetector(
            onTap: () {
              cardIndex.value = index;
            },
            child: Container(
              width: 90,
              margin: const EdgeInsets.only(left: 10, right: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: index == cardIndex.value
                    ? [
                        BoxShadow(
                          color: CustomColors.dividerLine.withAlpha(150),
                          spreadRadius: 1,
                          blurRadius: 30,
                          offset: const Offset(0.5, 0),
                        ),
                      ]
                    : null,
                gradient: cardIndex.value == index
                    ? const LinearGradient(
                        colors: [
                          CustomColors.firstGradientColor,
                          CustomColors.secondGradientColor,
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          Colors.grey.shade300,
                          Colors.grey.shade200,
                        ],
                      ),
              ),
              child: HourlyDetails(
                index: index,
                cardIndex: cardIndex.value,
                temp: weatherDataHourly!.hourly[index].temp!.toInt(),
                timestamp: weatherDataHourly!.hourly[index].dt!,
                weatherIcon: weatherDataHourly!.hourly[index].weather![0].icon!,
              ),
            ),
          )),
    );
  }
}

class HourlyDetails extends StatelessWidget {
  final int temp;
  final int timestamp;
  final String weatherIcon;
  final int index;
  final int cardIndex;

  const HourlyDetails({
    Key? key,
    required this.temp,
    required this.timestamp,
    required this.weatherIcon,
    required this.index,
    required this.cardIndex,
  }) : super(key: key);

  String getTime(final timeStamp) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
    final String formattedDate = DateFormat('jm').format(date);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            getTime(timestamp),
            style: TextStyle(
              color: index == cardIndex
                  ? Colors.white
                  : CustomColors.textColorBlack,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(5),
          child: Image.asset(
            "assets/weather/$weatherIcon.png",
            height: 40,
            width: 40,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Text(
            "$temp°",
            style: TextStyle(
              fontSize: 14,
              color: index == cardIndex
                  ? Colors.white
                  : CustomColors.textColorBlack,
            ),
          ),
        ),
      ],
    );
  }
}
