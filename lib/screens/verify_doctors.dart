// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doc_easy_admin/providers/doctor_provider.dart';
import 'package:doc_easy_admin/providers/user_provider.dart';
import 'package:doc_easy_admin/screens/image_full.dart';
import 'package:doc_easy_admin/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class VerifyDoctor extends StatefulWidget {
  static const routeName = '/verifydoctors';

  const VerifyDoctor();

  @override
  _VerifyDoctorState createState() => _VerifyDoctorState();
}

class _VerifyDoctorState extends State<VerifyDoctor> {
  DoctorProvider userProvider = new DoctorProvider();
  @override
  void initState() {
    // TODO: implement initState

    userProvider.loadUsers();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    userProvider.dispose();
    super.dispose();
  }

  void change(var id, var state, var docVerified) async {
    var params = {"status": state, "verified": docVerified};
    EasyLoading.show(status: "changing status");
    var res = await changeStatus(id, params);
    errDialog(res);
  }

  void errDialog(var response) {
    if (response['success'] == true) {
      EasyLoading.dismiss();
      userProvider.loadUsers();

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
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: Container(
          margin: EdgeInsets.only(left: 15, top: 50),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Doctors",
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
                "These are all of our doctors listed.",
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
                  value: userProvider,
                  child: Consumer<DoctorProvider>(builder: (_, ctl, __) {
                    return _buildUI(userProvider);
                  }),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildUI(DoctorProvider dataProvider) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: dataProvider.isLoading
          ? Align()
          : ListView.builder(
              itemCount: dataProvider.userList.length,
              itemBuilder: (context, index) {
                print(dataProvider.userList[index].name);
                print(dataProvider.userList[index].requiredPictures);
                return Container(
                    height: MediaQuery.of(context).size.height * .65,
                    margin: EdgeInsets.only(right: 15),
                    child: Card(
                      elevation: 7,
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Name : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Phone : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].phone.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Email : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].email.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Location : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].zip.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "Gender : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].gender
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "status : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].status
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  "document verified : ",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                                Text(
                                  dataProvider.userList[index].docVerified
                                      .toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Averta',
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                              indent: 3,
                              endIndent: 20,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                              margin: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (dataProvider.userList[index]
                                          .requiredPictures1.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ImageFull(
                                                    dataProvider.userList[index]
                                                        .requiredPictures)));
                                      }
                                    },
                                    child: CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .25,
                                      width: MediaQuery.of(context).size.width *
                                          .25,
                                      fit: BoxFit.contain,
                                      imageUrl: dataProvider.userList[index]
                                              .requiredPictures.isEmpty
                                          ? "https://www.gadgetspidy.com/petroleum_images/No_Image_Available.png"
                                          : dataProvider
                                              .userList[index].requiredPictures,
                                      placeholder: (context, url) => Center(
                                          child:
                                              new CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (dataProvider.userList[index]
                                          .requiredPictures1.isNotEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ImageFull(
                                                    dataProvider.userList[index]
                                                        .requiredPictures1)));
                                      }
                                    },
                                    child: CachedNetworkImage(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .25,
                                      width: MediaQuery.of(context).size.width *
                                          .25,
                                      fit: BoxFit.contain,
                                      imageUrl: dataProvider.userList[index]
                                              .requiredPictures1.isEmpty
                                          ? "https://www.gadgetspidy.com/petroleum_images/No_Image_Available.png"
                                          : dataProvider.userList[index]
                                              .requiredPictures1,
                                      placeholder: (context, url) => Center(
                                          child:
                                              new CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          new Icon(Icons.error),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey,
                              indent: 3,
                              endIndent: 20,
                            ),
                            Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 9),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        change(dataProvider.userList[index].id,
                                            "verified", true);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF363940)),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(fontSize: 30))),
                                      child: Text(
                                        "Verify",
                                        style: TextStyle(
                                          fontSize: 18,
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
                                        change(dataProvider.userList[index].id,
                                            "reupload", false);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF363940)),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(fontSize: 30))),
                                      child: Text(
                                        "Re-upload",
                                        style: TextStyle(
                                          fontSize: 18,
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
                                        change(dataProvider.userList[index].id,
                                            "not verified", false);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Color(0xFF363940)),
                                          textStyle: MaterialStateProperty.all(
                                              TextStyle(fontSize: 30))),
                                      child: Text(
                                        "Deny",
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
                            )
                          ],
                        ),
                      ),
                    ));
              }),
    );
  }
}
