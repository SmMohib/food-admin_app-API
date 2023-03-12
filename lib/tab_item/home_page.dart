import 'dart:convert';
import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/model.dart';
import 'package:admin_app/provider/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState

    // getAllOrders();
    Provider.of<OrderProvider>(context, listen: false).getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderList = Provider.of<OrderProvider>(context).orderList;
    return Scaffold(
      body: Container(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${orderList[index].user!.name}"),
                  Text(
                      "${orderList[index].orderStatus!.orderStatusCategory!.name}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
