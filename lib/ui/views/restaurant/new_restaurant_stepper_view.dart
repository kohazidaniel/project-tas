import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/category_card.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:tas/ui/widgets/note_text.dart';
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
    return ViewModelProvider<NewRestaurantStepperViewModel>.withConsumer(
      viewModel: NewRestaurantStepperViewModel(),
      builder: (context, model, child) => Scaffold(
          body: new WillPopScope(
        child: new Material(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: new ListView(
              children: <Widget>[
                new Stepper(
                  physics: ClampingScrollPhysics(),
                  steps: [
                    new Step(
                      title: const Text('Név'),
                      isActive: true,
                      state: StepState.indexed,
                      content: InputField(
                        controller: nameController,
                        placeholder: 'Név',
                        validationMessage: model.restaurantNameErrorMessage,
                        enterPressed: () => model.onStepContinue(),
                      ),
                    ),
                    new Step(
                      title: const Text('Leírás'),
                      isActive: true,
                      state: StepState.indexed,
                      content: InputField(
                        controller: descriptionController,
                        placeholder: 'Leírás',
                        validationMessage:
                            model.restaurantDescriptionErrorMessage,
                        enterPressed: () => model.onStepContinue(),
                      ),
                    ),
                    new Step(
                      title: const Text('Típus'),
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
                      title: const Text('Kép hozzáadása'),
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
                      title: const Text('Cím megadása'),
                      isActive: true,
                      state: StepState.indexed,
                      content: InputField(
                        controller: model.addressController,
                        placeholder: 'Cím',
                        validationMessage: model.restaurantAddressErrorMessage,
                        isLocation: true,
                        getLocation: () => model.getCurrentPosition(),
                        enterPressed: () => model.onStepContinue(),
                      ),
                    ),
                  ],
                  type: StepperType.vertical,
                  currentStep: model.currStep,
                  controlsBuilder: (context, {onStepCancel, onStepContinue}) =>
                      BusyButton(
                    title: model.currStep == model.totalSteps
                        ? 'Létrehozás'
                        : 'Tovább',
                    onPressed: onStepContinue,
                    busy: model.busy,
                  ),
                  onStepContinue: () {
                    if (model.currStep == model.totalSteps) {
                      model.createRestaurant(
                        nameController.text,
                        descriptionController.text,
                      );
                    } else {
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
