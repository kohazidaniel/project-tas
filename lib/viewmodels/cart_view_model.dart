import 'package:animations/animations.dart';
import 'package:tas/viewmodels/base_model.dart';

class CartViewModel extends BaseModel {
  final ContainerTransitionType _transitionType =
      ContainerTransitionType.fadeThrough;

  ContainerTransitionType get transitionType => _transitionType;
}
