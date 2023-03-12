import 'dart:convert';

import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/provider/product_provider.dart';
import 'package:admin_app/screen/add_product.dart';
import 'package:admin_app/screen/edit_product.dart';
import 'package:admin_app/widget/Constants.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool? visible;
  bool? available;
  bool onProgress = false;

  ScrollController? _scrollController;
  bool showFav = true;

  Future<void> availabilityUpdate(BuildContext context, int id) async {
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "https://apihomechef.antopolis.xyz/api/admin/product/update/available/status/$id");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequest().getHeaderWithToken());
    var response = await request.send();
    if (response.statusCode == 200) {
      showInToast("Product Status Update Successfull");
      setState(() {
        onProgress = false;
      });
    } else {
      showInToast("Something wrong, Pls try again");
      setState(() {
        onProgress = false;
      });
    }
  }

  Future<void> visibilityUpdate(BuildContext context, int id) async {
    setState(() {
      onProgress = true;
    });
    print(id);
    final uri = Uri.parse(
        "https://apihomechef.antopolis.xyz/api/admin/product/update/visible/status/$id");
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
      print(data['message']);
      showInToast(data['message']);
      setState(() {
        onProgress = false;
      });
    } else {
      setState(() {
        onProgress = false;
      });
    }
  }

  @override
  void initState() {
    final productsData = Provider.of<ProductProvider>(context, listen: false);
    productsData.getProduct();
    // print('$onProgress');

    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final profileData = Provider.of<ProfileProvider>(context);
    final productsData = Provider.of<ProductProvider>(context);

    return ModalProgressHUD(
      inAsyncCall: onProgress,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        backgroundColor: aBackgroundColor,
        floatingActionButton: showFav
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AddProduct()))
                      .then((value) => productsData.getProduct());
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
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: aSearchFieldColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // showSearch(context: context, delegate: ProductSearchHere(itemsList: productsData.productsList ));
                      },
                      child: Row(
                        children: [
                          Text(
                            'Search Products',
                            style: TextStyle(
                              color: Colors.black45,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 12,
              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: 10),
                child: productsData.productList.isNotEmpty
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
                            controller: _scrollController,
                            itemCount: productsData.productList.length,
                            itemBuilder: (context, index) {
                              String productVisible = productsData
                                  .productList[index].isVisible
                                  .toString();
                              String productAvailable = productsData
                                  .productList[index].isAvailable
                                  .toString();
                              print(
                                  'product discount type:  ${productsData.productList[index].price![0].discountType}');

                              visible = productVisible == '1'
                                  ? true
                                  : productVisible == '0'
                                      ? false
                                      : false;
                              available = productAvailable == '1'
                                  ? true
                                  : productAvailable == '0'
                                      ? false
                                      : false;
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 200,
                                      color: Colors.lightBlueAccent,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  ),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(
                                                          "https://apihomechef.antopolis.xyz/images/${productsData.productList[index].image ?? ""}"))),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 6,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${productsData.productList[index].name ?? ""}',
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: aTextColor),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '\৳${productsData.productList[index].price![0].discountedPrice ?? ""}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    aPriceTextColor),
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            '\৳${productsData.productList[index].price![0].originalPrice ?? ""}',
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: aTextColor
                                                                    .withOpacity(
                                                                        0.5)),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Visibility',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: aTextColor,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          /*   MCustomSwitch(
                                                            value: visible,
                                                            activeColor:
                                                                aTextColor,
                                                            activeTogolColor:
                                                                aPrimaryColor,
                                                            onChanged:
                                                                (value) async {
                                                              print(
                                                                  "defaulttttttttttttttttttttttt : $value");
                                                              setState(() {
                                                                visible ==true? visible=false:visible=true;
                                                                onProgress =
                                                                false;
                                                              });
                                                              print("$visible");
                                                              int? productId =
                                                                  productsData
                                                                      .productsList[
                                                                          index]
                                                                      .id;

                                                              visibilityUpdate(
                                                                      context,
                                                                      productId!)
                                                                  .then(
                                                                (value) => productsData
                                                                    .getProducts(
                                                                        context,
                                                                        onProgress),
                                                              );
                                                            },
                                                          ),*/
                                                          SizedBox(
                                                            width: 10,
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'Availability',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: aTextColor,
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            width: 70,
                                                            height: 30,
                                                            child:
                                                                FlutterSwitch(
                                                              width: 125.0,
                                                              height: 55.0,
                                                              valueFontSize:
                                                                  25.0,
                                                              toggleSize: 45.0,
                                                              value: available!,
                                                              borderRadius:
                                                                  30.0,
                                                              padding: 8.0,
                                                              showOnOff: true,
                                                              onToggle: (val) {
                                                                available = val;

                                                                print(
                                                                    "$available");
                                                                int? productId =
                                                                    productsData
                                                                        .productList[
                                                                            index]
                                                                        .id;

                                                                availabilityUpdate(
                                                                        context,
                                                                        productId!)
                                                                    .then(
                                                                  (value) =>
                                                                      productsData
                                                                          .getProduct(),
                                                                );
                                                              },
                                                            ),
                                                          ),

                                                          /*MCustomSwitch(
                                                            value: available,
                                                            activeColor:
                                                            aTextColor,
                                                            activeTogolColor:
                                                            aPrimaryColor,
                                                            onChanged:
                                                                (value) async {
                                                              print(
                                                                  "default : $available");
                                                              setState(() {
                                                                available =
                                                                !available!;
                                                                onProgress =
                                                                false;
                                                              });
                                                              print(
                                                                  "$available");
                                                              int ? productId =
                                                                  productsData
                                                                      .productsList[
                                                                  index]
                                                                      .id;

                                                              availabilityUpdate(
                                                                  context,
                                                                  productId!)
                                                                  .then(
                                                                    (value) => productsData
                                                                    .getProducts(
                                                                    context,
                                                                    onProgress),
                                                              );
                                                            },
                                                          ),*/
                                                          SizedBox(
                                                            width: 10,
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: PopupMenuButton<String>(
                                        onSelected: (value) {
                                          String choice = value;
                                          if (choice == Constants.Edit) {
                                            print('edit');
                                            print(
                                                'id  : ${productsData.productList[index].id}');
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return EditProduct();
                                            })).then((value) =>
                                                Provider.of<ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .getProduct());
                                          } else if (choice ==
                                              Constants.Delete) {
                                            print('delete');
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title:
                                                        Text('Are you sure ?'),
                                                    titleTextStyle: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: aTextColor),
                                                    titlePadding:
                                                        EdgeInsets.only(
                                                            left: 35, top: 25),
                                                    content: Text(
                                                        'Once you delete, the item will gone permanently.'),
                                                    contentTextStyle: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: aTextColor),
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
                                                                  vertical: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(Radius
                                                                          .circular(
                                                                              5)),
                                                              border: Border.all(
                                                                  color:
                                                                      aTextColor,
                                                                  width: 0.2)),
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
                                                                  vertical: 10),
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
                                                          /*   CustomHttpRequest
                                                        .deleteProductItem(
                                                        context,
                                                        productsData
                                                            .productsList[
                                                        index]
                                                            .id)
                                                        .then((value) => productsData.getProducts(context,onProgress));
                                                    setState(() {
                                                      productsData.productsList
                                                          .removeAt(index);
                                                    });
                                                    Navigator.pop(context);*/
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }
                                        },
                                        itemBuilder: (context) {
                                          return Constants.choices
                                              .map((String e) {
                                            return PopupMenuItem<String>(
                                                value: e, child: Text(e));
                                          }).toList();
                                        },
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
