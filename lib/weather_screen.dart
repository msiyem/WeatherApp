import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<List<Map<String, dynamic>>> getCurrentWeatherAndForecast() async {
    try {
      final cityName = 'Sylhet';
      final urlForecast = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName,BD&appid=$openWeatherAPIKey&units=metric',
      );
      final urlWeather = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName,BD&appid=$openWeatherAPIKey&units=metric',
      );
      final responses = await Future.wait([
        http.get(urlWeather),
        http.get(urlForecast),
      ]);

      final dataWeather = jsonDecode(responses[0].body);
      final dataForecast = jsonDecode(responses[1].body);

      if (responses[0].statusCode != 200) throw dataWeather['message'];
      if (responses[1].statusCode != 200) throw dataForecast['message'];

      return [dataWeather, dataForecast];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                getCurrentWeatherAndForecast();
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeatherAndForecast(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: const CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final weatherData = snapshot.data![0];
          final forecastData = snapshot.data![1];
          final temp = weatherData['main']['temp'];
          final iconText = weatherData['weather'][0]['main'];
          final humidity = weatherData['main']['humidity'];
          final windSpeed = weatherData['wind']['speed'];
          final pressure = weatherData['main']['pressure'];

          IconData icon = Icons.sunny;
          if (iconText == 'Rain') icon = Icons.cloudy_snowing;
          if (iconText == 'Clouds') icon = Icons.cloud;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    surfaceTintColor: Colors.grey,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$temp°C',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(icon, size: 64),
                              const SizedBox(height: 16),
                              Text(iconText, style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 64),
                const Text(
                  ' Weather Forecast',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < 10; i++)
                        (() {
                          IconData icn = Icons.sunny; // default

                          final condition =
                              forecastData['list'][i]['weather'][0]['main'];
                          if (condition == 'Clouds') {
                            icn = Icons.cloud;
                          } else if (condition == 'Rain') {
                            icn = Icons.cloudy_snowing;
                          } else if (condition == 'Clear') {
                            icn = Icons.wb_sunny;
                          }

                          return HourlyForeCastItem(
                            time: forecastData['list'][i]['dt_txt'].substring(
                              11,
                              16,
                            ),
                            icon: icn,
                            temperature:
                                '${forecastData['list'][i]['main']['temp']}°C',
                          );
                        })(),
                      // HourlyForeCastItem(
                      //   time: '03:00',
                      //   icon: Icons.sunny,
                      //   temperature: '300.52',
                      // ),
                      // HourlyForeCastItem(
                      //   time: '06:00',
                      //   icon: Icons.cloud,
                      //   temperature: '302.22',
                      // ),
                      // HourlyForeCastItem(
                      //   time: '09:00',
                      //   icon: Icons.sunny,
                      //   temperature: '300.12',
                      // ),
                      // HourlyForeCastItem(
                      //   time: '12:00',
                      //   icon: Icons.cloudy_snowing,
                      //   temperature: '304.12',
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 64),
                Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItems(
                      icon: Icons.water_drop,
                      text: 'Humidity',
                      value: humidity.toString(),
                    ),
                    AdditionalInfoItems(
                      icon: Icons.air_outlined,
                      text: 'Wind Speed',
                      value: windSpeed.toString(),
                    ),
                    AdditionalInfoItems(
                      icon: Icons.beach_access,
                      text: 'Pressure',
                      value: pressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
