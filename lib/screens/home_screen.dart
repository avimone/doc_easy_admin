import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/models/doctor.dart';
import 'package:doc_easy_admin/providers/booking_provider.dart';
import 'package:doc_easy_admin/providers/vehical_providers.dart';
import 'package:doc_easy_admin/screens/details.dart';
import 'package:doc_easy_admin/screens/verification_doc.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();
  static const routeName = '/homescreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  VehicalProvider dataProvider = new VehicalProvider();
  BookingProvider bookingProvider = new BookingProvider();
  var filteredList = [];
  var selectedCity;
  var cityList = ["Chennai", "Banglore"];
  var time;
  var dropTime;
  var valid = false;
  var validrop = false;
  var dateTimeSet = false;
  var prevPick;
  var prevDrop;
  var invalidDate = false;
  bool _enabled = true;
/*   AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        backgroundColor: Colors.purple[900],
        title: new Text(''),
        actions: [searchBar.getSearchAction(context)]);
  }

  void onSubmitted(String value) {
    setState(() => _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text('You wrote $value!'))));
  } */

  /* _HomeScreenState() {
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        }); 
  }*/

  @override
  void initState() {
    // TODO: implement initState
    requestDocumentStatus(User.shared.id);

    EasyLoading.dismiss();
    selectedCity = "chennai";
    dataProvider.loadVehicals();
    bookingProvider.loadVehicals();
    dataProvider.isLoading = true;
    requestConfig();
    super.initState();
  }

  Future<List<DoctorElement>> filterList(
      var selectedDate, var selectedDate1) async {
    EasyLoading.show(status: "Fetching vehicals for selected date");
    if (bookingProvider.bookingList.length <= 0) {
      await bookingProvider.loadVehicals();
    }
    var selectedPickUpDate = DateTime.parse(selectedDate); // a
    var selectedDropInDate = DateTime.parse(selectedDate1); //b
    if (selectedPickUpDate.isAfter(selectedDropInDate)) {
      print("invalid date");
      filteredList.clear();
      setState(() {
        EasyLoading.dismiss();
        invalidDate = true;
      });
      return [];
    }
    invalidDate = false;
    print("filter process start");
    filteredList.clear();

    filteredList.addAll(dataProvider.vehicalList);
    print(bookingProvider.bookingList);
    var filtered = bookingProvider.bookingList.map((e) {
      print("filter is processing");
      print(e.doctorId);
      //for every booking
      return dataProvider.vehicalList.map((m) {
        print("filtering......");
        //for each vehical
        print(m.doctorId);
        print(e.doctorId.id);
        // ignore: unrelated_type_equality_checks
        if (m.doctorId == e.doctorId.id) {
          print(m.doctorId);
          print(m.name);
          print("-----------------");
          print(e.pickUp);
          print(e.dropIn);
          print("-----------------");
          print("-----------------");
          print(selectedDate);
          print(selectedDate1);
          print("-----------------");
          var pickUpDate = DateTime.parse(e.pickUp); // c
          var dropInDate = DateTime.parse(e.dropIn); // d

          if (selectedPickUpDate.isBefore(pickUpDate) &&
              selectedDropInDate.isBefore(dropInDate) &&
              selectedDropInDate.isAfter(pickUpDate)) {
            filteredList.remove(m);
            return null;
          } else if (selectedPickUpDate.isAfter(pickUpDate) &&
              selectedDropInDate.isBefore(dropInDate)) {
            filteredList.remove(m);

            return null;
          } else if (selectedPickUpDate.isAfter(pickUpDate) &&
              selectedDropInDate.isAfter(dropInDate) &&
              selectedPickUpDate.isBefore(dropInDate)) {
            filteredList.remove(m);

            return null;
          } else if (selectedPickUpDate.isBefore(pickUpDate) &&
              selectedDropInDate.isAfter(dropInDate)) {
            filteredList.remove(m);

            return null;
          } else {
            return m;
          }
        }
      });
    });
    Future.delayed(Duration(seconds: 1), () {
      EasyLoading.dismiss();
      setState(() {});
    });
    print(filtered);
    print("filtered list ${filteredList}");
    print(dataProvider.vehicalList);
  }

  @override
  Widget build(BuildContext context) {
    if (valid && validrop) {
      print("filter called");

      if (prevPick == time && prevDrop == dropTime) {
      } else {
        print("filter condition PASSED");
        prevPick = time;
        prevDrop = dropTime;

        dateTimeSet = true;
        filterList(time, dropTime);
      }
    } else {
      dateTimeSet = false;
      setState(() {});
    }
    return Scaffold(
      /*  appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text("Book A Ride"),
      ), */
      backgroundColor: Color(0xFF363940),
      body: ChangeNotifierProvider.value(
        value: dataProvider,
        child: Consumer<VehicalProvider>(builder: (_, ctl, __) {
          return _buildUI(dataProvider);
        }),
      ),
    );
  }

  Widget _buildUI(VehicalProvider dataProvider) {
    var shimmer = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 3.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.white10,
              enabled: _enabled,
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: Container(
                  margin: EdgeInsets.only(top: 2),
                  child: ListView.builder(
                    itemBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.white.withOpacity(.5),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .13,
                          ),
                          Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(top: 5, bottom: 5, left: 5),
                                color: Colors.grey,
                                width: MediaQuery.of(context).size.width * .23,
                                height:
                                    MediaQuery.of(context).size.height * .11,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 8.0,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    itemCount: 9,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [
        Container(
          decoration: new BoxDecoration(
            color: Colors.white.withOpacity(.9),
            boxShadow: [
              new BoxShadow(
                color: Colors.white10,
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 3),
                    child: Text(
                      "You're in Chennai",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF363940),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              /*   Container(
                height: MediaQuery.of(context).size.height * .1,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: cityList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedCity = cityList[index];
                          });
                        },
                        child: Card(
                          color: selectedCity == cityList[index]
                              ? Color(0xFF363940)
                              : Colors.white,
                          elevation: 5,
                          child: Row(
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.only(left: 3, top: 3, bottom: 3),
                                child: Card(
                                  elevation: 5,
                                  child: Icon(
                                    Icons.location_city,
                                    size: 30,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Text(
                                  cityList[index],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Futura',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Color(0xFFffb423),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ), */
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 3),
                    child: Text(
                      "Choose Service Start Time ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF363940),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: "",
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      selectableDayPredicate: (date) {
                        // Disable weekend days to select from the calendar
                        if (date.weekday == 6 || date.weekday == 7) {
                          return true;
                        }

                        return true;
                      },
                      onChanged: (val) {
                        print("changed");
                        time = val;
                        print(time);
                        if (time.contains(":") && time.contains("-")) {
                          valid = true;

                          bookingProvider.bookingList.clear();
                          setState(() {});
                        }
                        print(valid);
                      },
                      validator: (val) {
                        // print(val);

                        return null;
                      },
                      onSaved: (val) {
                        print("saved");
                        time = val;
                        print(time);
                        if (time.contains(":") && time.contains("-")) {
                          valid = true;

                          bookingProvider.bookingList.clear();
                        }
                        print(valid);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10, bottom: 3),
                    child: Text(
                      "Choose Service End Time ",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Futura',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF363940),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: DateTimePicker(
                      type: DateTimePickerType.dateTimeSeparate,
                      dateMask: 'd MMM, yyyy',
                      initialValue: "",
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      icon: Icon(Icons.event),
                      dateLabelText: 'Date',
                      timeLabelText: "Hour",
                      selectableDayPredicate: (date) {
                        // Disable weekend days to select from the calendar
                        if (date.weekday == 6 || date.weekday == 7) {
                          return true;
                        }

                        return true;
                      },
                      onChanged: (val) {
                        print("changed");
                        dropTime = val;
                        print(dropTime);
                        if (dropTime.contains(":") && dropTime.contains("-")) {
                          validrop = true;

                          bookingProvider.bookingList.clear();
                          setState(() {});
                        }
                        print(validrop);
                      },
                      validator: (val) {
                        // print(val);

                        return null;
                      },
                      onSaved: (val) {
                        print("saved");

                        dropTime = val;
                        print(dropTime);
                        if (dropTime.contains(":") && dropTime.contains("-")) {
                          validrop = true;
                          bookingProvider.bookingList.clear();
                        }
                        print(validrop);
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        User.shared.documentsVerified
            ? Container()
            : InkWell(
                onTap: () {
                  Navigator.popAndPushNamed(context, DocVerification.routeName);
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * .07,
                    child: Card(
                      color: Colors.deepOrange,
                      elevation: 7,
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/upload.png",
                            height: MediaQuery.of(context).size.height * .14,
                            width: 60,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Upload/Verify Documents",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Averta',
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
        dateTimeSet
            ? Expanded(
                child: filteredList.length <= 0
                    ? Center(
                        child: invalidDate
                            ? Text(
                                "Invalid Date !!!",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Averta',
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                width: 150,
                                child: Lottie.asset(
                                    'assets/rive/bike_yellow.json')),
                      )
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            itemCount: filteredList.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  print(time);
                                  if (valid && validrop) {
                                    Navigator.pushNamed(
                                        context, DetailsPage.routeName,
                                        arguments: {
                                          "vehical": filteredList[i],
                                          "index": i,
                                          "pickUp": time,
                                          "dropIn": dropTime
                                        });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Please Select Valid Time")));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          child: Card(
                                            elevation: 7,
                                            child: Row(
                                              children: [
                                                Hero(
                                                  transitionOnUserGestures:
                                                      true,
                                                  tag: "Image${i}",
                                                  child: CachedNetworkImage(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            .14,
                                                    width: 150,
                                                    fit: BoxFit.contain,
                                                    imageUrl: filteredList[i] !=
                                                            null
                                                        ? filteredList[i]
                                                            .coverImage
                                                        : "assets/images/boy.png",
                                                    placeholder: (context,
                                                            url) =>
                                                        Center(
                                                            child:
                                                                new CircularProgressIndicator()),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        new Icon(Icons.error),
                                                  ), /* Image.network(
                                              filteredList[i].coverImage,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .14,width: 150,
                                            ), */
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      filteredList[i].name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'Averta',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${filteredList[i].pricePerHour.toString()}/hr",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'Futura',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .09,
                                                ),
                                                /*  Container(
                                            margin: EdgeInsets.only(right: 9),
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            Color(0xFF363940)),
                                                    textStyle:
                                                        MaterialStateProperty.all(
                                                            TextStyle(
                                                                fontSize: 30))),
                                                child: Text(
                                                  dataProvider.vehicalList[i]
                                                          .available
                                                      ? "Book"
                                                      : "No Available",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Color(0xFFffb423),
                                                  ),
                                                )),
                                          ) */
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ))
            : Expanded(
                child: dataProvider.isLoading
                    ? Center(
                        child: invalidDate
                            ? Text("Invalid Date")
                            : Container(
                                width: 150,
                                child: Lottie.asset(
                                    'assets/rive/bike_yellow.json')),
                      )
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            itemCount: dataProvider.vehicalList.length,
                            itemBuilder: (context, i) {
                              return InkWell(
                                onTap: () {
                                  print(time);
                                  if (valid && validrop) {
                                    /*  Navigator.pushNamed(
                                        context, DetailsPage.routeName,
                                        arguments: {
                                          "vehical":
                                              dataProvider.vehicalList[i],
                                          "index": i
                                        }); */
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Please Select Valid Time")));
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 2),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .15,
                                          child: Card(
                                            elevation: 7,
                                            child: Row(
                                              children: [
                                                Hero(
                                                    transitionOnUserGestures:
                                                        true,
                                                    tag: "Image${i}",
                                                    child: CachedNetworkImage(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              .14,
                                                      width: 150,
                                                      fit: BoxFit.contain,
                                                      imageUrl: dataProvider
                                                              .vehicalList[i]
                                                              .coverImage
                                                              .isNotEmpty
                                                          ? dataProvider
                                                              .vehicalList[i]
                                                              .coverImage
                                                          : "assets/images/boy.png",
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  new CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          new Icon(Icons.error),
                                                    ) /* Image.network(
                                            dataProvider.vehicalList[i].coverImage,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .14,
                                                  width: 150,
                                            ), */
                                                    ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      dataProvider
                                                          .vehicalList[i].name,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'Averta',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: Colors.black54,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${dataProvider.vehicalList[i].pricePerHour.toString()}/hr",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'Futura',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .09,
                                                ),
                                                /*  Container(
                                            margin: EdgeInsets.only(right: 9),
                                            child: ElevatedButton(
                                                onPressed: () {},
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty.all(
                                                            Color(0xFF363940)),
                                                    textStyle:
                                                        MaterialStateProperty.all(
                                                            TextStyle(
                                                                fontSize: 30))),
                                                child: Text(
                                                  dataProvider.vehicalList[i]
                                                          .available
                                                      ? "Book"
                                                      : "No Available",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Futura',
                                                    fontWeight: FontWeight.w700,
                                                    fontStyle: FontStyle.italic,
                                                    color: Color(0xFFffb423),
                                                  ),
                                                )),
                                          ) */
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ))
      ],
    );
  }
}
