import 'package:flutter/material.dart';

class ChipList extends StatelessWidget {
  final List<String> menuTypes;
  final String selectedMenuType;
  final Function onPress;
  ChipList({this.menuTypes, this.onPress, this.selectedMenuType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        itemCount: menuTypes.length,
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(top: 10.0),
        itemBuilder: (context, index) {
          String currMenuType = menuTypes[index];
          return InkWell(
            onTap: () => onPress(currMenuType),
            child: Container(
              decoration: BoxDecoration(
                border: currMenuType == selectedMenuType
                    ? Border(
                        bottom: BorderSide(
                          color: Colors.black,
                          width: 2.5,
                        ),
                      )
                    : Border(),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Text(
                    currMenuType,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
