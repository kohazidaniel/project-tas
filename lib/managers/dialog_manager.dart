import 'package:flutter/material.dart';
import 'package:tas/locator.dart';
import 'package:tas/models/dialog_models.dart';
import 'package:tas/services/dialog_service.dart';
import 'package:tas/ui/shared/app_colors.dart';

class DialogManager extends StatefulWidget {
  final Widget child;
  DialogManager({Key key, this.child}) : super(key: key);

  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    super.initState();
    _dialogService.registerDialogListener(_showDialog);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _showDialog(DialogRequest request) {
    var isConfirmationDialog = request.cancelTitle != null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Text(
          request.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: request.content,
        actions: <Widget>[
          if (isConfirmationDialog)
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              splashColor: primaryColor.withOpacity(0.2),
              child: Text(
                request.cancelTitle,
                style: TextStyle(
                  color: primaryColor,
                ),
              ),
              onPressed: () {
                _dialogService.dialogComplete(
                  DialogResponse(confirmed: false),
                );
              },
            ),
          FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            splashColor: primaryColor.withOpacity(0.2),
            child: Text(
              request.buttonTitle,
              style: TextStyle(
                color: primaryColor,
              ),
            ),
            onPressed: () {
              _dialogService.dialogComplete(
                DialogResponse(confirmed: true),
              );
            },
          ),
        ],
      ),
    );
  }
}
