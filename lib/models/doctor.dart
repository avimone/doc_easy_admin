// To parse this JSON data, do
//
//     final doctor = doctorFromJson(jsonString);

import 'dart:convert';

Doctor doctorFromJson(String str) => Doctor.fromJson(json.decode(str));

String doctorToJson(Doctor data) => json.encode(data.toJson());

class Doctor {
  Doctor({
    this.doctors,
  });

  List<DoctorElement> doctors;

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        doctors: List<DoctorElement>.from(
            json["doctors"].map((x) => DoctorElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "doctors": List<dynamic>.from(doctors.map((x) => x.toJson())),
      };
}

class DoctorElement {
  DoctorElement({
    this.status,
    this.email,
    this.address,
    this.country,
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
    this.phone,
    this.zip,
    this.pricePerDay,
    this.pricePerHour,
    this.v,
    this.doctorId,
  });
  String status;

  String email;
  String address;
  String country;
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
  int phone;
  int zip;
  int pricePerDay;
  int pricePerHour;
  int v;
  String doctorId;

  factory DoctorElement.fromJson(Map<String, dynamic> json) => DoctorElement(
        status: json['status'],
        email: json["email"],
        address: json["address"],
        country: json["country"],
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
        phone: json["phone"],
        zip: json["zip"],
        pricePerDay: json["pricePerDay"],
        pricePerHour: json["pricePerHour"],
        v: json["__v"],
        doctorId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "email": email,
        "address": address,
        "country": country,
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
        "phone": phone,
        "zip": zip,
        "pricePerDay": pricePerDay,
        "pricePerHour": pricePerHour,
        "__v": v,
        "id": doctorId,
      };
}
