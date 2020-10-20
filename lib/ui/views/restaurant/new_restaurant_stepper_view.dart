import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:tas/viewmodels/restaurant/new_restaurant_stepper_view_model.dart';

class NewRestaurantStepperView extends StatelessWidget {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<NewRestaurantStepperViewModel>.withConsumer(
      viewModel: NewRestaurantStepperViewModel(),
      builder: (context, model, child) => Scaffold(
          body: new WillPopScope(
        child: new Material(
          child: Container(
            child: new ListView(children: <Widget>[
              new Stepper(
                steps: [
                  new Step(
                    title: const Text('Vendéglátóhely neve'),
                    isActive: true,
                    state: StepState.indexed,
                    content: InputField(
                      controller: nameController,
                      placeholder: 'Név',
                      validationMessage: model.restaurantNameErrorMessage,
                    ),
                  ),
                  new Step(
                    title: const Text('Vendéglátóhely telefonszáma'),
                    isActive: true,
                    state: StepState.indexed,
                    content: InputField(
                      controller: phoneController,
                      placeholder: '36301234567',
                      validationMessage: model.restaurantPhoneErrorMessage,
                    ),
                  ),
                  new Step(
                    title: const Text('Vendéglátóhely leírása'),
                    isActive: true,
                    state: StepState.indexed,
                    content: InputField(
                      controller: phoneController,
                      placeholder: '36301234567',
                      validationMessage: model.restaurantPhoneErrorMessage,
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
                        onPressed: onStepContinue),
                onStepContinue: () {
                  if (model.currStep == model.totalSteps) {
                    model.createRestaurant(
                      nameController.text,
                      phoneController.text,
                    );
                  } else {
                    model.onStepContinue();
                  }
                },
                onStepTapped: (step) {
                  model.onStepTapped(step);
                },
              ),
            ]),
          ),
        ),
        onWillPop: () async => model.onStepCancel(),
      )),
    );
  }
}
