import 'package:doc_easy_admin/models/doctor.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/cupertino.dart';

class VehicalProvider with ChangeNotifier {
  List<DoctorElement> vehicalList = [];
  bool isLoading = false;

  void loadVehicals() async {
    var response = await requestVehicals();

    if (response['success']) {
      var vehical = Doctor.fromJson(response['doctors']);
      vehicalList = vehical.doctors as List<DoctorElement>;
      print(vehicalList.length);
      print(vehicalList[0].name);
      isLoading = false;
      notifyListeners();
    } else {
      print("something went wrong");
    }
  }
}
