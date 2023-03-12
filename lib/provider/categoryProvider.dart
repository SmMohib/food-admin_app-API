import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/category_model.dart';
import 'package:admin_app/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryModel> categoryList = [];
  late CategoryModel categoryModel;

  getCategory() async {
    categoryList = await CustomHttpRequest().getAllCategory();
    notifyListeners();
  }
}
