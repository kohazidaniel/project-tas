import 'package:flutter/material.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';

class _RatingDialogState extends State<RatingDialog> {
  final _commentController = TextEditingController();
  int _rating = 0;
  FocusNode _commentFocusNode = FocusNode();

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
            _commentFocusNode.requestFocus();
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
                TextFormField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  cursorColor: primaryColor,
                ),
                verticalSpaceTiny,
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
                    widget.onSubmitPressed(_rating, _commentController.text);
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
  final Function onSubmitPressed;
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
