import 'package:covid_track/model/world_state.dart';
import 'package:covid_track/services/utils/states_services.dart';
import 'package:flutter/material.dart';
import 'package:covid_track/View/countries_list.dart';

import 'package:pie_chart/pie_chart.dart';

class WorldStateScreen extends StatefulWidget {
  const WorldStateScreen({super.key});

  @override
  State<WorldStateScreen> createState() => _WorldStateScreenState();
}

class _WorldStateScreenState extends State<WorldStateScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 3), vsync: this)
        ..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  StatesServices statesServices = StatesServices();

  final colorList = <Color>[
    const Color(0xff1aa260),
    const Color(0xffde5246),
    const Color(0xff4285F4),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder(
            future: statesServices.worldApi(),
            builder: (context, AsyncSnapshot<WorldState> snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              } else {
                return Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  PieChart(
                    dataMap: {
                      'Total': double.parse(snapshot.data!.cases.toString()),
                      'Deaths': double.parse(snapshot.data!.deaths.toString()),
                      'Recovered':
                          double.parse(snapshot.data!.recovered.toString()),
                    },
                    chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true),
                    chartRadius: MediaQuery.of(context).size.width / 2.5,
                    legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.left),
                    chartType: ChartType.ring,
                    animationDuration: const Duration(milliseconds: 1200),
                    colorList: colorList,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  Card(
                    child: Column(
                      children: [
                        ReusableRow(
                            title: 'Total',
                            value:
                                double.parse(snapshot.data!.cases!.toString())),
                        ReusableRow(
                            title: 'Deaths',
                            value: double.parse(
                                snapshot.data!.deaths!.toString())),
                        ReusableRow(
                            title: 'Active',
                            value: double.parse(
                                snapshot.data!.active!.toString())),
                        ReusableRow(
                            title: 'Critical',
                            value: double.parse(
                                snapshot.data!.critical!.toString())),
                        ReusableRow(
                            title: 'Recovered',
                            value: double.parse(
                                snapshot.data!.recovered.toString())),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * .05),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CountriesList()));
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .08,
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 86, 190, 95),
                          borderRadius: BorderRadius.circular(35)),
                      child: const Center(
                          child: Text(
                        'Track Countries',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 25),
                      )),
                    ),
                  )
                ]);
              }
            }),
      ),
    ));
  }
}

class ReusableRow extends StatelessWidget {
  final String title;
  final double value;
  const ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10, bottom: 5),
      child: Column(children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(title), Text(value.toString())]),
        SizedBox(
          height: MediaQuery.of(context).size.height * .02,
        ),
        const Divider()
      ]),
    );
  }
}
