import 'package:admin_app/http/custom_http_request.dart';
import 'package:admin_app/model/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class OrderProvider with ChangeNotifier {
  List<OrderModel> orderList = [];
  late OrderModel orderModel;

  getOrders() async {
    orderList = await CustomHttpRequest().getAllOrders();
    notifyListeners();
  }
}
