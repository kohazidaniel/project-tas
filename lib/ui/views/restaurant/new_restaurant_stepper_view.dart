import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/category_card.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:tas/ui/widgets/note_text.dart';
import 'package:tas/ui/widgets/opening_hours_select.dart';
import 'package:tas/ui/widgets/show_up.dart';
import 'package:tas/viewmodels/restaurant/new_restaurant_stepper_view_model.dart';

List categories = [
  {"name": "Sörözõ", "icon": FontAwesomeIcons.beer, "slug": "BEER"},
  {"name": "Kávézó", "icon": FontAwesomeIcons.coffee, "slug": "CAFE"},
  {"name": "Bisztró", "icon": FontAwesomeIcons.utensils, "slug": "BISTRO"},
  {"name": "Borozó", "icon": FontAwesomeIcons.wineGlass, "slug": "WINE"}
];

class NewRestaurantStepperView extends StatelessWidget {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  NewRestaurantStepperView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewRestaurantStepperViewModel>.reactive(
      viewModelBuilder: () => NewRestaurantStepperViewModel(),
      builder: (context, model, child) => Scaffold(
          body: new WillPopScope(
        child: new Material(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: new ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 25, left: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.hurray',
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.new_place_on_sight',
                        ),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                new Stepper(
                  physics: ClampingScrollPhysics(),
                  steps: [
                    new Step(
                      title: Text(FlutterI18n.translate(
                        context,
                        'new_restaurant_stepper.name',
                      )),
                      isActive: true,
                      state: StepState.indexed,
                      content: InputField(
                        controller: nameController,
                        placeholder: FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.name',
                        ),
                        validationMessage: model.restaurantNameErrorMessage,
                        enterPressed: () => model.onStepContinue(),
                        nextFocusNode: model.descriptionNode,
                      ),
                    ),
                    new Step(
                      title: Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.description',
                        ),
                      ),
                      isActive: true,
                      state: StepState.indexed,
                      content: InputField(
                        controller: descriptionController,
                        placeholder: FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.description',
                        ),
                        validationMessage:
                            model.restaurantDescriptionErrorMessage,
                        enterPressed: () => model.onStepContinue(),
                        fieldFocusNode: model.descriptionNode,
                      ),
                    ),
                    new Step(
                      title: Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.type',
                        ),
                      ),
                      isActive: true,
                      state: StepState.indexed,
                      content: Column(
                        children: [
                          Container(
                            height: 65.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                                  categories == null ? 0 : categories.length,
                              itemBuilder: (BuildContext context, int index) {
                                Map cat = categories[index];
                                return CategoryCard(
                                  icon: cat['icon'],
                                  title: cat['name'],
                                  isSelected:
                                      model.selectedTypes.contains(cat['slug']),
                                  tap: () =>
                                      model.addToSelectedTypes(cat['slug']),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ShowUp(
                              child: NoteText(
                                model.restaurantTypeErrorMessage,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          verticalSpaceTiny,
                        ],
                      ),
                    ),
                    new Step(
                      title: Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.add_photo',
                        ),
                      ),
                      isActive: true,
                      state: StepState.indexed,
                      content: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 3.2,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: model.imageFile == null
                                  ? Container(
                                      color: Colors.grey[200],
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(Icons.add_a_photo),
                                        onPressed: () => model.pickImage(),
                                      ),
                                    )
                                  : Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.file(
                                          model.imageFile,
                                          fit: BoxFit.cover,
                                        ),
                                        IconButton(
                                          color: Colors.white,
                                          icon: Icon(Icons.add_a_photo),
                                          onPressed: () => model.pickImage(),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ShowUp(
                              child: NoteText(
                                model.restaurantImageErrorMessage,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          verticalSpaceTiny,
                        ],
                      ),
                    ),
                    new Step(
                      title: Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.add_address',
                        ),
                      ),
                      isActive: true,
                      state: StepState.indexed,
                      content: InputField(
                        controller: model.addressController,
                        placeholder: FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.address',
                        ),
                        validationMessage: model.restaurantAddressErrorMessage,
                        isLocation: true,
                        getLocation: () => model.getCurrentPosition(),
                        enterPressed: () => model.onStepContinue(),
                        fieldFocusNode: model.addressNode,
                      ),
                    ),
                    new Step(
                      title: Text(
                        FlutterI18n.translate(
                          context,
                          'new_restaurant_stepper.opening_hours',
                        ),
                      ),
                      isActive: true,
                      state: StepState.indexed,
                      content: Column(
                        children: [
                          OpeningHoursSelect(
                            closingTime: model.closingTime,
                            openingTime: model.openingTime,
                            closingTap: () => model.selectTime(
                              context: context,
                              isClosingTime: true,
                            ),
                            openingTap: () => model.selectTime(
                              context: context,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: ShowUp(
                              child: NoteText(
                                model.openingHoursErrorMessage,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          verticalSpaceTiny,
                        ],
                      ),
                    ),
                  ],
                  type: StepperType.vertical,
                  currentStep: model.currStep,
                  controlsBuilder: (context, {onStepCancel, onStepContinue}) =>
                      BusyButton(
                    title: model.currStep == model.totalSteps
                        ? FlutterI18n.translate(
                            context,
                            'new_restaurant_stepper.create',
                          )
                        : FlutterI18n.translate(
                            context,
                            'new_restaurant_stepper.next_step',
                          ),
                    onPressed: onStepContinue,
                    busy: model.busy,
                  ),
                  onStepContinue: () {
                    if (model.currStep == model.totalSteps) {
                      model.createRestaurant(
                        nameController.text,
                        descriptionController.text,
                        context,
                      );
                    } else {
                      if (model.currStep == 0)
                        model.descriptionNode.requestFocus();
                      if (model.currStep == 1) model.descriptionNode.unfocus();
                      if (model.currStep == 3) model.addressNode.requestFocus();
                      if (model.currStep == 4) model.addressNode.unfocus();
                      model.onStepContinue();
                    }
                  },
                  onStepTapped: (step) {
                    model.onStepTapped(step);
                  },
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => model.onStepCancel(),
      )),
    );
  }
}
