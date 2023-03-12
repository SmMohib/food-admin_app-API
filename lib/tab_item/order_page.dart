import 'dart:convert';

import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/order_model.dart';
import 'package:admin_app/provider/order_provider.dart';
import 'package:admin_app/screen/createOrder_page.dart';
import 'package:admin_app/screen/searchOrder_screen.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/custom_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  bool onProgress = false;
  bool? payment;

  ScrollController? _scrollController;
  bool showFav = true;

  Future<void> updateOrderStatus(
      BuildContext context, int id, int status) async {
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "https://apihomechef.antopolis.xyz/api/admin/order/status/update/$id");
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
      print(data['data']['message']);
      showInToast(data['data']['message']);
      setState(() {
        onProgress = false;
      });
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
    } else {
      setState(() {
        onProgress = false;
      });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> displayViewDetailsDialog(BuildContext context, int id) async {
    Order? order;
    setState(() {
      onProgress = true;
    });
    String house;
    String road;
    String city;
    order = await CustomHttpRequest.getOrderWithId(context, id);
    if (order.shippingAddress == null) {
      house = order.user!.billingAddress!.house!;
      road = order.user!.billingAddress!.road!;
      city = order.user!.billingAddress!.city!;
    } else {
      house = order.shippingAddress!.house!;
      road = order.shippingAddress!.road!;
      city = order.shippingAddress!.city!;
    }
    setState(() {
      onProgress = false;
    });
    return showDialog(
        context: _scaffoldKey.currentContext!,
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
                                      "https://apihomechef.antopolis.xyz/images/${order.user!.image ?? ""}"),
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
                                      "${order.payment!.paymentStatus.toString() == "0" ? "Cash on delivery" : "Another pay"}",
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
                                        '$house, Rd No $road, $city',
                                        style: TextStyle(
                                            color: aTextColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    /*Row(
                                children: [
                                  Text(
                                    "$house ,",
                                    //"${order.shippingAddress != null ? order.shippingAddress.house : order.user.billingAddress.house.toString() }, ",
                                    //'${order.user.billingAddress.house} Rd No ${order.user.billingAddress.road} ${order.user.billingAddress.city}',
                                    style: TextStyle(
                                        color: aTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "$road st ,",
                                    //"${order.shippingAddress != null ?order.shippingAddress.road : order.user.billingAddress.road  } st, ",
                                    //'${order.user.billingAddress.house} Rd No ${order.user.billingAddress.road} ${order.user.billingAddress.city}',
                                    style: TextStyle(
                                        color: aTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "$city ,",
                                    //"${order.shippingAddress != null ? order.shippingAddress.city : order.user.billingAddress.city }",
                                    //'${order.user.billingAddress.house} Rd No ${order.user.billingAddress.road} ${order.user.billingAddress.city}',
                                    style: TextStyle(
                                        color: aTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),*/
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
                                    int q = order!.orderFoodItems![index].pivot!
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
                  : Center(child: CircularProgressIndicator()),
            ),
          );
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
  void initState() {
    //Recent orders ...
    final recentOrders = Provider.of<OrderProvider>(context, listen: false);
    recentOrders.getOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recentOrders = Provider.of<OrderProvider>(context);
    return ModalProgressHUD(
      inAsyncCall: onProgress,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: aBackgroundColor,
        floatingActionButton: showFav
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateOrderPage())).then(
                      (value) =>
                          Provider.of<OrderProvider>(context, listen: false)
                              .getOrders());
                },
                backgroundColor: aBlackCardColor,
                child: Icon(
                  Icons.add,
                  size: 30,
                  color: aPrimaryColor,
                ),
              )
            : null,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 15),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          //height: 30,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: aSearchFieldColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: TextButton(
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: OrderSearchHere());
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Search Orders',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Spacer(),
                                Container(
                                    height: 20,
                                    width: 20,
                                    child: Icon(Icons.search)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: recentOrders.orderList.isNotEmpty
                    ? NotificationListener<UserScrollNotification>(
                        onNotification: (notification) {
                          setState(() {
                            if (notification.direction ==
                                ScrollDirection.forward) {
                              showFav = true;
                            } else if (notification.direction ==
                                ScrollDirection.reverse) {
                              showFav = false;
                            }
                          });
                          return true;
                        },
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: recentOrders.orderList.length,
                            itemBuilder: (context, index) {
                              payment = recentOrders.orderList[index].payment!
                                          .paymentStatus
                                          .toString() ==
                                      "1"
                                  ? true
                                  : recentOrders.orderList[index].payment!
                                              .paymentStatus
                                              .toString() ==
                                          "0"
                                      ? false
                                      : false;
                              return Card(
                                elevation: 0.5,
                                child: ExpansionTile(
                                  trailing: Text(
                                    '\৳ ${recentOrders.orderList[index].price ?? ""}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: aPriceTextColor),
                                  ),
                                  title: Text(
                                    '${recentOrders.orderList[index].user!.name ?? ""}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: aTextColor),
                                  ),
                                  leading: Icon(
                                    recentOrders.orderList[index].orderStatus!
                                                .orderStatusCategory!.name ==
                                            'Complete'
                                        ? Icons.check_circle_outlined
                                        : Icons.access_time_rounded,
                                    color: recentOrders
                                                    .orderList[index]
                                                    .orderStatus!
                                                    .orderStatusCategory!
                                                    .name ==
                                                'Complete' ||
                                            recentOrders.orderList[index]
                                                    .payment!.paymentStatus
                                                    .toString() ==
                                                '1'
                                        ? Colors.green
                                        : aPrimaryColor,
                                  ),
                                  subtitle: Text(
                                    '#${recentOrders.orderList[index].id ?? ""}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: aTextColor),
                                  ),
                                  children: [
                                    Divider(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order Status',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: aTextColor
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    print('tap');
                                                    int id = recentOrders
                                                        .orderList[index].id!;
                                                    updateOrderStatus(
                                                            context, id, 1)
                                                        .then((value) =>
                                                            recentOrders
                                                                .getOrders());
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 12,
                                                          width: 12,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: recentOrders
                                                                        .orderList[
                                                                            index]
                                                                        .orderStatus!
                                                                        .orderStatusCategory!
                                                                        .name ==
                                                                    'Ongoing'
                                                                ? aTextColor
                                                                : aNavBarColor,
                                                            border: Border.all(
                                                                color:
                                                                    aTextColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20),
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
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                    int id = recentOrders
                                                        .orderList[index].id!;
                                                    updateOrderStatus(
                                                            context, id, 2)
                                                        .then(
                                                      (value) => recentOrders
                                                          .getOrders(),
                                                    );
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 12,
                                                          width: 12,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: recentOrders
                                                                        .orderList[
                                                                            index]
                                                                        .orderStatus!
                                                                        .orderStatusCategory!
                                                                        .name ==
                                                                    'Delivered'
                                                                ? aTextColor
                                                                : aNavBarColor,
                                                            border: Border.all(
                                                                color:
                                                                    aTextColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20),
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
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                                    int id = recentOrders
                                                        .orderList[index].id!;
                                                    updateOrderStatus(
                                                            context, id, 3)
                                                        .then((value) =>
                                                            recentOrders
                                                                .getOrders());
                                                  },
                                                  child: Container(
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 12,
                                                          width: 12,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: recentOrders
                                                                        .orderList[
                                                                            index]
                                                                        .orderStatus!
                                                                        .orderStatusCategory!
                                                                        .name ==
                                                                    'Complete'
                                                                ? aTextColor
                                                                : aNavBarColor,
                                                            border: Border.all(
                                                                color:
                                                                    aTextColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  20),
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
                                                            fontWeight:
                                                                FontWeight.w400,
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: aTextColor,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    MCustomSwitch(
                                                      value: payment,
                                                      activeColor: aTextColor,
                                                      activeTogolColor:
                                                          aPrimaryColor,
                                                      onChanged: (value) async {
                                                        print(
                                                            "default : $payment");
                                                        setState(() {
                                                          payment = payment!;
                                                          onProgress = true;
                                                        });
                                                        print("$payment");
                                                        int orderId =
                                                            recentOrders
                                                                .orderList[
                                                                    index]
                                                                .id!;

                                                        final uri = Uri.parse(
                                                            "https://apihomechef.antopolis.xyz/api/admin/order/payment/status/update/$orderId");
                                                        var request = http
                                                            .MultipartRequest(
                                                                "POST", uri);
                                                        request.headers.addAll(
                                                            await CustomHttpRequest()
                                                                .getHeaderWithToken());
                                                        var response =
                                                            await request
                                                                .send();
                                                        var responseData =
                                                            await response
                                                                .stream
                                                                .toBytes();
                                                        var responseString =
                                                            String.fromCharCodes(
                                                                responseData);
                                                        print("responseBody " +
                                                            responseString);
                                                        print(
                                                            'responseStatus ${response.statusCode}');
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          print("responseBody1 " +
                                                              responseString);
                                                          var data = jsonDecode(
                                                              responseString);
                                                          print(
                                                              'oooooooooooooooooooo');
                                                          print(data);
                                                          showInToast(
                                                              data['data']
                                                                  ['message']);

                                                          recentOrders
                                                              .getOrders();
                                                          setState(() {
                                                            onProgress = false;
                                                          });
                                                        } else {
                                                          recentOrders
                                                              .getOrders();
                                                          setState(() {
                                                            onProgress = false;
                                                          });
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    )
                                                  ],
                                                ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              int id = recentOrders
                                                  .orderList[index].id!;
                                              print(id);
                                              displayViewDetailsDialog(
                                                  context, id);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                    color: aTextColor,
                                                    width: 0.1),
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
                                                      title: Text(
                                                          'Are you sure ?'),
                                                      titleTextStyle: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: aTextColor),
                                                      titlePadding:
                                                          EdgeInsets.only(
                                                              left: 35,
                                                              top: 25),
                                                      content: Text(
                                                          'delete permanently.'),
                                                      contentTextStyle:
                                                          TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  aTextColor),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 35,
                                                              top: 10,
                                                              right: 40),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        10),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            5)),
                                                                border: Border.all(
                                                                    color:
                                                                        aTextColor,
                                                                    width:
                                                                        0.2)),
                                                            child: Text(
                                                              'CANCEL',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      aTextColor),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15,
                                                                    vertical:
                                                                        10),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .redAccent
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                            ),
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color:
                                                                      aPriceTextColor),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            CustomHttpRequest.deleteOrderItem(
                                                                    context,
                                                                    recentOrders
                                                                        .orderList[
                                                                            index]
                                                                        .id!,
                                                                    onProgress)
                                                                .then((value) =>
                                                                    value);
                                                            setState(() {
                                                              recentOrders
                                                                  .orderList
                                                                  .removeAt(
                                                                      index);
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 5),
                                              decoration: BoxDecoration(
                                                color: aPriceTextColor
                                                    .withOpacity(0.18),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                border: Border.all(
                                                    color: aTextColor,
                                                    width: 0.1),
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
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
