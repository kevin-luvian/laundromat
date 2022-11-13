import 'package:drift/drift.dart';
import 'package:laundry/db/drift_db.dart';
import 'package:laundry/db/tables/customer.dart';
import 'package:laundry/helpers/utils.dart';

@DriftAccessor(tables: [Customers])
class CustomerDao extends DatabaseAccessor<DriftDB> {
  CustomerDao(DriftDB db) : super(db);

  $CustomersTable get customers => attachedDatabase.customers;

  Future<int> create(Customer customer) => into(customers).insert(customer);

  Future<void> updateName(String id, String? name) async {
    await (update(customers)..where((c) => c.id.equals(id)))
        .write(CustomersCompanion(name: wrapAbsentValue(name)));
  }

  Future<List<Customer>> all() => select(customers).get();

  Stream<List<Customer>> streamAll() => (select(customers)
        ..orderBy([(tbl) => OrderingTerm(expression: tbl.name)]))
      .watch();

  Future<Customer?> findByPhone(String phone) =>
      (select(customers)..where((tbl) => tbl.phone.equals(phone)))
          .getSingleOrNull();
}
