import 'package:flutter/cupertino.dart';
import 'package:pds_route/models/address.dart';

class AppData extends ChangeNotifier {
  Address pickupLocation, dropOffLocation;

  void updatePickupLocationAddress(Address pickupAddress) {
    pickupLocation = pickupAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Address dropOffAddress) {
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}
