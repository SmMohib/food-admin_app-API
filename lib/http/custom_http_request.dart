import 'dart:convert';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/model.dart';
import 'package:admin_app/model/order_model.dart';
import 'package:admin_app/model/product_model.dart';
import 'package:admin_app/widget/widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomHttpRequest {
  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
    "Authorization":
        "bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczpcL1wvYXBpaG9tZWNoZWYuYW50b3BvbGlzLnh5elwvYXBpXC9hZG1pblwvc2lnbi1pbiIsImlhdCI6MTY1NDAwNzYwNiwiZXhwIjoxNjY2OTY3NjA2LCJuYmYiOjE2NTQwMDc2MDYsImp0aSI6IjlLWGFGNmRFdlgwWVNZVzIiLCJzdWIiOjUwLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.Cbii274lgjkMIf2Ix9fZ7e8HPAT47B5MV0QP03Rd520",
  };

  SharedPreferences? sharedPreferences;

  Future<Map<String, String>> getHeaderWithToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "bearer  ${sharedPreferences!.getString("token")}",
    };
    print("token is ${sharedPreferences!.getString("token")}");
    return header;
  }

  Future<Map<String, String>> getHeaderWithToken2() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Content-type": "application/json",
      "Authorization": "bearer ${sharedPreferences!.getString("token")}",
    };
    print("user token is :${sharedPreferences!.getString('token')}");
    return header;
  }

  String allOrderLink =
      "https://apihomechef.antopolis.xyz/api/admin/all/orders";

  Future<dynamic> getAllOrders() async {
    List<OrderModel> orderList = [];
    late OrderModel orderModel;
    var responce = await http.get(Uri.parse(allOrderLink),
        headers: await CustomHttpRequest().getHeaderWithToken());
    if (responce.statusCode == 200) {
      var item = jsonDecode(responce.body);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$item");
      for (var data in item) {
        orderModel = OrderModel.fromJson(data);

        orderList.add(orderModel);
      }
      print("total order is ${orderList.length}");
    }

    return orderList;
  }

  Future<dynamic> getAllCategory() async {
    List<CategoryModel> categoryList = [];
    late CategoryModel categoryModel;
    var responce = await http.get(
        Uri.parse("https://apihomechef.antopolis.xyz/api/admin/category"),
        headers: await CustomHttpRequest().getHeaderWithToken());
    if (responce.statusCode == 200) {
      var item = jsonDecode(responce.body);
      print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa$item");
      for (var data in item) {
        categoryModel = CategoryModel.fromJson(data);

        categoryList.add(categoryModel);
      }
      print("total order is ${categoryList.length}");
    }

    return categoryList;
  }

  static Future<dynamic> deleteCategory(int id) async {
    var responce = await http.delete(
        Uri.parse(
            "https://apihomechef.antopolis.xyz/api/admin/category/$id/delete"),
        headers: await CustomHttpRequest().getHeaderWithToken());

    if (responce.statusCode == 200) {
      showInToast("Category Item Deleted Successfully");
    } else {
      showInToast("PLs try again");
    }
  }

  Future<dynamic> getAllProduct() async {
    List<ProductModel> productList = [];
    late ProductModel productModel;
    var responce = await http.get(
        Uri.parse("https://apihomechef.antopolis.xyz/api/admin/products"),
        headers: await CustomHttpRequest().getHeaderWithToken());
    if (responce.statusCode == 200) {
      var item = jsonDecode(responce.body);
      print("product data areeeeeeee $item");
      for (var data in item) {
        productModel = ProductModel.fromJson(data);

        productList.add(productModel);
      }
      print("total Products  ${productList.length}");
    }
    return productList;
  }

  static Future<dynamic> getCategoriesDropDown() async {
    try {
      String url = "https://apihomechef.antopolis.xyz/api/admin/category";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(myUri,
          headers: await CustomHttpRequest().getHeaderWithToken());
      if (response.statusCode == 200) {
        print(response);
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<ProductModel> getProductEditId(context, int id) async {
    late ProductModel products;
    try {
      String url =
          "https://apihomechef.antopolis.xyz/api/admin/product/$id/edit/";
      Uri myUri = Uri.parse(url);
      var response = await http.get(myUri,
          headers: await CustomHttpRequest().getHeaderWithToken());
      print(response.statusCode);
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        print(item);
        products = ProductModel.fromJson(item);
      } else {
        print('Data not found');
      }
    } catch (e) {
      print(e);
    }
    return products;
  }

  static Future<Order> getOrderWithId(context, int id) async {
    Order? order;
    try {
      String url =
          "https://apihomechef.antopolis.xyz/api/admin/order/$id/invoice";
      Uri myUri = Uri.parse(url);
      var response = await http.get(myUri,
          headers: await CustomHttpRequest().getHeaderWithToken());
      print("Status code issssssssssssssssssss${response.statusCode}");
      if (response.statusCode == 200) {
        final item = json.decode(response.body);
        print(item);
        print('data found');
        order = Order.fromJson(item);

        print(order);
      } else {
        print('Data not found');
      }
    } catch (e) {
      print(e);
    }
    return order!;
  }

  static Future<dynamic> deleteOrderItem(
      BuildContext context, int id, bool onProgress) async {
    try {
      onProgress = true;
      print(id.toString());
      String url =
          "https://apihomechef.antopolis.xyz/api/admin/order/$id/delete";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.delete(myUri,
          headers: await CustomHttpRequest().getHeaderWithToken());
      final data = jsonDecode(response.body);
      print(data.toString());
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(data);
        print("delete sucessfully");
        print(data['message'].toString());
        onProgress = false;
        showInToast("context,'${data['message']}");
        return response;
      } else {
        onProgress = false;
        throw Exception("Can't delete ");
      }
    } catch (e) {
      onProgress = false;
      print(e);
    }
  }

  static Future<dynamic> getProductDropDown() async {
    try {
      String url = "https://apihomechef.antopolis.xyz/api/admin/products";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(myUri,
          headers: await CustomHttpRequest().getHeaderWithToken());
      if (response.statusCode == 200) {
        print(response);
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> getUsersDropDown() async {
    try {
      String url = "https://apihomechef.antopolis.xyz/api/admin/all/user";
      Uri myUri = Uri.parse(url);
      http.Response response = await http.get(myUri,
          headers: await CustomHttpRequest().getHeaderWithToken());
      if (response.statusCode == 200) {
        print(response);
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }
}
