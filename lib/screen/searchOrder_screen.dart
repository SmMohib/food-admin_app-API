import 'dart:convert';

import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/order_model.dart';
import 'package:admin_app/model/orders_model_search.dart';
import 'package:admin_app/provider/order_provider.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class OrderSearchHere extends SearchDelegate<Orders> {
  /* final List<Orders> itemsList;
  OrderSearchHere({this.itemsList});*/
  bool onProgress = false;
  bool? payment;

  Future<void> updateOrderStatus(
      BuildContext context, int id, int status) async {
    /* setState(() {
      onProgress = true;
    });*/
    final uri = Uri.parse(
        "https://apihomechef.antapp.space/api/admin/order/status/update/$id");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest().getHeaderWithToken());
    request.fields['order_status_category_id'] = status.toString();
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    print('responseStatus ${response.statusCode}');
    if (response.statusCode == 200) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      print('oooooooooooooooooooo');
      print(data);
      showInToast(
          data['data']['message'] + " :" + data['data']['order_status']);

      //
      // setState(() {
      //   onProgress = false;
      // });
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      // setState(() {
      //   onProgress = false;
      // });
    }
  }

  Future<void> availabilityUpdate(BuildContext context, int id) async {
    onProgress = true;
    final uri = Uri.parse(
        "https://apihomechef.antapp.space/api/admin/product/update/available/status/$id");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest().getHeaderWithToken());
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    print('responseStatus ${response.statusCode}');
    if (response.statusCode == 200) {
      print("responseBody1 " + responseString);
      var data = jsonDecode(responseString);
      print('oooooooooooooooooooo');
      print(data['success']);
      showInToast(data['success']);
      onProgress = false;
    } else {
      onProgress = false;
    }
  }

  Future<void> displayViewDetailsDialog(BuildContext context, int id) async {
    Order order = Order();
    onProgress = true;

    order = await CustomHttpRequest.getOrderWithId(context, id);
    onProgress = false;
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.height * 0.9,
              child: order != null
                  ? SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 10),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close)),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      "https://homechef.antapp.space/avatar/${order.user!.image ?? ""}"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${order.user!.name}',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '${order.user!.contact}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                /*Spacer(),
                          InkWell(
                            onTap: () {

                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              decoration: BoxDecoration(
                                color: aPriceTextColor.withOpacity(0.18),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Icon(
                                Icons.delete_outline_outlined,
                                color: aPriceTextColor,
                                size: 18,
                              ),
                            ),
                          ),*/
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 30),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Order ID',
                                      style: TextStyle(
                                          color: aTextColor.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      '#${order.id}',
                                      style: TextStyle(
                                          color: aTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Payment',
                                      style: TextStyle(
                                          color: aTextColor.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${order.payment!.paymentStatus == "0" ? "Cash on delivery" : "Another pay"}",
                                      style: TextStyle(
                                          color: aTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Address',
                                      style: TextStyle(
                                          color: aTextColor.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Expanded(
                                      child: Text(
                                        '${order.user!.billingAddress!.house} Rd No ${order.user!.billingAddress!.road} ${order.user!.billingAddress!.city}',
                                        style: TextStyle(
                                            color: aTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: aTextColor.withOpacity(0.5),
                          ),
                          Container(
                            height: 150,
                            child: RawScrollbar(
                              isAlwaysShown: true,
                              child: ListView.builder(
                                  itemCount: order.orderFoodItems!.length,
                                  itemBuilder: (context, index) {
                                    int q = order.orderFoodItems![index].pivot!
                                        .quantity!;
                                    int p = order.orderFoodItems![index]
                                        .price![0].discountedPrice!;
                                    var total = q * p;
                                    return ListTile(
                                      title: Text(
                                          '${order.orderFoodItems![index].name}'),
                                      subtitle: Text('x$q'),
                                      /* leading: CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                      "https://homechef.masudlearn.com/images/${order.orderFoodItems[index].}"),
                                ),*/
                                      trailing: Text(
                                        '$total',
                                        style: TextStyle(
                                            color: aPriceTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          Divider(
                            color: aTextColor.withOpacity(0.5),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Discount',
                                      style: TextStyle(
                                          color: aTextColor.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${order.discount == null ? "-0.00" : '${order.discount}'}',
                                      style: TextStyle(
                                          color: aTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Delivery charge',
                                      style: TextStyle(
                                          color: aTextColor.withOpacity(0.5),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      '0.00',
                                      style: TextStyle(
                                          color: aTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Total charge',
                                      style: TextStyle(
                                          color: aTextColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    Text(
                                      '${order.price}',
                                      style: TextStyle(
                                          color: aTextColor,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : CircularProgressIndicator(),
            ),
          );
        });
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // close(context, null);
        });
  }

  showInToast(String value) {
    Fluttertoast.showToast(
        msg: "$value",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: aPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget buildResults(BuildContext context) {
    final recentOrders = Provider.of<OrderProvider>(context);
    final myList = query.isEmpty
        ? recentOrders.orderList
        : recentOrders.orderList
            .where((element) =>
                element.user!.name!.toLowerCase().startsWith(query))
            .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: myList.isEmpty
          ? Center(
              child: Text(
              'No result found',
              style: TextStyle(fontSize: 18),
            ))
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: myList.length,
              itemBuilder: (context, index) {
                print(
                    ' order status :  ${myList[index].orderStatus!.orderStatusCategory!.name}');
                payment = myList[index].payment!.paymentStatus.toString() == "1"
                    ? true
                    : myList[index].payment!.paymentStatus.toString() == "0"
                        ? false
                        : false;
                return Card(
                  child: ExpansionTile(
                    trailing: Text(
                      '\৳ ${myList[index].price ?? ""}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: aPriceTextColor),
                    ),
                    title: Text(
                      '${myList[index].user!.name ?? ""}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: aTextColor),
                    ),
                    leading: Icon(
                      myList[index].orderStatus!.orderStatusCategory!.name ==
                              'Complete'
                          ? Icons.check_circle_outlined
                          : Icons.access_time_rounded,
                      color: myList[index]
                                      .orderStatus!
                                      .orderStatusCategory!
                                      .name ==
                                  'Complete' ||
                              myList[index].payment!.paymentStatus.toString() ==
                                  '1'
                          ? Colors.green
                          : aPrimaryColor,
                    ),
                    subtitle: Text(
                      '#${myList[index].id ?? ""}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: aTextColor),
                    ),
                    children: [
                      Divider(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: aTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap');
                                      int id = myList[index].id!.toInt();
                                      updateOrderStatus(context, id, 1).then(
                                          (value) => recentOrders.getOrders());
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: myList[index]
                                                          .orderStatus!
                                                          .orderStatusCategory!
                                                          .name ==
                                                      'Ongoing'
                                                  ? aTextColor
                                                  : aNavBarColor,
                                              border:
                                                  Border.all(color: aTextColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 10,
                                              color: aNavBarColor,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Ongoing',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap');
                                      int id = myList[index].id!.toInt();
                                      updateOrderStatus(context, id, 2).then(
                                          (value) => recentOrders.getOrders());
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: myList[index]
                                                          .orderStatus!
                                                          .orderStatusCategory!
                                                          .name ==
                                                      'Delivered'
                                                  ? aTextColor
                                                  : aNavBarColor,
                                              border:
                                                  Border.all(color: aTextColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 10,
                                              color: aNavBarColor,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Delivered',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap');
                                      int id = myList[index].id!.toInt();
                                      updateOrderStatus(context, id, 3).then(
                                          (value) => recentOrders.getOrders());
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: myList[index]
                                                          .orderStatus!
                                                          .orderStatusCategory!
                                                          .name ==
                                                      'Complete'
                                                  ? aTextColor
                                                  : aNavBarColor,
                                              border:
                                                  Border.all(color: aTextColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 10,
                                              color: aNavBarColor,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Complete',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Payment',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: aTextColor,
                                        ),
                                      ),
                                      Spacer(),
                                      MCustomSwitch(
                                        value: payment,
                                        activeColor: aTextColor,
                                        activeTogolColor: aPrimaryColor,
                                        onChanged: (value) async {
                                          print("default : $payment");
                                          payment = payment!;
                                          onProgress = true;
                                          print("$payment");
                                          int orderId =
                                              myList[index].id!.toInt();

                                          final uri = Uri.parse(
                                              "https://apihomechef.antapp.space/api/admin/order/payment/status/update/$orderId");
                                          var request = http.MultipartRequest(
                                              "POST", uri);
                                          request.headers.addAll(
                                              await CustomHttpRequest()
                                                  .getHeaderWithToken());
                                          var response = await request.send();
                                          var responseData =
                                              await response.stream.toBytes();
                                          var responseString =
                                              String.fromCharCodes(
                                                  responseData);
                                          print(
                                              "responseBody " + responseString);
                                          print(
                                              'responseStatus ${response.statusCode}');
                                          if (response.statusCode == 200) {
                                            print("responseBody1 " +
                                                responseString);
                                            var data =
                                                jsonDecode(responseString);
                                            print('oooooooooooooooooooo');
                                            print(data);
                                            showInToast(
                                                data['data']['message']);
                                            recentOrders.getOrders();
                                            onProgress = false;
                                          } else {
                                            onProgress = false;
                                            recentOrders.getOrders();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                  /*Row(
                                          children: [
                                            Text(
                                              'Approval',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: aTextColor,
                                              ),
                                            ),
                                            Spacer(),
                                            Switch(
                                              value:
                                                  _availabilitySwitchCondition,
                                              onChanged: (value) {
                                                _availabilitySwitchCondition ==
                                                        value
                                                    ? _availabilityValue = 1
                                                    : _availabilityValue = 0;
                                                print("$_availabilityValue");
                                              },
                                              activeColor: aPrimaryColor,
                                              activeTrackColor: aTextColor,
                                            ),
                                          ],
                                        )*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                int id = myList[index].id!.toInt();
                                print(id);
                                displayViewDetailsDialog(context, id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(color: aTextColor, width: 0.1),
                                ),
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: aTextColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Are you sure ?'),
                                        titleTextStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: aTextColor),
                                        titlePadding:
                                            EdgeInsets.only(left: 35, top: 25),
                                        content: Text(
                                            'Once you delete, the order will gone permanently.'),
                                        contentTextStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: aTextColor),
                                        contentPadding: EdgeInsets.only(
                                            left: 35, top: 10, right: 40),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      color: aTextColor,
                                                      width: 0.2)),
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: aTextColor),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: aPriceTextColor),
                                              ),
                                            ),
                                            onPressed: () async {
                                              /*   Navigator.pop(context);
                                              CustomHttpRequest.deleteOrderItem(
                                                      context,
                                                      myList[index].id,
                                                      onProgress)
                                                  .then((value) => recentOrders
                                                      .getRecentOrders(
                                                          context));
                                              myList.removeAt(index);*/
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: aPriceTextColor.withOpacity(0.18),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(color: aTextColor, width: 0.1),
                                ),
                                child: Icon(
                                  Icons.delete_outline_outlined,
                                  color: aPriceTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final recentOrders = Provider.of<OrderProvider>(context);
    final myList = query.isEmpty
        ? recentOrders.orderList
        : recentOrders.orderList
            .where((element) =>
                element.user!.name!.toLowerCase().startsWith(query))
            .toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: myList.isEmpty
          ? Center(
              child: Text(
              'No result found',
              style: TextStyle(fontSize: 18),
            ))
          : ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: myList.length,
              itemBuilder: (context, index) {
                payment = myList[index].payment!.paymentStatus.toString() == "1"
                    ? true
                    : myList[index].payment!.paymentStatus.toString() == "0"
                        ? false
                        : false;
                return Card(
                  child: ExpansionTile(
                    trailing: Text(
                      '\৳ ${myList[index].price ?? ""}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: aPriceTextColor),
                    ),
                    title: Text(
                      '${myList[index].user!.name ?? ""}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: aTextColor),
                    ),
                    leading: Icon(
                      myList[index].orderStatus!.orderStatusCategory!.name ==
                              'Complete'
                          ? Icons.check_circle_outlined
                          : Icons.access_time_rounded,
                      color: myList[index]
                                      .orderStatus!
                                      .orderStatusCategory!
                                      .name ==
                                  'Complete' ||
                              myList[index].payment!.paymentStatus.toString() ==
                                  '1'
                          ? Colors.green
                          : aPrimaryColor,
                    ),
                    subtitle: Text(
                      '#${myList[index].id ?? ""}',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: aTextColor),
                    ),
                    children: [
                      Divider(),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      color: aTextColor.withOpacity(0.5),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap');
                                      int id = myList[index].id!.toInt();
                                      updateOrderStatus(context, id, 1).then(
                                          (value) => recentOrders.getOrders());
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: myList[index]
                                                          .orderStatus!
                                                          .orderStatusCategory!
                                                          .name ==
                                                      'Ongoing'
                                                  ? aTextColor
                                                  : aNavBarColor,
                                              border:
                                                  Border.all(color: aTextColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 10,
                                              color: aNavBarColor,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Ongoing',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap');
                                      int id = myList[index].id!.toInt();
                                      updateOrderStatus(context, id, 2).then(
                                          (value) => recentOrders.getOrders());
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: myList[index]
                                                          .orderStatus!
                                                          .orderStatusCategory!
                                                          .name ==
                                                      'Delivered'
                                                  ? aTextColor
                                                  : aNavBarColor,
                                              border:
                                                  Border.all(color: aTextColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 10,
                                              color: aNavBarColor,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Delivered',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap');
                                      int id = myList[index].id!.toInt();
                                      updateOrderStatus(context, id, 3).then(
                                          (value) => recentOrders.getOrders());
                                    },
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            height: 12,
                                            width: 12,
                                            decoration: BoxDecoration(
                                              color: myList[index]
                                                          .orderStatus!
                                                          .orderStatusCategory!
                                                          .name ==
                                                      'Complete'
                                                  ? aTextColor
                                                  : aNavBarColor,
                                              border:
                                                  Border.all(color: aTextColor),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Center(
                                                child: Icon(
                                              Icons.check,
                                              size: 10,
                                              color: aNavBarColor,
                                            )),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Complete',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Payment',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: aTextColor,
                                        ),
                                      ),
                                      Spacer(),
                                      MCustomSwitch(
                                        value: payment,
                                        activeColor: aTextColor,
                                        activeTogolColor: aPrimaryColor,
                                        onChanged: (value) async {
                                          print("default : $payment");
                                          payment = !payment!;
                                          onProgress = true;
                                          print("$payment");
                                          int orderId =
                                              myList[index].id!.toInt();

                                          final uri = Uri.parse(
                                              "https://apihomechef.antapp.space/api/admin/order/payment/status/update/$orderId");
                                          var request = http.MultipartRequest(
                                              "POST", uri);
                                          request.headers.addAll(
                                              await CustomHttpRequest()
                                                  .getHeaderWithToken());
                                          var response = await request.send();
                                          var responseData =
                                              await response.stream.toBytes();
                                          var responseString =
                                              String.fromCharCodes(
                                                  responseData);
                                          print(
                                              "responseBody " + responseString);
                                          print(
                                              'responseStatus ${response.statusCode}');
                                          if (response.statusCode == 200) {
                                            print("responseBody1 " +
                                                responseString);
                                            var data =
                                                jsonDecode(responseString);
                                            print('oooooooooooooooooooo');
                                            print(data);

                                            onProgress = false;
                                            recentOrders.getOrders();
                                          } else {
                                            onProgress = false;
                                            recentOrders.getOrders();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                  /*Row(
                                          children: [
                                            Text(
                                              'Approval',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: aTextColor,
                                              ),
                                            ),
                                            Spacer(),
                                            Switch(
                                              value:
                                                  _availabilitySwitchCondition,
                                              onChanged: (value) {
                                                _availabilitySwitchCondition ==
                                                        value
                                                    ? _availabilityValue = 1
                                                    : _availabilityValue = 0;
                                                print("$_availabilityValue");
                                              },
                                              activeColor: aPrimaryColor,
                                              activeTrackColor: aTextColor,
                                            ),
                                          ],
                                        )*/
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                int id = myList[index].id!.toInt();
                                print(id);
                                displayViewDetailsDialog(context, id);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(color: aTextColor, width: 0.1),
                                ),
                                child: Text(
                                  'View Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: aTextColor,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Are you sure ?'),
                                        titleTextStyle: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: aTextColor),
                                        titlePadding:
                                            EdgeInsets.only(left: 35, top: 25),
                                        content: Text(
                                            'Once you delete, the order will gone permanently.'),
                                        contentTextStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: aTextColor),
                                        contentPadding: EdgeInsets.only(
                                            left: 35, top: 10, right: 40),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border.all(
                                                      color: aTextColor,
                                                      width: 0.2)),
                                              child: Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: aTextColor),
                                              ),
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 10),
                                              decoration: BoxDecoration(
                                                color: Colors.redAccent
                                                    .withOpacity(0.2),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                              ),
                                              child: Text(
                                                'Delete',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: aPriceTextColor),
                                              ),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              CustomHttpRequest.deleteOrderItem(
                                                      context,
                                                      myList[index].id!.toInt(),
                                                      onProgress)
                                                  .then((value) =>
                                                      recentOrders.getOrders());
                                              myList.removeAt(index);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                decoration: BoxDecoration(
                                  color: aPriceTextColor.withOpacity(0.18),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border:
                                      Border.all(color: aTextColor, width: 0.1),
                                ),
                                child: Icon(
                                  Icons.delete_outline_outlined,
                                  color: aPriceTextColor,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}
