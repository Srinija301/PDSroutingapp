import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pds_route/assistants/requestAssistant.dart';
import 'package:pds_route/dataHandler/appData.dart';
import 'package:pds_route/models/address.dart';
import 'package:pds_route/models/directDetails.dart';
import 'package:provider/provider.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAe0APrNqo0gHypud27iZN9uaQyygizaio";
    var response = await RequestAssistant.getRequest(url);

    if (response != "failed") {
      //placeAddress = response["results"][0]["formatted_address"];
      st1 = response["results"][0]["address_components"][4]["long_name"];
      st2 = response["results"][0]["address_components"][7]["long_name"];
      st3 = response["results"][0]["address_components"][6]["long_name"];
      st4 = response["results"][0]["address_components"][7]["long_name"];
      placeAddress = st1 + ", " + st2 + ", " + st3 + ", " + st4 + ", ";

      Address userPickupAddress = new Address();
      userPickupAddress.longitude = position.longitude;
      userPickupAddress.latitude = position.latitude;
      userPickupAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickupLocationAddress(userPickupAddress);
    }
    return placeAddress;
  }

  static Future<DirectionDetails> obtainPlaceDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionUrl =
        "https://maps.googleapis.com/maps/api/directions/json?+origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}+&key=AIzaSyAe0APrNqo0gHypud27iZN9uaQyygizaio";
    var res = await RequestAssistant.getRequest(directionUrl);
    if (res == "failed") {
      return null;
    }

    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"]["0"]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"]["0"]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"]["0"]["distance"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"]["0"]["distance"]["value"];

    return directionDetails;
  }
}
