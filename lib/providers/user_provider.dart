import 'package:doc_easy_admin/models/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:doc_easy_admin/services/api_services.dart';

class UserProvider with ChangeNotifier {
  List<User> userList = [];
  bool isLoading = false;
  bool fetched = false;
  var id;
  Future<void> loadUsers() async {
    var response = await requestUsers();
    if (response['success']) {
      var user = UsersList.fromJson(response['users']);
      userList.clear();
      userList = user.user as List<User>;
      print(userList.length);
      isLoading = false;
      fetched = true;
      notifyListeners();
    } else {
      print("something went wrong");
    }
  }

/*   Future<void> loadBookings() async {
    isLoading = true;
    EasyLoading.show(status: "Loading History");
    var response = await requestBookingsById(id);
    await requestBookingStatus(id);
    print(response);
    if (response['success']) {
      var booking = Booking.fromJson(response['bookings']);
      bookingList.clear();
      bookingList = booking.bookings as List<BookingElement>;
      print(bookingList.length);
      isLoading = false;
      fetched = true;
      EasyLoading.dismiss();
      notifyListeners();
    } else {
      print("something went wrong");
    }
  } */
}
