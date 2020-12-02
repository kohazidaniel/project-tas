import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:tas/viewmodels/restaurant/restaurant_main_view_model.dart';

import 'indicator.dart';

class TasPieChart extends StatefulWidget {
  final List<Indicator> indicators;
  final List<ChartColorAndValue> chartColorsAndValues;
  final String title;
  final String subtitle;

  TasPieChart({
    this.indicators,
    this.chartColorsAndValues,
    this.title,
    this.subtitle,
  });

  @override
  _TasPieChartState createState() => _TasPieChartState();
}

class _TasPieChartState extends State<TasPieChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Foglalások',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'Napi bontásban',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.7),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                )),
            Row(
              children: [
                Container(
                  width: 225,
                  height: 225,
                  child: PieChart(
                    PieChartData(
                      pieTouchData:
                          PieTouchData(touchCallback: (pieTouchResponse) {
                        setState(() {
                          if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              pieTouchResponse.touchInput is FlPanEnd) {
                            touchedIndex = -1;
                          } else {
                            touchedIndex = pieTouchResponse.touchedSectionIndex;
                          }
                        });
                      }),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 40,
                      sections: showingSections(widget.chartColorsAndValues),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.indicators,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(
    List<ChartColorAndValue> chartColorsAndValues,
  ) {
    return List.generate(chartColorsAndValues.length, (i) {
      ChartColorAndValue chartColorAndValue = chartColorsAndValues[i];

      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 25 : 16;
      final double radius = isTouched ? 60 : 50;
      return PieChartSectionData(
        color: chartColorAndValue.color,
        value: chartColorAndValue.value,
        title: '${chartColorAndValue.value.toInt()}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color(0xffffffff),
        ),
      );
    });
  }
}
