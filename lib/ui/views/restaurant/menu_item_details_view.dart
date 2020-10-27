import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:smart_select/smart_select.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/shared_styles.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:tas/viewmodels/restaurant/restaurant_menu_view_model.dart';

class MenuItemDetailsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RestaurantMenuViewModel>.withConsumer(
      viewModel: RestaurantMenuViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Létrehozás',
            style: TextStyle(color: primaryColor),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          elevation: 1.0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.loose,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 75.0,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: model.imageFile != null
                          ? FileImage(model.imageFile)
                          : null,
                      child: Icon(Icons.photo, color: primaryColor),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 5,
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 20.0,
                        child: IconButton(
                          onPressed: () => model.pickImage(),
                          icon: Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InputField(
                  controller: null,
                  placeholder: 'Név',
                ),
                horizontalSpaceSmall,
                InputField(
                  controller: null,
                  placeholder: 'Leírás',
                ),
                horizontalSpaceSmall,
                InputField(
                  controller: null,
                  placeholder: 'Ár',
                  inputPostfix: 'Ft',
                ),
                horizontalSpaceSmall,
                Container(
                  decoration: fieldDecortaion,
                  child: SmartSelect<String>.single(
                    title: 'Kategória',
                    placeholder: 'Válassz ki egy kategóriát',
                    modalTitle: 'Kategóriák',
                    value: null,
                    choiceItems: [
                      S2Choice<String>(value: 'beer', title: 'Sör'),
                      S2Choice<String>(value: 'wine', title: 'Bor'),
                    ],
                    modalType: S2ModalType.bottomSheet,
                    choiceType: S2ChoiceType.chips,
                    onChange: (state) => {},
                    tileBuilder: (context, state) => S2Tile.fromState(
                      state,
                      isTwoLine: true,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                BusyButton(title: 'Hozzáadás', onPressed: null),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyShapeBorder extends ContinuousRectangleBorder {
  const MyShapeBorder(this.curveHeight);
  final double curveHeight;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) => Path()
    ..lineTo(0, rect.size.height)
    ..quadraticBezierTo(
      rect.size.width / 2,
      rect.size.height + curveHeight * 2,
      rect.size.width,
      rect.size.height,
    )
    ..lineTo(rect.size.width, 0)
    ..close();
}
