import 'package:flutter/material.dart';
import 'package:provider_architecture/provider_architecture.dart';
import 'package:smart_select/smart_select.dart';
import 'package:tas/models/menu_item.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/shared_styles.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/busy_button.dart';
import 'package:tas/ui/widgets/input_field.dart';
import 'package:tas/ui/widgets/note_text.dart';
import 'package:tas/ui/widgets/show_up.dart';
import 'package:tas/viewmodels/restaurant/menu_item_details_view_model.dart';

class MenuItemDetailsView extends StatelessWidget {
  final MenuItem selectedCartItem;
  final bool isUpdating;
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  MenuItemDetailsView({this.selectedCartItem, this.isUpdating = false}) {
    if (isUpdating) {
      this.nameController.text = selectedCartItem.name;
      this.descriptionController.text = selectedCartItem.description;
      this.priceController.text = selectedCartItem.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<MenuItemDetailsViewModel>.withConsumer(
      viewModel: MenuItemDetailsViewModel(selectedMenuItem: selectedCartItem),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            isUpdating ? 'Frissítés' : 'Létrehozás',
            style: TextStyle(color: primaryColor),
          ),
          actions: [
            isUpdating
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: primaryColor,
                    ),
                    onPressed: () async {
                      if (await model.deleteMenuItem()) {
                        Navigator.pop(context);
                      }
                    },
                  )
                : Container()
          ],
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
                          : isUpdating
                              ? NetworkImage(selectedCartItem.photoUrl)
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
                Align(
                  alignment: Alignment.center,
                  child: ShowUp(
                    child: NoteText(
                      model.imageErrorMessage,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                InputField(
                  validationMessage: model.nameErrorMessage,
                  controller: nameController,
                  placeholder: 'Név',
                  nextFocusNode: model.descriptionNode,
                ),
                horizontalSpaceSmall,
                InputField(
                  validationMessage: model.descriptionErrorMessage,
                  controller: descriptionController,
                  placeholder: 'Leírás',
                  fieldFocusNode: model.descriptionNode,
                  nextFocusNode: model.priceNode,
                ),
                horizontalSpaceSmall,
                InputField(
                  validationMessage: model.priceErrorMessage,
                  controller: priceController,
                  placeholder: 'Ár',
                  inputPostfix: 'Ft',
                  fieldFocusNode: model.priceNode,
                  enterPressed: () => model.priceNode.unfocus(),
                ),
                horizontalSpaceSmall,
                Container(
                  decoration: fieldDecortaion,
                  child: SmartSelect<String>.single(
                    title: 'Kategória',
                    placeholder: 'Válassz ki egy kategóriát',
                    modalTitle: 'Kategóriák',
                    value: model.selectedType,
                    choiceItems: [
                      S2Choice<String>(value: 'beer', title: 'Sör'),
                      S2Choice<String>(value: 'wine', title: 'Bor'),
                      S2Choice<String>(value: 'soda', title: 'Üdítő'),
                      S2Choice<String>(value: 'snack', title: 'Sörkorcsolya'),
                    ],
                    modalType: S2ModalType.bottomSheet,
                    choiceType: S2ChoiceType.chips,
                    onChange: (state) => model.setSelectedType(state.value),
                    tileBuilder: (context, state) => S2Tile.fromState(
                      state,
                      isTwoLine: true,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ShowUp(
                    child: NoteText(
                      model.typeErrorMessage,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                BusyButton(
                  title: isUpdating ? 'Frissítés' : 'Létrehozás',
                  busy: model.busy,
                  onPressed: () => model.addMenuItem(
                    name: nameController.text,
                    description: descriptionController.text,
                    price: priceController.text,
                    isUpdating: isUpdating,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
