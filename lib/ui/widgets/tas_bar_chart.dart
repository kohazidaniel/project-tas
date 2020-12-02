import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/viewmodels/restaurant/restaurant_main_view_model.dart';

class TasBarChart extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<WeekDayWithValue> weekDayValues;

  TasBarChart({this.title, this.subtitle, this.weekDayValues});

  @override
  _TasBarChartState createState() => _TasBarChartState();
}

class _TasBarChartState extends State<TasBarChart> {
  int touchedIndex;
  int today = DateTime.now().weekday;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 4.0,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    widget.title,
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
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 38,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BarChart(
                        mainBarData(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors:
              isTouched || x + 1 == today ? [Colors.yellow] : [primaryColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 20,
            colors: [primaryColor.withOpacity(0.2)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        return makeGroupData(
          i,
          widget.weekDayValues[i].value,
          isTouched: i == touchedIndex,
        );
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.white,
            tooltipRoundedRadius: 10.0,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String weekDay;
              weekDay = FlutterI18n.translate(
                context,
                'barChartDays.${widget.weekDayValues[group.x.toInt()].weekDayKey}',
              );
              return BarTooltipItem(
                weekDay + '\n' + (rod.y - 1).toInt().toString(),
                TextStyle(
                  color: Colors.black,
                ),
              );
            }),
        touchCallback: (barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (value) => const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          margin: 16,
          getTitles: (double value) {
            return FlutterI18n.translate(
              context,
              'barChartDays.shorten.${widget.weekDayValues[value.toInt()].weekDayKey}',
            );
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }
}
