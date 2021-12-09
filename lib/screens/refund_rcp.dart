import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RefundRcp extends StatefulWidget {
  BookingElement booking;
  RefundRcp({this.booking});

  @override
  _RefundRcpState createState() => _RefundRcpState();
}

class _RefundRcpState extends State<RefundRcp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
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
            "REFUND INITIATED",
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
                            "you will get ${widget.booking.refundPercent}% of amount in refund.",
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
                            "${widget.booking.refundPercent}%",
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
                            '${(widget.booking.ammount / 100) * (int.parse(widget.booking.refundPercent) / 100)} ₹',
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
                    Container(
                      margin: EdgeInsets.only(right: 9),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed(Homepage.routeName);
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF363940)),
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
