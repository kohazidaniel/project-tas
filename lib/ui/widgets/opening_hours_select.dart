import 'package:flutter/material.dart';

class OpeningHoursSelect extends StatelessWidget {
  final TimeOfDay openingTime;
  final TimeOfDay closingTime;
  final Function openingTap;
  final Function closingTap;

  OpeningHoursSelect({
    this.openingTime,
    this.closingTime,
    this.openingTap,
    this.closingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: openingTime == null ? Colors.grey[300] : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: openingTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 7.5,
                ),
                child: openingTime == null
                    ? SizedBox(
                        width: 60,
                        height: 25,
                      )
                    : Text(
                        openingTime.format(context),
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
              color: closingTime == null ? Colors.grey[300] : null,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(5),
              onTap: closingTap,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 7.5,
                ),
                child: closingTime == null
                    ? SizedBox(
                        width: 60,
                        height: 25,
                      )
                    : Text(
                        closingTime.format(context),
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
