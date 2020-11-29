class RestaurantReservationsListFilterOptions {
  RestaurantReservationsListFilterOptions({
    this.title = '',
    this.filterValue,
    this.isSelected = false,
  });

  final String title;
  final String filterValue;
  bool isSelected;
}
