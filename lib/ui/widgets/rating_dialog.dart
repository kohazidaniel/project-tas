import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tas/ui/shared/app_colors.dart';

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;

  List<Widget> _buildStarRatingButtons() {
    List<Widget> buttons = [];

    for (int rateValue = 1; rateValue <= 5; rateValue++) {
      final starRatingButton = IconButton(
          icon: Icon(
            _rating >= rateValue ? Icons.star : Icons.star_border,
            color: widget.starColor,
            size: 35,
          ),
          onPressed: () {
            setState(() {
              _rating = rateValue;
            });
          });
      buttons.add(starRatingButton);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final String commentText =
        _rating >= 4 ? widget.positiveComment : widget.negativeComment;

    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 15),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.description,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStarRatingButtons(),
          ),
          Visibility(
            visible: _rating > 0,
            child: Column(
              children: <Widget>[
                const Divider(),
                FlatButton(
                  child: Text(
                    widget.submitButton,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.accentColor,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onSubmitPressed(_rating);
                  },
                ),
                Visibility(
                  visible: commentText.isNotEmpty,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Text(
                        commentText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: _rating == 0,
            child: FlatButton(
              child: Text(
                widget.alternativeButton,
                style: TextStyle(
                    color: widget.accentColor, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                widget.onAlternativePressed();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String title;
  final String description;
  final String submitButton;
  final String alternativeButton;
  final String positiveComment;
  final String negativeComment;
  final Color starColor;
  final Color accentColor;
  final ValueSetter<int> onSubmitPressed;
  final VoidCallback onAlternativePressed;

  RatingDialog({
    @required this.title,
    @required this.description,
    @required this.onSubmitPressed,
    @required this.submitButton,
    this.accentColor = Colors.black,
    this.starColor = Colors.blue,
    this.alternativeButton = "",
    this.positiveComment = "",
    this.negativeComment = "",
    this.onAlternativePressed,
  });

  @override
  _RatingDialogState createState() => new _RatingDialogState();
}
