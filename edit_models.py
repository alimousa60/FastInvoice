import sys, re

sys.stdout.reconfigure(encoding='utf-8')

filepath = r'C:\Users\PC3\Desktop\invoice-flutter\lib\main.dart'

with open(filepath, 'r', encoding='utf-8-sig') as f:
    content = f.read()

# ========== 1. Payment class: add customerId, invoiceId fields ==========
old_payment_fields = """  String? notes;



  Payment({required this.amount, required this.date, this.method = PaymentMethod.cash, this.receiptNumber, this.referenceNumber, this.notes})"""

new_payment_fields = """  String? notes;

  String? customerId;

  String? invoiceId;



  Payment({required this.amount, required this.date, this.method = PaymentMethod.cash, this.receiptNumber, this.referenceNumber, this.notes, this.customerId, this.invoiceId})"""

if old_payment_fields in content:
    content = content.replace(old_payment_fields, new_payment_fields)
    print("1. Payment constructor: OK")
else:
    print("1. Payment constructor: NOT FOUND")

# Payment toMap
old_toMap = """    'receiptNumber': receiptNumber, 'referenceNumber': referenceNumber, 'notes': notes,

  };"""
new_toMap = """    'receiptNumber': receiptNumber, 'referenceNumber': referenceNumber, 'notes': notes,

    'customerId': customerId, 'invoiceId': invoiceId,

  };"""

if old_toMap in content:
    content = content.replace(old_toMap, new_toMap, 1)
    print("2. Payment toMap: OK")
else:
    print("2. Payment toMap: NOT FOUND")

# Payment fromMap - add customerId, invoiceId to return
old_fromMap = """      receiptNumber: m['receiptNumber'], referenceNumber: m['referenceNumber'], notes: m['notes'],

    );

  }

}"""

new_fromMap = """      receiptNumber: m['receiptNumber'], referenceNumber: m['referenceNumber'], notes: m['notes'],

      customerId: m['customerId'], invoiceId: m['invoiceId'],

    );

  }

}"""

if old_fromMap in content:
    content = content.replace(old_fromMap, new_fromMap, 1)
    print("3. Payment fromMap: OK")
else:
    print("3. Payment fromMap: NOT FOUND")

# ========== 2. Customer class: add advanceBalance ==========
old_customer_toMap = """  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone, 'address': address, 'priceListId': priceListId};"""
new_customer_toMap = """  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone, 'address': address, 'priceListId': priceListId, 'advanceBalance': advanceBalance};"""

if old_customer_toMap in content:
    content = content.replace(old_customer_toMap, new_customer_toMap, 1)
    print("4. Customer toMap: OK")
else:
    print("4. Customer toMap: NOT FOUND")

old_customer_class = """class Customer {

  String id;

  String name;

  String phone;

  String address;

  String priceListId;



  Customer({required this.id, required this.name, this.phone = '', this.address = '', this.priceListId = ''});"""

new_customer_class = """class Customer {

  String id;

  String name;

  String phone;

  String address;

  String priceListId;

  double advanceBalance;



  Customer({required this.id, required this.name, this.phone = '', this.address = '', this.priceListId = '', this.advanceBalance = 0});"""

if old_customer_class in content:
    content = content.replace(old_customer_class, new_customer_class, 1)
    print("5. Customer class: OK")
else:
    print("5. Customer class: NOT FOUND")

old_customer_fromMap = """  factory Customer.fromMap(Map<String, dynamic> m) => Customer(

    id: m['id'] ?? '', name: m['name'] ?? '', phone: m['phone'] ?? '',

    address: m['address'] ?? '', priceListId: m['priceListId'] ?? '',

  );"""

new_customer_fromMap = """  factory Customer.fromMap(Map<String, dynamic> m) => Customer(

    id: m['id'] ?? '', name: m['name'] ?? '', phone: m['phone'] ?? '',

    address: m['address'] ?? '', priceListId: m['priceListId'] ?? '',

    advanceBalance: (m['advanceBalance'] ?? 0).toDouble(),

  );"""

if old_customer_fromMap in content:
    content = content.replace(old_customer_fromMap, new_customer_fromMap, 1)
    print("6. Customer fromMap: OK")
else:
    print("6. Customer fromMap: NOT FOUND")

# ========== 3. DataStore: add standalonePayments ==========
old_standalone = """  List<Product> _products = [];"""
new_standalone = """  List<Product> _products = [];

  List<Payment> _standalonePayments = [];

  List<Payment> get standalonePayments => List.unmodifiable(_standalonePayments);"""

if old_standalone in content:
    content = content.replace(old_standalone, new_standalone, 1)
    print("7. DataStore standalonePayments: OK")
else:
    print("7. DataStore standalonePayments: NOT FOUND")

# ========== Save ==========
with open(filepath, 'w', encoding='utf-8-sig') as f:
    f.write(content)

print("\nAll model changes saved!")
