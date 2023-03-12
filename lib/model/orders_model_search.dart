class Orders {
  Orders({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.vat,
    this.orderDateAndTime,
    this.user,
    this.payment,
    this.orderStatus,
  });

  int? id;
  int ?quantity;
  int ?price;
  dynamic discount;
  dynamic vat;
  DateTime ?orderDateAndTime;
  User ?user;
  Payment ?payment;
  OrderStatus? orderStatus;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    id: json["id"],
    quantity: json["quantity"],
    price: json["price"],
    discount: json["discount"],
    vat: json["VAT"],
    orderDateAndTime: DateTime.parse(json["order_date_and_time"]),
    user: User.fromJson(json["user"]),
    payment: Payment.fromJson(json["payment"]),
    orderStatus: OrderStatus.fromJson(json["order_status"]),
  );


}

class OrderStatus {
  OrderStatus({
    this.orderStatusCategory,
  });

  User? orderStatusCategory;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
    orderStatusCategory: User.fromJson(json["order_status_category"]),
  );


}

class User {
  User({
    this.id,
    this.name,
  });

  int ?id;
  String? name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );


}

class Payment {
  Payment({
    this.paymentStatus,
  });

  int? paymentStatus;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    paymentStatus: json["payment_status"],
  );

}
