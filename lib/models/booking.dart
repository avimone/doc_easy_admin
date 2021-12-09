// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);

import 'dart:convert';
import 'package:doc_easy_admin/models/users.dart' as u;

Booking bookingFromJson(String str) => Booking.fromJson(json.decode(str));

String bookingToJson(Booking data) => json.encode(data.toJson());

class Booking {
  Booking({
    this.bookings,
  });

  List<BookingElement> bookings;

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        bookings: List<BookingElement>.from(
            json["bookings"].map((x) => BookingElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "bookings": List<dynamic>.from(bookings.map((x) => x.toJson())),
      };
}

class BookingElement {
  BookingElement(
      {this.address,
      this.isCompleted,
      this.completedTime,
      this.isOnGoing,
      this.isYetToStart,
      this.isCancelled,
      this.priceDays,
      this.priceHours,
      this.discount,
      this.refundId,
      this.refundPercent,
      this.id,
      this.userId,
      this.doctorId,
      this.pincode,
      this.city,
      this.paymentId,
      this.orderId,
      this.bookingOrderId,
      this.time,
      this.ammount,
      this.pickUp,
      this.dropIn,
      this.dateStart,
      this.dateStop,
      this.days,
      this.hours,
      this.totalPaid,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.bookingId,
      this.user});

  String address;
  bool isCompleted;
  String completedTime;
  bool isOnGoing;
  bool isYetToStart;
  bool isCancelled;
  String priceDays;
  String priceHours;
  String discount;
  String refundId;
  String refundPercent;
  String id;
  String userId;
  DoctorId doctorId;
  int pincode;
  String city;
  String paymentId;
  String orderId;
  String bookingOrderId;
  String time;
  int ammount;
  String pickUp;
  String dropIn;
  String dateStart;
  String dateStop;
  String days;
  String hours;
  int totalPaid;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String bookingId;
  u.User user;

  factory BookingElement.fromJson(Map<String, dynamic> json) => BookingElement(
        user: json['user'],
        address: json["address"],
        isCompleted: json["isCompleted"],
        completedTime: json["completedTime"],
        isOnGoing: json["isOnGoing"],
        isYetToStart: json["isYetToStart"],
        isCancelled: json["isCancelled"],
        priceDays: json["price_days"],
        priceHours: json["price_hours"],
        discount: json["discount"],
        refundId: json["refund_id"],
        refundPercent: json["refund_percent"],
        id: json["_id"],
        userId: json["userId"],
        doctorId: DoctorId.fromJson(json["doctorId"]),
        pincode: json["pincode"],
        city: json["city"],
        paymentId: json["paymentId"],
        orderId: json["orderId"],
        bookingOrderId: json["order_id"],
        time: json["time"],
        ammount: json["ammount"],
        pickUp: json["pickUp"],
        dropIn: json["dropIn"],
        dateStart: json["dateStart"],
        dateStop: json["dateStop"],
        days: json["days"],
        hours: json["hours"],
        totalPaid: json["total_paid"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        bookingId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user": user,
        "address": address,
        "isCompleted": isCompleted,
        "completedTime": completedTime,
        "isOnGoing": isOnGoing,
        "isYetToStart": isYetToStart,
        "isCancelled": isCancelled,
        "price_days": priceDays,
        "price_hours": priceHours,
        "discount": discount,
        "refund_id": refundId,
        "refund_percent": refundPercent,
        "_id": id,
        "userId": userId,
        "doctorId": doctorId.toJson(),
        "pincode": pincode,
        "city": city,
        "paymentId": paymentId,
        "orderId": orderId,
        "order_id": bookingOrderId,
        "time": time,
        "ammount": ammount,
        "pickUp": pickUp,
        "dropIn": dropIn,
        "dateStart": dateStart,
        "dateStop": dateStop,
        "days": days,
        "hours": hours,
        "total_paid": totalPaid,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "id": bookingId,
      };
}

class DoctorId {
  DoctorId({
    this.status,
    this.email,
    this.address,
    this.country,
    this.isAdmin,
    this.height,
    this.weight,
    this.gender,
    this.emailVerified,
    this.mobileVerified,
    this.selectedPlan,
    this.trainer,
    this.dob,
    this.designation,
    this.qualification,
    this.presentInstitution,
    this.experience,
    this.specialization,
    this.skills,
    this.docVerified,
    this.requiredPictures,
    this.requiredPictures1,
    this.inProcess,
    this.available,
    this.coverImage,
    this.imageUrls,
    this.id,
    this.name,
    this.passwordHash,
    this.phone,
    this.zip,
    this.pricePerDay,
    this.pricePerHour,
    this.v,
    this.doctorIdId,
  });
  String status;
  String email;
  String address;
  String country;
  bool isAdmin;
  String height;
  String weight;
  String gender;
  bool emailVerified;
  bool mobileVerified;
  String selectedPlan;
  bool trainer;
  String dob;
  String designation;
  String qualification;
  String presentInstitution;
  String experience;
  String specialization;
  String skills;
  bool docVerified;
  String requiredPictures;
  String requiredPictures1;
  bool inProcess;
  bool available;
  String coverImage;
  String imageUrls;
  String id;
  String name;
  String passwordHash;
  int phone;
  int zip;
  int pricePerDay;
  int pricePerHour;
  int v;
  String doctorIdId;

  factory DoctorId.fromJson(Map<String, dynamic> json) => DoctorId(
        status: json['status'],
        email: json["email"],
        address: json["address"],
        country: json["country"],
        isAdmin: json["isAdmin"],
        height: json["height"],
        weight: json["weight"],
        gender: json["gender"],
        emailVerified: json["emailVerified"],
        mobileVerified: json["mobileVerified"],
        selectedPlan: json["selectedPlan"],
        trainer: json["trainer"],
        dob: json["dob"],
        designation: json["designation"],
        qualification: json["qualification"],
        presentInstitution: json["presentInstitution"],
        experience: json["experience"],
        specialization: json["specialization"],
        skills: json["skills"],
        docVerified: json["docVerified"],
        requiredPictures: json["requiredPictures"],
        requiredPictures1: json["requiredPictures1"],
        inProcess: json["inProcess"],
        available: json["available"],
        coverImage: json["coverImage"],
        imageUrls: json["imageUrls"],
        id: json["_id"],
        name: json["name"],
        passwordHash: json["passwordHash"],
        phone: json["phone"],
        zip: json["zip"],
        pricePerDay: json["pricePerDay"],
        pricePerHour: json["pricePerHour"],
        v: json["__v"],
        doctorIdId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "email": email,
        "address": address,
        "country": country,
        "isAdmin": isAdmin,
        "height": height,
        "weight": weight,
        "gender": gender,
        "emailVerified": emailVerified,
        "mobileVerified": mobileVerified,
        "selectedPlan": selectedPlan,
        "trainer": trainer,
        "dob": dob,
        "designation": designation,
        "qualification": qualification,
        "presentInstitution": presentInstitution,
        "experience": experience,
        "specialization": specialization,
        "skills": skills,
        "docVerified": docVerified,
        "requiredPictures": requiredPictures,
        "requiredPictures1": requiredPictures1,
        "inProcess": inProcess,
        "available": available,
        "coverImage": coverImage,
        "imageUrls": imageUrls,
        "_id": id,
        "name": name,
        "passwordHash": passwordHash,
        "phone": phone,
        "zip": zip,
        "pricePerDay": pricePerDay,
        "pricePerHour": pricePerHour,
        "__v": v,
        "id": doctorIdId,
      };
}
