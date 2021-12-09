import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/screens/nav_bar.dart';
import 'package:flutter/material.dart';

class PaymentSuccess extends StatefulWidget {
  BookingElement booking;
  var days = '0';
  var hours = '0';

  var pickUp;
  var dropIn;
  var address;
  var paymentId;
  var ammount;
  var time;
  var discount;
  var price_days;
  var price_hours;
  var vName;
  var order_id;
  PaymentSuccess(
      {this.booking,
      this.days,
      this.hours,
      this.address,
      this.ammount,
      this.discount,
      this.dropIn,
      this.paymentId,
      this.pickUp,
      this.price_days,
      this.price_hours,
      this.vName,
      this.order_id,
      this.time});

  @override
  _PaymentSuccessState createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent,
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
            "PAYMENT COMPLETED",
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
                      widget.booking == null
                          ? widget.vName
                          : widget.booking.doctorId.name,
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
                          widget.booking == null
                              ? widget.pickUp
                              : widget.booking.pickUp,
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
                          widget.booking == null
                              ? widget.dropIn
                              : widget.booking.dropIn,
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
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.teal,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Expanded(
                            child: Text(
                              widget.booking == null
                                  ? widget.address
                                  : widget.booking.address,
                              maxLines: 3,
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
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "Duration",
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
                            "${widget.days} Days and ${widget.hours} Hours",
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
                            "Per Day Charge",
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
                            widget.booking == null
                                ? "${widget.price_days} * ${widget.days}"
                                : "${widget.booking.doctorId.pricePerDay.toString()} * ${widget.days}",
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
                            "Per Hour Charge",
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
                            widget.booking == null
                                ? "${widget.price_hours} * ${widget.hours}"
                                : "${widget.booking.doctorId.pricePerHour.toString()} * ${widget.hours}",
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
                            widget.booking == null
                                ? (widget.ammount / 100).toString() + '₹'
                                : (widget.booking.ammount / 100).toString() +
                                    '₹',
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
                    widget.booking == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "Order Id",
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
                                  widget.order_id,
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
                          )
                        : Row(
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
                    widget.booking != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "Order Id",
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
                                  widget.booking.orderId,
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
                          )
                        : Align(),
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
                            widget.booking == null
                                ? (widget.ammount / 100).toString() + '₹'
                                : (widget.booking.ammount / 100).toString() +
                                    '₹',
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
                            "Done",
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Futura',
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic,
                              color: Colors.greenAccent,
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
