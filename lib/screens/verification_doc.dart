import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:doc_easy_admin/models/user.dart';
import 'package:doc_easy_admin/screens/nav_bar.dart';
import 'package:doc_easy_admin/services/api_services.dart';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class DocVerification extends StatefulWidget {
  static const routeName = '/docverify';

  const DocVerification();

  @override
  _DocVerificationState createState() => _DocVerificationState();
}

class _DocVerificationState extends State<DocVerification> {
  XFile _image;
  File file;
  XFile _image1;
  File file1;
  var status = "Not Uploaded";
  var _isLoading = false;
  var args;
  var skip = true;
  void _showPicker(context, var img) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery(img);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      _imgFromCamera(img);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<Uint8List> testCompressFile(File file) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 50,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  void uploadImage() async {
    EasyLoading.show(status: "Uploading");
    List<int> imageBytes = file.readAsBytesSync();
    print(imageBytes);
    var uimage = await testCompressFile(file);
    String base64Image = base64Encode(uimage);

    List<int> imageBytes1 = file1.readAsBytesSync();

    var uimage1 = await testCompressFile(file1);

    print(imageBytes1);
    String base64Image1 = base64Encode(uimage1);
    print(base64Image);
    print(base64Image1);
    var parameters = {
      "imageDL": base64Image,
      "imageAC": base64Image1,
      "passwordOld": User.shared.password
    };
    print(User.shared.password);
    var res = await uploadDocuments(parameters);
    errDialog(res);
  }

  _imgFromCamera(var img) async {
    final ImagePicker _picker = ImagePicker();

    XFile image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (img) {
        _image = image;
        file = File(_image.path);
      } else {
        _image1 = image;
        file1 = File(_image1.path);
      }
    });
  }

  _imgFromGallery(var img) async {
    final ImagePicker _picker = ImagePicker();

    XFile image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    print("Image ${img}");
    setState(() {
      if (img) {
        _image = image;
        file = File(_image.path);
      } else {
        _image1 = image;
        file1 = File(_image1.path);
      }
    });
  }

  void errDialog(var response) {
    if (response['success'] == true) {
      print("logged in");
      requestDocumentStatus(User.shared.id);

      EasyLoading.dismiss();

      Navigator.popAndPushNamed(context, Homepage.routeName);

      //   Navigator.popAndPushNamed(context, ExtraDetails.routeName);

    } else {
      setState(() {
        _isLoading = false;
      });
      EasyLoading.dismiss();
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
            Container(
              child: Text(
                response['message'].toString(),
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
        btnOkOnPress: () {},
      )..show();
      //    print(response['message']);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    requestDocumentStatus(User.shared.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    status = User.shared.status;

    args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      skip = args['skip'];
    }
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      "Documents Verification",
                      style: TextStyle(
                          fontFamily: 'Averta',
                          fontWeight: FontWeight.w700,
                          fontSize: 26,
                          fontStyle: FontStyle.normal,
                          color: Colors.purple[200]),
                    ),
                  ),
                  skip
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.popAndPushNamed(
                                    context, Homepage.routeName);
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF363940)),
                                  textStyle: MaterialStateProperty.all(
                                      TextStyle(fontSize: 30))),
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'Futura',
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.purple[200],
                                ),
                              )),
                        )
                      : Align(),
                ],
              ),
            ),
            Divider(
              color: Colors.white,
            ),
            Container(
              margin: EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 5),
              child: Card(
                color: Colors.white.withOpacity(.9),
                child: Row(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (User.shared.status == "processing" ||
                              User.shared.status == 'not verified') {
                          } else if (User.shared.status == 'reupload' ||
                              User.shared.status == 'not uploaded') {
                            _showPicker(context, true);
                          }
                        },
                        child: file != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.file(
                                  file,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.6),
                                    borderRadius: BorderRadius.circular(0)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          "Upload Degree Certificate",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                        Text(
                          "upload .jpeg file only",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 13, right: 13),
              child: Card(
                color: Colors.white.withOpacity(.9),
                child: Row(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (User.shared.status == "processing" ||
                              User.shared.status == 'not verified') {
                          } else if (User.shared.status == 'reupload' ||
                              User.shared.status == 'not uploaded') {
                            _showPicker(context, false);
                          }
                        },
                        child: file1 != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.file(
                                  file1,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(.6),
                                    borderRadius: BorderRadius.circular(0)),
                                width: 100,
                                height: 100,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey[800],
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      children: [
                        Text(
                          "Upload Council Membership",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                        Text(
                          "upload .jpeg file only",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Card(
              color: Colors.white.withOpacity(.6),
              child: Container(
                margin: EdgeInsets.all(3),
                child: Text(
                  "Status : $status",
                  style: TextStyle(
                      fontFamily: 'Averta',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      fontStyle: FontStyle.normal,
                      color: status == 'processing'
                          ? Colors.greenAccent
                          : status == 'reupload'
                              ? Colors.redAccent
                              : status == 'not verified'
                                  ? Colors.yellow
                                  : Colors.black),
                ),
              ),
            ),
            Center(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                      onPressed: () {
                        if (status == "processing") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "please wait while we finish processing your old documents.")));
                        } else {
                          if (file != null && file1 != null) {
                            uploadImage();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("please upload both files")));
                          }
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF363940)),
                          textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 30))),
                      child: Text(
                        "Upload",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Futura',
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic,
                          color: Colors.purple[200],
                        ),
                      ))),
            ),
            Card(
              color: Colors.white.withOpacity(.6),
              margin: EdgeInsets.all(10),
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "NOT UPLOADED :",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                        Text(
                          "please upload your documents for verification of profile.",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Text(
                          "PROCESSING :",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.greenAccent),
                        ),
                        Text(
                          "please wait!!! our team is verifing your documents,it may take up to 2-4 days.",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Text(
                          "REUPLOAD :",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.yellow),
                        ),
                        Text(
                          "please re-upload your documents for verification of profile,take clear photo and make sure it's jpeg file.",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      children: [
                        Text(
                          "NOT VERIFIED :",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.red),
                        ),
                        Text(
                          "your profile is not eligible for our services,reason may be one of these.\n1) your age 18< \n2) License is not valid \n3) Bad driving records",
                          style: TextStyle(
                              fontFamily: 'Averta',
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
