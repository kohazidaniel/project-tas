import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:tas/models/dialog_models.dart';

class DialogService {
  GlobalKey<NavigatorState> _dialogNavigationKey = GlobalKey<NavigatorState>();
  Function(DialogRequest) _showDialogListener;
  Completer<DialogResponse> _dialogCompleter;

  GlobalKey<NavigatorState> get dialogNavigationKey => _dialogNavigationKey;

  void registerDialogListener(Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  Future<DialogResponse> showDialog({
    String title,
    Widget content,
    String buttonTitle = 'Ok',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(DialogRequest(
      title: title,
      content: content,
      buttonTitle: buttonTitle,
    ));
    return _dialogCompleter.future;
  }

  Future<DialogResponse> showConfirmationDialog({
    String title,
    Widget content,
    String confirmationTitle = 'Ok',
    String cancelTitle = 'Cancel',
  }) {
    _dialogCompleter = Completer<DialogResponse>();
    _showDialogListener(
      DialogRequest(
        title: title,
        content: content,
        buttonTitle: confirmationTitle,
        cancelTitle: cancelTitle,
      ),
    );
    return _dialogCompleter.future;
  }

  void dialogComplete(DialogResponse response) {
    _dialogNavigationKey.currentState.pop();
    _dialogCompleter.complete(response);
    _dialogCompleter = null;
  }
}
