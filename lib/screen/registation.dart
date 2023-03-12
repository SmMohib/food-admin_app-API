// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';

import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/custom_TextField.dart';
import 'package:admin_app/widget/widget.dart';
//import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegistationPage extends StatefulWidget {
  const RegistationPage({Key? key}) : super(key: key);

  @override
  State<RegistationPage> createState() => _RegistationPageState();
}

class _RegistationPageState extends State<RegistationPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  // Future<bool> check() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.mobile) {
  //     return true;
  //     // I am connected to a mobile network.
  //   } else if (connectivityResult == ConnectivityResult.wifi) {
  //     return true;
  //     // I am connected to a wifi network.
  //   }
  //   showInToast("No Internet");
  //   return false;
  // }

  // getRegister() async {
  //   check().then((internet) async {
  //     if (internet != null && internet) {
  //       var map = Map<String, dynamic>();
  //       map["name"] = nameController.text.toString();
  //       map["email"] = emailController.text.toString();
  //       map["password"] = passwordController.text.toString();
  //       map["password_confirmation"] =
  //           confirmPasswordController.text.toString();
  //       var responce = await http.post(
  //           Uri.parse(
  //             "https://apihomechef.antopolis.xyz/api/admin/create/new/admin",
  //           ),
  //           body: map,
  //           headers: CustomHttpRequest.defaultHeader);
  //       print("${responce.body}");
  //       final data = jsonDecode(responce.body);
  //       if (responce.statusCode == 201) {
  //         showInToast("Registation Successfull");
  //       } else {
  //         showInToast("Registation failed");
  //       }
  //     } else {
  //       showInToast("No Internet Connection");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hintText: "Enter your name",
            ),
            CustomTextField(
              controller: emailController,
              hintText: "Enter your Email",
            ),
            CustomTextField(
              controller: passwordController,
              hintText: "Enter your password",
            ),
            CustomTextField(
              controller: confirmPasswordController,
              hintText: "Enter Confirm password",
            ),
            MaterialButton(
              onPressed: () {
                //  getRegister();
              },
              color: Colors.orange,
              child: Text("Submit"),
            )
          ],
        ),
      ),
    );
  }
}
