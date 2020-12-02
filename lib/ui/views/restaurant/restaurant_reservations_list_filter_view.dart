import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:tas/locator.dart';
import 'package:tas/ui/shared/app_colors.dart';
import 'package:tas/ui/shared/ui_helpers.dart';
import 'package:tas/ui/widgets/date_range_select.dart';
import 'package:tas/viewmodels/restaurant/restaurant_reservations_list_view_model.dart';

class RestaurantReservationsListFilterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RestaurantReservationsListViewModel>.reactive(
      viewModelBuilder: () => locator<RestaurantReservationsListViewModel>(),
      disposeViewModel: false,
      builder: (context, model, child) => Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          centerTitle: true,
          title: Text(
            'Szűrőfeltételek',
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom: 8,
                          ),
                          child: Text(
                            FlutterI18n.translate(context, 'status'),
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Column(
                          children: model.statusFilterList
                              .map(
                                (option) => Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16, left: 16),
                                  child: Column(
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0)),
                                          onTap: () =>
                                              model.updateStatusFilterOptions(
                                            option.title,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: Text(
                                                    option.title,
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                Switch(
                                                  activeColor: option.isSelected
                                                      ? primaryColor
                                                      : primaryColor
                                                          .withOpacity(0.6),
                                                  onChanged: (bool value) => model
                                                      .updateStatusFilterOptions(
                                                    option.title,
                                                  ),
                                                  value: option.isSelected,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        verticalSpaceSmall,
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom: 8,
                                ),
                                child: Text(
                                  FlutterI18n.translate(context, 'date'),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: model.filterStartDate != null ||
                                    model.filterEndDate != null,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 20),
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.times),
                                    color: Colors.grey[600],
                                    iconSize: 22.0,
                                    onPressed: () => model.clearDateFilter(),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        verticalSpaceSmall,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DateRangeSelect(
                              startDate: model.filterStartDate,
                              startTap: () => model.selectDate(context, false),
                              endDate: model.filterEndDate,
                              endTap: () => model.selectDate(context, true),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 8,
              ),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Szűrés',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
