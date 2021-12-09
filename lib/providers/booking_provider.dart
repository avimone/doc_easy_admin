import 'package:doc_easy_admin/models/booking.dart';
import 'package:doc_easy_admin/models/users.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class BookingProvider with ChangeNotifier {
  List<BookingElement> bookingList = [];
  bool isLoading = false;
  bool fetched = false;
  var id;
  Future<void> loadVehicals() async {
    var response = await requestBookings();
    if (response['success']) {
      var booking = Booking.fromJson(response['bookings']);
      bookingList.clear();
      bookingList = booking.bookings as List<BookingElement>;
      print(bookingList.length);
      isLoading = false;
      fetched = true;
      notifyListeners();
    } else {
      print("something went wrong");
    }
  }

  Future<void> loadBookings() async {
    isLoading = true;
    EasyLoading.show(status: "Loading History");
    // var response = await requestBookingsById(id);
    var response = await requestBookings();
    //  await requestBookingStatus(id);
    print(response);
    if (response['success']) {
      List<BookingElement> tempList = [];
      var booking = Booking.fromJson(response['bookings']);
      bookingList.clear();
      tempList = booking.bookings as List<BookingElement>;
      for (var item in tempList) {
        var res = await requestUsersById(item.userId);
        item.user = User.fromJson(res['users']);
        bookingList.add(item);
      }
      isLoading = false;
      fetched = true;
      EasyLoading.dismiss();
      notifyListeners();
    } else {
      print("something went wrong");
    }
  }
}
