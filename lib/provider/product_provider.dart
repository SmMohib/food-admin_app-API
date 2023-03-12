import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/model.dart';
import 'package:admin_app/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProductProvider with ChangeNotifier {
  List<ProductModel> productList = [];
  late ProductModel productModel;

  getProduct() async {
    productList = await CustomHttpRequest().getAllProduct();
    notifyListeners();
  }
}
