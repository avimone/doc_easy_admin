// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, unnecessary_new

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/providers/booking_provider.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class BookingsPage extends StatefulWidget {
  static const routeName = '/booking';

  @override
  _BookingsPageState createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  BookingProvider bookingProvider = new BookingProvider();
  BookingElement current;
  @override
  void initState() {
    // TODO: implement initState
    bookingProvider.id = User.shared.id;
    bookingProvider.loadBookings();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bookingProvider.dispose();
    super.dispose();
  }

  void change(var id, var isCompleted, var isOnGoing, var isYetToStart,
      {var completeTime}) async {
    var params;
    if (isCompleted) {
      params = {
        "isCompleted": isCompleted,
        "isOnGoing": isOnGoing,
        "isYetToStart": isYetToStart,
        "completedTime": DateTime.now().toString()
      };
    } else {
      params = {
        "isCompleted": isCompleted,
        "isOnGoing": isOnGoing,
        "isYetToStart": isYetToStart
      };
    }
    EasyLoading.show(status: "changing status");
    var res = await updateBooking(params, id);
    errDialog(res);
  }

  void errDialog(var response) {
    if (response['success'] == true) {
      EasyLoading.dismiss();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Done")));
    } else {
      EasyLoading.dismiss();
      // ignore: avoid_single_cascade_in_expression_statements
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        headerAnimationLoop: true,
        animType: AnimType.RIGHSLIDE,
        dismissOnBackKeyPress: true,
        dialogBackgroundColor: Colors.transparent,
        borderSide: BorderSide(color: Colors.white),
        // desc: response['message'],
        body: Column(
          children: [
            Container(
              child: Text(
                "Error",
                style: TextStyle(
                    fontFamily: 'Averta',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFF56E39F)),
              ),
            ),
            Text(
              response['message'].toString(),
              style: TextStyle(
                  fontFamily: 'Averta',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: Color(0xFF56E39F)),
            ),
          ],
        ),
        btnOkOnPress: () {},
      )..show();
      //    print(response['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (User.shared.onGoing != null) {
      current = User.shared.onGoing;
    }
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Container(
          margin: EdgeInsets.only(left: 15, top: 50),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Bookings",
                style: TextStyle(
                    fontFamily: 'Averta',
                    fontWeight: FontWeight.w700,
                    fontSize: 27,
                    fontStyle: FontStyle.normal,
                    color: Color(0xFFffb423)),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "These are all of your account related bookings here.",
                style: TextStyle(
                    fontFamily: 'Averta',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontStyle: FontStyle.normal,
                    color: Colors.grey[600]),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.grey,
                indent: 3,
                endIndent: 20,
              ),
              Expanded(
                child: ChangeNotifierProvider.value(
                  value: bookingProvider,
                  child: Consumer<BookingProvider>(builder: (_, ctl, __) {
                    return _buildUI(bookingProvider);
                  }),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildUI(BookingProvider dataProvider) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: dataProvider.isLoading
          ? Align()
          : ListView.builder(
              itemCount: dataProvider.bookingList.length,
              itemBuilder: (context, index) {
                var temp = false;
                if (current != null &&
                    current.id == dataProvider.bookingList[index].id) {
                  print(current.doctorId.name);
                  temp = true;
                }
                DateTime pickUp =
                    DateTime.parse(dataProvider.bookingList[index].pickUp);
                DateTime dropIn =
                    DateTime.parse(dataProvider.bookingList[index].dropIn);
                DateTime bookDate = DateTime.parse(
                    dataProvider.bookingList[index].createdAt.toString());

                return Container(
                    height: MediaQuery.of(context).size.height * .4,
                    margin: EdgeInsets.only(right: 15),
                    child: Card(
                      elevation: 7,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CachedNetworkImage(
                                  height:
                                      MediaQuery.of(context).size.height * .13,
                                  width:
                                      MediaQuery.of(context).size.width * .28,
                                  fit: BoxFit.contain,
                                  imageUrl: dataProvider
                                              .bookingList[index].doctorId !=
                                          null
                                      ? dataProvider.bookingList[index].doctorId
                                          .coverImage
                                      : "",
                                  placeholder: (context, url) => Center(
                                      child: new CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dataProvider
                                              .bookingList[index].doctorId.name
                                              .toString(),
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    dataProvider.bookingList[index].isOnGoing
                                        ? Text(
                                            "OnGoing",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Averta',
                                              fontWeight: FontWeight.w700,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.green,
                                            ),
                                          )
                                        : dataProvider
                                                .bookingList[index].isYetToStart
                                            ? Text(
                                                "UPCOMING",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: 'Averta',
                                                  fontWeight: FontWeight.w700,
                                                  fontStyle: FontStyle.normal,
                                                  color: Colors.blue,
                                                ),
                                              )
                                            : dataProvider.bookingList[index]
                                                    .isCompleted
                                                ? Text(
                                                    "COMPLETED",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: 'Averta',
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: Colors.grey,
                                                    ),
                                                  )
                                                : dataProvider
                                                        .bookingList[index]
                                                        .isCancelled
                                                    ? Text(
                                                        "Cancelled",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontFamily: 'Averta',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontStyle:
                                                              FontStyle.normal,
                                                          color: Colors.red,
                                                        ),
                                                      )
                                                    : Align(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "User Name : ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          dataProvider
                                              .bookingList[index].user.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "PickUp Time : ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd  kk:mm')
                                              .format(pickUp),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "DropIn Time : ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd  kk:mm')
                                              .format(dropIn),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Paid : ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          (dataProvider.bookingList[index]
                                                      .ammount /
                                                  100)
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Booking Date : ",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Averta',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd  kk:mm')
                                              .format(bookDate),
                                          style: TextStyle(
                                            overflow: TextOverflow.clip,
                                            fontSize: 13,
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
                              ],
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                              indent: 3,
                              endIndent: 3,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15),
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 9),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          change(
                                              dataProvider
                                                  .bookingList[index].id,
                                              false,
                                              false,
                                              true);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFF363940)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(fontSize: 30))),
                                        child: Text(
                                          "UPCOMING",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Futura',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.greenAccent,
                                          ),
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 9),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          change(
                                              dataProvider
                                                  .bookingList[index].id,
                                              false,
                                              true,
                                              false);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFF363940)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(fontSize: 30))),
                                        child: Text(
                                          "ONGOING",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Futura',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.yellow,
                                          ),
                                        )),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(right: 9),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          change(
                                              dataProvider
                                                  .bookingList[index].id,
                                              true,
                                              false,
                                              false);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    Color(0xFF363940)),
                                            textStyle:
                                                MaterialStateProperty.all(
                                                    TextStyle(fontSize: 30))),
                                        child: Text(
                                          "COMPLETED",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Futura',
                                            fontWeight: FontWeight.w700,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.red,
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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
                    ));
              }),
    );
  }
}
