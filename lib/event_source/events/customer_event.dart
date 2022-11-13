import 'package:laundry/helpers/utils.dart';

const customerEventType = "CUSTOMER";

class CustomerCreated implements EventData<CustomerCreated> {
  final String name;
  final String phone;
  final String createdBy;

  CustomerCreated(
      {required this.name, required this.phone, required this.createdBy});

  @override
  get tag => staticTag;
  static const String staticTag = "CustomerCreated";

  @override
  get serializer => CustomerCreatedSerializer();
}

class CustomerUpdated implements EventData<CustomerUpdated> {
  final String? phone;
  final String? name;
  final String updatedBy;

  CustomerUpdated({this.phone, this.name, required this.updatedBy});

  @override
  get tag => staticTag;
  static const String staticTag = "CustomerUpdated";

  @override
  get serializer => CustomerUpdatedSerializer();
}

class CustomerDeactivated implements EventData<CustomerDeactivated> {
  final String deactivatedBy;

  CustomerDeactivated({required this.deactivatedBy});

  @override
  get tag => staticTag;
  static const String staticTag = "CustomerDeactivated";

  @override
  get serializer => CustomerDeactivatedSerializer();
}

class CustomerReactivated implements EventData<CustomerReactivated> {
  final String reactivatedBy;

  CustomerReactivated({required this.reactivatedBy});

  @override
  get tag => staticTag;
  static const String staticTag = "CustomerReactivated";

  @override
  get serializer => CustomerReactivatedSerializer();
}

/// SERIALIZERS ==============================================================

class CustomerCreatedSerializer implements Serializer<CustomerCreated> {
  @override
  fromJson(data) => CustomerCreated(
        phone: data["phone"] as String,
        name: data["name"] as String,
        createdBy: data["createdBy"] as String,
      );

  @override
  toJson(t) => <String, dynamic>{
        "phone": t.phone,
        "name": t.name,
        "createdBy": t.createdBy,
      };
}

class CustomerUpdatedSerializer implements Serializer<CustomerUpdated> {
  @override
  fromJson(data) => CustomerUpdated(
        name: data["name"] as String,
        phone: data["phone"] as String,
        updatedBy: data["updatedBy"] as String,
      );

  @override
  toJson(t) => <String, dynamic>{
        "name": t.name,
        "phone": t.phone,
        "updatedBy": t.updatedBy,
      };
}

class CustomerDeactivatedSerializer implements Serializer<CustomerDeactivated> {
  @override
  fromJson(data) => CustomerDeactivated(
    deactivatedBy: data["deactivatedBy"] as String,
  );

  @override
  toJson(t) => <String, dynamic>{
    "deactivatedBy": t.deactivatedBy,
  };
}

class CustomerReactivatedSerializer implements Serializer<CustomerReactivated> {
  @override
  fromJson(data) => CustomerReactivated(
    reactivatedBy: data["reactivatedBy"] as String,
  );

  @override
  toJson(t) => <String, dynamic>{
    "reactivatedBy": t.reactivatedBy,
  };
}
