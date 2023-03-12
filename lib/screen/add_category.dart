// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/custom_TextField.dart';
import 'package:flutter/material.dart';
//import "package:image_picker/image_picker.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  File? icon, image;
  //final picker = ImagePicker();

  // Future getIconformGallery() async {
  //   print('on the way of gallery');
  //   final pickedImage = await picker.getImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedImage != null) {
  //       icon = File(pickedImage.path);
  //       print('image found');
  //       print('$icon');
  //     } else {
  //       print('no image found');
  //     }
  //   });
  // }

  // Future getImageformGallery() async {
  //   print('on the way of gallery');
  //   final pickedImage = await picker.getImage(source: ImageSource.camera);
  //   setState(() {
  //     if (pickedImage != null) {
  //       image = File(pickedImage.path);
  //       print('image found');
  //       print('$image');
  //     } else {
  //       print('no image found');
  //     }
  //   });
  // }

  bool onProgress = false;

  Future addCategory() async {
    setState(() {
      onProgress = true;
    });
    final uri =
        Uri.parse("https://apihomechef.antopolis.xyz/api/admin/category/store");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(
      await CustomHttpRequest().getHeaderWithToken(),
    );
    request.fields['name'] = nameController.text.toString();
    if (image != null) {
      var photo = await http.MultipartFile.fromPath('image', image!.path);
      print('processing');
      request.files.add(photo);
    }
    if (icon != null) {
      var _icon = await http.MultipartFile.fromPath('icon', icon!.path);
      print('processing');
      request.files.add(_icon);
    }
    var response = await request.send();
    print("${response.statusCode}");

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);

    if (response.statusCode == 201) {
      print("responseBody1 $responseData");

      print('oooooooooooooooooooo');
      print(data['message']);
      setState(() {
        onProgress = false;
      });
      showInToast(data['message']);
      Navigator.pop(context);
      print("***************");
      print("${response.statusCode}");
    } else {
      print('else call');
      print("responseBody1 $responseString");
      print(data['errors']['image'][0]);
      showInToast(data["errors"]['image'][0]);
      setState(() {
        onProgress = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: onProgress == true,
        progressIndicator: CircularProgressIndicator(),
        child: Scaffold(
          appBar: AppBar(),
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomTextField(
                  controller: nameController,
                  hintText: "Enter Category Name",
                ),
                Text("Choose category Icon"),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: icon == null
                      ? InkWell(
                          onTap: () {
                            //    getIconformGallery();
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: aTextColor.withOpacity(0.3),
                                  size: 40,
                                ),
                                Text(
                                  "UPLOAD",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: aTextColor.withOpacity(0.5)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(icon!),
                          )),
                        ),
                ),
                Text("Choose category Image"),
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: image == null
                      ? InkWell(
                          onTap: () {
                            //  getImageformGallery();
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  color: aTextColor.withOpacity(0.3),
                                  size: 40,
                                ),
                                Text(
                                  "UPLOAD",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: aTextColor.withOpacity(0.5)),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(image!),
                          )),
                        ),
                ),
                MaterialButton(
                  color: pinkColor,
                  onPressed: () {
                    addCategory();
                  },
                  child: Text("Upload"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
