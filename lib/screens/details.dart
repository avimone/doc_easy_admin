import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/models/doctor.dart';
import 'package:doc_easy_admin/providers/booking_provider.dart';
import 'package:doc_easy_admin/screens/verification_doc.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DetailsPage extends StatefulWidget {
  static const routeName = '/details';

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  DoctorElement vehical;
  int days = 0;
  var hours = 0;
  DateTime pickUp;
  DateTime dropIn;
  var total;
  var index;
  var difference;
  var available = true;
  var isLoading = true;
  var _razorpay = Razorpay();
  var loadingText = "";
  var checkBox = true;
  var booked = false;
  BookingProvider bookingProvider = new BookingProvider();

  Future<void> preCheck() async {
    setState(() {
      isLoading = true;
      loadingText = "Checking Availablity";
    });
    EasyLoading.show(status: loadingText);
    if (bookingProvider.bookingList.length <= 0) {
      await bookingProvider.loadVehicals();
    }

// check if scooty is available at choosen time once more

    bookingProvider.bookingList.map((e) {
      print("filter is processing");
      print(e.doctorId);
      //for every booking

      print("filtering......");
      //for one vehical
      if (vehical.doctorId == e.doctorId) {
        print(vehical.doctorId);
        print(vehical.name);
        print("-----------------");
        print(e.pickUp);
        print(e.dropIn);
        print("-----------------");
        print("-----------------");
        print(pickUp);
        print(dropIn);
        print("-----------------");
        var pickUpDate = DateTime.parse(e.pickUp); // c
        var dropInDate = DateTime.parse(e.dropIn); // d

        if (pickUp.isBefore(pickUpDate) &&
            dropIn.isBefore(dropInDate) &&
            dropIn.isAfter(pickUpDate)) {
          available = false;
          return null;
        } else if (pickUp.isAfter(pickUpDate) && dropIn.isBefore(dropInDate)) {
          available = false;
          return null;
        } else if (pickUp.isAfter(pickUpDate) &&
            dropIn.isAfter(dropInDate) &&
            pickUp.isBefore(dropInDate)) {
          available = false;

          return null;
        } else if (pickUp.isBefore(pickUpDate) && dropIn.isAfter(dropInDate)) {
          available = false;

          return null;
        } else {
          return null;
        }
      }
    });
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
      /*  EasyLoading.dismiss();
      setState(() {
        isLoading = false;
      }); */
    });
    print(available);
  }

  //////////////////////////////////////////////////////////
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(response);
    setState(() {
      isLoading = true;
      loadingText = "verifing payment";
    });
    var parameters = {
      "razorpay_payment_id": response.paymentId,
      "razorpay_order_id": response.orderId,
      "razorpay_signature": response.signature
    };
    var res = await confirmPayment(parameters);
    setState(() {
      booked = true;
    });
    // errDialog(res);
    if (res['success']) {
      EasyLoading.dismiss();
      /*  Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentSuccess(
                address: res['address'],
                ammount: res['ammount'],
                days: res['days'],
                hours: res['hours'],
                order_id: res['orderId'],
                pickUp: res['pickUp'],
                price_days: res['price_days'],
                price_hours: res['price_hours'],
                discount: res['discount'],
                dropIn: res['dropIn'],
                time: res['time'],
                vName: vehical.name,
              ))); */
    } else {}
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print(response);
    setState(() {
      isLoading = false;
    });
    EasyLoading.dismiss();
    print("faild");
    // Do something when payment fails
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response);
    setState(() {
      isLoading = false;
    });
    EasyLoading.dismiss();
    // Do something when an external wallet is selected
  }

  void errDialog(var response) {
    setState(() {
      isLoading = true;
    });
    EasyLoading.dismiss();
    AwesomeDialog(
      context: context,
      dialogType: response['success'] ? DialogType.SUCCES : DialogType.ERROR,
      headerAnimationLoop: true,
      animType: AnimType.RIGHSLIDE,
      dismissOnBackKeyPress: true,
      dialogBackgroundColor: Colors.transparent,
      borderSide: BorderSide(color: Colors.white),
      // desc: response['message'],
      body: Column(
        children: [
          Container(
            child: response['success']
                ? Text(
                    "Success",
                    style: TextStyle(
                        fontFamily: 'Averta',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: Color(0xFF56E39F)),
                  )
                : Text(
                    "Error",
                    style: TextStyle(
                        fontFamily: 'Averta',
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        color: Color(0xFF56E39F)),
                  ),
          ),
          Container(
            child: Text(
              response['message'],
              style: TextStyle(
                  fontFamily: 'Averta',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  fontStyle: FontStyle.normal,
                  color: Color(0xFF56E39F)),
            ),
          ),
        ],
      ),
      btnOkOnPress: () async {},
    )..show();
  }

  void initRazor() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void createOrder() async {
    if (available) {
      var res = await requestStatus(vehical.doctorId);
      if (res["success"] == true) {
        available = !res["process"];
      }
    }
    if (available) {
      setState(() {
        isLoading = true;
      });
      var parameters = {
        "userId": User.shared.id,
        "doctorId": vehical.doctorId,
        "pickUpTime": pickUp.toString(),
        "dropInTime": dropIn.toString(),
        "address": "senthamil nager",
      };
      var response = await createOrderRazorPay(parameters);
      if (response['success'] == true) {
        var options = response['option'];
        print("here");
        print(options);

        _razorpay.open(options);

        //  print(_razorpay);
      } else {
        errDialog(response);
      }
    } else {
      print("another booking done");
      EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Someone else Just Book this one !!!")));
    }
  }

  /////////////////////////////////////////////////////////
  @override
  void initState() {
    // TODO: implement initState
    initRazor();

    bookingProvider.loadVehicals();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    dynamic args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      vehical = args['vehical'];
      index = args['index'];
      pickUp = DateTime.parse(args['pickUp']);
      dropIn = DateTime.parse(args['dropIn']);
      var diffInMin = dropIn.difference(pickUp).inMinutes.ceil();
      difference = dropIn.difference(pickUp).inHours.ceil();
      print("-------------");
      print(diffInMin);
      print((diffInMin / 60).ceil());
      print(difference);
      print("-------------");
      difference = (diffInMin / 60).ceil();

      days = (difference / 24).floor();
      hours = (difference - (24 * days));
    }
    print(days);
    print(hours);
    total = days * vehical.pricePerDay + hours * vehical.pricePerHour;
    print(total);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .07,
          child: ElevatedButton(
              onPressed: () {
                if (User.shared.documentsVerified && booked == false) {
                  if (checkBox) {
                    preCheck().then((value) {
                      createOrder();
                    });
                  } else if (booked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("You already booked.")));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "Please accept Terms and conditions to use of our services.")));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Please verify your account by submitting documents.")));
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF363940)),
                  textStyle:
                      MaterialStateProperty.all(TextStyle(fontSize: 30))),
              child: Text(
                booked
                    ? "Booked"
                    : vehical.available
                        ? "Book for ${total}₹"
                        : "No Available",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Futura',
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  color: Colors.blue[200],
                ),
              )),
        ),
        elevation: 0,
      ),
      backgroundColor: Colors.black87,
      body: AbsorbPointer(
        absorbing: isLoading,
        child: Column(
          children: [
            Center(
              child: Hero(
                transitionOnUserGestures: true,
                tag: "Image${index}",
                child: Container(
                  margin: EdgeInsets.only(top: 25),
                  child: CachedNetworkImage(
                    width: MediaQuery.of(context).size.width * .3,
                    height: MediaQuery.of(context).size.height * .2,
                    fit: BoxFit.contain,
                    imageUrl: vehical != null
                        ? vehical.imageUrls
                        : "https://www.gadgetspidy.com/petroleum_images/No_Image_Available.png",
                    placeholder: (context, url) =>
                        Center(child: new CircularProgressIndicator()),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),
                ), /* Image.network(
                  vehical.imageUrls,
                  width: MediaQuery.of(context).size.width ,
                  height: MediaQuery.of(context).size.height * .43,
                ), */
              ),
            ),
            Text(
              vehical.name,
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Averta',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
            ),
            Text(
              vehical.designation,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Averta',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  /*   borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(23.0),
                      topRight: Radius.circular(23.0)), */
                  color: Colors.white.withOpacity(.9),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Specialization :",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              vehical.name,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 7,
                        ),
                        Row(
                          children: [
                            Text(
                              "charges :",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "${vehical.pricePerHour.toString()}/hr ,",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "${vehical.pricePerDay.toString()}/day",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Divider(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Pick Up Time",
                                  style: TextStyle(
                                    fontSize: 21,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              pickUp.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 17,
                            ),
                            Text(
                              "Drop In Time",
                              style: TextStyle(
                                fontSize: 21,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(
                              height: 13,
                            ),
                            Text(
                              dropIn.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            Text(
                              "${days} days and ${hours} hours",
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Averta',
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                                color: Colors.blue,
                              ),
                            ),
                            User.shared.documentsVerified
                                ? Container()
                                : InkWell(
                                    onTap: () {
                                      Navigator.popAndPushNamed(
                                          context, DocVerification.routeName,
                                          arguments: {"skip": false});
                                    },
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .07,
                                        child: Card(
                                          color: Colors.deepOrange,
                                          elevation: 7,
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/upload.png",
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .14,
                                                width: 60,
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
                                                    "Upload/Verify Documents",
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
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                            Row(
                              children: [
                                Checkbox(
                                    value: checkBox,
                                    onChanged: (val) {
                                      setState(() {
                                        checkBox = !checkBox;
                                      });
                                    }),
                                Text(
                                  "I agree ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  "Terms and Condition ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.blue,
                                  ),
                                ),
                                Text(
                                  "of Doc Easy",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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
