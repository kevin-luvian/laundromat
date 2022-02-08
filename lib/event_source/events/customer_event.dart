import 'package:laundry/helpers/utils.dart';

const customerEventType = "CUSTOMER";

class CustomerCreated implements EventData<CustomerCreated> {
  final String name;
  final String phone;

  CustomerCreated({required this.name, required this.phone});

  @override
  get tag => staticTag;
  static const String staticTag = "CustomerCreated";

  @override
  get serializer => CustomerCreatedSerializer();
}

class CustomerUpdated implements EventData<CustomerUpdated> {
  final String? phone;
  final String? name;

  CustomerUpdated({this.phone, this.name});

  @override
  get tag => staticTag;
  static const String staticTag = "CustomerUpdated";

  @override
  get serializer => CustomerUpdatedSerializer();
}

/// SERIALIZERS ==============================================================

class CustomerCreatedSerializer implements Serializer<CustomerCreated> {
  @override
  fromJson(data) => CustomerCreated(
        phone: data["phone"] as String,
        name: data["name"] as String,
      );

  @override
  toJson(t) => <String, dynamic>{"phone": t.phone, "name": t.name};
}

class CustomerUpdatedSerializer implements Serializer<CustomerUpdated> {
  @override
  fromJson(data) => CustomerUpdated(
        name: data["name"] as String,
        phone: data["phone"] as String,
      );

  @override
  toJson(t) => <String, dynamic>{"name": t.name, "phone": t.phone};
}
