import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/screens/nav_bar.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Refund extends StatefulWidget {
  BookingElement booking;
  var refund;
  var hours;
  Refund({this.booking, this.refund, this.hours});

  @override
  _RefundState createState() => _RefundState();
}

class _RefundState extends State<Refund> {
  var title = "REFUND REQUEST";
  var ccompleted = false;
  void submit() async {
    EasyLoading.show(status: "sending request");

    var parameters = {"passwordOld": User.shared.password};
    var response = await cancelBooking(parameters, widget.booking.id);
    if (response['success']) {
      setState(() {
        title = "REFUND INITIATED";
        ccompleted = true;
      });
      EasyLoading.dismiss();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response['message'])));
    }
  }

  @override
  Widget build(BuildContext context) {
    var charge = int.parse(widget.refund.toString());
    var finalAmount = ((widget.booking.ammount / 100) * (charge / 100));
    var cancelCharge = ((widget.booking.ammount / 100) - finalAmount);
    return Scaffold(
      backgroundColor: ccompleted ? Colors.blueAccent : Colors.amberAccent,
      body: Column(
        children: [
          SizedBox(
            height: 70,
          ),
          Icon(
            Icons.check_circle,
            color: Colors.white,
            size: 70,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Futura',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              color: Colors.black,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .05,
                right: MediaQuery.of(context).size.width * .05,
              ),
              child: Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Column(
                  children: [
                    Text(
                      widget.booking.doctorId.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Averta',
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.watch_later_rounded,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.booking.pickUp,
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.time_to_leave_outlined,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.booking.dropIn,
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
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.teal,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          widget.booking.address,
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
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Time elapsed",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${widget.hours} Hours to the pick up time left",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Refund",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "you will get ${widget.refund}% of amount in refund.",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Payment Id",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            widget.booking.paymentId,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            "Charges Breakup",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Ammount Paid",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            (widget.booking.ammount / 100).toString() + '₹',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Cancellation charge",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            (cancelCharge).toString() + '₹',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "you will receive",
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            '$finalAmount₹',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.normal,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Container(
                      child: Text(
                        "Please Read Terms and Conditions of Bike Rental",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Averta',
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ccompleted
                        ? Container(
                            margin: EdgeInsets.only(right: 9),
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed(Homepage.routeName);
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFF363940)),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(fontSize: 30))),
                                child: Text(
                                  "Home",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Futura',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.blueGrey,
                                  ),
                                )),
                          )
                        : Container(
                            margin: EdgeInsets.only(right: 9),
                            child: ElevatedButton(
                                onPressed: () {
                                  submit();
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFF363940)),
                                    textStyle: MaterialStateProperty.all(
                                        TextStyle(fontSize: 30))),
                                child: Text(
                                  "Proceed Cancellation",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Futura',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
