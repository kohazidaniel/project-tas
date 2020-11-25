import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class DialogRequest {
  final String title;
  final Widget content;
  final String buttonTitle;
  final String cancelTitle;

  DialogRequest({
    @required this.title,
    @required this.content,
    @required this.buttonTitle,
    this.cancelTitle,
  });
}

class DialogResponse {
  final String fieldOne;
  final String fieldTwo;
  final bool confirmed;

  DialogResponse({
    this.fieldOne,
    this.fieldTwo,
    this.confirmed,
  });
}
