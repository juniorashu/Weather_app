import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:weather_flutter/additional_item.dart';
import 'package:weather_flutter/apikey.dart';
import 'package:weather_flutter/weatherforecast.dart';
import 'package:http/http.dart' as http;

class Weatherapp extends StatefulWidget {
  const Weatherapp({super.key});
  @override
  State<Weatherapp> createState() => _WeatherappState();
}

class _WeatherappState extends State<Weatherapp> {
  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final cityName = "London"; // No space before "London"
      // Directly use API key

      final res = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$weatherapikey&units=metric",
        ),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != 200) {
        throw "Error: ${data['message']}";
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {  
              
            });
          }, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          // print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          final temp = data['main']['temp'];
          final sky = data['weather'][0]['main'];
          final pressure = data['main']['pressure'];
          final humidity = data['main']['humidity'];
          final windSpeed = data['wind']['speed'];
           DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(data['dt'] * 1000);
           String formatteddate = "${dateTime.minute}:${dateTime.minute.toString().padLeft(2, '0')}";
           print(formatteddate);
                    // print(data["main"]);
          //main card
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                "$temp k",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                sky == "Clouds" || sky == "Rain"
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              Text("$sky", style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ), 
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Weather Forecast",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     children: [
                //       for (int i = 0; i < 5; i++) ...[
                //         //,
                //         ForeCastPerHour(
                //           time: data['dt'].toString(),
                //           temperature: "$sky",
                //           icon:
                //               data['weather'][0]['main'] == "Clouds" ||
                //                       data['weather'][0]['main'] == "Rain"
                //                   ? Icons.cloud
                //                   : Icons.sunny,
                //         ),
                //       ],
                //     ],
                //   ),
                // ),
                SizedBox(
                  height:110  ,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return ForeCastPerHour(
                        time: formatteddate.toString(),
                        temperature: "$sky",
                        icon:
                            data['weather'][0]['main'] == "Clouds" ||
                                    data['weather'][0]['main'] == "Rain"
                                ? Icons.cloud
                                : Icons.sunny,
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Additional Information",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AdditionalItem(
                      icon: Icons.water_drop,
                      label: "Humidty",
                      value: "$humidity",
                    ),
                    AdditionalItem(
                      icon: Icons.air,
                      label: "wind Speed",
                      value: "$windSpeed",
                    ),
                    AdditionalItem(
                      icon: Icons.beach_access,
                      label: "Pressure",
                      value: "$pressure",
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
