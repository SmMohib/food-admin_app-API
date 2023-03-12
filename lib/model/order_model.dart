class Order {
  Order({
    this.id,
    this.quantity,
    this.price,
    this.discount,
    this.vat,
    this.orderDateAndTime,
    this.user,
    this.shippingAddress,
    this.orderFoodItems,
    this.payment,
    this.orderStatus,
  });

  int? id;
  int? quantity;
  int? price;
  dynamic? discount;
  dynamic? vat;
  DateTime? orderDateAndTime;
  User? user;
  IngAddress? shippingAddress;
  List<OrderFoodItem>? orderFoodItems;
  Payment? payment;
  OrderStatus? orderStatus;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"],
        discount: json["discount"],
        vat: json["VAT"],
        orderDateAndTime: DateTime.parse(json["order_date_and_time"]),
        user: User.fromJson(json["user"]),
        shippingAddress: json["shipping_address"] != null
            ? IngAddress.fromJson(json["shipping_address"])
            : null,
        orderFoodItems: List<OrderFoodItem>.from(
            json["order_food_items"].map((x) => OrderFoodItem.fromJson(x))),
        payment: Payment.fromJson(json["payment"]),
        orderStatus: OrderStatus.fromJson(json["order_status"]),
      );
}

class OrderFoodItem {
  OrderFoodItem({
    this.id,
    this.name,
    this.pivot,
    this.price,
  });

  int? id;
  String? name;
  Pivot? pivot;
  List<Price>? price;

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) => OrderFoodItem(
        id: json["id"],
        name: json["name"],
        pivot: Pivot.fromJson(json["pivot"]),
        price: List<Price>.from(json["price"].map((x) => Price.fromJson(x))),
      );
}

class Pivot {
  Pivot({
    this.orderId,
    this.foodItemId,
    this.foodItemPriceId,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  int? orderId;
  int? foodItemId;
  int? foodItemPriceId;
  int? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
        orderId: json["order_id"],
        foodItemId: json["food_item_id"],
        foodItemPriceId: json["food_item_price_id"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );
}

class Price {
  Price({
    this.originalPrice,
    this.discountedPrice,
  });

  int? originalPrice;
  int? discountedPrice;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        originalPrice: json["original_price"],
        discountedPrice: json["discounted_price"],
      );
}

class OrderStatus {
  OrderStatus({
    this.orderStatusCategory,
  });

  OrderStatusCategory? orderStatusCategory;

  factory OrderStatus.fromJson(Map<String, dynamic> json) => OrderStatus(
        orderStatusCategory:
            OrderStatusCategory.fromJson(json["order_status_category"]),
      );
}

class OrderStatusCategory {
  OrderStatusCategory({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory OrderStatusCategory.fromJson(Map<String, dynamic> json) =>
      OrderStatusCategory(
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

class IngAddress {
  IngAddress({
    this.area,
    this.appartment,
    this.house,
    this.road,
    this.city,
    this.district,
    this.zipCode,
    this.contact,
  });

  String? area;
  String? appartment;
  String? house;
  String? road;
  String? city;
  String? district;
  String? zipCode;
  String? contact;

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
        area: json["area"],
        appartment: json["appartment"],
        house: json["house"],
        road: json["road"],
        city: json["city"],
        district: json["district"],
        zipCode: json["zip_code"],
        contact: json["contact"],
      );
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.contact,
    this.image,
    this.billingAddress,
  });

  int? id;
  String? name;
  String? email;
  String? contact;
  String? image;
  IngAddress? billingAddress;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        contact: json["contact"],
        image: json["image"],
        billingAddress: IngAddress.fromJson(json["billing_address"]),
      );
}
