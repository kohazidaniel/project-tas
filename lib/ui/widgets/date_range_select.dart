import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeSelect extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function startTap;
  final Function endTap;

  final DateFormat formatter = new DateFormat.MMMMd('hu');

  DateRangeSelect({
    this.startDate,
    this.endDate,
    this.startTap,
    this.endTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: startDate == null ? Colors.grey[300] : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: startTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 7.5,
                ),
                child: startDate == null
                    ? SizedBox(
                        width: 120,
                        height: 25,
                      )
                    : Text(
                        formatter.format(startDate),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
          Text(
            '-',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: endDate == null ? Colors.grey[300] : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: endTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 7.5,
                ),
                child: endDate == null
                    ? SizedBox(
                        width: 120,
                        height: 25,
                      )
                    : Text(
                        formatter.format(endDate),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
