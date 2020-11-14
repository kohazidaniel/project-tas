import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class CategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String items;
  final Function tap;
  final bool isHome;
  final bool isSelected;

  CategoryCard(
      {Key key,
      @required this.icon,
      @required this.title,
      this.items,
      this.tap,
      this.isHome = false,
      this.isSelected = false})
      : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<CategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.isHome ? () {} : widget.tap,
      child: Card(
        color: widget.isSelected ? Colors.yellow[400] : Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 4.0,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: Icon(
                  widget.icon,
                  color: Theme.of(context).accentColor,
                ),
              ),
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    "${widget.title}",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  widget.items != null
                      ? Text(
                          widget.items +
                              " " +
                              FlutterI18n.translate(context, "item"),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                          ),
                        )
                      : Container(),
                  SizedBox(height: 5),
                ],
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
