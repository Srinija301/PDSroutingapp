import 'package:flutter/material.dart';
import 'package:pds_route/assistants/requestAssistant.dart';
import 'package:pds_route/custom_widgets/divider.dart';
import 'package:pds_route/dataHandler/appData.dart';
import 'package:pds_route/models/address.dart';
import 'package:pds_route/models/placePredictions.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const String id = 'search_screen';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController pickupTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placePredictionList = [];
  @override
  Widget build(BuildContext context) {
    String placeAddress =
        Provider.of<AppData>(context).pickupLocation.placeName ?? "n/a";
    pickupTextEditingController.text = placeAddress;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 215.0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ]),
              child: Padding(
                padding: EdgeInsets.only(
                    left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 5.0),
                    Stack(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back)),
                        Center(
                          child: Text(
                            "Set Destination",
                            style: TextStyle(
                                fontSize: 18.0, fontFamily: "Brand-Bold"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Image.asset(
                          "images/marker.png",
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                controller: pickupTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Pickup Location",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: [
                        Image.asset(
                          "images/marker.png",
                          height: 16.0,
                          width: 16.0,
                        ),
                        SizedBox(
                          width: 18.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.0),
                              child: TextField(
                                onChanged: (val) {
                                  findPlace(val);
                                },
                                controller: dropOffTextEditingController,
                                decoration: InputDecoration(
                                  hintText: "Destination?",
                                  fillColor: Colors.grey[400],
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(
                                      left: 11.0, top: 8.0, bottom: 8.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //tile for predictions
            (placePredictionList.length > 0)
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        return PredictionTile(
                          placePredictions: placePredictionList[index],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                    ))
                : Container()
          ],
        ),
      ),
    );
  }

  void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyAe0APrNqo0gHypud27iZN9uaQyygizaio&sessiontoken=1234567890&components=country:in";
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
      }
      if (res["status"] == "OK") {
        var predictions = res["predictions"];
        var placesList = (predictions as List)
            .map((e) => PlacePredictions.fromJson(e))
            .toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePredictions placePredictions;

  // ignore: non_constant_identifier_names
  PredictionTile({Key, key, this.placePredictions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        getPlaceAddressDetails(placePredictions.placeId, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        placePredictions.mainText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        placePredictions.secondaryText,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0),
          ],
        ),
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Setting Drop off ... Pleas wait"),
        );
      },
    );
    String placeDetailsUrl =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=ChIJN1t_tDeuEmsRUsoyG83frY4&fields=name,rating,formatted_phone_number&key=AIzaSyAe0APrNqo0gHypud27iZN9uaQyygizaio";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    Navigator.pop(context);
    if (res == "failed") {
      return;
    }
    if (res["status"] == "OK") {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      print(res["result"]["geometry"]);
      //["location"]["lat"];
      print(res["result"]["geometry"]);
      //["location"]["lng"];
      Provider.of<AppData>(context, listen: false)
          .updateDropOffLocationAddress(address);
      print("This is droploc");
      print(address.placeName);
    }
  }
}
