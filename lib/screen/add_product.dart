import 'dart:convert';
import 'dart:io';
import 'package:admin_app/widget/custom_TextField.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:http/http.dart' as http;
import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/widget/brand_colors.dart';
import 'package:flutter/material.dart';
//import "package:image_picker/image_picker.dart";
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountAmountController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();

  // double price;
  // double disAmount;
  double? disPrice;
  bool? onProgress = false;

  dynamic discountPrice;
  dynamic amount;
  String? discount_type;

  _calcutateFix() {
    if (isFixed) {
      setState(() {
        discountPrice =
            int.parse(priceController.text.toString()) - int.parse(amount);
        print('...................................');
        print(discountPrice);
        discount_type = 'fixed';
      });
    } else {
      setState(() {
        dynamic price = int.parse(priceController.text.toString()) *
            int.parse(amount) /
            100;
        discountPrice = int.parse(priceController.text.toString()) - price;
        print('.......percent............................');
        print(discountPrice);
        discount_type = "percent";
      });
    }
  }

  String? categoryType;

  List? categoryList;

  Future<dynamic> getCategory() async {
    setState(() {
      onProgress = true;
    });
    await CustomHttpRequest.getCategoriesDropDown().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        categoryList = dataa;
        onProgress = false;
        print("all categories are : $categoryList");
      });
    });
  }

  bool isFixed = true;
  bool isPercentage = false;
  bool isImageVisiable = false;
  File? image;
  // final picker = ImagePicker();

  // Future getImageformGallery() async {
  //   print('on the way of gallery');
  //   final pickedImage = await picker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     if (pickedImage != null) {
  //       image = File(pickedImage.path);
  //       print('image found');
  //       print('$image');
  //       setState(() {
  //         isImageVisiable = true;
  //       });
  //     } else {
  //       print('no image found');
  //     }
  //   });
  // }

  Future addProduct(BuildContext context) async {
    try {
      if (mounted) {
        setState(() {
          onProgress = true;
        });
        var data;

        final uri = Uri.parse(
            "https://apihomechef.antopolis.xyz/api/admin/product/store");
        var request = http.MultipartRequest("POST", uri);
        request.headers.addAll(await CustomHttpRequest().getHeaderWithToken());
        request.fields['name'] = nameController.text.toString();
        request.fields['category_id'] = categoryType.toString();
        request.fields['quantity'] = quantityController.text.toString();
        request.fields['original_price'] = priceController.text.toString();
        request.fields['discount_type'] = "fixed";
        request.fields['percent_of'] = "0";

        request.fields['fixed_value'] = "0";

        request.fields['discounted_price'] = "10";
        var photo = await http.MultipartFile.fromPath('image', image!.path);
        print('processing');
        request.files.add(photo);
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print("responseBody " + responseString);
        data = jsonDecode(responseString);
        print(data);
        //var data = jsonDecode(responseString);
        //showInToast(data['email'].toString());
        //stay here
        if (response.statusCode == 201) {
          print("responseBody1 " + responseString);
          data = jsonDecode(responseString);
          //var data = jsonDecode(responseString);
          showInToast(data['message'].toString());

          //go to the login page
          Navigator.pop(context);
        } else {
          showInToast(data['errors']['image'][0]);
          setState(() {
            onProgress = false;
          });
          var errorr = jsonDecode(responseString.trim().toString());
          //showInToast("Registered Failed, please fill all the fields");
          print("Registered failed " + responseString);
        }
      }
    } catch (e) {
      print("something went wrong $e");
    }
  }

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double weidth = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: onProgress!,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        backgroundColor: aNavBarColor,
        appBar: AppBar(
          backgroundColor: aNavBarColor,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: aTextColor,
            ),
          ),
          title: Text('Add new product'),
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        body: RawScrollbar(
          thumbColor: aPrimaryColor,
          isAlwaysShown: true,
          thickness: 3.0,
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 3, bottom: 0),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      decoration: BoxDecoration(
                          color: aSearchFieldColor,
                          border: Border.all(color: Colors.grey, width: 0.2),
                          borderRadius: BorderRadius.circular(10.0)),
                      height: 60,
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          isExpanded: true,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            size: 30,
                          ),
                          decoration: InputDecoration.collapsed(hintText: ''),
                          value: categoryType,
                          hint: Text(
                            'Select Category',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: aTextColor, fontSize: 16),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              categoryType = newValue;
                              print("my Category is $categoryType");
                              if (categoryType!.isEmpty) {
                                showInToast("Category Type required");
                              }
                              // print();
                            });
                          },
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          items: categoryList?.map((item) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                    "${item['name']}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: aTextColor,
                                        fontWeight: FontWeight.w400),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  value: item['id'].toString(),
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      lebelText: 'Product Name',
                      hintText: 'Enter Product name',
                      controller: nameController,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "*Please give product name";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      lebelText: 'Product Details',
                      hintText: 'Write details here...',
                      maxNumber: 5,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            lebelText: 'Quantity(Units)',
                            hintText: 'Enter amount',
                            controller: quantityController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "*How much product you have";
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: CustomTextField(
                            lebelText: 'Price(BDT)',
                            hintText: 'Enter price',
                            controller: priceController,
                            validator: (value) {
                              if (value.isEmpty) {
                                return "*Please give product price";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                      // padding: EdgeInsets.symmetric(
                      //     horizontal: 10,),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Discount',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    CustomTextField(
                      lebelText: 'Discount Amount',
                      hintText: 'Enter discount amount',
                      controller: discountAmountController,
                      onChangeFunction: (value) {
                        setState(() {
                          amount = value;
                          _calcutateFix();
                        });
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "*Please give discount";
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Product Image',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      // overflow: Overflow.visible,
                      children: [
                        Container(
                          height: height * 0.3,
                          width: weidth * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: image == null
                              ? InkWell(
                                  onTap: () {
                                    //    getImageformGallery();
                                  },
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                              color:
                                                  aTextColor.withOpacity(0.5)),
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
                        Positioned(
                          bottom: -25,
                          left: weidth * 0.4,
                          child: Visibility(
                            visible: isImageVisiable,
                            child: TextButton(
                              onPressed: () {
                                // getImageformGallery();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                    color: Colors.black,
                                    border: Border.all(
                                        color: aNavBarColor, width: 1.5)),
                                child: Center(
                                  child: Container(
                                    height: 20,
                                    width: 20,
                                    child: Icon(Icons.message),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Text(
                      '* 640x360 is the Recommended Size',
                      style: TextStyle(
                          color: Colors.black26,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          color: Colors.black,
                          border: Border.all(color: aTextColor, width: 0.5),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (image == null) {
                                showInToast('Please select product image');
                              } else {
                                addProduct(context);
                              }
                            }
                          },
                          child: Center(
                            child: Text(
                              'Publish Product',
                              style: TextStyle(
                                  color: aPrimaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
