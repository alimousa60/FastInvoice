import 'dart:convert';

import 'dart:io';

import 'dart:math';

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:share_plus/share_plus.dart';

import 'package:printing/printing.dart';

import 'package:pdf/pdf.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:uuid/uuid.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:image_picker/image_picker.dart';

import 'package:lottie/lottie.dart';

import 'package:shimmer/shimmer.dart';

import 'package:path_provider/path_provider.dart';



String fixPdfArabic(String text) {

  if (text.isEmpty) return text;

  final buffer = StringBuffer();

  for (final word in text.split(' ')) {

    if (word.isEmpty) { buffer.write(' '); continue; }

    final hasArabic = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]').hasMatch(word);

    if (hasArabic) {

      buffer.write(word.split('').reversed.join(''));

    } else {

      buffer.write(word);

    }

    buffer.write(' ');

  }

  return buffer.toString().trim();

}



pw.Text pdfText(String text, {pw.TextStyle? style}) =>

    pw.Text(fixPdfArabic(text), style: style);



// ==================== TRANSLATIONS ====================

const Map<String, String> _en = {

  'appTitle': 'Invoice Maker',

  'invoices': 'Invoices',

  'payments': 'Payments',

  'products': 'Products',

  'customers': 'Customers',

  'statistics': 'Statistics',

  'settings': 'Settings',

  'newInvoice': 'New Invoice',

  'darkMode': 'Dark Mode',

  'enabled': 'Enabled',

  'disabled': 'Disabled',

  'language': 'Language',

  'arabic': 'Arabic',

  'english': 'English',

  'search': 'Search...',

  'sort': 'Sort',

  'filter': 'Filter',

  'all': 'All',

  'paid': 'Paid',

  'partial': 'Partial',

  'unpaid': 'Unpaid',

  'total': 'Total',

  'remaining': 'Remaining',

  'paid2': 'Paid',

  'amount': 'Amount',

  'save': 'Save',

  'cancel': 'Cancel',

  'delete': 'Delete',

  'add': 'Add',

  'confirm': 'Confirm',

  'restore': 'Restore',

  'apply': 'Apply',

  'close': 'Close',

  'share': 'Share',

  'export': 'Export',

  'backup': 'Backup',

  'restoreBackup': 'Restore Backup',

  'exportAll': 'Export all data',

  'importFromAbk': 'Import from .abk file',

  'exportProducts': 'Export Products CSV',

  'exportCustomers': 'Export Customers CSV',

  'exportInvoices': 'Export Invoices CSV',

  'clearAll': 'Clear All Data',

  'clearAllConfirm': 'Delete all invoices and products?',

  'noInvoices': 'No Invoices',

  'noProducts': 'No Products',

  'noCustomers': 'No Customers',

  'noPayments': 'No Payments Yet',

  'startCreate': 'Start by creating a new invoice',

  'addProducts': 'Add your products to start',

  'addCustomers': 'Add your customers to track their invoices',

  'addProduct': 'Add Product',

  'addCustomer': 'Add Customer',

  'productName': 'Product Name *',

  'barcode': 'Barcode',

  'buyPrice': 'Buy Price',

  'sellPrice': 'Sell Price *',

  'quantity': 'Quantity',

  'category': 'Category',

  'unit': 'Unit',

  'customerName': 'Customer Name *',

  'phone': 'Phone',

  'address': 'Address',

  'paymentMethod': 'Payment Method',

  'cash': 'Cash',

  'bankTransfer': 'Bank Transfer',

  'mobileMoney': 'Mobile',

  'check': 'Check',

  'creditCard': 'Credit Card',

  'other': 'Other',

  'discount': 'Discount',

  'subtotal': 'Subtotal',

  'notes': 'Notes',

  'dueDate': 'Due Date',

  'template': 'Template',

  'classic': 'Classic',

  'modern': 'Modern',

  'simple': 'Simple',

  'corporate': 'Corporate',

  'colorful': 'Colorful',

  'dark': 'Dark',

  'newest': 'Newest First',

  'oldest': 'Oldest First',

  'highest': 'Highest Amount',

  'lowest': 'Lowest Amount',

  'byName': 'By Customer Name',

  'filterAdvanced': 'Advanced Filter',

  'clearFilter': 'Clear Filter',

  'fromDate': 'From Date:',

  'toDate': 'To Date:',

  'minAmount': 'Min Amount:',

  'maxAmount': 'Max Amount:',

  'sellerInfo': 'Seller Info',

  'invoiceSettings': 'Invoice Settings',

  'dataManagement': 'Data Management',

  'nightMode': 'Night Mode',

  'selectProduct': 'Select Product',

  'selectCustomer': 'Select Customer',

  'createInvoice': 'Create Invoice',

  'editInvoice': 'Edit Invoice',

  'saveInvoice': 'Save Invoice',

  'shareInvoice': 'Share Invoice',

  'items': 'Items',

  'addItems': 'Add items first',

  'enterCustomerName': 'Enter customer name',

  'saved': 'Saved',

  'deleted': 'Deleted',

  'error': 'Error in data',

  'whatsApp': 'WhatsApp',

  'telegram': 'Telegram',

  'copyText': 'Copy Text',

  'quickPay': 'Quick Pay',

  'half': 'Half',

  'quarter': 'Quarter',

  'third': 'Third',

  'customerStatement': 'Customer Statement',

  'purchase': 'Purchase',

  'sale': 'Sale',

  'unit2': 'Piece',

  'pcs': 'pcs',

  'statsTotal': 'Total Sales',

  'statsInvoices': 'Invoices',

  'statsPaid': 'Paid',

  'statsRemaining': 'Remaining',

  'statsAvg': 'Average',

  'statsProducts': 'Products',

  'topCustomers': 'Top Customers',

  'recentInvoices': 'Recent Invoices',

  'overdueInvoices': 'Overdue Invoices',

  'daysOverdue': 'days overdue',

  'daysLeft': 'days left',

  'paidStatus': 'Paid',

  'partialStatus': 'Partial',

  'unpaidStatus': 'Unpaid',

  'overdue': 'Overdue',

  'onboardingTitle1': 'Create Invoices',

  'onboardingDesc1': 'Create professional sales invoices with one tap',

  'onboardingTitle2': 'Instant Sharing',

  'onboardingDesc2': 'Share invoices via WhatsApp, Telegram or PDF',

  'onboardingTitle3': 'Smart Tracking',

  'onboardingDesc3': 'Track sales and customers with detailed statistics',

  'skip': 'Skip',

  'next': 'Next',

  'start': 'Start',

  'enterAmount': 'Enter amount',

  'selectCustomer2': 'Select customer',

  'paymentType': 'Payment Type',

  'singleInvoice': 'Single Invoice',

  'multiInvoice': 'Multi Invoice',

  'advancePayment': 'Advance Payment',

  'saveAdvance': 'Save Advance Payment',

  'confirmPayment': 'Confirm Payment',

  'confirmReceive': 'Confirm Receive',

  'receive': 'Receive',

  'itemsCount': 'Items',

  'selectDueDate': 'Tap to select due date',

  'canChangeSettings': '(can be changed in settings)',

  'image': 'Image',

  'deleteProduct': 'Delete Product',

  'deleteCustomer': 'Delete Customer',

  'areYouSureDelete': 'Are you sure you want to delete',

  'priceList': 'Price List',

  'overdueAlert': 'Overdue Alert',

  'whatsNew': "What's New",

  'done': 'Done',

  'pasteBackupHere': 'Paste backup text here...',

  'invoice': 'Invoice',

  'payment': 'Payment',

};

String tr(String key, {bool? isEng}) {

  final eng = isEng ?? false;

  if (!eng) return key;

  return _en[key] ?? key;

}



// ==================== CSV EXPORT ====================

String _escapeCsv(String value) {

  if (value.contains(',') || value.contains('"') || value.contains('\n')) {

    return '"${value.replaceAll('"', '""')}"';

  }

  return value;

}

String _csvRow(List<String> cells) => cells.map(_escapeCsv).join(',');



Future<void> exportProductsCsv(List<Product> products) async {

  final rows = <String>[

    _csvRow(['اسم المنتج', 'الباركود', 'سعر الشراء', 'سعر البيع', 'الوحدة', 'المخزون', 'التصنيف']),

    ...products.map((p) => _csvRow([

      p.name, p.barcode, p.buyPrice.toStringAsFixed(2),

      p.sellPrice.toStringAsFixed(2), p.unit, p.quantity.toString(), p.category,

    ])),

  ];

  final csv = rows.join('\r\n');

  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/products.csv');

  await file.writeAsString('\uFEFF$csv');

  SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'تصدير المنتجات'));

}



Future<void> exportCustomersCsv(List<Customer> customers) async {

  final rows = <String>[

    _csvRow(['اسم العميل', 'الهاتف', 'العنوان', 'الرصيد']),

    ...customers.map((c) => _csvRow([

      c.name, c.phone, c.address, c.advanceBalance.toStringAsFixed(2),

    ])),

  ];

  final csv = rows.join('\r\n');

  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/customers.csv');

  await file.writeAsString('\uFEFF$csv');

  SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'تصدير العملاء'));

}



Future<void> exportInvoicesCsv(List<Invoice> invoices) async {

  final rows = <String>[

    _csvRow(['رقم الفاتورة', 'التاريخ', 'العميل', 'الهاتف', 'الإجمالي', 'المدفوع', 'المتبقي', 'الحالة']),

    ...invoices.map((inv) => _csvRow([

      inv.id, inv.date, inv.buyerName, inv.buyerPhone,

      inv.total.toStringAsFixed(2), inv.totalPaid.toStringAsFixed(2),

      inv.remaining.toStringAsFixed(2),

      inv.status == 'paid' ? 'مدفوع' : (inv.status == 'partial' ? 'جزئي' : 'غير مدفوع'),

    ])),

  ];

  final csv = rows.join('\r\n');

  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/invoices.csv');

  await file.writeAsString('\uFEFF$csv');

  SharePlus.instance.share(ShareParams(files: [XFile(file.path)], subject: 'تصدير الفواتير'));

}



void main() {

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(

    statusBarColor: Colors.transparent,

    statusBarIconBrightness: Brightness.light,

  ));

  runApp(const MainApp());

}



// ==================== MODELS ====================

class Product {

  String id;

  String name;

  String barcode;

  String category;

  double buyPrice;

  double sellPrice;

  int quantity;

  String unit;

  String imagePath;



  Product({

    required this.id,

    required this.name,

    this.barcode = '',

    this.category = '',

    this.buyPrice = 0,

    this.sellPrice = 0,

    this.quantity = 0,

    this.unit = 'قطعة',

    this.imagePath = '',

  });



  Map<String, dynamic> toMap() => {

    'id': id, 'name': name, 'barcode': barcode, 'category': category,

    'buyPrice': buyPrice, 'sellPrice': sellPrice, 'quantity': quantity, 'unit': unit,

    'imagePath': imagePath,

  };



  factory Product.fromMap(Map<String, dynamic> m) => Product(

    id: m['id'] ?? '', name: m['name'] ?? '', barcode: m['barcode'] ?? '',

    category: m['category'] ?? '', buyPrice: (m['buyPrice'] ?? 0).toDouble(),

    sellPrice: (m['sellPrice'] ?? 0).toDouble(), quantity: m['quantity'] ?? 0, unit: m['unit'] ?? 'قطعة',

    imagePath: m['imagePath'] ?? '',

  );

}



class Customer {

  String id;

  String name;

  String phone;

  String address;

  String priceListId;

  double advanceBalance;



  Customer({required this.id, required this.name, this.phone = '', this.address = '', this.priceListId = '', this.advanceBalance = 0});



  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone, 'address': address, 'priceListId': priceListId, 'advanceBalance': advanceBalance};



  factory Customer.fromMap(Map<String, dynamic> m) => Customer(

    id: m['id'] ?? '', name: m['name'] ?? '', phone: m['phone'] ?? '',

    address: m['address'] ?? '', priceListId: m['priceListId'] ?? '',

    advanceBalance: (m['advanceBalance'] ?? 0).toDouble(),

  );

}



class InvoiceItem {

  String productId;

  String name;

  double price;

  int quantity;

  double discountPct;

  double discountAmt;



  InvoiceItem({

    required this.productId,

    required this.name,

    required this.price,

    this.quantity = 1,

    this.discountPct = 0,

    this.discountAmt = 0,

  });



  double get lineTotal => (price * quantity) - discountAmt - (price * quantity * discountPct / 100);



  Map<String, dynamic> toMap() => {

    'productId': productId, 'name': name, 'price': price, 'quantity': quantity,

    'discountPct': discountPct, 'discountAmt': discountAmt,

  };



  factory InvoiceItem.fromMap(Map<String, dynamic> m) => InvoiceItem(

    productId: m['productId'] ?? '', name: m['name'] ?? '', price: (m['price'] ?? 0).toDouble(),

    quantity: m['quantity'] ?? 1, discountPct: (m['discountPct'] ?? 0).toDouble(),

    discountAmt: (m['discountAmt'] ?? 0).toDouble(),

  );

}



enum PaymentMethod { cash, bankTransfer, mobileMoney, check, creditCard, other }



String paymentMethodName(PaymentMethod m) {

  switch (m) {

    case PaymentMethod.cash: return 'نقدي';

    case PaymentMethod.bankTransfer: return 'تحويل بنكي';

    case PaymentMethod.mobileMoney: return 'موبايل موني';

    case PaymentMethod.check: return 'شيك';

    case PaymentMethod.creditCard: return 'بطاقة ائتمان';

    case PaymentMethod.other: return 'أخرى';

  }

}



String paymentMethodIcon(PaymentMethod m) {

  switch (m) {

    case PaymentMethod.cash: return '💵';

    case PaymentMethod.bankTransfer: return '🏦';

    case PaymentMethod.mobileMoney: return '📱';

    case PaymentMethod.check: return '📄';

    case PaymentMethod.creditCard: return '💳';

    case PaymentMethod.other: return '💰';

  }

}



class Payment {

  String id;

  double amount;

  String date;

  PaymentMethod method;

  String? receiptNumber;

  String? referenceNumber;

  String? notes;

  String? customerId;

  String? invoiceId;



  Payment({required this.amount, required this.date, this.method = PaymentMethod.cash, this.receiptNumber, this.referenceNumber, this.notes, this.customerId, this.invoiceId})

    : id = 'PAY-${DateTime.now().millisecondsSinceEpoch}';



  Map<String, dynamic> toMap() => {

    'id': id, 'amount': amount, 'date': date, 'method': method.index,

    'receiptNumber': receiptNumber, 'referenceNumber': referenceNumber, 'notes': notes,

    'customerId': customerId, 'invoiceId': invoiceId,

  };

  factory Payment.fromMap(Map<String, dynamic> m) {

    PaymentMethod method = PaymentMethod.cash;

    final rawMethod = m['method'];

    if (rawMethod is int && rawMethod < PaymentMethod.values.length) {

      method = PaymentMethod.values[rawMethod];

    } else if (rawMethod is String) {

      if (rawMethod.contains('تحويل')) method = PaymentMethod.bankTransfer;

      else if (rawMethod.contains('موبايل')) method = PaymentMethod.mobileMoney;

      else if (rawMethod.contains('شيك')) method = PaymentMethod.check;

      else if (rawMethod.contains('بطاقة')) method = PaymentMethod.creditCard;

      else if (rawMethod.contains('أخرى')) method = PaymentMethod.other;

    }

    return Payment(

      amount: (m['amount'] ?? 0).toDouble(), date: m['date'] ?? '',

      method: method,

      receiptNumber: m['receiptNumber'], referenceNumber: m['referenceNumber'], notes: m['notes'],

      customerId: m['customerId'], invoiceId: m['invoiceId'],

    );

  }

}



class Invoice {

  String id;

  String buyerName;

  String buyerPhone;

  String buyerAddress;

  String date;

  List<InvoiceItem> items;

  List<Payment> payments;

  double discountPct;

  double discountAmt;

  String notes;

  String template;

  String? dueDate;



  Invoice({

    required this.id,

    required this.buyerName,

    this.buyerPhone = '',

    this.buyerAddress = '',

    required this.date,

    required this.items,

    this.payments = const [],

    this.discountPct = 0,

    this.discountAmt = 0,

    this.notes = '',

    this.template = 'classic',

    this.dueDate,

  });



  double get subtotal => items.fold(0, (s, i) => s + i.lineTotal);

  double get total => subtotal - discountAmt - (subtotal * discountPct / 100);

  double get totalPaid => payments.fold(0, (s, p) => s + p.amount);

  double get remaining => total - totalPaid;

  String get status => remaining <= 0 ? 'paid' : (totalPaid > 0 ? 'partial' : 'unpaid');



  bool get isOverdue {

    if (dueDate == null || status == 'paid') return false;

    return DateTime.tryParse(dueDate!)?.isBefore(DateTime.now()) ?? false;

  }



  int get daysUntilDue {

    if (dueDate == null) return -1;

    final due = DateTime.tryParse(dueDate!);

    if (due == null) return -1;

    return due.difference(DateTime.now()).inDays;

  }



  Map<String, dynamic> toMap() => {

    'id': id, 'buyerName': buyerName, 'buyerPhone': buyerPhone, 'buyerAddress': buyerAddress,

    'date': date, 'items': items.map((i) => i.toMap()).toList(),

    'payments': payments.map((p) => p.toMap()).toList(),

    'discountPct': discountPct, 'discountAmt': discountAmt, 'notes': notes,

    'template': template, 'dueDate': dueDate,

  };



  factory Invoice.fromMap(Map<String, dynamic> m) => Invoice(

    id: m['id'] ?? '', buyerName: m['buyerName'] ?? '', buyerPhone: m['buyerPhone'] ?? '',

    buyerAddress: m['buyerAddress'] ?? '', date: m['date'] ?? '',

    items: (m['items'] as List? ?? []).map((i) => InvoiceItem.fromMap(i)).toList(),

    payments: (m['payments'] as List? ?? []).map((i) => Payment.fromMap(i)).toList(),

    discountPct: (m['discountPct'] ?? 0).toDouble(),

    discountAmt: (m['discountAmt'] ?? 0).toDouble(),

    notes: m['notes'] ?? '',

    template: m['template'] ?? 'classic',

    dueDate: m['dueDate'],

  );

}



// ==================== DESIGN SYSTEM ====================

class AppColors {

  static const primary = Color(0xFF6366F1);

  static const primaryLight = Color(0xFF818CF8);

  static const primaryDark = Color(0xFF4F46E5);

  static const secondary = Color(0xFF06B6D4);

  static const accent = Color(0xFFF59E0B);

  static const success = Color(0xFF10B981);

  static const danger = Color(0xFFEF4444);

  static const warning = Color(0xFFF59E0B);

  static const whatsapp = Color(0xFF25D366);

  static const bg = Color(0xFFF0F4FF);

  static const cardLight = Color(0xFFFFFFFF);

  static const cardDark = Color(0xFF1E293B);

  static const textPrimary = Color(0xFF1E293B);

  static const textSecondary = Color(0xFF64748B);

  static const gradient1 = [Color(0xFF667EEA), Color(0xFF764BA2)];

  static const gradient2 = [Color(0xFFF093FB), Color(0xFFF5576C)];

  static const gradient3 = [Color(0xFF4FACFE), Color(0xFF00F2FE)];

  static const gradient4 = [Color(0xFF43E97B), Color(0xFF38F9D7)];

  static const gradient5 = [Color(0xFFFA709A), Color(0xFFFEE140)];

  static const neumorphicLight = Color(0xFFFFFFFF);

  static const neumorphicDark = Color(0xFFE0E5EC);

  static bool _isDark(BuildContext c) => Theme.of(c).brightness == Brightness.dark;

  static Color bgOf(BuildContext c) => _isDark(c) ? const Color(0xFF0F172A) : const Color(0xFFF0F4FF);

  static Color cardOf(BuildContext c) => _isDark(c) ? const Color(0xFF1E293B) : Colors.white;

  static Color cardAltOf(BuildContext c) => _isDark(c) ? const Color(0xFF334155) : const Color(0xFFF8FAFC);

  static Color textPrimaryOf(BuildContext c) => _isDark(c) ? Colors.white : const Color(0xFF1E293B);

  static Color textSecondaryOf(BuildContext c) => _isDark(c) ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

  static Color dividerOf(BuildContext c) => _isDark(c) ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

  static Color borderOf(BuildContext c) => _isDark(c) ? const Color(0xFF475569) : const Color(0xFFCBD5E1);

  static Color inputBgOf(BuildContext c) => _isDark(c) ? const Color(0xFF1E293B) : Colors.white;

  static Color neumorphicOf(BuildContext c) => _isDark(c) ? const Color(0xFF1E293B) : Colors.white;

  static Color neumorphicShadowOf(BuildContext c) => _isDark(c) ? const Color(0xFF0B1120) : const Color(0xFFE0E5EC);

  static Color dialogBgOf(BuildContext c) => _isDark(c) ? const Color(0xFF1E293B) : Colors.white;

}



// ==================== APP ====================

class MainApp extends StatelessWidget {

  const MainApp({super.key});



  @override

  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (_) => DataStore()..load(),

      child: Consumer<DataStore>(

        builder: (_, store, __) {

          return MaterialApp(

            title: 'FastInvoice',

            debugShowCheckedModeBanner: false,

            theme: ThemeData(

              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.light),

              useMaterial3: true,

              scaffoldBackgroundColor: AppColors.bg,

            ),

            darkTheme: ThemeData(

              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary, brightness: Brightness.dark),

              useMaterial3: true,

              scaffoldBackgroundColor: const Color(0xFF0F172A),

            ),

            themeMode: store.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            locale: store.isEnglish ? const Locale('en') : const Locale('ar', 'LY'),

            supportedLocales: const [Locale('ar', 'LY'), Locale('en')],

            localizationsDelegates: const [

              GlobalMaterialLocalizations.delegate,

              GlobalWidgetsLocalizations.delegate,

              GlobalCupertinoLocalizations.delegate,

            ],

            home: const SplashScreen(),

          );

        },

      ),

    );

  }

}



// ==================== DESIGN COMPONENTS ====================

class GlassCard extends StatelessWidget {

  final Widget child;

  final double blur;

  final double opacity;

  final EdgeInsets? padding;

  final EdgeInsets? margin;

  final VoidCallback? onTap;



  const GlassCard({

    super.key,

    required this.child,

    this.blur = 10,

    this.opacity = 0.2,

    this.padding,

    this.margin,

    this.onTap,

  });



  @override

  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05);

    final borderColor = isDark ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.3);

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: margin ?? const EdgeInsets.only(bottom: 12),

        decoration: BoxDecoration(

          color: cardColor.withOpacity(opacity),

          borderRadius: BorderRadius.circular(20),

          border: Border.all(color: borderColor),

          boxShadow: [

            BoxShadow(

              color: shadowColor,

              blurRadius: blur,

              offset: const Offset(0, 8),

            ),

          ],

        ),

        child: ClipRRect(

          borderRadius: BorderRadius.circular(20),

          child: BackdropFilter(

            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),

            child: Container(

              padding: padding ?? const EdgeInsets.all(16),

              decoration: BoxDecoration(

                gradient: LinearGradient(

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                  colors: [

                    cardColor.withOpacity(0.5),

                    cardColor.withOpacity(0.2),

                  ],

                ),

              ),

              child: child,

            ),

          ),

        ),

      ),

    );

  }

}



class NeumorphicCard extends StatelessWidget {

  final Widget child;

  final EdgeInsets? padding;

  final EdgeInsets? margin;

  final bool isPressed;

  final VoidCallback? onTap;



  const NeumorphicCard({

    super.key,

    required this.child,

    this.padding,

    this.margin,

    this.isPressed = false,

    this.onTap,

  });



  @override

  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;

    final shadowBg = isDark ? const Color(0xFF0B1120) : const Color(0xFFE0E5EC);

    final shadowLight = isDark ? const Color(0xFF334155) : const Color(0xFFFFFFFF);

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        margin: margin ?? const EdgeInsets.only(bottom: 12),

        padding: padding ?? const EdgeInsets.all(16),

        decoration: BoxDecoration(

          color: bgColor,

          borderRadius: BorderRadius.circular(20),

          boxShadow: isPressed

              ? [

                  BoxShadow(

                    color: shadowBg,

                    offset: const Offset(-3, -3),

                    blurRadius: 5,

                  ),

                  BoxShadow(

                    color: shadowBg,

                    offset: const Offset(3, 3),

                    blurRadius: 5,

                  ),

                ]

              : [

                  BoxShadow(

                    color: shadowBg,

                    offset: const Offset(-5, -5),

                    blurRadius: 10,

                  ),

                  BoxShadow(

                    color: shadowLight,

                    offset: const Offset(5, 5),

                    blurRadius: 10,

                  ),

                ],

        ),

        child: child,

      ),

    );

  }

}



class GradientButton extends StatelessWidget {

  final String label;

  final IconData icon;

  final List<Color> gradient;

  final VoidCallback onPressed;

  final bool isExpanded;



  const GradientButton({

    super.key,

    required this.label,

    required this.icon,

    required this.gradient,

    required this.onPressed,

    this.isExpanded = false,

  });



  @override

  Widget build(BuildContext context) {

    final btn = Material(

      color: Colors.transparent,

      child: InkWell(

        onTap: onPressed,

        borderRadius: BorderRadius.circular(16),

        child: Ink(

          decoration: BoxDecoration(

            gradient: LinearGradient(colors: gradient),

            borderRadius: BorderRadius.circular(16),

            boxShadow: [

              BoxShadow(

                color: gradient.first.withOpacity(0.4),

                blurRadius: 12,

                offset: const Offset(0, 4),

              ),

            ],

          ),

          child: Padding(

            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),

            child: Row(

              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [

                Icon(icon, color: Colors.white, size: 20),

                const SizedBox(width: 8),

                Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),

              ],

            ),

          ),

        ),

      ),

    );

    return isExpanded ? SizedBox(width: double.infinity, child: btn) : btn;

  }

}



class AnimatedCounter extends StatefulWidget {

  final double value;

  final String suffix;

  final TextStyle? style;



  const AnimatedCounter({super.key, required this.value, this.suffix = '', this.style});



  @override

  State<AnimatedCounter> createState() => _AnimatedCounterState();

}



class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _animation;



  @override

  void initState() {

    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _animation = Tween<double>(begin: 0, end: widget.value).animate(

      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),

    );

    _controller.forward();

  }



  @override

  void didUpdateWidget(AnimatedCounter oldWidget) {

    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {

      _animation = Tween<double>(begin: _animation.value, end: widget.value).animate(

        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),

      );

      _controller.reset();

      _controller.forward();

    }

  }



  @override

  void dispose() {

    _controller.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return AnimatedBuilder(

      animation: _animation,

      builder: (_, __) => Text(

        '${_animation.value.toStringAsFixed(2)} ${widget.suffix}',

        style: widget.style,

      ),

    );

  }

}



class ShimmerLoading extends StatelessWidget {

  final double width;

  final double height;

  final double borderRadius;



  const ShimmerLoading({

    super.key,

    required this.width,

    required this.height,

    this.borderRadius = 12,

  });



  @override

  Widget build(BuildContext context) {

    return Shimmer.fromColors(

      baseColor: Colors.grey[300]!,

      highlightColor: Colors.grey[100]!,

      child: Container(

        width: width,

        height: height,

        decoration: BoxDecoration(

          color: Colors.white,

          borderRadius: BorderRadius.circular(borderRadius),

        ),

      ),

    );

  }

}



class AnimatedIconWidget extends StatefulWidget {

  final IconData icon;

  final Color color;

  final double size;



  const AnimatedIconWidget({super.key, required this.icon, required this.color, this.size = 24});



  @override

  State<AnimatedIconWidget> createState() => _AnimatedIconWidgetState();

}



class _AnimatedIconWidgetState extends State<AnimatedIconWidget> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _scaleAnimation;



  @override

  void initState() {

    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _scaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(

      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),

    );

  }



  @override

  void dispose() {

    _controller.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () {

        _controller.forward().then((_) => _controller.reverse());

      },

      child: AnimatedBuilder(

        animation: _scaleAnimation,

        builder: (_, child) => Transform.scale(

          scale: _scaleAnimation.value,

          child: Icon(widget.icon, color: widget.color, size: widget.size),

        ),

      ),

    );

  }

}



class GradientHeader extends StatelessWidget {

  final String title;

  final String? subtitle;

  final List<Color> gradient;

  final Widget? child;



  const GradientHeader({

    super.key,

    required this.title,

    this.subtitle,

    this.gradient = AppColors.gradient1,

    this.child,

  });



  @override

  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(

        gradient: LinearGradient(

          begin: Alignment.topLeft,

          end: Alignment.bottomRight,

          colors: gradient,

        ),

        borderRadius: BorderRadius.circular(24),

        boxShadow: [

          BoxShadow(

            color: gradient.first.withOpacity(0.3),

            blurRadius: 20,

            offset: const Offset(0, 10),

          ),

        ],

      ),

      child: Column(

        children: [

          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),

          if (subtitle != null) ...[

            const SizedBox(height: 4),

            Text(subtitle!, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),

          ],

          if (child != null) ...[

            const SizedBox(height: 16),

            child!,

          ],

        ],

      ),

    );

  }

}



class StatusBadge extends StatelessWidget {

  final String status;

  final bool showIcon;



  const StatusBadge({super.key, required this.status, this.showIcon = true});



  @override

  Widget build(BuildContext context) {

    final isPaid = status == 'paid';

    final isPartial = status == 'partial';

    final color = isPaid ? AppColors.success : (isPartial ? AppColors.warning : AppColors.danger);

    final label = isPaid ? 'مدفوع' : (isPartial ? 'جزئي' : 'غير مدفوع');

    final icon = isPaid ? Icons.check_circle : (isPartial ? Icons.schedule : Icons.cancel);



    return Container(

      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      decoration: BoxDecoration(

        color: color.withOpacity(0.1),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: color.withOpacity(0.3)),

      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          if (showIcon) ...[

            Icon(icon, color: color, size: 14),

            const SizedBox(width: 4),

          ],

          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),

        ],

      ),

    );

  }

}



// ==================== DATA STORE ====================

class DataStore extends ChangeNotifier {

  List<Product> products = [];

  List<Customer> customers = [];

  List<Invoice> invoices = [];

  List<Payment> standalonePayments = [];

  int invoiceCounter = 0;

  String sellerName = '';

  String sellerPhone = '';

  String sellerAddress = '';

  String logoUrl = '';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  bool _isEnglish = false;

  bool get isEnglish => _isEnglish;



  // Invoice settings

  String _defaultTemplate = 'classic';

  String get defaultTemplate => _defaultTemplate;

  String _invoiceTitle = 'فاتورة مبيعات';

  String get invoiceTitle => _invoiceTitle;

  String _invoiceSubtitle = '';

  String get invoiceSubtitle => _invoiceSubtitle;

  int _invoiceStartNumber = 1;

  int get invoiceStartNumber => _invoiceStartNumber;

  bool _showSellerInfo = true;

  bool get showSellerInfo => _showSellerInfo;

  bool _showBuyerInfo = true;

  bool get showBuyerInfo => _showBuyerInfo;

  bool _showItemImages = false;

  bool get showItemImages => _showItemImages;

  bool _showItemBarcode = false;

  bool get showItemBarcode => _showItemBarcode;

  bool _showNotes = true;

  bool get showNotes => _showNotes;

  bool _showPaymentHistory = true;

  bool get showPaymentHistory => _showPaymentHistory;

  String _currencySymbol = 'د.ل';

  String get currencySymbol => _currencySymbol;

  String _footerText = 'شكراً لتعاملكم معنا';

  String get footerText => _footerText;

  // Advanced customization

  String _primaryColor = '#6366F1';

  String get primaryColor => _primaryColor;

  String _accentColor = '#10B981';

  String get accentColor => _accentColor;

  double _headerFontSize = 28;

  double get headerFontSize => _headerFontSize;

  bool _showLogo = false;

  bool get showLogo => _showLogo;

  String _logoPath = '';

  String get logoPath => _logoPath;

  bool _showInvoiceDate = true;

  bool get showInvoiceDate => _showInvoiceDate;

  bool _showInvoiceNumber = true;

  bool get showInvoiceNumber => _showInvoiceNumber;

  bool _showSellerPhone = true;

  bool get showSellerPhone => _showSellerPhone;

  bool _showSellerAddress = true;

  bool get showSellerAddress => _showSellerAddress;

  bool _showItemNumber = true;

  bool get showItemNumber => _showItemNumber;

  bool _showTotalWords = false;

  bool get showTotalWords => _showTotalWords;



  // Advanced layout settings

  bool _useGradient = true;

  bool get useGradient => _useGradient;

  double _accentBarHeight = 5;

  double get accentBarHeight => _accentBarHeight;

  double _borderRadius = 8;

  double get borderRadius => _borderRadius;

  double _logoHeight = 55;

  double get logoHeight => _logoHeight;

  double _sectionSpacing = 14;

  double get sectionSpacing => _sectionSpacing;

  double _qrSize = 100;

  double get qrSize => _qrSize;

  String _logoPosition = 'right';

  String get logoPosition => _logoPosition;

  String _paperSize = 'portrait';

  String get paperSize => _paperSize;



  // Typography settings

  String _fontFamily = 'Cairo';

  String get fontFamily => _fontFamily;

  double _fontSize = 12;

  double get fontSize => _fontSize;

  double _companyNameSize = 20;

  double get companyNameSize => _companyNameSize;

  double _lineHeight = 1.5;

  double get lineHeight => _lineHeight;

  double _rowPadding = 7;

  double get rowPadding => _rowPadding;



  // Table settings

  String _tableHeaderStyle = 'gradient';

  String get tableHeaderStyle => _tableHeaderStyle;

  String _tableRowStyle = 'alternating';

  String get tableRowStyle => _tableRowStyle;

  String _tableBorderColor = '#e2e8f0';

  String get tableBorderColor => _tableBorderColor;

  bool _showItemCode = false;

  bool get showItemCode => _showItemCode;

  bool _showUnitPrice = true;

  bool get showUnitPrice => _showUnitPrice;

  bool _showDiscountCol = true;

  bool get showDiscountCol => _showDiscountCol;



  // Colors settings

  String _invoiceBgColor = '#ffffff';

  String get invoiceBgColor => _invoiceBgColor;

  String _textColor = '#1e293b';

  String get textColor => _textColor;

  String _accentBorderColor = '';

  String get accentBorderColor => _accentBorderColor;



  // Section visibility

  bool _showCompanyInfo = true;

  bool get showCompanyInfo => _showCompanyInfo;

  bool _showTaxNo = false;

  bool get showTaxNo => _showTaxNo;

  bool _showBadge = true;

  bool get showBadge => _showBadge;

  bool _showInfoGrid = true;

  bool get showInfoGrid => _showInfoGrid;

  bool _showQrCode = false;

  bool get showQrCode => _showQrCode;

  bool _showTerms = false;

  bool get showTerms => _showTerms;

  bool _showStamps = true;

  bool get showStamps => _showStamps;

  bool _showWatermark = false;

  bool get showWatermark => _showWatermark;

  bool _showPaymentDetails = true;

  bool get showPaymentDetails => _showPaymentDetails;



  // Content settings

  List<String> _termsText = ['يتم الدفع خلال 30 يوماً من تاريخ الفاتورة', 'المرتجعات خلال 7 أيام فقط', 'الأسعار لا تشمل رسوم التوصيل', 'نحتفظ بحق رفض المرتجعات غير المبررة'];

  List<String> get termsText => _termsText;

  String _customTitle = '';

  String get customTitle => _customTitle;



  // Section order

  List<String> _sectionOrder = ['header', 'infoGrid', 'table', 'summary', 'terms', 'stamps', 'footer'];

  List<String> get sectionOrder => _sectionOrder;



  // Saved templates

  List<Map<String, dynamic>> _savedTemplates = [];

  List<Map<String, dynamic>> get savedTemplates => _savedTemplates;

  String _activeTemplate = '';

  String get activeTemplate => _activeTemplate;



  Future<void> load() async {

    try {

      final prefs = await SharedPreferences.getInstance();

      products = jsonDecode(prefs.getString('products') ?? '[]').map<Product>((m) => Product.fromMap(m)).toList();

      customers = jsonDecode(prefs.getString('customers') ?? '[]').map<Customer>((m) => Customer.fromMap(m)).toList();

      invoices = jsonDecode(prefs.getString('invoices') ?? '[]').map<Invoice>((m) => Invoice.fromMap(m)).toList();

      try {
        standalonePayments = jsonDecode(prefs.getString('standalonePayments') ?? '[]').map<Payment>((m) => Payment.fromMap(m)).toList();
      } catch (_) {
        standalonePayments = [];
      }

      invoiceCounter = prefs.getInt('invoiceCounter') ?? 0;

      sellerName = prefs.getString('sellerName') ?? '';

      sellerPhone = prefs.getString('sellerPhone') ?? '';

      sellerAddress = prefs.getString('sellerAddress') ?? '';

      logoUrl = prefs.getString('logoUrl') ?? '';

      _isDarkMode = prefs.getBool('isDarkMode') ?? false;

      _isEnglish = prefs.getBool('isEnglish') ?? false;

      _defaultTemplate = prefs.getString('defaultTemplate') ?? 'classic';

      _invoiceTitle = prefs.getString('invoiceTitle') ?? 'فاتورة مبيعات';

      _invoiceSubtitle = prefs.getString('invoiceSubtitle') ?? '';

      _invoiceStartNumber = prefs.getInt('invoiceStartNumber') ?? 1;

      _showSellerInfo = prefs.getBool('showSellerInfo') ?? true;

      _showBuyerInfo = prefs.getBool('showBuyerInfo') ?? true;

      _showItemImages = prefs.getBool('showItemImages') ?? false;

      _showItemBarcode = prefs.getBool('showItemBarcode') ?? false;

      _showNotes = prefs.getBool('showNotes') ?? true;

      _showPaymentHistory = prefs.getBool('showPaymentHistory') ?? true;

      _currencySymbol = prefs.getString('currencySymbol') ?? 'د.ل';

      _footerText = prefs.getString('footerText') ?? 'شكراً لتعاملكم معنا';

      _primaryColor = prefs.getString('primaryColor') ?? '#6366F1';

      _accentColor = prefs.getString('accentColor') ?? '#10B981';

      _headerFontSize = prefs.getDouble('headerFontSize') ?? 28;

      _showLogo = prefs.getBool('showLogo') ?? false;

      _logoPath = prefs.getString('logoPath') ?? '';

      _showInvoiceDate = prefs.getBool('showInvoiceDate') ?? true;

      _showInvoiceNumber = prefs.getBool('showInvoiceNumber') ?? true;

      _showSellerPhone = prefs.getBool('showSellerPhone') ?? true;

      _showSellerAddress = prefs.getBool('showSellerAddress') ?? true;

      _showItemNumber = prefs.getBool('showItemNumber') ?? true;

      _showTotalWords = prefs.getBool('showTotalWords') ?? false;

      _useGradient = prefs.getBool('useGradient') ?? true;

      _accentBarHeight = prefs.getDouble('accentBarHeight') ?? 5;

      _borderRadius = prefs.getDouble('borderRadius') ?? 8;

      _logoHeight = prefs.getDouble('logoHeight') ?? 55;

      _sectionSpacing = prefs.getDouble('sectionSpacing') ?? 14;

      _qrSize = prefs.getDouble('qrSize') ?? 100;

      _logoPosition = prefs.getString('logoPosition') ?? 'right';

      _paperSize = prefs.getString('paperSize') ?? 'portrait';

      _fontFamily = prefs.getString('fontFamily') ?? 'Cairo';

      _fontSize = prefs.getDouble('fontSize') ?? 12;

      _companyNameSize = prefs.getDouble('companyNameSize') ?? 20;

      _lineHeight = prefs.getDouble('lineHeight') ?? 1.5;

      _rowPadding = prefs.getDouble('rowPadding') ?? 7;

      _tableHeaderStyle = prefs.getString('tableHeaderStyle') ?? 'gradient';

      _tableRowStyle = prefs.getString('tableRowStyle') ?? 'alternating';

      _tableBorderColor = prefs.getString('tableBorderColor') ?? '#e2e8f0';

      _showItemCode = prefs.getBool('showItemCode') ?? false;

      _showUnitPrice = prefs.getBool('showUnitPrice') ?? true;

      _showDiscountCol = prefs.getBool('showDiscountCol') ?? true;

      _invoiceBgColor = prefs.getString('invoiceBgColor') ?? '#ffffff';

      _textColor = prefs.getString('textColor') ?? '#1e293b';

      _accentBorderColor = prefs.getString('accentBorderColor') ?? '';

      _showCompanyInfo = prefs.getBool('showCompanyInfo') ?? true;

      _showTaxNo = prefs.getBool('showTaxNo') ?? false;

      _showBadge = prefs.getBool('showBadge') ?? true;

      _showInfoGrid = prefs.getBool('showInfoGrid') ?? true;

      _showQrCode = prefs.getBool('showQrCode') ?? false;

      _showTerms = prefs.getBool('showTerms') ?? false;

      _showStamps = prefs.getBool('showStamps') ?? true;

      _showWatermark = prefs.getBool('showWatermark') ?? false;

      _showPaymentDetails = prefs.getBool('showPaymentDetails') ?? true;

      _termsText = (jsonDecode(prefs.getString('termsText') ?? '[]') as List).map((e) => e.toString()).toList();

      _customTitle = prefs.getString('customTitle') ?? '';

      _sectionOrder = (jsonDecode(prefs.getString('sectionOrder') ?? '["header","infoGrid","table","summary","terms","stamps","footer"]') as List).map((e) => e.toString()).toList();

      _savedTemplates = (jsonDecode(prefs.getString('savedTemplates') ?? '[]') as List).map((e) => Map<String, dynamic>.from(e)).toList();

      _activeTemplate = prefs.getString('activeTemplate') ?? '';

    } catch (e) {

      products = []; customers = []; invoices = [];

    }

    notifyListeners();

  }



  Future<void> save() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('products', jsonEncode(products.map((p) => p.toMap()).toList()));

    await prefs.setString('customers', jsonEncode(customers.map((c) => c.toMap()).toList()));

    await prefs.setString('invoices', jsonEncode(invoices.map((i) => i.toMap()).toList()));

    await prefs.setString('standalonePayments', jsonEncode(standalonePayments.map((p) => p.toMap()).toList()));

    await prefs.setInt('invoiceCounter', invoiceCounter);

    await prefs.setString('sellerName', sellerName);

    await prefs.setString('sellerPhone', sellerPhone);

    await prefs.setString('sellerAddress', sellerAddress);

    await prefs.setString('logoUrl', logoUrl);

    await prefs.setBool('isDarkMode', _isDarkMode);

    await prefs.setBool('isEnglish', _isEnglish);

    await prefs.setString('defaultTemplate', _defaultTemplate);

    await prefs.setString('invoiceTitle', _invoiceTitle);

    await prefs.setString('invoiceSubtitle', _invoiceSubtitle);

    await prefs.setInt('invoiceStartNumber', _invoiceStartNumber);

    await prefs.setBool('showSellerInfo', _showSellerInfo);

    await prefs.setBool('showBuyerInfo', _showBuyerInfo);

    await prefs.setBool('showItemImages', _showItemImages);

    await prefs.setBool('showItemBarcode', _showItemBarcode);

    await prefs.setBool('showNotes', _showNotes);

    await prefs.setBool('showPaymentHistory', _showPaymentHistory);

    await prefs.setString('currencySymbol', _currencySymbol);

    await prefs.setString('footerText', _footerText);

    await prefs.setString('primaryColor', _primaryColor);

    await prefs.setString('accentColor', _accentColor);

    await prefs.setDouble('headerFontSize', _headerFontSize);

    await prefs.setBool('showLogo', _showLogo);

    await prefs.setString('logoPath', _logoPath);

    await prefs.setBool('showInvoiceDate', _showInvoiceDate);

    await prefs.setBool('showInvoiceNumber', _showInvoiceNumber);

    await prefs.setBool('showSellerPhone', _showSellerPhone);

    await prefs.setBool('showSellerAddress', _showSellerAddress);

    await prefs.setBool('showItemNumber', _showItemNumber);

    await prefs.setBool('showTotalWords', _showTotalWords);

    await prefs.setBool('useGradient', _useGradient);

    await prefs.setDouble('accentBarHeight', _accentBarHeight);

    await prefs.setDouble('borderRadius', _borderRadius);

    await prefs.setDouble('logoHeight', _logoHeight);

    await prefs.setDouble('sectionSpacing', _sectionSpacing);

    await prefs.setDouble('qrSize', _qrSize);

    await prefs.setString('logoPosition', _logoPosition);

    await prefs.setString('paperSize', _paperSize);

    await prefs.setString('fontFamily', _fontFamily);

    await prefs.setDouble('fontSize', _fontSize);

    await prefs.setDouble('companyNameSize', _companyNameSize);

    await prefs.setDouble('lineHeight', _lineHeight);

    await prefs.setDouble('rowPadding', _rowPadding);

    await prefs.setString('tableHeaderStyle', _tableHeaderStyle);

    await prefs.setString('tableRowStyle', _tableRowStyle);

    await prefs.setString('tableBorderColor', _tableBorderColor);

    await prefs.setBool('showItemCode', _showItemCode);

    await prefs.setBool('showUnitPrice', _showUnitPrice);

    await prefs.setBool('showDiscountCol', _showDiscountCol);

    await prefs.setString('invoiceBgColor', _invoiceBgColor);

    await prefs.setString('textColor', _textColor);

    await prefs.setString('accentBorderColor', _accentBorderColor);

    await prefs.setBool('showCompanyInfo', _showCompanyInfo);

    await prefs.setBool('showTaxNo', _showTaxNo);

    await prefs.setBool('showBadge', _showBadge);

    await prefs.setBool('showInfoGrid', _showInfoGrid);

    await prefs.setBool('showQrCode', _showQrCode);

    await prefs.setBool('showTerms', _showTerms);

    await prefs.setBool('showStamps', _showStamps);

    await prefs.setBool('showWatermark', _showWatermark);

    await prefs.setBool('showPaymentDetails', _showPaymentDetails);

    await prefs.setString('termsText', jsonEncode(_termsText));

    await prefs.setString('customTitle', _customTitle);

    await prefs.setString('sectionOrder', jsonEncode(_sectionOrder));

    await prefs.setString('savedTemplates', jsonEncode(_savedTemplates));

    await prefs.setString('activeTemplate', _activeTemplate);

    notifyListeners();

  }



  void updateInvoiceSetting(String key, dynamic value) {

    switch (key) {

      case 'defaultTemplate': _defaultTemplate = value; break;

      case 'invoiceTitle': _invoiceTitle = value; break;

      case 'invoiceSubtitle': _invoiceSubtitle = value; break;

      case 'invoiceStartNumber': _invoiceStartNumber = value; break;

      case 'showSellerInfo': _showSellerInfo = value; break;

      case 'showBuyerInfo': _showBuyerInfo = value; break;

      case 'showItemImages': _showItemImages = value; break;

      case 'showItemBarcode': _showItemBarcode = value; break;

      case 'showNotes': _showNotes = value; break;

      case 'showPaymentHistory': _showPaymentHistory = value; break;

      case 'currencySymbol': _currencySymbol = value; break;

      case 'footerText': _footerText = value; break;

      case 'primaryColor': _primaryColor = value; break;

      case 'accentColor': _accentColor = value; break;

      case 'headerFontSize': _headerFontSize = value; break;

      case 'showLogo': _showLogo = value; break;

      case 'logoPath': _logoPath = value; break;

      case 'showInvoiceDate': _showInvoiceDate = value; break;

      case 'showInvoiceNumber': _showInvoiceNumber = value; break;

      case 'showSellerPhone': _showSellerPhone = value; break;

      case 'showSellerAddress': _showSellerAddress = value; break;

      case 'showItemNumber': _showItemNumber = value; break;

      case 'showTotalWords': _showTotalWords = value; break;

      case 'useGradient': _useGradient = value; break;

      case 'accentBarHeight': _accentBarHeight = value; break;

      case 'borderRadius': _borderRadius = value; break;

      case 'logoHeight': _logoHeight = value; break;

      case 'sectionSpacing': _sectionSpacing = value; break;

      case 'qrSize': _qrSize = value; break;

      case 'logoPosition': _logoPosition = value; break;

      case 'paperSize': _paperSize = value; break;

      case 'fontFamily': _fontFamily = value; break;

      case 'fontSize': _fontSize = value; break;

      case 'companyNameSize': _companyNameSize = value; break;

      case 'lineHeight': _lineHeight = value; break;

      case 'rowPadding': _rowPadding = value; break;

      case 'tableHeaderStyle': _tableHeaderStyle = value; break;

      case 'tableRowStyle': _tableRowStyle = value; break;

      case 'tableBorderColor': _tableBorderColor = value; break;

      case 'showItemCode': _showItemCode = value; break;

      case 'showUnitPrice': _showUnitPrice = value; break;

      case 'showDiscountCol': _showDiscountCol = value; break;

      case 'invoiceBgColor': _invoiceBgColor = value; break;

      case 'textColor': _textColor = value; break;

      case 'accentBorderColor': _accentBorderColor = value; break;

      case 'showCompanyInfo': _showCompanyInfo = value; break;

      case 'showTaxNo': _showTaxNo = value; break;

      case 'showBadge': _showBadge = value; break;

      case 'showInfoGrid': _showInfoGrid = value; break;

      case 'showQrCode': _showQrCode = value; break;

      case 'showTerms': _showTerms = value; break;

      case 'showStamps': _showStamps = value; break;

      case 'showWatermark': _showWatermark = value; break;

      case 'showPaymentDetails': _showPaymentDetails = value; break;

      case 'termsText': _termsText = List<String>.from(value); break;

      case 'customTitle': _customTitle = value; break;

      case 'sectionOrder': _sectionOrder = List<String>.from(value); break;

      case 'savedTemplates': _savedTemplates = List<Map<String, dynamic>>.from(value); break;

      case 'activeTemplate': _activeTemplate = value; break;

    }

    save();

  }



  void toggleDarkMode() {

    _isDarkMode = !_isDarkMode;

    save();

  }

  void toggleLanguage() {

    _isEnglish = !_isEnglish;

    save();

  }



  void addProduct(Product p) { products.add(p); save(); }

  void updateProduct(int i, Product p) { products[i] = p; save(); }

  void deleteProduct(int i) { products.removeAt(i); save(); }

  void addCustomer(Customer c) { customers.add(c); save(); }

  void updateCustomer(int i, Customer c) { customers[i] = c; save(); }

  void deleteCustomer(int i) { customers.removeAt(i); save(); }

  void addInvoice(Invoice inv) { invoices.insert(0, inv); invoiceCounter++; save(); }

  void updateInvoice(int i, Invoice inv) { invoices[i] = inv; save(); }

  void deleteInvoice(int i) { invoices.removeAt(i); save(); }



  // ==================== CUSTOMER BALANCE & MULTI-INVOICE PAYMENT ====================



  /// حساب رصيد الزبون (المقدم - المُستخدم)

  double getCustomerAdvanceBalance(String customerName) {

    // الدفعات المقدمة لهذا الزبون (مستقلة عن الفواتير)

    final advancePayments = standalonePayments

        .where((p) => p.customerId == customerName && p.invoiceId == null)

        .fold(0.0, (s, p) => s + p.amount);

    // المبالغ التي خُصمت من الرصيد عند إنشاء فواتير

    final usedFromBalance = invoices

        .where((i) => i.buyerName == customerName)

        .fold(0.0, (s, i) {

          final balanceUsed = double.tryParse(i.notes.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;

          return s + (i.notes.contains('رصيد') ? balanceUsed : 0);

        });

    return advancePayments - usedFromBalance;

  }

  /// فواتير الزبون غير المدفوعة

  List<Invoice> getCustomerUnpaidInvoices(String customerName) {

    return invoices.where((i) => i.buyerName == customerName && i.remaining > 0).toList();

  }

  /// إضافة دفعة مقدمة (بدون فاتورة)

  void addAdvancePayment(String customerName, Payment payment) {

    payment.customerId = customerName;

    payment.invoiceId = null;

    standalonePayments.add(payment);

    save();

  }

  /// توزيع مبلغ على عدة فواتير

  /// يُعيد المبلغ المتبقي بعد التوزيع

  double allocatePaymentToInvoices(String customerName, double totalAmount, Map<String, double> invoiceAllocations, PaymentMethod method, {String? notes}) {

    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    double remaining = totalAmount;



    for (final entry in invoiceAllocations.entries) {

      if (remaining <= 0) break;

      final invIdx = invoices.indexWhere((i) => i.id == entry.key);

      if (invIdx == -1) continue;

      final inv = invoices[invIdx];

      final allocAmt = entry.value.clamp(0.0, remaining.clamp(0.0, inv.remaining));

      if (allocAmt > 0) {

        inv.payments.add(Payment(

          amount: allocAmt,

          date: now,

          method: method,

          customerId: customerName,

          invoiceId: inv.id,

          receiptNumber: 'RCP-${inv.id}-${inv.payments.length + 1}',

          notes: notes,

        ));

        invoices[invIdx] = inv;

        remaining -= allocAmt;

      }

    }

    save();

    return remaining;

  }

}



// ==================== TOAST ====================

void showAppToast(BuildContext context, String message, {IconData icon = Icons.check_circle, Color color = AppColors.success}) {

  final overlay = Overlay.of(context);

  late OverlayEntry entry;

  entry = OverlayEntry(

    builder: (_) => _ToastWidget(message: message, icon: icon, color: color, onDismiss: () => entry.remove()),

  );

  overlay.insert(entry);

}



class _ToastWidget extends StatefulWidget {

  final String message;

  final IconData icon;

  final Color color;

  final VoidCallback onDismiss;

  const _ToastWidget({required this.message, required this.icon, required this.color, required this.onDismiss});



  @override

  State<_ToastWidget> createState() => _ToastWidgetState();

}



class _ToastWidgetState extends State<_ToastWidget> with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<Offset> _offsetAnimation;



  @override

  void initState() {

    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));

    _offsetAnimation = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(

      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),

    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {

      if (mounted) _controller.reverse().then((_) => widget.onDismiss());

    });

  }



  @override

  void dispose() {

    _controller.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Positioned(

      top: MediaQuery.of(context).padding.top + 10,

      left: 16, right: 16,

      child: SlideTransition(

        position: _offsetAnimation,

        child: Material(

          color: Colors.transparent,

          child: GlassCard(

            blur: 20,

            opacity: 0.9,

            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

            child: Row(

              children: [

                Container(

                  padding: const EdgeInsets.all(8),

                  decoration: BoxDecoration(

                    color: widget.color.withOpacity(0.2),

                    borderRadius: BorderRadius.circular(10),

                  ),

                  child: Icon(widget.icon, color: widget.color, size: 20),

                ),

                const SizedBox(width: 12),

                Expanded(

                  child: Text(widget.message, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),

                ),

              ],

            ),

          ),

        ),

      ),

    );

  }

}



// ==================== EMPTY STATE ====================

class EmptyState extends StatelessWidget {

  final IconData icon;

  final String title;

  final String subtitle;

  final String? actionLabel;

  final VoidCallback? onAction;



  const EmptyState({super.key, required this.icon, required this.title, required this.subtitle, this.actionLabel, this.onAction});



  @override

  Widget build(BuildContext context) {

    return Center(

      child: Padding(

        padding: const EdgeInsets.all(40),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            TweenAnimationBuilder<double>(

              tween: Tween(begin: 0, end: 1),

              duration: const Duration(milliseconds: 600),

              curve: Curves.easeOutBack,

              builder: (_, value, child) => Transform.scale(scale: value, child: child),

              child: Container(

                padding: const EdgeInsets.all(32),

                decoration: BoxDecoration(

                  gradient: LinearGradient(colors: AppColors.gradient1),

                  shape: BoxShape.circle,

                ),

                child: Icon(icon, size: 64, color: Colors.white),

              ),

            ),

            const SizedBox(height: 32),

            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.grey[500]), textAlign: TextAlign.center),

            if (actionLabel != null && onAction != null) ...[

              const SizedBox(height: 24),

              GradientButton(

                label: actionLabel!,

                icon: Icons.add,

                gradient: AppColors.gradient1,

                onPressed: onAction!,

              ),

            ],

          ],

        ),

      ),

    );

  }

}



// ==================== HELPERS ====================

Future<void> shareWhatsApp(String phone, Invoice inv) async {

  final msg = '🧾 فاتورة رقم: ${inv.id}\n👤 العميل: ${inv.buyerName}\n💰 الإجمالي: ${inv.total.toStringAsFixed(2)} د.ل\n📅 التاريخ: ${inv.date}';

  final url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeComponent(msg)}');

  try {

    if (await canLaunchUrl(url)) {

      await launchUrl(url, mode: LaunchMode.externalApplication);

    } else {

      SharePlus.instance.share(ShareParams(text: msg));

    }

  } catch (_) {

    SharePlus.instance.share(ShareParams(text: msg));

  }

}



Future<void> shareTelegram(Invoice inv) async {

  final msg = '🧾 فاتورة رقم: ${inv.id}\n👤 العميل: ${inv.buyerName}\n💰 الإجمالي: ${inv.total.toStringAsFixed(2)} د.ل\n📅 التاريخ: ${inv.date}';

  final url = Uri.parse('https://t.me/share/url?text=${Uri.encodeComponent(msg)}');

  try {

    if (await canLaunchUrl(url)) {

      await launchUrl(url, mode: LaunchMode.externalApplication);

    } else {

      SharePlus.instance.share(ShareParams(text: msg));

    }

  } catch (_) {

    SharePlus.instance.share(ShareParams(text: msg));

  }

}



Future<void> shareWhatsAppBackup(String json) async {

  final url = Uri.parse('https://wa.me/?text=${Uri.encodeComponent('📦 نسخة احتياطية - FastInvoice\n\n$json')}');

  try {

    if (await canLaunchUrl(url)) {

      await launchUrl(url, mode: LaunchMode.externalApplication);

    } else {

      SharePlus.instance.share(ShareParams(text: json, subject: 'نسخة احتياطية'));

    }

  } catch (_) {

    SharePlus.instance.share(ShareParams(text: json, subject: 'نسخة احتياطية'));

  }

}



Future<void> shareTelegramBackup(String json) async {

  final url = Uri.parse('https://t.me/share/url?text=${Uri.encodeComponent(json)}');

  try {

    if (await canLaunchUrl(url)) {

      await launchUrl(url, mode: LaunchMode.externalApplication);

    } else {

      SharePlus.instance.share(ShareParams(text: json, subject: 'نسخة احتياطية'));

    }

  } catch (_) {

    SharePlus.instance.share(ShareParams(text: json, subject: 'نسخة احتياطية'));

  }

}



Future<void> shareEmailBackup(String json) async {

  final url = Uri.parse('mailto:?subject=${Uri.encodeComponent('نسخة احتياطية - FastInvoice')}&body=${Uri.encodeComponent(json)}');

  try {

    if (await canLaunchUrl(url)) {

      await launchUrl(url, mode: LaunchMode.externalApplication);

    } else {

      SharePlus.instance.share(ShareParams(text: json, subject: 'نسخة احتياطية'));

    }

  } catch (_) {

    SharePlus.instance.share(ShareParams(text: json, subject: 'نسخة احتياطية'));

  }

}



// ==================== INVOICE TEMPLATES ====================

class InvoiceTemplate {

  final String id;

  final String name;

  final String description;

  final Color primaryColor;

  final Color secondaryColor;

  final List<Color> headerGradient;

  final String icon;



  const InvoiceTemplate({

    required this.id,

    required this.name,

    required this.description,

    required this.primaryColor,

    required this.secondaryColor,

    required this.headerGradient,

    required this.icon,

  });

}



const List<InvoiceTemplate> invoiceTemplates = [

  InvoiceTemplate(

    id: 'classic',

    name: 'كلاسيكي',

    description: 'تصميم تقليدي أنيق',

    primaryColor: Color(0xFF1E293B),

    secondaryColor: Color(0xFF64748B),

    headerGradient: [Color(0xFF1E293B), Color(0xFF334155)],

    icon: '📄',

  ),

  InvoiceTemplate(

    id: 'modern',

    name: 'عصري',

    description: 'تصميم حديث وملون',

    primaryColor: Color(0xFF6366F1),

    secondaryColor: Color(0xFF818CF8),

    headerGradient: [Color(0xFF6366F1), Color(0xFF8B5CF6)],

    icon: '🎨',

  ),

  InvoiceTemplate(

    id: 'minimal',

    name: 'بسيط',

    description: 'تصميم بسيط وأنيق',

    primaryColor: Color(0xFF374151),

    secondaryColor: Color(0xFF9CA3AF),

    headerGradient: [Color(0xFFF9FAFB), Color(0xFFF3F4F6)],

    icon: '✨',

  ),

  InvoiceTemplate(

    id: 'corporate',

    name: 'مؤسسي',

    description: 'تصميم رسمي للمؤسسات',

    primaryColor: Color(0xFF0369A1),

    secondaryColor: Color(0xFF38BDF8),

    headerGradient: [Color(0xFF0369A1), Color(0xFF0284C7)],

    icon: '🏢',

  ),

  InvoiceTemplate(

    id: 'colorful',

    name: 'ملون',

    description: 'تصميم ملون ومميز',

    primaryColor: Color(0xFFEC4899),

    secondaryColor: Color(0xFFF472B6),

    headerGradient: [Color(0xFFEC4899), Color(0xFFF59E0B)],

    icon: '🌈',

  ),

  InvoiceTemplate(

    id: 'dark',

    name: 'داكن',

    description: 'تصميم بألوان داكنة',

    primaryColor: Color(0xFF0F172A),

    secondaryColor: Color(0xFF475569),

    headerGradient: [Color(0xFF0F172A), Color(0xFF1E293B)],

    icon: '🌙',

  ),

];



InvoiceTemplate getTemplate(String id) {

  return invoiceTemplates.firstWhere((t) => t.id == id, orElse: () => invoiceTemplates[0]);

}



Future<void> printInvoice(Invoice inv) async {

  final pdf = pw.Document();

  final font = await PdfGoogleFonts.cairoRegular();

  final fontBold = await PdfGoogleFonts.cairoBold();

  final template = getTemplate(inv.template);



  switch (inv.template) {

    case 'modern':

      _buildModernTemplate(pdf, inv, template, font, fontBold);

      break;

    case 'minimal':

      _buildMinimalTemplate(pdf, inv, template, font, fontBold);

      break;

    case 'corporate':

      _buildCorporateTemplate(pdf, inv, template, font, fontBold);

      break;

    case 'colorful':

      _buildColorfulTemplate(pdf, inv, template, font, fontBold);

      break;

    case 'dark':

      _buildDarkTemplate(pdf, inv, template, font, fontBold);

      break;

    default:

      _buildClassicTemplate(pdf, inv, template, font, fontBold);

  }



  await Printing.layoutPdf(onLayout: (format) async => pdf.save());

}



Future<void> printPaymentReceipt(Invoice inv, Payment payment) async {

  final pdf = pw.Document();

  final font = await PdfGoogleFonts.cairoRegular();

  final fontBold = await PdfGoogleFonts.cairoBold();



  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (_) => [

      pw.Header(level: 0, child: pdfText('إيصال دفع', style: pw.TextStyle(font: fontBold, fontSize: 22))),

      pw.Divider(),

      pw.SizedBox(height: 16),

      _receiptRow('رقم الإيصال', payment.receiptNumber ?? 'N/A', font, fontBold),

      _receiptRow('التاريخ', payment.date, font, fontBold),

      pw.SizedBox(height: 12),

      pw.Divider(),

      pw.SizedBox(height: 12),

      _receiptRow('رقم الفاتورة', inv.id, font, fontBold),

      _receiptRow('العميل', inv.buyerName, font, fontBold),

      if (inv.buyerPhone.isNotEmpty) _receiptRow('الهاتف', inv.buyerPhone, font, fontBold),

      pw.SizedBox(height: 12),

      pw.Divider(),

      pw.SizedBox(height: 12),

      pw.Container(

        padding: const pw.EdgeInsets.all(16),

        decoration: pw.BoxDecoration(

          color: PdfColor(0.9, 0.95, 0.9),

          borderRadius: pw.BorderRadius.circular(8),

        ),

        child: pw.Column(

          children: [

            pdfText('المبلغ المدفوع', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),

            pw.SizedBox(height: 4),

            pdfText('${payment.amount.toStringAsFixed(2)} د.ل', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColor(0.07, 0.53, 0.3))),

          ],

        ),

      ),

      pw.SizedBox(height: 16),

      _receiptRow('طريقة الدفع', paymentMethodIcon(payment.method) + ' ' + paymentMethodName(payment.method), font, fontBold),

      if (payment.referenceNumber != null) _receiptRow('رقم المرجع', payment.referenceNumber!, font, fontBold),

      if (payment.notes != null) _receiptRow('ملاحظات', payment.notes!, font, fontBold),

      pw.SizedBox(height: 12),

      pw.Divider(),

      pw.SizedBox(height: 12),

      _receiptRow('إجمالي الفاتورة', '${inv.total.toStringAsFixed(2)} د.ل', font, fontBold),

      _receiptRow('المبلغ المدفوع', '${inv.totalPaid.toStringAsFixed(2)} د.ل', font, fontBold),

      _receiptRow('المتبقي', '${inv.remaining.toStringAsFixed(2)} د.ل', font, fontBold),

      pw.SizedBox(height: 24),

      pw.Center(child: pdfText('شكراً لتعاملكم معنا', style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.grey600))),

    ],

  ));

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());

}



pw.Widget _receiptRow(String label, String value, pw.Font font, pw.Font fontBold) {

  return pw.Padding(

    padding: const pw.EdgeInsets.symmetric(vertical: 4),

    child: pw.Row(

      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

      children: [

        pdfText(label, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey700)),

        pdfText(value, style: pw.TextStyle(font: fontBold, fontSize: 12)),

      ],

    ),

  );

}



void _buildClassicTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold) {

  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (ctx) => [

      pw.Container(

        padding: const pw.EdgeInsets.all(20),

        decoration: pw.BoxDecoration(

          color: PdfColor.fromHex('#1E293B'),

          borderRadius: const pw.BorderRadius.only(

            bottomLeft: pw.Radius.circular(20),

            bottomRight: pw.Radius.circular(20),

          ),

        ),

        child: pw.Column(children: [

          pdfText('فاتورة مبيعات', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.white)),

          pw.SizedBox(height: 4),

          pdfText(inv.id, style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey300)),

        ]),

      ),

      pw.SizedBox(height: 24),

      _buildInfoSection(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildItemsTable(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildTotalSection(inv, font, fontBold),

    ],

  ));

}



void _buildModernTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold) {

  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (ctx) => [

      pw.Container(

        padding: const pw.EdgeInsets.all(24),

        decoration: pw.BoxDecoration(

          gradient: pw.LinearGradient(

            colors: [PdfColor.fromHex('#6366F1'), PdfColor.fromHex('#8B5CF6')],

          ),

          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),

        ),

        child: pw.Column(children: [

          pdfText('فاتورة مبيعات', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.white)),

          pw.SizedBox(height: 8),

          pw.Container(

            padding: const pw.EdgeInsets.symmetric(horizontal: 16, vertical: 6),

            decoration: pw.BoxDecoration(

              color: PdfColor(1, 1, 1, 0.2),

              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(20)),

            ),

            child: pdfText(inv.id, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.white)),

          ),

        ]),

      ),

      pw.SizedBox(height: 24),

      _buildInfoSection(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildItemsTable(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildTotalSection(inv, font, fontBold),

    ],

  ));

}



void _buildMinimalTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold) {

  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (ctx) => [

      pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [

        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [

          pdfText('فاتورة', style: pw.TextStyle(font: fontBold, fontSize: 32, color: PdfColor.fromHex('#374151'))),

          pdfText(inv.id, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey)),

        ]),

        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [

          pdfText(inv.date, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey)),

          pw.SizedBox(height: 4),

          pw.Container(

            padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),

            decoration: pw.BoxDecoration(

              color: PdfColor(0.93, 0.29, 0.6, 0.1),

              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),

            ),

            child: pdfText(_statusLabel(inv.status), style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColor.fromHex('#EC4899'))),

          ),

        ]),

      ]),

      pw.SizedBox(height: 32),

      pw.Divider(color: PdfColor.fromHex('#E5E7EB')),

      pw.SizedBox(height: 16),

      _buildInfoSection(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildItemsTable(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildTotalSection(inv, font, fontBold),

    ],

  ));

}



void _buildCorporateTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold) {

  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (ctx) => [

      pw.Container(

        padding: const pw.EdgeInsets.all(24),

        decoration: pw.BoxDecoration(

          gradient: pw.LinearGradient(

            colors: [PdfColor.fromHex('#0369A1'), PdfColor.fromHex('#0284C7')],

          ),

        ),

        child: pw.Row(

          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

          children: [

            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [

              pdfText('فاتورة مبيعات', style: pw.TextStyle(font: fontBold, fontSize: 24, color: PdfColors.white)),

              pdfText(inv.id, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.blue100)),

            ]),

            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [

              pdfText(inv.date, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.blue100)),

              pdfText(_statusLabel(inv.status), style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.white)),

            ]),

          ],

        ),

      ),

      pw.SizedBox(height: 24),

      _buildInfoSection(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildItemsTable(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildTotalSection(inv, font, fontBold),

    ],

  ));

}



void _buildColorfulTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold) {

  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (ctx) => [

      pw.Container(

        padding: const pw.EdgeInsets.all(24),

        decoration: pw.BoxDecoration(

          gradient: pw.LinearGradient(

            colors: [PdfColor.fromHex('#EC4899'), PdfColor.fromHex('#F59E0B')],

          ),

          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),

        ),

        child: pw.Column(children: [

          pdfText('فاتورة مبيعات', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.white)),

          pw.SizedBox(height: 8),

          pdfText(inv.id, style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.white)),

        ]),

      ),

      pw.SizedBox(height: 24),

      _buildInfoSection(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildItemsTable(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildTotalSection(inv, font, fontBold),

    ],

  ));

}



void _buildDarkTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold) {

  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (ctx) => [

      pw.Container(

        padding: const pw.EdgeInsets.all(24),

        decoration: pw.BoxDecoration(

          color: PdfColor.fromHex('#0F172A'),

          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),

        ),

        child: pw.Column(children: [

          pdfText('فاتورة مبيعات', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.white)),

          pw.SizedBox(height: 8),

          pdfText(inv.id, style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.grey300)),

          pw.SizedBox(height: 8),

          pdfText(inv.date, style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey400)),

        ]),

      ),

      pw.SizedBox(height: 24),

      _buildInfoSection(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildItemsTable(inv, font, fontBold),

      pw.SizedBox(height: 16),

      _buildTotalSection(inv, font, fontBold),

    ],

  ));

}



pw.Widget _buildInfoSection(Invoice inv, pw.Font font, pw.Font fontBold) {

  return pw.Container(

    padding: const pw.EdgeInsets.all(16),

    decoration: pw.BoxDecoration(

      color: PdfColors.grey100,

      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),

    ),

    child: pw.Row(

      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,

      children: [

        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [

          pdfText('بيانات العميل', style: pw.TextStyle(font: fontBold, fontSize: 14)),

          pw.SizedBox(height: 8),

          pdfText('الاسم: ${inv.buyerName}', style: pw.TextStyle(font: font, fontSize: 12)),

          if (inv.buyerPhone.isNotEmpty) pdfText('الهاتف: ${inv.buyerPhone}', style: pw.TextStyle(font: font, fontSize: 12)),

          if (inv.buyerAddress.isNotEmpty) pdfText('العنوان: ${inv.buyerAddress}', style: pw.TextStyle(font: font, fontSize: 12)),

        ]),

        pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [

          pdfText('تفاصيل الفاتورة', style: pw.TextStyle(font: fontBold, fontSize: 14)),

          pw.SizedBox(height: 8),

          pdfText('رقم: ${inv.id}', style: pw.TextStyle(font: font, fontSize: 12)),

          pdfText('التاريخ: ${inv.date}', style: pw.TextStyle(font: font, fontSize: 12)),

        ]),

      ],

    ),

  );

}



pw.Widget _buildItemsTable(Invoice inv, pw.Font font, pw.Font fontBold) {

  return pw.TableHelper.fromTextArray(

    headerStyle: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.white),

    headerDecoration: const pw.BoxDecoration(

      color: PdfColor(0.2, 0.4, 0.6),

      borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),

    ),

    cellStyle: pw.TextStyle(font: font, fontSize: 10),

    cellAlignment: pw.Alignment.center,

    headerAlignment: pw.Alignment.center,

    headers: ['المنتج', 'السعر', 'الكمية', 'الخصم', 'الإجمالي'],

    data: inv.items.map((item) => [

      item.name,

      '${item.price.toStringAsFixed(2)} د.ل',

      '${item.quantity}',

      '${item.discountAmt.toStringAsFixed(2)}',

      '${item.lineTotal.toStringAsFixed(2)} د.ل',

    ]).toList(),

  );

}



pw.Widget _buildTotalSection(Invoice inv, pw.Font font, pw.Font fontBold) {

  return pw.Container(

    padding: const pw.EdgeInsets.all(16),

    decoration: pw.BoxDecoration(

      color: PdfColors.grey50,

      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),

      border: pw.Border.all(color: PdfColors.grey200),

    ),

    child: pw.Column(

      children: [

        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [

          pdfText('الإجمالي الفرعي:', style: pw.TextStyle(font: font, fontSize: 12)),

          pdfText('${inv.subtotal.toStringAsFixed(2)} د.ل', style: pw.TextStyle(font: font, fontSize: 12)),

        ]),

        if (inv.discountAmt > 0 || inv.discountPct > 0) ...[

          pw.SizedBox(height: 8),

          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [

            pdfText('الخصم:', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.red)),

            pdfText('${(inv.discountAmt + inv.subtotal * inv.discountPct / 100).toStringAsFixed(2)} د.ل', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.red)),

          ]),

        ],

        pw.Divider(),

        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [

          pdfText('المجموع:', style: pw.TextStyle(font: fontBold, fontSize: 18)),

          pdfText('${inv.total.toStringAsFixed(2)} د.ل', style: pw.TextStyle(font: fontBold, fontSize: 18)),

        ]),

        if (inv.totalPaid > 0) ...[

          pw.SizedBox(height: 8),

          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [

            pdfText('المدفوع:', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.green)),

            pdfText('${inv.totalPaid.toStringAsFixed(2)} د.ل', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.green)),

          ]),

          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [

            pdfText('المتبقي:', style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.red)),

            pdfText('${inv.remaining.toStringAsFixed(2)} د.ل', style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.red)),

          ]),

        ],

      ],

    ),

  );

}



String _statusLabel(String s) => s == 'paid' ? 'مدفوع' : (s == 'partial' ? 'جزئي' : 'غير مدفوع');



// ==================== UPDATE SYSTEM ====================

const String appVersion = '1.1.0';

const String appBuildNumber = '2';

const Map<String, Map<String, dynamic>> appChangelog = {

  '1.1.0': {

    'title': 'الإصدار 1.1.0',

    'date': '2026-08-17',

    'features': [

      'دعم الدفعات المتعددة: سداد عدة فواتير بدفعة واحدة',

      'الدفعات المقدمة: إيداع مبالغ في حساب الزبون',

      'رصيد الزبون: تتبع الحسابات والمدفوعات',

      'اختيار الزبون عند الدفع مع عرض الفواتير غير المدفوعة',

    ],

    'fixes': [

      'إصلاح ظهور النصوص معكوسة في ملفات PDF',

      'إصلاح لوحة التعريف لتعمل فقط عند أول تثبيت',

      'إصلاح مشاركة واتساب وتيليجرام',

      'تحسين دعم الوضع الليلي',

    ],

  },

  '1.0.0': {

    'title': 'الإصدار 1.0.0',

    'date': '2026-08-15',

    'features': [

      'إنشاء الفواتير مع 6 نماذج مختلفة',

      'تخصيص الفواتير: ألوان، خطوط، جداول، أقسام',

      'إدارة المنتجات مع الباركود',

      'إدارة العملاء مع كشف الحساب',

      'طباعة ومشاركة الفواتير PDF',

      'مشاركة عبر واتساب وتيليجرام',

      'الوضع الليلي',

      'تصنيفات الفواتير',

    ],

    'fixes': [],

  },

};

void _showWhatsNewDialog(BuildContext context) {

  final changelog = appChangelog[appVersion];

  if (changelog == null) return;

  final features = changelog['features'] as List<String>? ?? [];

  final fixes = changelog['fixes'] as List<String>? ?? [];



  showDialog(

    context: context,

    barrierDismissible: false,

    builder: (ctx) => AlertDialog(

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      content: SingleChildScrollView(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Center(

              child: Container(

                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

                decoration: BoxDecoration(

                  gradient: LinearGradient(colors: AppColors.gradient1),

                  borderRadius: BorderRadius.circular(20),

                ),

                child: Text('${changelog['title']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),

              ),

            ),

            const SizedBox(height: 4),

            Center(child: Text('${changelog['date']}', style: TextStyle(color: Colors.grey[500], fontSize: 12))),

            const SizedBox(height: 16),

            if (features.isNotEmpty) ...[

              const Row(children: [

                Icon(Icons.new_releases, color: AppColors.primary, size: 18),

                SizedBox(width: 6),

                Text('الميزات الجديدة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

              ]),

              const SizedBox(height: 8),

              ...features.map((f) => Padding(

                padding: const EdgeInsets.only(bottom: 6),

                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text('✦ ', style: TextStyle(color: AppColors.primary)),

                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),

                  ],

                ),

              )),

              const SizedBox(height: 12),

            ],

            if (fixes.isNotEmpty) ...[

              const Row(children: [

                Icon(Icons.bug_report, color: AppColors.success, size: 18),

                SizedBox(width: 6),

                Text('إصلاحات', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

              ]),

              const SizedBox(height: 8),

              ...fixes.map((f) => Padding(

                padding: const EdgeInsets.only(bottom: 6),

                child: Row(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Text('✓ ', style: TextStyle(color: AppColors.success)),

                    Expanded(child: Text(f, style: const TextStyle(fontSize: 13))),

                  ],

                ),

              )),

            ],

          ],

        ),

      ),

      actions: [

        Center(

          child: GradientButton(

            label: 'تم',

            icon: Icons.check,

            gradient: AppColors.gradient1,

            onPressed: () {

              Navigator.of(ctx).pop();

            },

          ),

        ),

      ],

    ),

  );

}



Future<void> checkForUpdate(BuildContext context) async {

  final prefs = await SharedPreferences.getInstance();

  final lastSeenVersion = prefs.getString('lastSeenVersion') ?? '';

  if (lastSeenVersion != appVersion) {

    await prefs.setString('lastSeenVersion', appVersion);

    if (context.mounted) {

      _showWhatsNewDialog(context);

    }

  }

}



// ==================== SPLASH ====================

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override

  State<SplashScreen> createState() => _SplashScreenState();

}



class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {

  late AnimationController _fadeController;

  late AnimationController _scaleController;

  late AnimationController _rotateController;

  late Animation<double> _fadeAnimation;

  late Animation<double> _scaleAnimation;

  late Animation<double> _rotateAnimation;



  @override

  void initState() {

    super.initState();

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));

    _scaleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _rotateController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));



    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_rotateController);



    _fadeController.forward();

    _scaleController.forward();

    _rotateController.repeat();

    Future.delayed(const Duration(seconds: 3), () async {

      if (mounted) {

        final prefs = await SharedPreferences.getInstance();

        final onboardingDone = prefs.getBool('onboardingDone') ?? false;

        Navigator.pushReplacement(context, PageRouteBuilder(

          pageBuilder: (_, __, ___) => onboardingDone ? const HomeScreen() : const OnboardingScreen(),

          transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),

          transitionDuration: const Duration(milliseconds: 800),

        ));

      }

    });

  }



  @override

  void dispose() {

    _fadeController.dispose();

    _scaleController.dispose();

    _rotateController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,

            colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],

          ),

        ),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            AnimatedBuilder(

              animation: _rotateAnimation,

              builder: (_, child) => Transform.rotate(

                angle: _rotateAnimation.value * 0.1,

                child: AnimatedBuilder(

                  animation: _scaleAnimation,

                  builder: (_, child) => Transform.scale(

                    scale: _scaleAnimation.value,

                    child: Container(

                      padding: const EdgeInsets.all(40),

                      decoration: BoxDecoration(

                        color: Colors.white.withOpacity(0.2),

                        shape: BoxShape.circle,

                        boxShadow: [

                          BoxShadow(

                            color: Colors.white.withOpacity(0.3),

                            blurRadius: 40,

                            spreadRadius: 10,

                          ),

                        ],

                      ),

                      child: const Icon(Icons.receipt_long, size: 80, color: Colors.white),

                    ),

                  ),

                ),

              ),

            ),

            const SizedBox(height: 40),

            FadeTransition(

              opacity: _fadeAnimation,

              child: const Text('FastInvoice', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),

            ),

            const SizedBox(height: 8),

            FadeTransition(

              opacity: _fadeAnimation,

              child: Text('نظام فواتير متكامل', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),

            ),

          ],

        ),

      ),

    );

  }

}



// ==================== ONBOARDING ====================

class OnboardingScreen extends StatefulWidget {

  const OnboardingScreen({super.key});

  @override

  State<OnboardingScreen> createState() => _OnboardingScreenState();

}



class _OnboardingScreenState extends State<OnboardingScreen> {

  final _pageController = PageController();

  int _currentPage = 0;



  final _pages = [

    _OnboardData(

      title: 'إنشاء فواتير احترافية',

      subtitle: 'قم بإنشاء فواتير مبيعات احترافية بضغطة زر',

      lottie: 'invoice',

      gradient: AppColors.gradient1,

    ),

    _OnboardData(

      title: 'مشاركة فورية',

      subtitle: 'شارك الفواتير عبر واتساب أو تيليجرام أو PDF',

      lottie: 'share',

      gradient: AppColors.gradient2,

    ),

    _OnboardData(

      title: 'تتبع ذكي',

      subtitle: 'تتبع المبيعات والعملاء مع إحصائيات مفصلة',

      lottie: 'stats',

      gradient: AppColors.gradient3,

    ),

  ];



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        decoration: BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,

            end: Alignment.bottomCenter,

            colors: [

              _pages[_currentPage].gradient[0].withOpacity(0.1),

              Colors.white,

            ],

          ),

        ),

        child: SafeArea(

          child: Column(

            children: [

              Align(

                alignment: Alignment.topLeft,

                child: TextButton(

                  onPressed: _goToHome,

                  child: const Text('تخطي', style: TextStyle(color: Colors.grey)),

                ),

              ),

              Expanded(

                child: PageView.builder(

                  controller: _pageController,

                  onPageChanged: (i) => setState(() => _currentPage = i),

                  itemCount: _pages.length,

                  itemBuilder: (_, i) {

                    final page = _pages[i];

                    return Padding(

                      padding: const EdgeInsets.all(40),

                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [

                          TweenAnimationBuilder<double>(

                            tween: Tween(begin: 0.5, end: 1),

                            duration: const Duration(milliseconds: 800),

                            curve: Curves.elasticOut,

                            builder: (_, value, child) => Transform.scale(

                              scale: value,

                              child: Container(

                                width: 200,

                                height: 200,

                                decoration: BoxDecoration(

                                  gradient: LinearGradient(colors: page.gradient),

                                  shape: BoxShape.circle,

                                  boxShadow: [

                                    BoxShadow(

                                      color: page.gradient[0].withOpacity(0.3),

                                      blurRadius: 30,

                                      offset: const Offset(0, 15),

                                    ),

                                  ],

                                ),

                                child: _getLottieWidget(page.lottie),

                              ),

                            ),

                          ),

                          const SizedBox(height: 48),

                          Text(page.title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                          const SizedBox(height: 16),

                          Text(page.subtitle, style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),

                        ],

                      ),

                    );

                  },

                ),

              ),

              Padding(

                padding: const EdgeInsets.all(24),

                child: Row(

                  children: [

                    Row(

                      children: List.generate(_pages.length, (i) => AnimatedContainer(

                        duration: const Duration(milliseconds: 300),

                        margin: const EdgeInsets.only(right: 8),

                        width: _currentPage == i ? 40 : 12,

                        height: 12,

                        decoration: BoxDecoration(

                          gradient: _currentPage == i ? LinearGradient(colors: _pages[i].gradient) : null,

                          color: _currentPage == i ? null : Colors.grey[300],

                          borderRadius: BorderRadius.circular(6),

                        ),

                      )),

                    ),

                    const Spacer(),

                    GradientButton(

                      label: _currentPage < _pages.length - 1 ? 'التالي' : 'ابدأ',

                      icon: _currentPage < _pages.length - 1 ? Icons.arrow_back : Icons.check,

                      gradient: _pages[_currentPage].gradient,

                      onPressed: () {

                        if (_currentPage < _pages.length - 1) {

                          _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);

                        } else {

                          _goToHome();

                        }

                      },

                    ),

                  ],

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }



  Widget _getLottieWidget(String type) {

    return Icon(

      type == 'invoice' ? Icons.receipt_long : (type == 'share' ? Icons.share : Icons.analytics),

      size: 80,

      color: Colors.white,

    );

  }



  void _goToHome() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboardingDone', true);

    if (mounted) {

      Navigator.pushReplacement(context, PageRouteBuilder(

        pageBuilder: (_, __, ___) => const HomeScreen(),

        transitionsBuilder: (_, anim, __, child) => SlideTransition(

          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),

          child: child,

        ),

        transitionDuration: const Duration(milliseconds: 600),

      ));

    }

  }

}



class _OnboardData {

  final String title;

  final String subtitle;

  final String lottie;

  final List<Color> gradient;

  const _OnboardData({required this.title, required this.subtitle, required this.lottie, required this.gradient});

}



// ==================== HOME ====================

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override

  State<HomeScreen> createState() => _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  int _currentIndex = 0;

  late AnimationController _fabController;

  late Animation<double> _fabScale;



  @override

  void initState() {

    super.initState();

    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    _fabScale = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _fabController, curve: Curves.elasticOut));

    _fabController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {

      checkForUpdate(context);

    });

  }



  @override

  void dispose() {

    _fabController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: AnimatedSwitcher(

        duration: const Duration(milliseconds: 400),

        transitionBuilder: (child, anim) => FadeTransition(

          opacity: anim,

          child: SlideTransition(

            position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(anim),

            child: child,

          ),

        ),

        child: [

          const InvoiceListScreen(),

          const PaymentsScreen(),

          const ProductsScreen(),

          const CustomersScreen(),

          const StatsScreen(),

          const SettingsScreen(),

        ][_currentIndex],

      ),

      bottomNavigationBar: Container(

        decoration: BoxDecoration(

          boxShadow: [

            BoxShadow(

              color: Colors.black.withOpacity(0.05),

              blurRadius: 20,

              offset: const Offset(0, -5),

            ),

          ],

        ),

        child: NavigationBar(

          selectedIndex: _currentIndex,

          onDestinationSelected: (i) {

            HapticFeedback.lightImpact();

            setState(() => _currentIndex = i);

            _fabController.reset();

            _fabController.forward();

          },

          animationDuration: const Duration(milliseconds: 400),

          destinations: const [

            NavigationDestination(icon: Icon(Icons.receipt_long), selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary), label: 'الفواتير'),

            NavigationDestination(icon: Icon(Icons.payments), selectedIcon: Icon(Icons.payments, color: AppColors.primary), label: 'الدفعات'),

            NavigationDestination(icon: Icon(Icons.inventory_2), selectedIcon: Icon(Icons.inventory_2, color: AppColors.primary), label: 'المنتجات'),

            NavigationDestination(icon: Icon(Icons.people), selectedIcon: Icon(Icons.people, color: AppColors.primary), label: 'العملاء'),

            NavigationDestination(icon: Icon(Icons.bar_chart), selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary), label: 'الإحصائيات'),

            NavigationDestination(icon: Icon(Icons.settings), selectedIcon: Icon(Icons.settings, color: AppColors.primary), label: 'الإعدادات'),

          ],

        ),

      ),

      floatingActionButton: _currentIndex == 0

          ? ScaleTransition(

              scale: _fabScale,

              child: FloatingActionButton.extended(

                onPressed: () => Navigator.push(context, PageRouteBuilder(

                  pageBuilder: (_, __, ___) => const CreateInvoiceScreen(),

                  transitionsBuilder: (_, anim, __, child) => ScaleTransition(

                    scale: CurvedAnimation(parent: anim, curve: Curves.easeOutBack),

                    child: child,

                  ),

                )),

                icon: const Icon(Icons.add),

                label: const Text('فاتورة جديدة'),

              ),

            )

          : _currentIndex == 1

              ? ScaleTransition(

                  scale: _fabScale,

                  child: FloatingActionButton.extended(

                    onPressed: () {

                      final store = context.read<DataStore>();

                      final unpaidInvoices = store.invoices.where((i) => i.remaining > 0).toList();

                      if (unpaidInvoices.isNotEmpty) {

                        showModalBottomSheet(

                          context: context,

                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

                          builder: (_) => _quickPayBottomSheet(store),

                        );

                      }

                    },

                    icon: const Icon(Icons.payments),

                    label: Consumer<DataStore>(

                      builder: (_, store, __) {

                        final count = store.invoices.where((i) => i.remaining > 0).length;

                        return Text(count > 0 ? 'استلام ($count)' : 'مدفوعة');

                      },

                    ),

                    backgroundColor: AppColors.success,

                  ),

                )

              : null,

    );

  }



  Widget _quickPayBottomSheet(DataStore store) {

    return _MultiInvoicePaymentSheet(store: store);

  }



  Widget _payForInvoice(Invoice inv, DataStore store) {

    final amtCtrl = TextEditingController();

    PaymentMethod selectedMethod = PaymentMethod.cash;

    return StatefulBuilder(

      builder: (_, setSheetState) => Padding(

        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),

        child: SingleChildScrollView(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(children: [

                const Icon(Icons.payment, color: AppColors.primary, size: 24),

                const SizedBox(width: 8),

                Text('استلام - ${inv.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              ]),

              const SizedBox(height: 8),

              Text('العميل: ${inv.buyerName} | المتبقي: ${inv.remaining.toStringAsFixed(2)} د.ل', style: TextStyle(color: Colors.grey[600], fontSize: 13)),

              const SizedBox(height: 16),

              TextField(controller: amtCtrl, keyboardType: TextInputType.number, autofocus: true, decoration: const InputDecoration(labelText: 'المبلغ', border: OutlineInputBorder(), suffixText: 'د.ل')),

              const SizedBox(height: 8),

              Row(children: [

                _homeQuickPayBtn('الكل', inv.remaining, amtCtrl, setSheetState),

                const SizedBox(width: 8),

                _homeQuickPayBtn('النصف', inv.remaining / 2, amtCtrl, setSheetState),

              ]),

              const SizedBox(height: 12),

              Wrap(spacing: 8, runSpacing: 8, children: PaymentMethod.values.take(4).map((m) {

                final isSel = selectedMethod == m;

                return GestureDetector(

                  onTap: () => setSheetState(() => selectedMethod = m),

                  child: Container(

                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

                    decoration: BoxDecoration(

                      gradient: isSel ? LinearGradient(colors: AppColors.gradient4) : null,

                      color: isSel ? null : Colors.grey.shade100,

                      borderRadius: BorderRadius.circular(12),

                      border: Border.all(color: isSel ? AppColors.success : Colors.grey.shade300),

                    ),

                    child: Text('${paymentMethodIcon(m)} ${paymentMethodName(m)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSel ? Colors.white : AppColors.textPrimaryOf(context))),

                  ),

                );

              }).toList()),

              const SizedBox(height: 16),

              GradientButton(

                label: 'تأكيد', icon: Icons.check, gradient: AppColors.gradient4, isExpanded: true,

                onPressed: () {

                  final amt = double.tryParse(amtCtrl.text) ?? 0;

                  if (amt > 0) {

                    inv.payments.add(Payment(amount: amt, date: DateFormat('yyyy-MM-dd').format(DateTime.now()), method: selectedMethod, receiptNumber: 'RCP-${inv.id}-${inv.payments.length + 1}', customerId: inv.buyerName, invoiceId: inv.id));

                    store.updateInvoice(store.invoices.indexOf(inv), inv);

                    Navigator.pop(context);

                    HapticFeedback.heavyImpact();

                    showAppToast(context, 'تم استلام ${amt.toStringAsFixed(2)} د.ل', icon: Icons.check_circle, color: AppColors.success);

                  }

                },

              ),

              const SizedBox(height: 20),

            ],

          ),

        ),

      ),

    );

  }



  Widget _homeQuickPayBtn(String label, double amount, TextEditingController ctrl, StateSetter setState) {

    return Expanded(

      child: GestureDetector(

        onTap: () { ctrl.text = amount.toStringAsFixed(2); setState(() {}); },

        child: Container(

          padding: const EdgeInsets.symmetric(vertical: 10),

          decoration: BoxDecoration(

            gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.1), AppColors.success.withOpacity(0.05)]),

            borderRadius: BorderRadius.circular(10),

            border: Border.all(color: AppColors.success.withOpacity(0.3)),

          ),

          child: Column(children: [

            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),

            const SizedBox(height: 2),

            Text('${amount.toStringAsFixed(0)} د.ل', style: TextStyle(fontSize: 10, color: Colors.grey[600])),

          ]),

        ),

      ),

    );

  }

}



// ==================== BARCODE SCANNER ====================

class _MultiInvoicePaymentSheet extends StatefulWidget {
  final DataStore store;
  const _MultiInvoicePaymentSheet({required this.store});
  @override
  State<_MultiInvoicePaymentSheet> createState() => _MultiInvoicePaymentSheetState();
}

class _MultiInvoicePaymentSheetState extends State<_MultiInvoicePaymentSheet> {
  String? selectedCustomer;
  String paymentMode = 'invoice';
  final amtCtrl = TextEditingController();
  PaymentMethod selectedMethod = PaymentMethod.cash;
  Map<String, double> allocations = {};

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final customerNames = store.customers.map((c) => c.name).toSet().toList();
    final unpaidInvoices = selectedCustomer != null
        ? store.getCustomerUnpaidInvoices(selectedCustomer!)
        : store.invoices.where((i) => i.remaining > 0).toList();
    final advanceBalance = selectedCustomer != null ? store.getCustomerAdvanceBalance(selectedCustomer!) : 0.0;
    final totalAmount = double.tryParse(amtCtrl.text) ?? 0;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.payments, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                const Text('استلام دفعة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),

              const Text('الزبون', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedCustomer,
                isExpanded: true,
                decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'اختر الزبون'),
                items: customerNames.map((n) => DropdownMenuItem(value: n, child: Text(n))).toList(),
                onChanged: (v) => setState(() {
                  selectedCustomer = v;
                  allocations.clear();
                }),
              ),

              if (selectedCustomer != null && advanceBalance > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withOpacity(0.3)),
                  ),
                  child: Row(children: [
                    const Icon(Icons.account_balance_wallet, color: AppColors.success, size: 18),
                    const SizedBox(width: 8),
                    Text('رصيد الزبون: ${advanceBalance.toStringAsFixed(2)} د.ل',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                  ]),
                ),
              ],

              const SizedBox(height: 16),
              const Text('المبلغ', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: const InputDecoration(border: OutlineInputBorder(), suffixText: 'د.ل', hintText: 'أدخل المبلغ'),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 8),
              Row(children: [
                _amtQuickBtn('100', 100),
                const SizedBox(width: 8),
                _amtQuickBtn('500', 500),
                const SizedBox(width: 8),
                _amtQuickBtn('1000', 1000),
              ]),

              const SizedBox(height: 16),
              const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PaymentMethod.values.take(4).map((m) {
                  final isSel = selectedMethod == m;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMethod = m),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: isSel ? LinearGradient(colors: AppColors.gradient4) : null,
                        color: isSel ? null : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isSel ? AppColors.success : Colors.grey.shade300),
                      ),
                      child: Text('${paymentMethodIcon(m)} ${paymentMethodName(m)}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSel ? Colors.white : AppColors.textPrimaryOf(context))),
                    ),
                  );
                }).toList(),
              ),

              if (selectedCustomer != null) ...[
                const SizedBox(height: 16),
                const Text('نوع الدفعة', style: TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(children: [
                  _modeChip('فاتورة واحدة', 'single', unpaidInvoices.length == 1),
                  const SizedBox(width: 8),
                  _modeChip('عدة فواتير', 'multi', unpaidInvoices.length > 1),
                  const SizedBox(width: 8),
                  _modeChip('دفعة مقدمة', 'advance', true),
                ]),
              ],

              if (selectedCustomer != null && paymentMode == 'multi' && unpaidInvoices.length > 1 && totalAmount > 0) ...[
                const SizedBox(height: 16),
                Text('توزيع المبلغ على الفواتير (${totalAmount.toStringAsFixed(2)} د.ل)',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                ...unpaidInvoices.map((inv) {
                  final alloc = allocations[inv.id] ?? 0;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(inv.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text('المتبقي: ${inv.remaining.toStringAsFixed(2)}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: '0',
                            suffixText: 'د.ل',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            isDense: true,
                            border: const OutlineInputBorder(),
                          ),
                          controller: TextEditingController(text: alloc > 0 ? alloc.toStringAsFixed(2) : ''),
                          onChanged: (v) {
                            final amt = double.tryParse(v) ?? 0;
                            setState(() => allocations[inv.id] = amt);
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          final maxForInv = inv.remaining.clamp(0.0, totalAmount);
                          setState(() => allocations[inv.id] = maxForInv);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text('الكل', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
                        ),
                      ),
                    ]),
                  );
                }),
              ],

              const SizedBox(height: 16),
              GradientButton(
                label: _getPayLabel(paymentMode, unpaidInvoices.length),
                icon: Icons.check,
                gradient: AppColors.gradient4,
                isExpanded: true,
                onPressed: () => _processPayment(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _getPayLabel(String mode, int count) {
    switch (mode) {
      case 'advance': return 'حفظ دفعة مقدمة';
      case 'multi': return 'توزيع على $count فواتير';
      default: return 'تأكيد الدفعة';
    }
  }

  Widget _amtQuickBtn(String label, double amount) {
    return GestureDetector(
      onTap: () { amtCtrl.text = amount.toStringAsFixed(0); setState(() {}); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.1), AppColors.success.withOpacity(0.05)]),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _modeChip(String label, String mode, bool enabled) {
    final isSel = paymentMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: enabled ? () => setState(() => paymentMode = mode) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isSel ? LinearGradient(colors: AppColors.gradient1) : null,
            color: isSel ? null : (enabled ? Colors.grey.shade100 : Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSel ? AppColors.primary : Colors.grey.shade300),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.bold,
            color: isSel ? Colors.white : (enabled ? AppColors.textPrimaryOf(context) : Colors.grey),
          )),
        ),
      ),
    );
  }

  void _processPayment(BuildContext context) {
    final store = context.read<DataStore>();
    final amt = double.tryParse(amtCtrl.text) ?? 0;
    if (amt <= 0 || selectedCustomer == null) return;

    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (paymentMode == 'advance') {
      store.addAdvancePayment(selectedCustomer!, Payment(
        amount: amt, date: now, method: selectedMethod,
        receiptNumber: 'ADV-$selectedCustomer-${DateTime.now().millisecondsSinceEpoch}',
      ));
      Navigator.pop(context);
      HapticFeedback.heavyImpact();
      showAppToast(context, 'تم حفظ دفعة مقدمة ${amt.toStringAsFixed(2)} د.ل', icon: Icons.savings, color: AppColors.success);
      return;
    }

    final unpaidInvoices = store.getCustomerUnpaidInvoices(selectedCustomer!);

    if (paymentMode == 'single' || unpaidInvoices.length == 1) {
      final inv = unpaidInvoices.first;
      final payAmt = amt.clamp(0.0, inv.remaining);
      inv.payments.add(Payment(
        amount: payAmt, date: now, method: selectedMethod,
        customerId: selectedCustomer, invoiceId: inv.id,
        receiptNumber: 'RCP-${inv.id}-${inv.payments.length + 1}',
      ));
      store.updateInvoice(store.invoices.indexOf(inv), inv);
      Navigator.pop(context);
      HapticFeedback.heavyImpact();
      showAppToast(context, 'تم استلام ${payAmt.toStringAsFixed(2)} د.ل للفاتورة ${inv.id}', icon: Icons.check_circle, color: AppColors.success);
      return;
    }

    if (paymentMode == 'multi') {
      final remaining = store.allocatePaymentToInvoices(
        selectedCustomer!, amt, allocations, selectedMethod,
      );
      Navigator.pop(context);
      HapticFeedback.heavyImpact();
      final msg = remaining > 0
          ? 'تم التوزيع. متبقي ${remaining.toStringAsFixed(2)} د.ل غير موزع'
          : 'تم توزيع ${amt.toStringAsFixed(2)} د.ل على الفواتير';
      showAppToast(context, msg, icon: Icons.check_circle, color: remaining > 0 ? AppColors.warning : AppColors.success);
    }
  }
}


class BarcodeScannerScreen extends StatefulWidget {

  const BarcodeScannerScreen({super.key});

  @override

  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();

}



class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {

  MobileScannerController? _cameraController;

  bool _isProcessing = false;



  @override

  void initState() {

    super.initState();

    _cameraController = MobileScannerController(detectionSpeed: DetectionSpeed.normal, facing: CameraFacing.back);

  }



  @override

  void dispose() {

    _cameraController?.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text('مسح الباركود', style: TextStyle(fontWeight: FontWeight.bold)),

        backgroundColor: Colors.black,

        actions: [

          IconButton(

            icon: Icon(_cameraController?.torchEnabled == true ? Icons.flash_on : Icons.flash_off, color: Colors.white),

            onPressed: () => _cameraController?.toggleTorch(),

          ),

        ],

      ),

      body: Stack(

        children: [

          MobileScanner(

            controller: _cameraController!,

            onDetect: (capture) {

              if (_isProcessing) return;

              final barcode = capture.barcodes.firstOrNull;

              if (barcode != null && barcode.rawValue != null) {

                _isProcessing = true;

                HapticFeedback.heavyImpact();

                Navigator.pop(context, barcode.rawValue);

              }

            },

          ),

          Center(

            child: Container(

              width: 280,

              height: 280,

              decoration: BoxDecoration(

                border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),

                borderRadius: BorderRadius.circular(20),

              ),

              child: ClipRRect(

                borderRadius: BorderRadius.circular(17),

                child: CustomPaint(

                  painter: _ScannerPainter(),

                ),

              ),

            ),

          ),

          Positioned(

            bottom: 60,

            left: 0,

            right: 0,

            child: Container(

              margin: const EdgeInsets.symmetric(horizontal: 40),

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: Colors.black.withOpacity(0.7),

                borderRadius: BorderRadius.circular(16),

              ),

              child: const Text(

                'ضع الباركود داخل الإطار',

                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),

                textAlign: TextAlign.center,

              ),

            ),

          ),

        ],

      ),

    );

  }

}



class _ScannerPainter extends CustomPainter {

  @override

  void paint(Canvas canvas, Size size) {

    final paint = Paint()

      ..color = AppColors.primary

      ..strokeWidth = 3

      ..style = PaintingStyle.stroke;



    final path = Path()

      ..moveTo(0, 40)

      ..lineTo(0, 0)

      ..lineTo(40, 0);



    final path2 = Path()

      ..moveTo(size.width, size.height - 40)

      ..lineTo(size.width, size.height)

      ..lineTo(size.width - 40, size.height);



    final path3 = Path()

      ..moveTo(size.width, 40)

      ..lineTo(size.width, 0)

      ..lineTo(size.width - 40, 0);



    final path4 = Path()

      ..moveTo(0, size.height - 40)

      ..lineTo(0, size.height)

      ..lineTo(40, size.height);



    canvas.drawPath(path, paint);

    canvas.drawPath(path2, paint);

    canvas.drawPath(path3, paint);

    canvas.drawPath(path4, paint);

  }



  @override

  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;

}



// ==================== PAYMENTS SCREEN ====================

class PaymentsScreen extends StatefulWidget {

  const PaymentsScreen({super.key});

  @override

  State<PaymentsScreen> createState() => _PaymentsScreenState();

}



class _PaymentsScreenState extends State<PaymentsScreen> {

  String _filterMethod = 'all';

  String _searchQuery = '';



  @override

  Widget build(BuildContext context) {

    return Consumer<DataStore>(

      builder: (_, store, __) {

        final allPayments = <Map<String, dynamic>>[];

        for (final inv in store.invoices) {

          for (final p in inv.payments) {

            allPayments.add({

              'payment': p,

              'invoice': inv,

            });

  }


}

        allPayments.sort((a, b) => (b['payment'] as Payment).date.compareTo((a['payment'] as Payment).date));



        final unpaidInvoices = store.invoices.where((i) => i.remaining > 0).toList();

        final totalCollected = allPayments.fold(0.0, (s, e) => s + (e['payment'] as Payment).amount);

        final totalRemaining = store.invoices.fold(0.0, (s, i) => s + i.remaining);



        var filtered = allPayments;

        if (_searchQuery.isNotEmpty) {

          filtered = filtered.where((e) {

            final inv = e['invoice'] as Invoice;

            final p = e['payment'] as Payment;

            return inv.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||

                inv.buyerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||

                (p.receiptNumber ?? '').toLowerCase().contains(_searchQuery.toLowerCase());

          }).toList();

        }

        if (_filterMethod != 'all') {

          filtered = filtered.where((e) => (e['payment'] as Payment).method.name == _filterMethod).toList();

        }



        return Scaffold(

          backgroundColor: AppColors.bgOf(context),

          appBar: AppBar(

            title: const Text('الدفعات', style: TextStyle(fontWeight: FontWeight.bold)),

            backgroundColor: Colors.transparent,

            elevation: 0,

          ),

          body: ListView(

            padding: const EdgeInsets.all(16),

            children: [

              Row(

                children: [

                  Expanded(child: _summaryCard('المحصّل', totalCollected, AppColors.gradient4, Icons.check_circle)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard('المتبقي', totalRemaining, [AppColors.danger, AppColors.danger.withOpacity(0.7)], Icons.pending)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard('فواتير مفتوحة', unpaidInvoices.length.toDouble(), AppColors.gradient1, Icons.receipt_long)),

                ],

              ),

              const SizedBox(height: 16),

              GlassCard(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(children: [

                      const Icon(Icons.payment, color: AppColors.primary, size: 20),

                      const SizedBox(width: 8),

                      const Text('استلام دفعة سريعة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    ]),

                    const SizedBox(height: 12),

                    if (unpaidInvoices.isEmpty)

                      Center(

                        child: Padding(

                          padding: const EdgeInsets.all(20),

                          child: Column(

                            children: [

                              Icon(Icons.check_circle, size: 48, color: AppColors.success.withOpacity(0.3)),

                              const SizedBox(height: 8),

                              Text('جميع الفواتير مدفوعة!', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),

                            ],

                          ),

                        ),

                      )

                    else

                      ...unpaidInvoices.take(5).map((inv) {

                        return Container(

                          margin: const EdgeInsets.only(bottom: 8),

                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(

                            color: Colors.grey.shade50,

                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(color: Colors.grey.shade200),

                          ),

                          child: Row(

                            children: [

                              Expanded(

                                child: Column(

                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [

                                    Text('${inv.id} - ${inv.buyerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

                                    const SizedBox(height: 4),

                                    Text('الإجمالي: ${inv.total.toStringAsFixed(2)} | المدفوع: ${inv.totalPaid.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                                  ],

                                ),

                              ),

                              Column(

                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [

                                  Text('${inv.remaining.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger, fontSize: 14)),

                                  const SizedBox(height: 4),

                                  GestureDetector(

                                    onTap: () => _showQuickPayDialog(context, inv, store),

                                    child: Container(

                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                                      decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient4), borderRadius: BorderRadius.circular(8)),

                                      child: const Text('استلام', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),

                                    ),

                                  ),

                                ],

                              ),

                            ],

                          ),

                        );

                      }),

                  ],

                ),

              ),

              const SizedBox(height: 16),

              GlassCard(

                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                child: TextField(

                  decoration: InputDecoration(

                    hintText: 'بحث في الدفعات...',

                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),

                    border: InputBorder.none,

                  ),

                  onChanged: (v) => setState(() => _searchQuery = v),

                ),

              ),

              const SizedBox(height: 8),

              SizedBox(

                height: 40,

                child: ListView(

                  scrollDirection: Axis.horizontal,

                  children: [

                    _methodChip('الكل', 'all'),

                    _methodChip('💵 نقدي', 'cash'),

                    _methodChip('🏦 بنكي', 'bankTransfer'),

                    _methodChip('📱 موبايل', 'mobileMoney'),

                    _methodChip('📄 شيك', 'check'),

                    _methodChip('💳 ائتمان', 'creditCard'),

                  ],

                ),

              ),

              const SizedBox(height: 12),

              if (filtered.isEmpty)

                GlassCard(

                  child: Column(

                    children: [

                      Icon(Icons.payment_outlined, size: 48, color: Colors.grey[400]),

                      const SizedBox(height: 12),

                      Text(allPayments.isEmpty ? 'لا توجد دفعات بعد' : 'لا نتائج', style: TextStyle(color: Colors.grey[600])),

                    ],

                  ),

                )

              else

                ...filtered.map((e) {

                  final p = e['payment'] as Payment;

                  final inv = e['invoice'] as Invoice;

                  return GlassCard(

                    margin: const EdgeInsets.only(bottom: 8),

                    child: Row(

                      children: [

                        Container(

                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(

                            gradient: LinearGradient(colors: AppColors.gradient4),

                            borderRadius: BorderRadius.circular(12),

                          ),

                          child: Text(paymentMethodIcon(p.method), style: const TextStyle(fontSize: 18)),

                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Row(children: [

                                Text(inv.id, style: const TextStyle(fontWeight: FontWeight.bold)),

                                const SizedBox(width: 8),

                                Text(inv.buyerName, style: TextStyle(color: Colors.grey[600], fontSize: 12)),

                              ]),

                              const SizedBox(height: 4),

                              Text('${p.date} | ${paymentMethodName(p.method)}${p.receiptNumber != null ? ' | #' + p.receiptNumber! : ''}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),

                            ],

                          ),

                        ),

                        Column(

                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [

                            Text('${p.amount.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 14)),

                            const SizedBox(height: 4),

                            GestureDetector(

                              onTap: () => printPaymentReceipt(inv, p),

                              child: Icon(Icons.receipt, size: 18, color: AppColors.primary),

                            ),

                          ],

                        ),

                      ],

                    ),

                  );

                }),

              const SizedBox(height: 80),

            ],

          ),

        );

      },

    );

  }



  Widget _summaryCard(String label, double value, List<Color> gradient, IconData icon) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        gradient: LinearGradient(colors: gradient),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],

      ),

      child: Column(

        children: [

          Icon(icon, color: Colors.white, size: 24),

          const SizedBox(height: 8),

          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),

          const SizedBox(height: 4),

          value == value.truncateToDouble() && value < 100

              ? Text('${value.toInt()}', style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))

              : Text('${value.toStringAsFixed(0)} د.ل', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),

        ],

      ),

    );

  }



  Widget _methodChip(String label, String value) {

    final isSelected = _filterMethod == value;

    return Padding(

      padding: const EdgeInsets.only(left: 6),

      child: FilterChip(

        label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : null)),

        selected: isSelected,

        onSelected: (_) => setState(() => _filterMethod = value),

        selectedColor: AppColors.primary,

        checkmarkColor: Colors.white,

        padding: const EdgeInsets.symmetric(horizontal: 4),

      ),

    );

  }



  void _showQuickPayDialog(BuildContext ctx, Invoice inv, DataStore store) {

    final amtCtrl = TextEditingController();

    PaymentMethod selectedMethod = PaymentMethod.cash;



    showModalBottomSheet(

      context: ctx,

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (_) => StatefulBuilder(

        builder: (_, setSheetState) => Padding(

          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(children: [

                  const Icon(Icons.payment, color: AppColors.primary, size: 24),

                  const SizedBox(width: 8),

                  Text('استلام - ${inv.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const Spacer(),

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),

                    child: Text('المتبقي: ${inv.remaining.toStringAsFixed(2)} د.ل', style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.bold)),

                  ),

                ]),

                const SizedBox(height: 12),

                Text('العميل: ${inv.buyerName}', style: TextStyle(color: Colors.grey[600])),

                const SizedBox(height: 16),

                TextField(

                  controller: amtCtrl, keyboardType: TextInputType.number, autofocus: true,

                  decoration: InputDecoration(labelText: 'المبلغ', border: const OutlineInputBorder(), suffixText: 'د.ل'),

                ),

                const SizedBox(height: 8),

                Row(

                  children: [

                    _quickPayBtn('الكل', inv.remaining, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn('النصف', inv.remaining / 2, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn('الربع', inv.remaining / 4, amtCtrl, setSheetState),

                  ],

                ),

                const SizedBox(height: 12),

                const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                Wrap(

                  spacing: 8,

                  runSpacing: 8,

                  children: PaymentMethod.values.take(4).map((m) {

                    final isSelected = selectedMethod == m;

                    return GestureDetector(

                      onTap: () => setSheetState(() => selectedMethod = m),

                      child: AnimatedContainer(

                        duration: const Duration(milliseconds: 200),

                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

                        decoration: BoxDecoration(

                          gradient: isSelected ? LinearGradient(colors: AppColors.gradient1) : null,

                          color: isSelected ? null : Colors.grey.shade100,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),

                        ),

                        child: Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Text(paymentMethodIcon(m), style: const TextStyle(fontSize: 16)),

                            const SizedBox(width: 6),

                            Text(paymentMethodName(m), style: TextStyle(

                              fontSize: 12, fontWeight: FontWeight.bold,

                              color: isSelected ? Colors.white : AppColors.textPrimaryOf(context),

                            )),

                          ],

                        ),

                      ),

                    );

                  }).toList(),

                ),

                const SizedBox(height: 16),

                GradientButton(

                  label: 'تأكيد الاستلام',

                  icon: Icons.check,

                  gradient: AppColors.gradient4,

                  onPressed: () {

                    final amt = double.tryParse(amtCtrl.text) ?? 0;

                    if (amt > 0) {

                      inv.payments.add(Payment(

                        amount: amt,

                        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),

                        method: selectedMethod,

                        receiptNumber: 'RCP-${inv.id}-${inv.payments.length + 1}',

                        customerId: inv.buyerName,

                        invoiceId: inv.id,

                      ));

                      store.updateInvoice(store.invoices.indexOf(inv), inv);

                      Navigator.pop(ctx);

                      HapticFeedback.heavyImpact();

                      showAppToast(ctx, 'تم استلام ${amt.toStringAsFixed(2)} د.ل', icon: Icons.check_circle, color: AppColors.success);

                    }

                  },

                  isExpanded: true,

                ),

                const SizedBox(height: 20),

              ],

            ),

          ),

        ),

      ),

    );

  }



  Widget _quickPayBtn(String label, double amount, TextEditingController ctrl, StateSetter setState) {

    return Expanded(

      child: GestureDetector(

        onTap: () { ctrl.text = amount.toStringAsFixed(2); setState(() {}); },

        child: Container(

          padding: const EdgeInsets.symmetric(vertical: 10),

          decoration: BoxDecoration(

            gradient: LinearGradient(colors: [AppColors.success.withOpacity(0.1), AppColors.success.withOpacity(0.05)]),

            borderRadius: BorderRadius.circular(10),

            border: Border.all(color: AppColors.success.withOpacity(0.3)),

          ),

          child: Column(

            children: [

              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),

              const SizedBox(height: 2),

              Text('${amount.toStringAsFixed(0)} د.ل', style: TextStyle(fontSize: 10, color: Colors.grey[600])),

            ],

          ),

        ),

      ),

    );

  }

}



// ==================== INVOICE LIST ====================

class InvoiceListScreen extends StatefulWidget {

  const InvoiceListScreen({super.key});

  @override

  State<InvoiceListScreen> createState() => _InvoiceListScreenState();

}



class _InvoiceListScreenState extends State<InvoiceListScreen> {

  final _searchController = TextEditingController();

  String _searchQuery = '';

  String _filterStatus = 'all';

  String _sortBy = 'date_desc';

  DateTime? _dateFrom;

  DateTime? _dateTo;

  double? _amountMin;

  double? _amountMax;



  List<Invoice> _filteredInvoices(DataStore store) {

    var list = List<Invoice>.from(store.invoices);

    if (_searchQuery.isNotEmpty) {

      final q = _searchQuery.toLowerCase();

      list = list.where((inv) =>

        inv.id.toLowerCase().contains(q) ||

        inv.buyerName.toLowerCase().contains(q) ||

        inv.buyerPhone.contains(q)

      ).toList();

    }

    if (_filterStatus != 'all') {

      list = list.where((inv) => inv.status == _filterStatus).toList();

    }

    if (_dateFrom != null) {

      list = list.where((inv) {

        try {

          final d = DateFormat('yyyy-MM-dd').parse(inv.date);

          return d.isAfter(_dateFrom!) || d.isAtSameMomentAs(_dateFrom!);

        } catch (_) { return true; }

      }).toList();

    }

    if (_dateTo != null) {

      list = list.where((inv) {

        try {

          final d = DateFormat('yyyy-MM-dd').parse(inv.date);

          return d.isBefore(_dateTo!) || d.isAtSameMomentAs(_dateTo!);

        } catch (_) { return true; }

      }).toList();

    }

    if (_amountMin != null) {

      list = list.where((inv) => inv.total >= _amountMin!).toList();

    }

    if (_amountMax != null) {

      list = list.where((inv) => inv.total <= _amountMax!).toList();

    }

    switch (_sortBy) {

      case 'date_desc': list.sort((a, b) => b.date.compareTo(a.date)); break;

      case 'date_asc': list.sort((a, b) => a.date.compareTo(b.date)); break;

      case 'amount_desc': list.sort((a, b) => b.total.compareTo(a.total)); break;

      case 'amount_asc': list.sort((a, b) => a.total.compareTo(b.total)); break;

      case 'name': list.sort((a, b) => a.buyerName.compareTo(b.buyerName)); break;

    }

    return list;

  }



  Widget _buildNotificationBell(DataStore store) {

    final overdueInvoices = store.invoices.where((inv) => inv.isOverdue).toList();

    final lowStockProducts = store.products.where((p) => p.quantity <= 2 && p.quantity > 0).toList();

    final outOfStockProducts = store.products.where((p) => p.quantity == 0).toList();

    final total = overdueInvoices.length + lowStockProducts.length + outOfStockProducts.length;

    return Stack(children: [

      IconButton(

        icon: const Icon(Icons.notifications_outlined, color: AppColors.primary),

        onPressed: () => _showNotificationsSheet(context, store, overdueInvoices, lowStockProducts, outOfStockProducts),

      ),

      if (total > 0)

        Positioned(right: 6, top: 6, child: Container(

          padding: const EdgeInsets.all(4),

          decoration: const BoxDecoration(color: AppColors.danger, shape: BoxShape.circle),

          child: Text('$total', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),

        )),

    ]);

  }

  void _showNotificationsSheet(BuildContext ctx, DataStore store, List<Invoice> overdue, List<Product> lowStock, List<Product> outOfStock) {

    showModalBottomSheet(context: ctx, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))), builder: (_) => DraggableScrollableSheet(

      initialChildSize: 0.6, maxChildSize: 0.9, minChildSize: 0.3,

      expand: false,

      builder: (_, ctrl) => ListView(controller: ctrl, padding: const EdgeInsets.all(20), children: [

        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),

        const SizedBox(height: 16),

        const Text('التنبيهات', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

        const SizedBox(height: 16),

        if (overdue.isNotEmpty) ...[

          Row(children: [Icon(Icons.warning_amber, color: AppColors.danger, size: 20), const SizedBox(width: 8), Text('فواتير متأخرة (${overdue.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger))]),

          const SizedBox(height: 8),

          ...overdue.map((inv) => GlassCard(margin: const EdgeInsets.only(bottom: 8), child: ListTile(

            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.receipt_long, color: AppColors.danger, size: 20)),

            title: Text('${inv.id} - ${inv.buyerName}', style: const TextStyle(fontWeight: FontWeight.bold)),

            subtitle: Text('متأخر ${inv.daysUntilDue.abs()} يوم - متبقي ${inv.remaining.toStringAsFixed(0)} د.ل', style: TextStyle(color: Colors.grey[600], fontSize: 12)),

          ))),

          const SizedBox(height: 12),

        ],

        if (outOfStock.isNotEmpty) ...[

          Row(children: [Icon(Icons.inventory, color: AppColors.danger, size: 20), const SizedBox(width: 8), Text('نفذ من المخزون (${outOfStock.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger))]),

          const SizedBox(height: 8),

          ...outOfStock.map((p) => GlassCard(margin: const EdgeInsets.only(bottom: 8), child: ListTile(

            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.inventory_2, color: AppColors.danger, size: 20)),

            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),

            subtitle: const Text('انتهى من المخزون', style: TextStyle(color: AppColors.danger, fontSize: 12)),

          ))),

          const SizedBox(height: 12),

        ],

        if (lowStock.isNotEmpty) ...[

          Row(children: [Icon(Icons.info_outline, color: AppColors.warning, size: 20), const SizedBox(width: 8), Text('مخزون منخفض (${lowStock.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning))]),

          const SizedBox(height: 8),

          ...lowStock.map((p) => GlassCard(margin: const EdgeInsets.only(bottom: 8), child: ListTile(

            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.inventory_2, color: AppColors.warning, size: 20)),

            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),

            subtitle: Text('متبقي ${p.quantity} فقط', style: TextStyle(color: Colors.grey[600], fontSize: 12)),

          ))),

        ],

        if (overdue.isEmpty && outOfStock.isEmpty && lowStock.isEmpty)

          Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [

            Icon(Icons.check_circle, color: AppColors.success, size: 64),

            const SizedBox(height: 16),

            Text('لا توجد تنبيهات', style: TextStyle(color: Colors.grey[500], fontSize: 16)),

          ]))),

      ]),

    ));

  }

  @override

  void dispose() {

    _searchController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Consumer<DataStore>(

      builder: (ctx, store, _) {

        final filtered = _filteredInvoices(store);

        return Scaffold(

          backgroundColor: AppColors.bgOf(context),

          appBar: AppBar(

            title: const Text('الفواتير', style: TextStyle(fontWeight: FontWeight.bold)),

            backgroundColor: Colors.transparent,

            elevation: 0,

            actions: [

              _buildNotificationBell(store),

            ],

          ),

          body: Column(

            children: [

              _DashboardSummary(store: store),

              Padding(

                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),

                child: GlassCard(

                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                  child: TextField(

                    controller: _searchController,

                    decoration: InputDecoration(

                      hintText: 'بحث...',

                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),

                      suffixIcon: _searchQuery.isNotEmpty

                          ? IconButton(

                              icon: const Icon(Icons.clear),

                              onPressed: () { _searchController.clear(); setState(() => _searchQuery = ''); },

                            )

                          : null,

                      border: InputBorder.none,

                      filled: false,

                    ),

                    onChanged: (v) => setState(() => _searchQuery = v),

                  ),

                ),

              ),

              SizedBox(

                height: 44,

                child: ListView(

                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.symmetric(horizontal: 16),

                  children: [

                    _filterChip('الكل', 'all'),

                    _filterChip('مدفوعة', 'paid'),

                    _filterChip('جزئية', 'partial'),

                    _filterChip('غير مدفوعة', 'unpaid'),

                  ],

                ),

              ),

              const SizedBox(height: 8),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 16),

                child: Row(

                  children: [

                    Text('${filtered.length} فاتورة', style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                    const Spacer(),

                    if (store.invoices.isNotEmpty) ...[

                      TextButton.icon(

                        onPressed: _showSortSheet,

                        icon: const Icon(Icons.sort, size: 14),

                        label: const Text('ترتيب'),

                      ),

                      TextButton.icon(

                        onPressed: _showFilterSheet,

                        icon: Icon(Icons.filter_list, size: 14, color: (_dateFrom != null || _dateTo != null || _amountMin != null || _amountMax != null) ? AppColors.primary : null),

                        label: Text('فلتر', style: TextStyle(color: (_dateFrom != null || _dateTo != null || _amountMin != null || _amountMax != null) ? AppColors.primary : null)),

                      ),

                    ],

                  ],

                ),

              ),

              Expanded(

                child: filtered.isEmpty

                    ? EmptyState(

                        icon: Icons.receipt_long,

                        title: store.invoices.isEmpty ? 'لا توجد فواتير' : 'لا نتائج',

                        subtitle: store.invoices.isEmpty ? 'ابدأ بإنشاء فاتورة جديدة' : 'جرّب البحث بكلمات مختلفة',

                        actionLabel: store.invoices.isEmpty ? 'فاتورة جديدة' : null,

                        onAction: store.invoices.isEmpty ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateInvoiceScreen())) : null,

                      )

                    : RefreshIndicator(

                        onRefresh: () async { HapticFeedback.mediumImpact(); await store.load(); },

                        child: ListView.builder(

                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),

                          itemCount: filtered.length,

                          itemBuilder: (ctx, i) {

                            final inv = filtered[i];

                            final actualIndex = store.invoices.indexOf(inv);

                            return _InvoiceCard(

                              invoice: inv,

                              index: actualIndex,

                              onTap: () => Navigator.push(context, PageRouteBuilder(

                                pageBuilder: (_, __, ___) => InvoiceDetailScreen(invoice: inv, index: actualIndex),

                                transitionsBuilder: (_, anim, __, child) => SlideTransition(

                                  position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),

                                  child: child,

                                ),

                              )),

                            );

                          },

                        ),

                      ),

              ),

            ],

          ),

        );

      },

    );

  }



  Widget _filterChip(String label, String value) {

    final isSelected = _filterStatus == value;

    return Padding(

      padding: const EdgeInsets.only(left: 6),

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        child: FilterChip(

          label: Text(label, style: TextStyle(fontSize: 12, color: isSelected ? Colors.white : null)),

          selected: isSelected,

          onSelected: (_) => setState(() => _filterStatus = value),

          selectedColor: AppColors.primary,

          checkmarkColor: Colors.white,

          padding: const EdgeInsets.symmetric(horizontal: 4),

        ),

      ),

    );

  }

  void _showSortSheet() {

    showModalBottomSheet(

      context: context,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),

      builder: (ctx) => SafeArea(

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            const Padding(

              padding: EdgeInsets.all(16),

              child: Text('ترتيب حسب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            ),

            ...[

              ('date_desc', 'الأحدث أولاً', Icons.access_time),

              ('date_asc', 'الأقدم أولاً', Icons.history),

              ('amount_desc', 'الأعلى مبلغاً', Icons.arrow_downward),

              ('amount_asc', 'الأقل مبلغاً', Icons.arrow_upward),

              ('name', 'اسم العميل', Icons.person),

            ].map((s) => ListTile(

              leading: Icon(s.$3, color: _sortBy == s.$1 ? AppColors.primary : null),

              title: Text(s.$2, style: TextStyle(fontWeight: _sortBy == s.$1 ? FontWeight.bold : FontWeight.normal)),

              trailing: _sortBy == s.$1 ? const Icon(Icons.check, color: AppColors.primary) : null,

              onTap: () { setState(() => _sortBy = s.$1); Navigator.pop(ctx); },

            )),

            const SizedBox(height: 8),

          ],

        ),

      ),

    );

  }

  void _showFilterSheet() {

    final dateFromCtrl = TextEditingController(text: _dateFrom != null ? DateFormat('yyyy-MM-dd').format(_dateFrom!) : '');

    final dateToCtrl = TextEditingController(text: _dateTo != null ? DateFormat('yyyy-MM-dd').format(_dateTo!) : '');

    final minCtrl = TextEditingController(text: _amountMin?.toString() ?? '');

    final maxCtrl = TextEditingController(text: _amountMax?.toString() ?? '');

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),

      builder: (ctx) => Padding(

        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 16, right: 16, top: 16),

        child: StatefulBuilder(

          builder: (_, setSheetState) => Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                const Text('فلتر متقدم', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                if (_dateFrom != null || _dateTo != null || _amountMin != null || _amountMax != null)

                  TextButton(onPressed: () {

                    setSheetState(() { _dateFrom = null; _dateTo = null; _amountMin = null; _amountMax = null; });

                    setState(() {});

                  }, child: const Text('مسح الفلتر')),

              ]),

              const SizedBox(height: 12),

              const Text('من تاريخ:', style: TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              TextField(

                controller: dateFromCtrl,

                readOnly: true,

                decoration: InputDecoration(hintText: 'اختر التاريخ', prefixIcon: const Icon(Icons.calendar_today, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),

                onTap: () async {

                  final d = await showDatePicker(context: context, initialDate: _dateFrom ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());

                  if (d != null) { setSheetState(() { _dateFrom = d; dateFromCtrl.text = DateFormat('yyyy-MM-dd').format(d); }); }

                },

              ),

              const SizedBox(height: 12),

              const Text('إلى تاريخ:', style: TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 4),

              TextField(

                controller: dateToCtrl,

                readOnly: true,

                decoration: InputDecoration(hintText: 'اختر التاريخ', prefixIcon: const Icon(Icons.calendar_today, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),

                onTap: () async {

                  final d = await showDatePicker(context: context, initialDate: _dateTo ?? DateTime.now(), firstDate: DateTime(2020), lastDate: DateTime.now());

                  if (d != null) { setSheetState(() { _dateTo = d; dateToCtrl.text = DateFormat('yyyy-MM-dd').format(d); }); }

                },

              ),

              const SizedBox(height: 12),

              Row(children: [

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const Text('الحد الأدنى:', style: TextStyle(fontWeight: FontWeight.w600)),

                  const SizedBox(height: 4),

                  TextField(

                    controller: minCtrl,

                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(hintText: '0', suffixText: 'د.ل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),

                  ),

                ])),

                const SizedBox(width: 12),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const Text('الحد الأعلى:', style: TextStyle(fontWeight: FontWeight.w600)),

                  const SizedBox(height: 4),

                  TextField(

                    controller: maxCtrl,

                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(hintText: '∞', suffixText: 'د.ل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),

                  ),

                ])),

              ]),

              const SizedBox(height: 20),

              SizedBox(

                width: double.infinity,

                child: GradientButton(

                  label: 'تطبيق',

                  icon: Icons.check,

                  gradient: AppColors.gradient1,

                  isExpanded: true,

                  onPressed: () {

                    setState(() {

                      _amountMin = double.tryParse(minCtrl.text);

                      _amountMax = double.tryParse(maxCtrl.text);

                    });

                    Navigator.pop(ctx);

                  },

                ),

              ),

              const SizedBox(height: 16),

            ],

          ),

        ),

      ),

    );

  }

}



class _DashboardSummary extends StatelessWidget {

  final DataStore store;

  const _DashboardSummary({required this.store});

  @override

  Widget build(BuildContext context) {

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final thisMonth = DateFormat('yyyy-MM').format(DateTime.now());

    final todayInvoices = store.invoices.where((inv) => inv.date == today).toList();

    final todaySales = todayInvoices.fold(0.0, (s, inv) => s + inv.total);

    final todayPaid = todayInvoices.fold(0.0, (s, inv) => s + inv.totalPaid);

    final monthInvoices = store.invoices.where((inv) => inv.date.startsWith(thisMonth)).toList();

    final monthSales = monthInvoices.fold(0.0, (s, inv) => s + inv.total);

    final totalRemaining = store.invoices.fold(0.0, (s, inv) => s + inv.remaining);

    return Padding(

      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),

      child: Row(children: [

        _dashCard(context, 'اليوم', '${todaySales.toStringAsFixed(0)} د.ل', Icons.today, AppColors.gradient1),

        const SizedBox(width: 8),

        _dashCard(context, 'فواتير', '${todayInvoices.length}', Icons.receipt_long, AppColors.gradient2),

        const SizedBox(width: 8),

        _dashCard(context, 'الشهر', '${monthSales.toStringAsFixed(0)} د.ل', Icons.calendar_month, AppColors.gradient4),

        const SizedBox(width: 8),

        _dashCard(context, 'المتبقي', '${totalRemaining.toStringAsFixed(0)} د.ل', Icons.pending, [AppColors.danger, AppColors.danger.withOpacity(0.7)]),

      ]),

    );

  }

  Widget _dashCard(BuildContext ctx, String label, String value, IconData icon, List<Color> gradient) {

    return Expanded(

      child: Container(

        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),

        decoration: BoxDecoration(

          gradient: LinearGradient(colors: gradient),

          borderRadius: BorderRadius.circular(12),

        ),

        child: Column(children: [

          Icon(icon, color: Colors.white, size: 18),

          const SizedBox(height: 4),

          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),

          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 9)),

        ]),

      ),

    );

  }

}



class _InvoiceCard extends StatelessWidget {

  final Invoice invoice;

  final int index;

  final VoidCallback onTap;



  const _InvoiceCard({required this.invoice, required this.index, required this.onTap});



  @override

  Widget build(BuildContext context) {

    return Hero(

      tag: 'invoice_${invoice.id}',

      child: GlassCard(

        margin: const EdgeInsets.only(bottom: 12),

        onTap: onTap,

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Row(

              children: [

                Container(

                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                  decoration: BoxDecoration(

                    gradient: LinearGradient(colors: AppColors.gradient1),

                    borderRadius: BorderRadius.circular(10),

                  ),

                  child: Text(invoice.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),

                ),

                const Spacer(),

                StatusBadge(status: invoice.status),

              ],

            ),

            const SizedBox(height: 12),

            Row(

              children: [

                Icon(Icons.person_outline, size: 18, color: AppColors.textSecondaryOf(context)),

                const SizedBox(width: 6),

                Text(invoice.buyerName.isEmpty ? 'عميل' : invoice.buyerName, style: const TextStyle(fontWeight: FontWeight.w600)),

                const Spacer(),

                Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.textSecondaryOf(context)),

                const SizedBox(width: 4),

                Text(invoice.date, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryOf(context))),

              ],

            ),

            const SizedBox(height: 12),

            const Divider(height: 1),

            const SizedBox(height: 12),

            Row(

              children: [

                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text('الإجمالي', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryOf(context))),

                    AnimatedCounter(

                      value: invoice.total,

                      suffix: 'د.ل',

                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),

                    ),

                  ],

                ),

                const Spacer(),

                if (invoice.remaining > 0)

                  Column(

                    crossAxisAlignment: CrossAxisAlignment.end,

                    children: [

                      Text('المتبقي', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryOf(context))),

                      Text('${invoice.remaining.toStringAsFixed(2)} د.ل', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.danger)),

                    ],

                  )

                else

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: AppColors.gradient4),

                      borderRadius: BorderRadius.circular(8),

                    ),

                    child: const Row(

                      mainAxisSize: MainAxisSize.min,

                      children: [

                        Icon(Icons.check, color: Colors.white, size: 14),

                        SizedBox(width: 4),

                        Text('تم السداد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),

                      ],

                    ),

                  ),

              ],

            ),

          ],

        ),

      ),

    );

  }

}



// ==================== CREATE INVOICE ====================

class CreateInvoiceScreen extends StatefulWidget {

  final Invoice? editInvoice;

  final int? editIndex;

  const CreateInvoiceScreen({super.key, this.editInvoice, this.editIndex});

  @override

  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();

}



class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {

  final _buyerController = TextEditingController();

  final _phoneController = TextEditingController();

  final _addressController = TextEditingController();

  final _notesController = TextEditingController();

  final _discountPctController = TextEditingController(text: '0');

  final _discountAmtController = TextEditingController(text: '0');

  List<InvoiceItem> _items = [];

  String? _selectedCustomerId;

  bool _saved = false;

  String _selectedTemplate = 'classic';

  String? _dueDate;



  @override

  void initState() {

    super.initState();

    _selectedTemplate = context.read<DataStore>().defaultTemplate;

    if (widget.editInvoice != null) {

      final inv = widget.editInvoice!;

      _buyerController.text = inv.buyerName;

      _phoneController.text = inv.buyerPhone;

      _addressController.text = inv.buyerAddress;

      _notesController.text = inv.notes;

      _discountPctController.text = inv.discountPct.toString();

      _discountAmtController.text = inv.discountAmt.toString();

      _items = List.from(inv.items);

      _selectedTemplate = inv.template;

      _dueDate = inv.dueDate;

    }

  }



  @override

  void dispose() {

    _buyerController.dispose();

    _phoneController.dispose();

    _addressController.dispose();

    _notesController.dispose();

    _discountPctController.dispose();

    _discountAmtController.dispose();

    super.dispose();

  }



  double get _subtotal => _items.fold(0, (s, i) => s + i.lineTotal);

  double get _discPct => double.tryParse(_discountPctController.text) ?? 0;

  double get _discAmt => double.tryParse(_discountAmtController.text) ?? 0;

  double get _total => _subtotal - _discAmt - (_subtotal * _discPct / 100);



  void _addItem(Product p) {

    HapticFeedback.lightImpact();

    setState(() {

      final existing = _items.indexWhere((i) => i.productId == p.id);

      if (existing >= 0) {

        _items[existing] = InvoiceItem(

          productId: p.id, name: p.name, price: p.sellPrice,

          quantity: _items[existing].quantity + 1,

          discountPct: _items[existing].discountPct, discountAmt: _items[existing].discountAmt,

        );

      } else {

        _items.add(InvoiceItem(productId: p.id, name: p.name, price: p.sellPrice));

      }

    });

  }



  void _removeItem(int i) {

    HapticFeedback.lightImpact();

    setState(() => _items.removeAt(i));

  }



  void _showProductPicker() {

    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (ctx) {

        return DraggableScrollableSheet(

          initialChildSize: 0.75,

          maxChildSize: 0.95,

          minChildSize: 0.5,

          expand: false,

          builder: (ctx, scrollCtrl) {

            return Consumer<DataStore>(

              builder: (_, store, __) {

                String query = '';

                List<Product> filtered = store.products;

                return StatefulBuilder(

                  builder: (ctx, setSheetState) {

                    if (query.isNotEmpty) {

                      filtered = store.products.where((p) =>

                        p.name.toLowerCase().contains(query.toLowerCase()) ||

                        p.barcode.contains(query)

                      ).toList();

                    }

                    return Column(

                      children: [

                        Container(

                          margin: const EdgeInsets.only(top: 8),

                          width: 40,

                          height: 4,

                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),

                        ),

                        const Padding(

                          padding: EdgeInsets.all(16),

                          child: Text('اختر المنتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                        ),

                        Padding(

                          padding: const EdgeInsets.symmetric(horizontal: 16),

                          child: Row(

                            children: [

                              Expanded(

                                child: TextField(

                                  decoration: const InputDecoration(hintText: 'بحث...', prefixIcon: Icon(Icons.search)),

                                  onChanged: (v) => setSheetState(() => query = v),

                                ),

                              ),

                              const SizedBox(width: 8),

                              GradientButton(

                                label: '',

                                icon: Icons.qr_code_scanner,

                                gradient: AppColors.gradient3,

                                onPressed: () async {

                                  final result = await Navigator.push<String>(ctx, MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()));

                                  if (result != null) {

                                    final product = store.products.where((p) => p.barcode == result).toList();

                                    if (product.isNotEmpty) {

                                      _addItem(product.first);

                                      if (ctx.mounted) Navigator.pop(ctx);

                                    }

                                  }

                                },

                              ),

                            ],

                          ),

                        ),

                        const SizedBox(height: 8),

                        Expanded(

                          child: filtered.isEmpty

                              ? const Center(child: Text('لا توجد منتجات'))

                              : ListView.builder(

                                  controller: scrollCtrl,

                                  itemCount: filtered.length,

                                  itemBuilder: (_, i) {

                                    final p = filtered[i];

                                    return ListTile(

                                      leading: p.imagePath.isNotEmpty

                                          ? ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(p.imagePath), width: 48, height: 48, fit: BoxFit.cover))

                                          : CircleAvatar(backgroundColor: Theme.of(context).colorScheme.primaryContainer, child: Text(p.name[0], style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold))),

                                      title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600)),

                                      subtitle: Text('${p.sellPrice.toStringAsFixed(2)} د.ل | كم: ${p.quantity}'),

                                      trailing: const Icon(Icons.add_circle, color: AppColors.primary),

                                      onTap: () { _addItem(p); Navigator.pop(ctx); },

                                    );

                                  },

                                ),

                        ),

                      ],

                    );

                  },

                );

              },

            );

          },

        );

      },

    );

  }



  int _calculateDaysUntil(String date) {

    final target = DateTime.tryParse(date);

    if (target == null) return 0;

    return target.difference(DateTime.now()).inDays;

  }



  bool _isOverdue(String date) {

    final target = DateTime.tryParse(date);

    if (target == null) return false;

    return target.isBefore(DateTime.now());

  }



  void _saveInvoice() {

    if (_items.isEmpty) { showAppToast(context, 'أضف أصنافًا أولاً', icon: Icons.warning, color: AppColors.warning); return; }

    if (_buyerController.text.isEmpty) { showAppToast(context, 'أدخل اسم العميل', icon: Icons.warning, color: AppColors.warning); return; }



    final store = context.read<DataStore>();

    final inv = Invoice(

      id: widget.editInvoice?.id ?? 'INV-${(store.invoiceCounter + 1).toString().padLeft(4, '0')}',

      buyerName: _buyerController.text,

      buyerPhone: _phoneController.text,

      buyerAddress: _addressController.text,

      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),

      items: _items,

      discountPct: _discPct,

      discountAmt: _discAmt,

      notes: _notesController.text,

      template: _selectedTemplate,

      dueDate: _dueDate,

    );



    if (widget.editIndex != null) {

      store.updateInvoice(widget.editIndex!, inv);

    } else {

      store.addInvoice(inv);

    }



    HapticFeedback.heavyImpact();

    setState(() => _saved = true);

    showAppToast(context, 'تم حفظ الفاتورة ${inv.id}');

  }



  void _shareBottomSheet(Invoice inv) {

    showModalBottomSheet(

      context: context,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (_) => SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              const Text('مشاركة الفاتورة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              _shareOption(Icons.chat, AppColors.whatsapp, 'واتساب', () { Navigator.pop(context); shareWhatsApp(_phoneController.text, inv); }),

              _shareOption(Icons.send, Colors.blue, 'تيليجرام', () { Navigator.pop(context); shareTelegram(inv); }),

              _shareOption(Icons.content_copy, Colors.grey, 'نسخ النص', () {

                Navigator.pop(context);

                SharePlus.instance.share(ShareParams(text: 'فاتورة: ${inv.id} | العميل: ${inv.buyerName} | الإجمالي: ${inv.total.toStringAsFixed(2)} د.ل'));

              }),

              _shareOption(Icons.picture_as_pdf, Colors.red, 'PDF', () { Navigator.pop(context); printInvoice(inv); }),

            ],

          ),

        ),

      ),

    );

  }



  Widget _shareOption(IconData icon, Color color, String label, VoidCallback onTap) {

    return ListTile(

      leading: Container(

        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),

        child: Icon(icon, color: color),

      ),

      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),

      trailing: const Icon(Icons.chevron_left),

      onTap: onTap,

    );

  }



  Invoice _buildInvoice() {

    final store = context.read<DataStore>();

    return Invoice(

      id: widget.editInvoice?.id ?? 'INV-${(store.invoiceCounter + 1).toString().padLeft(4, '0')}',

      buyerName: _buyerController.text, buyerPhone: _phoneController.text, buyerAddress: _addressController.text,

      date: widget.editInvoice?.date ?? DateFormat('yyyy-MM-dd').format(DateTime.now()), items: _items,

      discountPct: _discPct, discountAmt: _discAmt, notes: _notesController.text,

      template: _selectedTemplate, dueDate: _dueDate,

    );

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(

        title: Text(widget.editInvoice != null ? 'تعديل الفاتورة' : 'فاتورة جديدة', style: const TextStyle(fontWeight: FontWeight.bold)),

        actions: [

          if (_saved || widget.editInvoice != null)

            IconButton(icon: const Icon(Icons.share), onPressed: () => _shareBottomSheet(widget.editInvoice ?? _buildInvoice())),

        ],

      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          GlassCard(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(children: [const Icon(Icons.person, color: AppColors.primary, size: 20), const SizedBox(width: 8), const Text('بيانات العميل', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                const SizedBox(height: 16),

                Consumer<DataStore>(

                  builder: (_, store, __) {

                    return DropdownButtonFormField<String>(

                      initialValue: _selectedCustomerId,

                      decoration: const InputDecoration(labelText: 'اختر عميل', border: OutlineInputBorder()),

                      items: store.customers.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),

                      onChanged: (v) {

                        setState(() => _selectedCustomerId = v);

                        if (v != null) {

                          final c = store.customers.firstWhere((c) => c.id == v);

                          _buyerController.text = c.name;

                          _phoneController.text = c.phone;

                          _addressController.text = c.address;

                        }

                      },

                    );

                  },

                ),

                const SizedBox(height: 12),

                TextField(controller: _buyerController, decoration: const InputDecoration(labelText: 'اسم العميل *', border: OutlineInputBorder())),

                const SizedBox(height: 12),

                TextField(controller: _phoneController, decoration: const InputDecoration(labelText: 'الهاتف', border: OutlineInputBorder()), keyboardType: TextInputType.phone),

                const SizedBox(height: 12),

                TextField(controller: _addressController, decoration: const InputDecoration(labelText: 'العنوان', border: OutlineInputBorder())),

              ],

            ),

          ),

          GlassCard(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(

                  children: [

                    const Icon(Icons.shopping_cart, color: AppColors.primary, size: 20),

                    const SizedBox(width: 8),

                    Text('الأصناف (${_items.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    const Spacer(),

                    GradientButton(label: 'إضافة', icon: Icons.add, gradient: AppColors.gradient1, onPressed: _showProductPicker),

                  ],

                ),

                const SizedBox(height: 12),

                if (_items.isEmpty)

                  Container(

                    padding: const EdgeInsets.all(32),

                    decoration: BoxDecoration(

                      color: AppColors.primary.withOpacity(0.05),

                      borderRadius: BorderRadius.circular(16),

                    ),

                    child: Center(child: Column(

                      children: [

                        Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.primary.withOpacity(0.3)),

                        const SizedBox(height: 8),

                        Text('اضغط "إضافة" لاختيار منتج', style: TextStyle(color: AppColors.textSecondaryOf(context))),

                      ],

                    )),

                  )

                else

                  ...List.generate(_items.length, (i) {

                    final item = _items[i];

                    return AnimatedSize(

                      duration: const Duration(milliseconds: 200),

                      child: Container(

                        margin: const EdgeInsets.only(bottom: 8),

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(

                          color: AppColors.primary.withOpacity(0.05),

                          borderRadius: BorderRadius.circular(12),

                        ),

                        child: Row(

                          children: [

                            Expanded(

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),

                                  Text('${item.price.toStringAsFixed(2)} د.ل x ${item.quantity}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                                ],

                              ),

                            ),

                            IconButton(

                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.danger),

                              onPressed: () {

                                if (item.quantity > 1) {

                                  setState(() => _items[i] = InvoiceItem(

                                    productId: item.productId, name: item.name, price: item.price,

                                    quantity: item.quantity - 1, discountPct: item.discountPct, discountAmt: item.discountAmt,

                                  ));

                                } else {

                                  _removeItem(i);

                                }

                              },

                            ),

                            AnimatedSwitcher(

                              duration: const Duration(milliseconds: 150),

                              child: Text('${item.quantity}', key: ValueKey(item.quantity), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),

                            ),

                            IconButton(

                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),

                              onPressed: () {

                                setState(() => _items[i] = InvoiceItem(

                                  productId: item.productId, name: item.name, price: item.price,

                                  quantity: item.quantity + 1, discountPct: item.discountPct, discountAmt: item.discountAmt,

                                ));

                              },

                            ),

                          ],

                        ),

                      ),

                    );

                  }),

              ],

            ),

          ),

          GlassCard(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(children: [const Icon(Icons.calculate, color: AppColors.primary, size: 20), const SizedBox(width: 8), const Text('الخصم والمجموع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                const SizedBox(height: 12),

                Row(

                  children: [

                    Expanded(child: TextField(controller: _discountPctController, decoration: const InputDecoration(labelText: 'خصم %', border: OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (_) => setState(() {}))),

                    const SizedBox(width: 12),

                    Expanded(child: TextField(controller: _discountAmtController, decoration: const InputDecoration(labelText: 'خصم مبلغ', border: OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (_) => setState(() {}))),

                  ],

                ),

                const SizedBox(height: 16),

                Container(

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(

                    gradient: LinearGradient(colors: AppColors.gradient1.map((c) => c.withOpacity(0.1)).toList()),

                    borderRadius: BorderRadius.circular(16),

                  ),

                  child: Column(

                    children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        const Text('الإجمالي الفرعي'),

                        Text('${_subtotal.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold)),

                      ]),

                      const SizedBox(height: 8),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        const Text('الخصم'),

                        Text('${(_discAmt + _subtotal * _discPct / 100).toStringAsFixed(2)} د.ل', style: const TextStyle(color: AppColors.danger)),

                      ]),

                      const Divider(),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        const Text('المجموع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                        AnimatedSwitcher(

                          duration: const Duration(milliseconds: 200),

                          child: Text('${_total.toStringAsFixed(2)} د.ل', key: ValueKey(_total.toStringAsFixed(2)), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary)),

                        ),

                      ]),

                    ],

                  ),

                ),

              ],

            ),

          ),

          // Template Selector

          GlassCard(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(children: [const Icon(Icons.palette, color: AppColors.primary, size: 20), const SizedBox(width: 8), const Text('اختر النموذج', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))]),

                const SizedBox(height: 8),

                SizedBox(

                  height: 36,

                  child: ListView(

                    scrollDirection: Axis.horizontal,

                    children: invoiceTemplates.map((t) {

                      final selected = _selectedTemplate == t.id;

                      return Padding(

                        padding: const EdgeInsets.only(right: 6),

                        child: ChoiceChip(

                          label: Text(t.name, style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.primary)),

                          selected: selected,

                          selectedColor: AppColors.primary,

                          backgroundColor: AppColors.primary.withOpacity(0.08),

                          onSelected: (_) => setState(() => _selectedTemplate = t.id),

                        ),

                      );

                    }).toList(),

                  ),

                ),

              ],

            ),

          ),

              const SizedBox(height: 12),

              GlassCard(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(children: [const Icon(Icons.calendar_today, color: AppColors.primary, size: 20), const SizedBox(width: 8), const Text('تاريخ الاستحقاق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                    const SizedBox(height: 12),

                    GestureDetector(

                      onTap: () async {

                        final picked = await showDatePicker(

                          context: context,

                          initialDate: _dueDate != null ? DateTime.tryParse(_dueDate!) : DateTime.now().add(const Duration(days: 30)),

                          firstDate: DateTime.now(),

                          lastDate: DateTime.now().add(const Duration(days: 365)),

                          locale: const Locale('ar'),

                        );

                        if (picked != null) {

                          setState(() => _dueDate = DateFormat('yyyy-MM-dd').format(picked));

                        }

                      },

                      child: Container(

                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

                        decoration: BoxDecoration(

                          border: Border.all(color: Colors.grey.shade400),

                          borderRadius: BorderRadius.circular(8),

                        ),

                        child: Row(

                          children: [

                            const Icon(Icons.event, color: AppColors.primary, size: 20),

                            const SizedBox(width: 12),

                            Text(

                              _dueDate != null ? _dueDate! : 'اضغط لاختيار تاريخ الاستحقاق',

                              style: TextStyle(

                                fontSize: 14,

                                color: _dueDate != null ? AppColors.textPrimaryOf(context) : Colors.grey[500],

                              ),

                            ),

                            const Spacer(),

                            if (_dueDate != null)

                              GestureDetector(

                                onTap: () => setState(() => _dueDate = null),

                                child: const Icon(Icons.close, color: AppColors.danger, size: 18),

                              ),

                          ],

                        ),

                      ),

                    ),

                    if (_dueDate != null) ...[

                      const SizedBox(height: 8),

                      Text(

                        '⏰ ${_calculateDaysUntil(_dueDate!)} يوم متبقي للاستحقاق',

                        style: TextStyle(

                          fontSize: 12,

                          color: _isOverdue(_dueDate!) ? AppColors.danger : AppColors.success,

                          fontWeight: FontWeight.bold,

                        ),

                      ),

                    ],

                  ],

                ),

              ),

              const SizedBox(height: 12),

              GlassCard(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(children: [const Icon(Icons.notes, color: AppColors.primary, size: 20), const SizedBox(width: 8), const Text('ملاحظات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                    const SizedBox(height: 12),

                    TextField(controller: _notesController, decoration: const InputDecoration(labelText: 'ملاحظات', border: OutlineInputBorder()), maxLines: 2),

                  ],

                ),

              ),

              const SizedBox(height: 20),

          Row(

            children: [

              Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_forward), label: const Text('رجوع'))),

              const SizedBox(width: 12),

              Expanded(flex: 2, child: GradientButton(label: 'حفظ الفاتورة', icon: Icons.save, gradient: AppColors.gradient1, onPressed: _saveInvoice, isExpanded: true)),

            ],

          ),

          if (_saved) ...[

            const SizedBox(height: 12),

            Row(

              children: [

                Expanded(child: GradientButton(label: 'مشاركة', icon: Icons.share, gradient: [AppColors.whatsapp, const Color(0xFF128C7E)], onPressed: () => _shareBottomSheet(_buildInvoice()), isExpanded: true)),

                const SizedBox(width: 12),

                Expanded(child: GradientButton(label: 'PDF', icon: Icons.picture_as_pdf, gradient: AppColors.gradient2, onPressed: () => printInvoice(_buildInvoice()), isExpanded: true)),

              ],

            ),

          ],

          const SizedBox(height: 30),

        ],

      ),

    );

  }

}



// ==================== INVOICE DETAIL ====================

class InvoiceDetailScreen extends StatelessWidget {

  final Invoice invoice;

  final int index;

  const InvoiceDetailScreen({super.key, required this.invoice, required this.index});



  void _showPayDialog(BuildContext ctx) {

    final amtCtrl = TextEditingController();

    final refCtrl = TextEditingController();

    final notesCtrl = TextEditingController();

    PaymentMethod selectedMethod = PaymentMethod.cash;



    showModalBottomSheet(

      context: ctx,

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (_) => StatefulBuilder(

        builder: (_, setSheetState) => Padding(

          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Row(children: [

                  const Icon(Icons.payment, color: AppColors.primary, size: 24),

                  const SizedBox(width: 8),

                  const Text('إضافة دفعة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const Spacer(),

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(color: AppColors.danger.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),

                    child: Text('المتبقي: ${invoice.remaining.toStringAsFixed(2)} د.ل', style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.bold)),

                  ),

                ]),

                const SizedBox(height: 16),

                const Text('المبلغ', style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                TextField(

                  controller: amtCtrl, keyboardType: TextInputType.number, autofocus: true,

                  decoration: InputDecoration(border: const OutlineInputBorder(), suffixText: 'د.ل', hintText: 'أدخل المبلغ'),

                ),

                const SizedBox(height: 12),

                const Text('دفع سريع', style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                Row(

                  children: [

                    _quickPayBtn('الكل', invoice.remaining, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn('النصف', invoice.remaining / 2, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn('الربع', invoice.remaining / 4, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn('الثلث', invoice.remaining / 3, amtCtrl, setSheetState),

                  ],

                ),

                const SizedBox(height: 16),

                const Text('طريقة الدفع', style: TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                Wrap(

                  spacing: 8,

                  runSpacing: 8,

                  children: PaymentMethod.values.map((m) {

                    final isSelected = selectedMethod == m;

                    return GestureDetector(

                      onTap: () => setSheetState(() => selectedMethod = m),

                      child: AnimatedContainer(

                        duration: const Duration(milliseconds: 200),

                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),

                        decoration: BoxDecoration(

                          gradient: isSelected ? LinearGradient(colors: AppColors.gradient1) : null,

                          color: isSelected ? null : Colors.grey.shade100,

                          borderRadius: BorderRadius.circular(12),

                          border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),

                        ),

                        child: Row(

                          mainAxisSize: MainAxisSize.min,

                          children: [

                            Text(paymentMethodIcon(m), style: const TextStyle(fontSize: 16)),

                            const SizedBox(width: 6),

                            Text(paymentMethodName(m), style: TextStyle(

                              fontSize: 12, fontWeight: FontWeight.bold,

                              color: isSelected ? Colors.white : AppColors.textPrimaryOf(ctx),

                            )),

                          ],

                        ),

                      ),

                    );

                  }).toList(),

                ),

                if (selectedMethod == PaymentMethod.bankTransfer || selectedMethod == PaymentMethod.mobileMoney) ...[

                  const SizedBox(height: 12),

                  TextField(controller: refCtrl, decoration: const InputDecoration(labelText: 'رقم المرجع/المعاملة', border: OutlineInputBorder())),

                ],

                const SizedBox(height: 12),

                TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'ملاحظات (اختياري)', border: OutlineInputBorder()), maxLines: 2),

                const SizedBox(height: 16),

                GradientButton(

                  label: 'حفظ الدفعة',

                  icon: Icons.check,

                  gradient: AppColors.gradient4,

                  onPressed: () {

                    final amt = double.tryParse(amtCtrl.text) ?? 0;

                    if (amt > 0) {

                      final store = ctx.read<DataStore>();

                      final paymentCount = invoice.payments.length + 1;

                      invoice.payments.add(Payment(

                        amount: amt,

                        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),

                        method: selectedMethod,

                        receiptNumber: 'RCP-${invoice.id}-$paymentCount',

                        referenceNumber: refCtrl.text.isNotEmpty ? refCtrl.text : null,

                        notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,

                        customerId: invoice.buyerName,

                        invoiceId: invoice.id,

                      ));

                      store.updateInvoice(index, invoice);

                      Navigator.pop(ctx);

                      HapticFeedback.heavyImpact();

                      showAppToast(ctx, 'تم تسجيل دفعة ${amt.toStringAsFixed(2)} د.ل');

                    }

                  },

                  isExpanded: true,

                ),

                const SizedBox(height: 20),

              ],

            ),

          ),

        ),

      ),

    );

  }



  Widget _quickPayBtn(String label, double amount, TextEditingController ctrl, StateSetter setState) {

    return Expanded(

      child: GestureDetector(

        onTap: () {

          ctrl.text = amount.toStringAsFixed(2);

          setState(() {});

        },

        child: Container(

          padding: const EdgeInsets.symmetric(vertical: 10),

          decoration: BoxDecoration(

            gradient: LinearGradient(colors: [AppColors.primary.withOpacity(0.1), AppColors.primary.withOpacity(0.05)]),

            borderRadius: BorderRadius.circular(10),

            border: Border.all(color: AppColors.primary.withOpacity(0.3)),

          ),

          child: Column(

            children: [

              Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),

              const SizedBox(height: 2),

              Text('${amount.toStringAsFixed(0)} د.ل', style: TextStyle(fontSize: 10, color: Colors.grey[600])),

            ],

          ),

        ),

      ),

    );

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(

        title: Text('فاتورة ${invoice.id}', style: const TextStyle(fontWeight: FontWeight.bold)),

        actions: [

          IconButton(icon: const Icon(Icons.share), onPressed: () => shareWhatsApp(invoice.buyerPhone, invoice)),

          IconButton(icon: const Icon(Icons.print), onPressed: () => printInvoice(invoice)),

        ],

      ),

      body: ListView(

        padding: const EdgeInsets.all(16),

        children: [

          Hero(

            tag: 'invoice_${invoice.id}',

            child: GradientHeader(

              title: invoice.id,

              subtitle: invoice.date,

              gradient: AppColors.gradient1,

              child: StatusBadge(status: invoice.status),

            ),

          ),

          const SizedBox(height: 16),

          GlassCard(

            child: ListTile(

              leading: CircleAvatar(backgroundColor: AppColors.primary.withOpacity(0.1), child: const Icon(Icons.person, color: AppColors.primary)),

              title: Text(invoice.buyerName.isEmpty ? 'عميل' : invoice.buyerName, style: const TextStyle(fontWeight: FontWeight.bold)),

              subtitle: Text([invoice.buyerPhone, invoice.buyerAddress].where((s) => s.isNotEmpty).join(' | ')),

            ),

          ),

          if (invoice.dueDate != null)

            GlassCard(

              child: Container(

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(

                  color: (invoice.isOverdue ? AppColors.danger : AppColors.success).withOpacity(0.05),

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: (invoice.isOverdue ? AppColors.danger : AppColors.success).withOpacity(0.3)),

                ),

                child: Row(

                  children: [

                    Icon(Icons.calendar_today, color: invoice.isOverdue ? AppColors.danger : AppColors.success, size: 20),

                    const SizedBox(width: 12),

                    Expanded(

                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Text('تاريخ الاستحقاق: ${invoice.dueDate}', style: const TextStyle(fontWeight: FontWeight.bold)),

                          const SizedBox(height: 4),

                          Text(

                            invoice.isOverdue

                                ? '⚠️ متأخر ${-invoice.daysUntilDue} يوم'

                                : invoice.status == 'paid'

                                    ? '✅ تم السداد'

                                    : '⏰ متبقي ${invoice.daysUntilDue} يوم',

                            style: TextStyle(

                              fontSize: 12,

                              color: invoice.isOverdue ? AppColors.danger : AppColors.success,

                              fontWeight: FontWeight.bold,

                            ),

                          ),

                        ],

                      ),

                    ),

                  ],

                ),

              ),

            ),

          GlassCard(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const Text('الأصناف', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                const SizedBox(height: 12),

                ...invoice.items.map((item) => Padding(

                  padding: const EdgeInsets.symmetric(vertical: 6),

                  child: Row(

                    children: [

                      Container(width: 8, height: 8, decoration: const BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient1), shape: BoxShape.circle)),

                      const SizedBox(width: 12),

                      Expanded(child: Text(item.name)),

                      Text('${item.quantity} x ${item.price.toStringAsFixed(2)}', style: TextStyle(color: AppColors.textSecondaryOf(context))),

                      const SizedBox(width: 16),

                      Text('${item.lineTotal.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold)),

                    ],

                  ),

                )),

              ],

            ),

          ),

          GlassCard(

            child: Column(

              children: [

                _totalRow('الإجمالي', '${invoice.total.toStringAsFixed(2)} د.ل', AppColors.primary),

                if (invoice.totalPaid > 0) ...[

                  const Divider(), _totalRow('المدفوع', '${invoice.totalPaid.toStringAsFixed(2)} د.ل', AppColors.success),

                ],

                if (invoice.remaining > 0) ...[

                  const Divider(), _totalRow('المتبقي', '${invoice.remaining.toStringAsFixed(2)} د.ل', AppColors.danger),

                ],

              ],

            ),

          ),

          if (invoice.payments.isNotEmpty)

            GlassCard(

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Row(children: [

                    const Icon(Icons.history, color: AppColors.primary, size: 20),

                    const SizedBox(width: 8),

                    const Text('سجل الدفعات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    const Spacer(),

                    Text('${invoice.payments.length} دفعة', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                  ]),

                  const SizedBox(height: 12),

                  ...invoice.payments.asMap().entries.map((entry) {

                    final idx = entry.key;

                    final p = entry.value;

                    return Container(

                      margin: const EdgeInsets.only(bottom: 8),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(

                        color: AppColors.success.withOpacity(0.05),

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: AppColors.success.withOpacity(0.2)),

                      ),

                      child: Row(

                        children: [

                          Container(

                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),

                            child: Text(paymentMethodIcon(p.method), style: const TextStyle(fontSize: 18)),

                          ),

                          const SizedBox(width: 12),

                          Expanded(

                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [

                                Row(children: [

                                  Text('${p.amount.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

                                  const SizedBox(width: 8),

                                  Container(

                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

                                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),

                                    child: Text(paymentMethodName(p.method), style: TextStyle(fontSize: 10, color: AppColors.primary)),

                                  ),

                                ]),

                                const SizedBox(height: 4),

                                Text('${p.date}${p.referenceNumber != null ? ' | #' + p.referenceNumber! : ''}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),

                              ],

                            ),

                          ),

                          IconButton(

                            icon: const Icon(Icons.receipt, size: 20),

                            color: AppColors.primary,

                            onPressed: () => printPaymentReceipt(invoice, p),

                            tooltip: 'إيصال الدفع',

                          ),

                        ],

                      ),

                    );

                  }),

                ],

              ),

            ),

          const SizedBox(height: 20),

          if (invoice.remaining > 0)

            GradientButton(

              label: 'إضافة دفعة',

              icon: Icons.payment,

              gradient: AppColors.gradient4,

              onPressed: () => _showPayDialog(context),

              isExpanded: true,

            ),

          const SizedBox(height: 30),

        ],

      ),

    );

  }



  Widget _totalRow(String label, String value, Color color) {

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

      Text(label),

      Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16)),

    ]);

  }

}



// ==================== CUSTOMER STATEMENT ====================

class CustomerStatementScreen extends StatelessWidget {

  final String customerName;

  const CustomerStatementScreen({super.key, required this.customerName});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(

        title: Text('كشف حساب: $customerName', style: const TextStyle(fontWeight: FontWeight.bold)),

        actions: [

          IconButton(

            icon: const Icon(Icons.print),

            onPressed: () => _printStatement(context),

          ),

          IconButton(

            icon: const Icon(Icons.share),

            onPressed: () => _shareStatement(context),

          ),

        ],

      ),

      body: Consumer<DataStore>(

        builder: (_, store, __) {

          final customerInvoices = store.invoices.where((i) => i.buyerName == customerName).toList();

          final totalPurchased = customerInvoices.fold(0.0, (s, i) => s + i.total);

          final totalPaid = customerInvoices.fold(0.0, (s, i) => s + i.totalPaid);

          final totalRemaining = totalPurchased - totalPaid;

          final advanceBalance = store.getCustomerAdvanceBalance(customerName);



          return ListView(

            padding: const EdgeInsets.all(16),

            children: [

              // Summary Cards

              Row(

                children: [

                  Expanded(child: _summaryCard('المشتريات', totalPurchased, AppColors.gradient1, Icons.shopping_cart)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard('المدفوعات', totalPaid, AppColors.gradient4, Icons.payment)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard('المتبقي', totalRemaining, totalRemaining > 0 ? [AppColors.danger, AppColors.danger.withOpacity(0.7)] : AppColors.gradient4, Icons.account_balance_wallet)),

                  if (advanceBalance > 0) ...[

                    const SizedBox(width: 8),

                    Expanded(child: _summaryCard('الرصيد', advanceBalance, [AppColors.success, AppColors.success.withOpacity(0.7)], Icons.savings)),

                  ],

                ],

              ),

              const SizedBox(height: 16),

              // Customer Info

              GlassCard(

                child: Row(

                  children: [

                    CircleAvatar(

                      radius: 30,

                      backgroundColor: AppColors.primary.withOpacity(0.1),

                      child: Text(customerName.substring(0, 1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),

                    ),

                    const SizedBox(width: 16),

                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                        const SizedBox(height: 4),

                        Text('${customerInvoices.length} فاتورة', style: TextStyle(color: Colors.grey[600])),

                        if (totalRemaining > 0)

                          Text('المتبقي: ${totalRemaining.toStringAsFixed(2)} د.ل', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),

                      ],

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 16),

              // Transactions Timeline

              const Text('سجل المعاملات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              if (customerInvoices.isEmpty)

                GlassCard(

                  child: Column(

                    children: [

                      Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),

                      const SizedBox(height: 12),

                      Text('لا توجد فواتير لهذا العميل', style: TextStyle(color: Colors.grey[600])),

                    ],

                  ),

                )

              else

                ...customerInvoices.expand((inv) => [

                  _transactionCard(inv),

                  ...inv.payments.map((p) => _paymentCard(p, inv.id)),

                ]),

              const SizedBox(height: 20),

            ],

          );

        },

      ),

    );

  }



  Widget _summaryCard(String label, double amount, List<Color> gradient, IconData icon) {

    return Container(

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(

        gradient: LinearGradient(colors: gradient),

        borderRadius: BorderRadius.circular(16),

        boxShadow: [BoxShadow(color: gradient.first.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],

      ),

      child: Column(

        children: [

          Icon(icon, color: Colors.white, size: 24),

          const SizedBox(height: 8),

          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),

          const SizedBox(height: 4),

          Text('${amount.toStringAsFixed(0)} د.ل', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),

        ],

      ),

    );

  }



  Widget _transactionCard(Invoice inv) {

    return GlassCard(

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(

              gradient: LinearGradient(colors: inv.status == 'paid' ? AppColors.gradient4 : [AppColors.danger, AppColors.danger.withOpacity(0.7)]),

              borderRadius: BorderRadius.circular(12),

            ),

            child: Icon(inv.status == 'paid' ? Icons.check_circle : Icons.receipt_long, color: Colors.white, size: 20),

          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text('فاتورة ${inv.id}', style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Text(inv.date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),

              ],

            ),

          ),

          Column(

            crossAxisAlignment: CrossAxisAlignment.end,

            children: [

              Text('${inv.total.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

              const SizedBox(height: 4),

              StatusBadge(status: inv.status),

            ],

          ),

        ],

      ),

    );

  }



  Widget _paymentCard(Payment payment, String invoiceId) {

    return GlassCard(

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(

              gradient: LinearGradient(colors: AppColors.gradient4),

              borderRadius: BorderRadius.circular(12),

            ),

            child: const Icon(Icons.payment, color: Colors.white, size: 20),

          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text('دفعة - $invoiceId', style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Text('${payment.date} | ${paymentMethodIcon(payment.method)} ${paymentMethodName(payment.method)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

              ],

            ),

          ),

          Text('-${payment.amount.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.success)),

        ],

      ),

    );

  }



  void _printStatement(BuildContext context) {

    final store = context.read<DataStore>();

    final customerInvoices = store.invoices.where((i) => i.buyerName == customerName).toList();

    final totalPurchased = customerInvoices.fold(0.0, (s, i) => s + i.total);

    final totalPaid = customerInvoices.fold(0.0, (s, i) => s + i.totalPaid);



    final pdf = pw.Document();

    pdf.addPage(pw.MultiPage(

      pageFormat: PdfPageFormat.a4,

      build: (_) => [

        pw.Header(level: 0, child: pdfText('كشف حساب العميل', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold))),

        pw.SizedBox(height: 8),

        pdfText('العميل: $customerName'),

        pdfText('التاريخ: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'),

        pw.Divider(),

        pw.SizedBox(height: 8),

        pw.TableHelper.fromTextArray(

          headers: ['الفاتورة', 'التاريخ', 'المبلغ', 'المدفوع', 'المتبقي'],

          data: customerInvoices.map((inv) => [inv.id, inv.date, '${inv.total.toStringAsFixed(2)} د.ل', '${inv.totalPaid.toStringAsFixed(2)} د.ل', '${inv.remaining.toStringAsFixed(2)} د.ل']).toList(),

          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),

        ),

        pw.Divider(),

        pw.SizedBox(height: 8),

        pdfText('إجمالي المشتريات: ${totalPurchased.toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        pdfText('إجمالي المدفوعات: ${totalPaid.toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        pdfText('المتبقي: ${(totalPurchased - totalPaid).toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red)),

      ],

    ));

    Printing.layoutPdf(onLayout: (format) => pdf.save());

  }



  void _shareStatement(BuildContext context) {

    final store = context.read<DataStore>();

    final customerInvoices = store.invoices.where((i) => i.buyerName == customerName).toList();

    final totalPurchased = customerInvoices.fold(0.0, (s, i) => s + i.total);

    final totalPaid = customerInvoices.fold(0.0, (s, i) => s + i.totalPaid);



    var text = '📋 كشف حساب: $customerName\n━━━━━━━━━━━━━━━━━━━━\n';

    for (final inv in customerInvoices) {

      text += '${inv.id} | ${inv.date} | ${inv.total.toStringAsFixed(2)} د.ل | ${inv.status == 'paid' ? '✅ مدفوع' : '⏳ ${inv.remaining.toStringAsFixed(2)} متبقي'}\n';

      for (final p in inv.payments) {

        text += '  💰 ${p.date} | -${p.amount.toStringAsFixed(2)} د.ل | ${paymentMethodName(p.method)}\n';

      }

    }

    text += '━━━━━━━━━━━━━━━━━━━━\n';

    text += 'المشتريات: ${totalPurchased.toStringAsFixed(2)} د.ل\n';

    text += 'المدفوعات: ${totalPaid.toStringAsFixed(2)} د.ل\n';

    text += 'المتبقي: ${(totalPurchased - totalPaid).toStringAsFixed(2)} د.ل';



    SharePlus.instance.share(ShareParams(text: text, subject: 'كشف حساب $customerName'));

  }

}



// ==================== PRODUCTS ====================

class ProductsScreen extends StatefulWidget {

  const ProductsScreen({super.key});

  @override State<ProductsScreen> createState() => _ProductsScreenState();

}

class _ProductsScreenState extends State<ProductsScreen> {

  final _searchCtrl = TextEditingController();

  String _search = '';

  String _sortBy = 'name';

  String _filterType = 'all'; // all, inStock, outOfStock

  

  @override

  void dispose() { _searchCtrl.dispose(); super.dispose(); }

  List<Product> _filtered(DataStore store) {

    var list = List<Product>.from(store.products);

    if (_search.isNotEmpty) {

      final q = _search.toLowerCase();

      list = list.where((p) =>

        p.name.toLowerCase().contains(q) ||

        p.barcode.toLowerCase().contains(q) ||

        p.category.toLowerCase().contains(q)

      ).toList();

    }

    if (_filterType == 'inStock') list = list.where((p) => p.quantity > 0).toList();

    if (_filterType == 'outOfStock') list = list.where((p) => p.quantity == 0).toList();

    switch (_sortBy) {

      case 'name': list.sort((a, b) => a.name.compareTo(b.name)); break;

      case 'price_asc': list.sort((a, b) => a.sellPrice.compareTo(b.sellPrice)); break;

      case 'price_desc': list.sort((a, b) => b.sellPrice.compareTo(a.sellPrice)); break;

      case 'qty_asc': list.sort((a, b) => a.quantity.compareTo(b.quantity)); break;

      case 'qty_desc': list.sort((a, b) => b.quantity.compareTo(a.quantity)); break;

    }

    return list;

  }

  void _showAddDialog(BuildContext ctx) {

    final nameCtrl = TextEditingController();

    final barcodeCtrl = TextEditingController();

    final buyPriceCtrl = TextEditingController();

    final sellPriceCtrl = TextEditingController();

    final qtyCtrl = TextEditingController(text: '0');

    final categoryCtrl = TextEditingController();

    String? imagePath;

    final picker = ImagePicker();



    showModalBottomSheet(

      context: ctx,

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (_) => StatefulBuilder(

        builder: (ctx, setSheetState) => Padding(

          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),

          child: SingleChildScrollView(

            child: Column(

              mainAxisSize: MainAxisSize.min,

              children: [

                const Text('إضافة منتج', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 16),

                GestureDetector(

                  onTap: () async {

                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) setSheetState(() => imagePath = image.path);

                  },

                  child: Container(

                    width: 100, height: 100,

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: AppColors.gradient3.map((c) => c.withOpacity(0.2)).toList()),

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),

                    ),

                    child: imagePath != null

                        ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(File(imagePath!), fit: BoxFit.cover))

                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            Icon(Icons.camera_alt, color: AppColors.primary, size: 32),

                            const SizedBox(height: 4),

                            Text('صورة', style: TextStyle(fontSize: 12, color: AppColors.primary)),

                          ]),

                  ),

                ),

                const SizedBox(height: 16),

                TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم المنتج *', border: OutlineInputBorder())),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: TextField(controller: barcodeCtrl, decoration: const InputDecoration(labelText: 'الباركود', border: OutlineInputBorder()))),

                  const SizedBox(width: 8),

                  GradientButton(label: '', icon: Icons.qr_code_scanner, gradient: AppColors.gradient3, onPressed: () async {

                    final result = await Navigator.push<String>(ctx, MaterialPageRoute(builder: (_) => const BarcodeScannerScreen()));

                    if (result != null) setSheetState(() => barcodeCtrl.text = result);

                  }),

                ]),

                const SizedBox(height: 12),

                TextField(controller: categoryCtrl, decoration: const InputDecoration(labelText: 'التصنيف', border: OutlineInputBorder())),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: TextField(controller: buyPriceCtrl, decoration: const InputDecoration(labelText: 'شراء', border: OutlineInputBorder()), keyboardType: TextInputType.number)),

                  const SizedBox(width: 12),

                  Expanded(child: TextField(controller: sellPriceCtrl, decoration: const InputDecoration(labelText: 'بيع *', border: OutlineInputBorder()), keyboardType: TextInputType.number)),

                ]),

                const SizedBox(height: 12),

                TextField(controller: qtyCtrl, decoration: const InputDecoration(labelText: 'الكمية', border: OutlineInputBorder()), keyboardType: TextInputType.number),

                const SizedBox(height: 16),

                GradientButton(

                  label: 'حفظ المنتج', icon: Icons.save, gradient: AppColors.gradient4, isExpanded: true,

                  onPressed: () {

                    if (nameCtrl.text.isEmpty) return;

                    ctx.read<DataStore>().addProduct(Product(

                      id: const Uuid().v4(), name: nameCtrl.text, barcode: barcodeCtrl.text,

                      category: categoryCtrl.text, buyPrice: double.tryParse(buyPriceCtrl.text) ?? 0,

                      sellPrice: double.tryParse(sellPriceCtrl.text) ?? 0, quantity: int.tryParse(qtyCtrl.text) ?? 0,

                      imagePath: imagePath ?? '',

                    ));

                    Navigator.pop(ctx);

                    showAppToast(ctx, 'تم إضافة المنتج');

                  },

                ),

                const SizedBox(height: 20),

              ],

            ),

          ),

        ),

      ),

    );

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(

        title: const Text('المنتجات', style: TextStyle(fontWeight: FontWeight.bold)),

        actions: [

          IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary), onPressed: () => _showAddDialog(context)),

        ],

      ),

      body: Consumer<DataStore>(

        builder: (_, store, __) {

          if (store.products.isEmpty) {

            return EmptyState(

              icon: Icons.inventory_2,

              title: 'لا توجد منتجات',

              subtitle: 'أضف منتجاتك لتبدأ',

              actionLabel: 'إضافة منتج',

              onAction: () => _showAddDialog(context),

            );

          }

          final filtered = _filtered(store);

          return Column(children: [

            Padding(

              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),

              child: GlassCard(

                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                child: TextField(

                  controller: _searchCtrl,

                  decoration: InputDecoration(

                    hintText: 'بحث بالاسم أو التصنيف أو الباركود...',

                    prefixIcon: const Icon(Icons.search, color: AppColors.primary),

                    suffixIcon: _search.isNotEmpty

                        ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); })

                        : null,

                    border: InputBorder.none, filled: false,

                  ),

                  onChanged: (v) => setState(() => _search = v),

                ),

              ),

            ),

            SizedBox(

              height: 36,

              child: ListView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), children: [

                _filterChip('الكل', 'all'), _filterChip('متوفر', 'inStock'), _filterChip('نفذ', 'outOfStock'),

                const SizedBox(width: 8),

                PopupMenuButton<String>(

                  icon: Container(

                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                    decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),

                    child: Row(mainAxisSize: MainAxisSize.min, children: [

                      Icon(Icons.sort, size: 14, color: AppColors.primary),

                      const SizedBox(width: 4),

                      Text('ترتيب', style: TextStyle(fontSize: 12, color: AppColors.primary)),

                    ]),

                  ),

                  onSelected: (v) => setState(() => _sortBy = v),

                  itemBuilder: (_) => [

                    CheckedPopupMenuItem(value: 'name', checked: _sortBy == 'name', child: const Text('الاسم')),

                    CheckedPopupMenuItem(value: 'price_asc', checked: _sortBy == 'price_asc', child: const Text('سعر ↑')),

                    CheckedPopupMenuItem(value: 'price_desc', checked: _sortBy == 'price_desc', child: const Text('سعر ↓')),

                    CheckedPopupMenuItem(value: 'qty_asc', checked: _sortBy == 'qty_asc', child: const Text('كمية ↑')),

                    CheckedPopupMenuItem(value: 'qty_desc', checked: _sortBy == 'qty_desc', child: const Text('كمية ↓')),

                  ],

                ),

              ]),

            ),

            if (filtered.isEmpty)

              Expanded(child: Center(child: Text('لا توجد نتائج', style: TextStyle(color: Colors.grey[500], fontSize: 16)))),

            if (filtered.isNotEmpty)

            Expanded(

              child: RefreshIndicator(

                onRefresh: () async { HapticFeedback.mediumImpact(); await store.load(); },

                child: ListView.builder(

                  padding: const EdgeInsets.all(12),

                  itemCount: filtered.length,

                  itemBuilder: (_, i) {

                    final p = filtered[i];

                    final idx = store.products.indexWhere((x) => x.id == p.id);

                    return Dismissible(

                      key: ValueKey(p.id),

                      direction: DismissDirection.endToStart,

                      confirmDismiss: (_) async {

                        HapticFeedback.heavyImpact();

                        return await showDialog<bool>(context: context, builder: (_) => AlertDialog(

                          title: const Text('حذف المنتج'), content: Text('هل أنت متأكد من حذف ${p.name}؟'),

                          actions: [

                            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),

                            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: AppColors.danger))),

                          ],

                        ));

                      },

                      onDismissed: (_) { store.deleteProduct(idx); showAppToast(context, 'تم حذف ${p.name}', icon: Icons.delete, color: AppColors.danger); },

                      background: Container(

                    margin: const EdgeInsets.only(bottom: 8),

                    decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.danger, AppColors.danger.withOpacity(0.7)]), borderRadius: BorderRadius.circular(16)),

                    alignment: Alignment.centerLeft,

                    padding: const EdgeInsets.only(left: 24),

                    child: const Icon(Icons.delete, color: Colors.white),

                  ),

                  child: GlassCard(

                    margin: const EdgeInsets.only(bottom: 8),

                    child: Row(

                      children: [

                        p.imagePath.isNotEmpty

                            ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(File(p.imagePath), width: 56, height: 56, fit: BoxFit.cover))

                            : Container(

                                width: 56, height: 56,

                                decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient3), borderRadius: BorderRadius.circular(12)),

                                child: Center(child: Text(p.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),

                              ),

                        const SizedBox(width: 16),

                        Expanded(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                              const SizedBox(height: 4),

                              Text('شراء: ${p.buyPrice.toStringAsFixed(2)} | بيع: ${p.sellPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                            ],

                          ),

                        ),

                        Container(

                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                          decoration: BoxDecoration(

                            color: p.quantity > 0 ? AppColors.success.withOpacity(0.1) : AppColors.danger.withOpacity(0.1),

                            borderRadius: BorderRadius.circular(8),

                          ),

                          child: Text('${p.quantity}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: p.quantity > 0 ? AppColors.success : AppColors.danger)),

                        ),

                      ],

                    ),

                  ),

                );

              },

            ),

            ),

          ),

          ]);

        },

      ),

    );

  }

  Widget _filterChip(String label, String value) {

    final active = _filterType == value;

    return Padding(

      padding: const EdgeInsets.only(right: 6),

      child: ChoiceChip(

        label: Text(label, style: TextStyle(fontSize: 12, color: active ? Colors.white : AppColors.primary)),

        selected: active,

        selectedColor: AppColors.primary,

        backgroundColor: AppColors.primary.withOpacity(0.08),

        onSelected: (_) => setState(() => _filterType = value),

      ),

    );

  }

}



// ==================== CUSTOMERS ====================

class CustomersScreen extends StatefulWidget {

  const CustomersScreen({super.key});

  @override

  State<CustomersScreen> createState() => _CustomersScreenState();

}



class _CustomersScreenState extends State<CustomersScreen> {

  final _searchCtrl = TextEditingController();

  String _search = '';

  String _filterType = 'all';

  String _sortBy = 'name';



  void _showAddDialog(BuildContext ctx) {

    final nameCtrl = TextEditingController();

    final phoneCtrl = TextEditingController();

    final addrCtrl = TextEditingController();

    showModalBottomSheet(

      context: ctx,

      isScrollControlled: true,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (_) => Padding(

        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, left: 20, right: 20, top: 20),

        child: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            const Text('إضافة عميل', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'اسم العميل *', border: OutlineInputBorder())),

            const SizedBox(height: 12),

            TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'الهاتف', border: OutlineInputBorder()), keyboardType: TextInputType.phone),

            const SizedBox(height: 12),

            TextField(controller: addrCtrl, decoration: const InputDecoration(labelText: 'العنوان', border: OutlineInputBorder())),

            const SizedBox(height: 16),

            GradientButton(

              label: 'حفظ', icon: Icons.save, gradient: AppColors.gradient4, isExpanded: true,

              onPressed: () {

                if (nameCtrl.text.isEmpty) return;

                ctx.read<DataStore>().addCustomer(Customer(id: const Uuid().v4(), name: nameCtrl.text, phone: phoneCtrl.text, address: addrCtrl.text));

                Navigator.pop(ctx);

                showAppToast(ctx, 'تم إضافة العميل');

              },

            ),

            const SizedBox(height: 20),

          ],

        ),

      ),

    );

  }



  List<Customer> _filtered(DataStore store) {

    var list = List<Customer>.from(store.customers);

    if (_search.isNotEmpty) {

      final q = _search.toLowerCase();

      list = list.where((c) =>

        c.name.toLowerCase().contains(q) ||

        c.phone.contains(q) ||

        c.address.toLowerCase().contains(q)

      ).toList();

    }

    switch (_filterType) {

      case 'withInvoices': list = list.where((c) => store.invoices.any((inv) => inv.buyerName == c.name)).toList(); break;

      case 'withBalance': list = list.where((c) => c.advanceBalance > 0).toList(); break;

      case 'withPhone': list = list.where((c) => c.phone.isNotEmpty).toList(); break;

      case 'withoutInvoices': list = list.where((c) => !store.invoices.any((inv) => inv.buyerName == c.name)).toList(); break;

    }

    switch (_sortBy) {

      case 'name': list.sort((a, b) => a.name.compareTo(b.name)); break;

      case 'name_desc': list.sort((a, b) => b.name.compareTo(a.name)); break;

      case 'invoices': list.sort((a, b) {

        final aCount = store.invoices.where((inv) => inv.buyerName == a.name).length;

        final bCount = store.invoices.where((inv) => inv.buyerName == b.name).length;

        return bCount.compareTo(aCount);

      }); break;

      case 'balance': list.sort((a, b) => b.advanceBalance.compareTo(a.advanceBalance)); break;

    }

    return list;

  }



  @override

  void dispose() {

    _searchCtrl.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(

        title: const Text('العملاء', style: TextStyle(fontWeight: FontWeight.bold)),

        actions: [

          IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary), onPressed: () => _showAddDialog(context)),

        ],

      ),

      body: Consumer<DataStore>(

        builder: (_, store, __) {

          final filtered = _filtered(store);

          return Column(

            children: [

              Padding(

                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),

                child: GlassCard(

                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                  child: TextField(

                    controller: _searchCtrl,

                    decoration: InputDecoration(

                      hintText: 'بحث بالاسم أو الهاتف...',

                      prefixIcon: const Icon(Icons.search, color: AppColors.primary),

                      suffixIcon: _search.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _searchCtrl.clear(); setState(() => _search = ''); }) : null,

                      border: InputBorder.none,

                      filled: false,

                    ),

                    onChanged: (v) => setState(() => _search = v),

                  ),

                ),

              ),

              SizedBox(

                height: 40,

                child: ListView(

                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.symmetric(horizontal: 12),

                  children: [

                    _filterChip('الكل', 'all'),

                    _filterChip('لديه فواتير', 'withInvoices'),

                    _filterChip('بدون فواتير', 'withoutInvoices'),

                    _filterChip('رصيد مقدم', 'withBalance'),

                    _filterChip('مع هاتف', 'withPhone'),

                  ],

                ),

              ),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

                child: Row(children: [

                  Text('${filtered.length} عميل', style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                  const Spacer(),

                  TextButton.icon(

                    onPressed: () {

                      showModalBottomSheet(

                        context: context,

                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),

                        builder: (ctx) => SafeArea(

                          child: Column(mainAxisSize: MainAxisSize.min, children: [

                            const Padding(padding: EdgeInsets.all(16), child: Text('ترتيب حسب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),

                            ...[

                              ('name', 'الاسم (أ-ي)', Icons.sort_by_alpha),

                              ('name_desc', 'الاسم (ي-أ)', Icons.sort_by_alpha),

                              ('invoices', 'عدد الفواتير', Icons.receipt),

                              ('balance', 'الرصيد الأعلى', Icons.account_balance_wallet),

                            ].map((s) => ListTile(

                              leading: Icon(s.$3, color: _sortBy == s.$1 ? AppColors.primary : null),

                              title: Text(s.$2, style: TextStyle(fontWeight: _sortBy == s.$1 ? FontWeight.bold : FontWeight.normal)),

                              trailing: _sortBy == s.$1 ? const Icon(Icons.check, color: AppColors.primary) : null,

                              onTap: () { setState(() => _sortBy = s.$1); Navigator.pop(ctx); },

                            )),

                            const SizedBox(height: 8),

                          ]),

                        ),

                      );

                    },

                    icon: const Icon(Icons.sort, size: 14),

                    label: const Text('ترتيب'),

                  ),

                ]),

              ),

              Expanded(

                child: store.customers.isEmpty

                    ? EmptyState(icon: Icons.people, title: 'لا يوجد عملاء', subtitle: 'أضف عملاءك لتتبع فواتيرهم', actionLabel: 'إضافة عميل', onAction: () => _showAddDialog(context))

                    : filtered.isEmpty

                        ? EmptyState(icon: Icons.search_off, title: 'لا نتائج', subtitle: 'جرّب البحث بكلمات مختلفة')

                        : RefreshIndicator(

                            onRefresh: () async { HapticFeedback.mediumImpact(); await store.load(); },

                            child: ListView.builder(

                              padding: const EdgeInsets.all(12),

                              itemCount: filtered.length,

                              itemBuilder: (_, i) {

                                final c = filtered[i];

                                final invCount = store.invoices.where((inv) => inv.buyerName == c.name).length;

                                final actualIndex = store.customers.indexOf(c);

                                return Dismissible(

                                  key: ValueKey(c.id),

                                  direction: DismissDirection.endToStart,

                                  confirmDismiss: (_) async {

                                    HapticFeedback.heavyImpact();

                                    return await showDialog<bool>(context: context, builder: (_) => AlertDialog(

                                      title: const Text('حذف العميل'), content: Text('هل أنت متأكد من حذف ${c.name}؟'),

                                      actions: [

                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),

                                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('حذف', style: TextStyle(color: AppColors.danger))),

                                      ],

                                    ));

                                  },

                                  onDismissed: (_) { store.deleteCustomer(actualIndex); showAppToast(context, 'تم حذف ${c.name}', icon: Icons.delete, color: AppColors.danger); },

                                  background: Container(

                                    margin: const EdgeInsets.only(bottom: 8),

                                    decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.danger, AppColors.danger.withOpacity(0.7)]), borderRadius: BorderRadius.circular(16)),

                                    alignment: Alignment.centerLeft,

                                    padding: const EdgeInsets.only(left: 24),

                                    child: const Icon(Icons.delete, color: Colors.white),

                                  ),

                                  child: GlassCard(

                                    margin: const EdgeInsets.only(bottom: 8),

                                    child: InkWell(

                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CustomerStatementScreen(customerName: c.name))),

                                      borderRadius: BorderRadius.circular(20),

                                      child: Row(children: [

                                        Container(

                                          width: 56, height: 56,

                                          decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient5), borderRadius: BorderRadius.circular(12)),

                                          child: Center(child: Text(c.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24))),

                                        ),

                                        const SizedBox(width: 16),

                                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                                          Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),

                                          const SizedBox(height: 4),

                                          Row(children: [

                                            if (c.phone.isNotEmpty) ...[

                                              Icon(Icons.phone, size: 12, color: Colors.grey[500]),

                                              const SizedBox(width: 4),

                                              Text(c.phone, style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                                              Text(' | ', style: TextStyle(fontSize: 12, color: Colors.grey[400])),

                                            ],

                                            Text('$invCount فاتورة', style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                                            if (c.advanceBalance > 0) ...[

                                              Text(' | ', style: TextStyle(fontSize: 12, color: Colors.grey[400])),

                                              Text('${c.advanceBalance.toStringAsFixed(0)} د.ل', style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),

                                            ],

                                          ]),

                                        ])),

                                        Icon(Icons.chevron_left, color: AppColors.textSecondaryOf(context)),

                                      ]),

                                    ),

                                  ),

                                );

                              },

                            ),

                          ),

              ),

            ],

          );

        },

      ),

    );

  }



  Widget _filterChip(String label, String value) {

    final sel = _filterType == value;

    return Padding(

      padding: const EdgeInsets.only(left: 6),

      child: FilterChip(

        label: Text(label, style: TextStyle(fontSize: 12, color: sel ? Colors.white : null)),

        selected: sel,

        onSelected: (_) => setState(() => _filterType = value),

        selectedColor: AppColors.primary,

        checkmarkColor: Colors.white,

        padding: const EdgeInsets.symmetric(horizontal: 4),

      ),

    );

  }

}



// ==================== STATS ====================

class StatsScreen extends StatelessWidget {

  const StatsScreen({super.key});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(title: const Text('الإحصائيات', style: TextStyle(fontWeight: FontWeight.bold))),

      body: Consumer<DataStore>(

        builder: (_, store, __) {

          final totalSales = store.invoices.fold<double>(0, (s, i) => s + i.total);

          final totalPaid = store.invoices.fold<double>(0, (s, i) => s + i.totalPaid);

          final totalRemaining = store.invoices.fold<double>(0, (s, i) => s + i.remaining);

          final avgInvoice = store.invoices.isEmpty ? 0.0 : totalSales / store.invoices.length;



          Map<String, int> customerInvoiceCount = {};

          Map<String, double> customerTotalSales = {};

          for (var inv in store.invoices) {

            final name = inv.buyerName.isEmpty ? 'عميل' : inv.buyerName;

            customerInvoiceCount[name] = (customerInvoiceCount[name] ?? 0) + 1;

            customerTotalSales[name] = (customerTotalSales[name] ?? 0) + inv.total;

          }

          final sortedCustomers = customerInvoiceCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

          final bestCustomers = sortedCustomers.take(5).toList();



          return RefreshIndicator(

            onRefresh: () async { HapticFeedback.mediumImpact(); await store.load(); },

            child: ListView(

              padding: const EdgeInsets.all(16),

              children: [

                Row(children: [

                  Expanded(child: _statCard('الإجمالي', totalSales, AppColors.gradient1, Icons.attach_money, context)),

                  const SizedBox(width: 12),

                  Expanded(child: _statCard('الفواتير', store.invoices.length.toDouble(), AppColors.gradient2, Icons.receipt, context)),

                ]),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: _statCard('المدفوع', totalPaid, AppColors.gradient4, Icons.check_circle, context)),

                  const SizedBox(width: 12),

                  Expanded(child: _statCard('المتبقي', totalRemaining, [AppColors.danger, AppColors.danger.withOpacity(0.7)], Icons.pending, context)),

                ]),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: _statCard('المتوسط', avgInvoice, AppColors.gradient5, Icons.analytics, context)),

                  const SizedBox(width: 12),

                  Expanded(child: _statCard('المنتجات', store.products.length.toDouble(), AppColors.gradient3, Icons.inventory_2, context)),

                ]),

                const SizedBox(height: 20),

                if (bestCustomers.isNotEmpty)

                  GlassCard(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(children: [

                          const Icon(Icons.emoji_events, color: AppColors.warning, size: 20),

                          const SizedBox(width: 8),

                          const Text('أفضل العملاء', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                        ]),

                        const SizedBox(height: 12),

                        ...bestCustomers.asMap().entries.map((entry) {

                          final idx = entry.key;

                          final e = entry.value;

                          final total = customerTotalSales[e.key] ?? 0;

                          return ListTile(

                            dense: true,

                            leading: Container(

                              width: 40, height: 40,

                              decoration: BoxDecoration(

                                gradient: idx == 0 ? LinearGradient(colors: [AppColors.warning, AppColors.warning.withOpacity(0.7)]) : null,

                                color: idx != 0 ? AppColors.primary.withOpacity(0.1) : null,

                                borderRadius: BorderRadius.circular(10),

                              ),

                              child: Center(

                                child: idx == 0

                                    ? const Icon(Icons.emoji_events, color: Colors.white, size: 20)

                                    : Text('${idx + 1}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),

                              ),

                            ),

                            title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.w600)),

                            subtitle: Text('${e.value} فاتورة'),

                            trailing: Text('${total.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),

                          );

                        }),

                      ],

                    ),

                  ),

                if (bestCustomers.isNotEmpty) const SizedBox(height: 12),

                if (store.invoices.any((i) => i.isOverdue))

                  GlassCard(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Row(children: [

                          const Icon(Icons.warning_amber, color: AppColors.danger, size: 20),

                          const SizedBox(width: 8),

                          Text('فواتير متأخرة (${store.invoices.where((i) => i.isOverdue).length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.danger)),

                        ]),

                        const SizedBox(height: 12),

                        ...store.invoices.where((i) => i.isOverdue).take(5).map((inv) => ListTile(

                          dense: true,

                          leading: CircleAvatar(backgroundColor: AppColors.danger.withOpacity(0.1), child: const Icon(Icons.warning_amber, color: AppColors.danger, size: 18)),

                          title: Text('${inv.id} - ${inv.buyerName}', style: const TextStyle(fontWeight: FontWeight.w600)),

                          subtitle: Text('متأخر ${-inv.daysUntilDue} يوم | متبقي ${inv.remaining.toStringAsFixed(2)} د.ل'),

                          trailing: const Icon(Icons.chevron_left, color: AppColors.danger),

                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => InvoiceDetailScreen(invoice: inv, index: store.invoices.indexOf(inv)))),

                        )),

                      ],

                    ),

                  ),

                if (store.invoices.any((i) => i.isOverdue)) const SizedBox(height: 12),

                GlassCard(

                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Row(children: [

                        const Icon(Icons.history, color: AppColors.primary, size: 20),

                        const SizedBox(width: 8),

                        const Text('آخر الفواتير', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                      ]),

                      const SizedBox(height: 12),

                      if (store.invoices.isEmpty)

                        const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('لا توجد فواتير')))

                      else

                        ...store.invoices.take(5).map((inv) => ListTile(

                          dense: true,

                          leading: Container(

                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(

                              color: statusColor(inv.status).withOpacity(0.1),

                              borderRadius: BorderRadius.circular(8),

                            ),

                            child: Icon(

                              inv.status == 'paid' ? Icons.check_circle : Icons.schedule,

                              color: statusColor(inv.status), size: 18,

                            ),

                          ),

                          title: Text('${inv.id} — ${inv.buyerName}', style: const TextStyle(fontWeight: FontWeight.w600)),

                          subtitle: Text('${inv.total.toStringAsFixed(2)} د.ل — ${inv.date}'),

                        )),

                    ],

                  ),

                ),

              ],

            ),

          );

        },

      ),

    );

  }



  Widget _statCard(String title, double value, List<Color> gradient, IconData icon, BuildContext context) {

    return GlassCard(

      child: Column(

        children: [

          Container(

            padding: const EdgeInsets.all(14),

            decoration: BoxDecoration(

              gradient: LinearGradient(colors: gradient),

              borderRadius: BorderRadius.circular(14),

              boxShadow: [

                BoxShadow(color: gradient.first.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),

              ],

            ),

            child: Icon(icon, color: Colors.white, size: 28),

          ),

          const SizedBox(height: 12),

          Text(title, style: TextStyle(fontSize: 12, color: AppColors.textSecondaryOf(context))),

          const SizedBox(height: 4),

          AnimatedCounter(

            value: value,

            suffix: title == 'الفواتير' || title == 'المنتجات' ? '' : 'د.ل',

            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryOf(context)),

          ),

        ],

      ),

    );

  }

}



// ==================== INVOICE SETTINGS ====================

class InvoiceSettingsScreen extends StatefulWidget {

  const InvoiceSettingsScreen({super.key});

  @override

  State<InvoiceSettingsScreen> createState() => _InvoiceSettingsScreenState();

}



class _InvoiceSettingsScreenState extends State<InvoiceSettingsScreen> {

  int _tab = 0;



  Color _h(String hex) {

    hex = hex.replaceFirst('#', '');

    if (hex.length == 6) hex = 'FF$hex';

    return Color(int.parse(hex, radix: 16));

  }



  Widget _tile(String label, bool val, VoidCallback onTap, {IconData? icon}) {

    return InkWell(

      onTap: onTap, borderRadius: BorderRadius.circular(10),

      child: Padding(

        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),

        child: Row(children: [

          if (icon != null) ...[Icon(icon, size: 20, color: AppColors.primary), const SizedBox(width: 12)],

          Expanded(child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),

          Container(width: 46, height: 26, decoration: BoxDecoration(

            color: val ? AppColors.primary : Colors.grey.shade300, borderRadius: BorderRadius.circular(13)),

            child: AnimatedAlign(alignment: val ? Alignment.centerRight : Alignment.centerLeft,

              duration: const Duration(milliseconds: 200),

              child: Container(width: 22, height: 22, margin: const EdgeInsets.symmetric(horizontal: 2),

                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle,

                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)])),

            ),

          ),

        ]),

      ),

    );

  }



  Widget _slider(String label, double val, double min, double max, String unit, Function(double) onChange, {double step = 1}) {

    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 4),

      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),

          Container(

            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),

            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),

            child: Text('${val.round()}$unit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),

          ),

        ]),

        SliderTheme(data: SliderTheme.of(context).copyWith(

          activeTrackColor: AppColors.primary, thumbColor: AppColors.primary,

          inactiveTrackColor: AppColors.primary.withOpacity(0.15),

          trackHeight: 4, thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8)),

          child: Slider(value: val, min: min, max: max, divisions: ((max - min) / step).round(), onChanged: onChange),

        ),

      ]),

    );

  }



  Widget _colorPicker(String label, String hex, Function(String) onChange) {

    return InkWell(

      borderRadius: BorderRadius.circular(10),

      onTap: () async {

        final colors = ['#6366F1','#8B5CF6','#EC4899','#EF4444','#F97316','#10B981','#06B6D4','#3B82F6','#000000','#6B7280','#1e293b','#d97706'];

        final picked = await showModalBottomSheet<String>(

          context: context, isScrollControlled: true,

          builder: (_) => Container(

            padding: const EdgeInsets.all(20),

            child: Column(mainAxisSize: MainAxisSize.min, children: [

              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),

              const SizedBox(height: 16),

              Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),

                itemCount: colors.length,

                itemBuilder: (_, i) {

                  final c = _h(colors[i]);

                  final sel = hex == colors[i];

                  return GestureDetector(

                    onTap: () => Navigator.pop(context, colors[i]),

                    child: AnimatedContainer(

                      duration: const Duration(milliseconds: 200),

                      decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: sel ? Colors.black : Colors.transparent, width: 3),

                        boxShadow: sel ? [BoxShadow(color: c.withOpacity(0.5), blurRadius: 8)] : []),

                    ),

                  );

                }),

              const SizedBox(height: 20),

            ]),

          ),

        );

        if (picked != null) onChange(picked);

      },

      child: Container(

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(

          color: _h(hex).withOpacity(0.08), borderRadius: BorderRadius.circular(12),

          border: Border.all(color: _h(hex).withOpacity(0.2)),

        ),

        child: Row(children: [

          Container(width: 36, height: 36, decoration: BoxDecoration(color: _h(hex), borderRadius: BorderRadius.circular(10),

              boxShadow: [BoxShadow(color: _h(hex).withOpacity(0.3), blurRadius: 6)])),

          const SizedBox(width: 12),

          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),

          const Spacer(),

          Text(hex, style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontFamily: 'monospace')),

          const SizedBox(width: 4),

          Icon(Icons.chevron_left, size: 18, color: Colors.grey.shade400),

        ]),

      ),

    );

  }



  Widget _optBtn(String label, String group, String val, Function(String) onChange) {

    final active = group == val;

    return GestureDetector(

      onTap: () => onChange(val),

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        decoration: BoxDecoration(

          color: active ? AppColors.primary : Colors.grey.shade100,

          borderRadius: BorderRadius.circular(10),

        ),

        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: active ? Colors.white : Colors.grey.shade600)),

      ),

    );

  }



  Widget _sectionLabel(String text, IconData icon) {

    return Padding(

      padding: const EdgeInsets.only(top: 20, bottom: 8),

      child: Row(children: [

        Container(width: 28, height: 28, decoration: BoxDecoration(

          gradient: LinearGradient(colors: AppColors.gradient1), borderRadius: BorderRadius.circular(8)),

          child: Icon(icon, size: 14, color: Colors.white)),

        const SizedBox(width: 10),

        Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),

      ]),

    );

  }



  Widget _divider() => Divider(height: 1, color: Colors.grey.shade100);



  Widget _inputField(String label, String value, Function(String) onChange, {String? hint}) {

    return Padding(

      padding: const EdgeInsets.only(bottom: 10),

      child: TextFormField(

        initialValue: value, style: const TextStyle(fontSize: 13),

        decoration: InputDecoration(

          labelText: label, labelStyle: TextStyle(fontSize: 12, color: Colors.grey.shade500),

          hintText: hint, hintStyle: TextStyle(color: Colors.grey.shade300),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),

          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primary, width: 2)),

          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

          filled: true, fillColor: Colors.grey.shade50,

        ),

        onChanged: onChange,

      ),

    );

  }



  Widget _preview(DataStore s) {

    final pri = _h(s.primaryColor);

    final sec = _h(s.accentColor);

    final txC = _h(s.textColor);

    final borderC = _h(s.tableBorderColor);

    return Container(

      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(16)),

      child: Column(children: [

        Container(

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

          decoration: BoxDecoration(color: Colors.white, borderRadius: const BorderRadius.vertical(top: Radius.circular(16)), border: Border(bottom: BorderSide(color: Colors.grey.shade200))),

          child: Row(children: [

            Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(gradient: LinearGradient(colors: [pri, sec]), borderRadius: BorderRadius.circular(8)),

                child: const Icon(Icons.preview, size: 16, color: Colors.white)),

            const SizedBox(width: 10),

            const Text('Preview', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

            const Spacer(),

            Container(

              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),

              child: Text(s.paperSize == 'landscape' ? 'Landscape' : 'Portrait', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),

            ),

          ]),

        ),

        Expanded(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(16),

            child: Center(

              child: Container(

                width: s.paperSize == 'landscape' ? 420 : 300,

                decoration: BoxDecoration(

                  color: _h(s.invoiceBgColor),

                  borderRadius: BorderRadius.circular(s.borderRadius),

                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],

                ),

                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                  if (s.useGradient) Container(height: s.accentBarHeight, decoration: BoxDecoration(gradient: LinearGradient(colors: [pri, sec]))),

                  Container(

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    decoration: BoxDecoration(

                      gradient: s.useGradient ? LinearGradient(colors: [pri, sec]) : null,

                      color: s.useGradient ? null : pri,

                      borderRadius: BorderRadius.vertical(top: Radius.circular(s.borderRadius)),

                    ),

                    child: Column(

                      crossAxisAlignment: s.logoPosition == 'center' ? CrossAxisAlignment.center : (s.logoPosition == 'left' ? CrossAxisAlignment.start : CrossAxisAlignment.end),

                      children: [

                        if (s.showLogo) ...[

                          Container(width: s.logoHeight * 0.8, height: s.logoHeight * 0.8,

                              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),

                              child: Icon(Icons.store, color: Colors.white, size: s.logoHeight * 0.4)),

                          const SizedBox(height: 8),

                        ],

                        Text(s.customTitle.isNotEmpty ? s.customTitle : s.invoiceTitle,

                            style: TextStyle(fontSize: s.companyNameSize * 0.7, fontWeight: FontWeight.bold, color: Colors.white, height: s.lineHeight),

                            textAlign: s.logoPosition == 'center' ? TextAlign.center : (s.logoPosition == 'left' ? TextAlign.left : TextAlign.right)),

                        if (s.invoiceSubtitle.isNotEmpty) Text(s.invoiceSubtitle, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: s.fontSize * 0.8)),

                        const SizedBox(height: 6),

                        if (s.showBadge) Align(

                          alignment: s.logoPosition == 'center' ? Alignment.center : (s.logoPosition == 'left' ? Alignment.centerLeft : Alignment.centerRight),

                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

                              decoration: BoxDecoration(color: sec, borderRadius: BorderRadius.circular(20)),

                              child: const Text('Unpaid', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),

                        ),

                      ],

                    ),

                  ),

                  if (s.showSellerInfo && s.showCompanyInfo)

                    Padding(

                      padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                      child: Row(children: [

                        CircleAvatar(radius: 16, backgroundColor: pri.withOpacity(0.1), child: Icon(Icons.person, color: pri, size: 18)),

                        const SizedBox(width: 10),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(s.sellerName.isNotEmpty ? s.sellerName : 'Store Name', style: TextStyle(fontSize: s.fontSize, fontWeight: FontWeight.bold, color: txC)),

                          if (s.showSellerPhone && s.sellerPhone.isNotEmpty) Text(s.sellerPhone, style: TextStyle(fontSize: s.fontSize * 0.75, color: txC.withOpacity(0.6))),

                          if (s.showSellerAddress && s.sellerAddress.isNotEmpty) Text(s.sellerAddress, style: TextStyle(fontSize: s.fontSize * 0.75, color: txC.withOpacity(0.6))),

                        ])),

                      ]),

                    ),

                  if (s.showInfoGrid) Container(

                    margin: EdgeInsets.symmetric(horizontal: s.sectionSpacing.toDouble()),

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    decoration: BoxDecoration(color: pri.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),

                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [

                      _infoCell('Invoice #', '#001', pri),

                      _infoCell('Date', '2025-01-01', pri),

                      if (s.showSellerPhone) _infoCell('Phone', s.sellerPhone.isNotEmpty ? s.sellerPhone : '---', pri),

                    ]),

                  ),

                  Padding(

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    child: Column(children: [

                      Container(

                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: s.rowPadding),

                        decoration: BoxDecoration(

                          gradient: s.tableHeaderStyle == 'gradient' ? LinearGradient(colors: [pri, sec]) : null,

                          color: s.tableHeaderStyle == 'solid' ? pri : (s.tableHeaderStyle == 'outline' ? Colors.transparent : Colors.grey.shade50),

                          border: s.tableHeaderStyle == 'outline' ? Border.all(color: pri) : null,

                          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),

                        ),

                        child: Row(children: [

                          if (s.showItemNumber) Expanded(flex: 1, child: _tHead('#', s)),

                          Expanded(flex: 3, child: _tHead('Product', s)),

                          if (s.showUnitPrice) Expanded(flex: 2, child: _tHead('Price', s)),

                          Expanded(flex: 1, child: _tHead('Qty', s)),

                          if (s.showDiscountCol) Expanded(flex: 1, child: _tHead('Disc', s)),

                          Expanded(flex: 2, child: _tHead('Total', s)),

                        ]),

                      ),

                      _tRow(s, 'Wireless Charger', 150, 2, 0, pri, 0),

                      _tRow(s, 'Phone Case', 45, 1, 5, pri, 1),

                      _tRow(s, 'BT Earbuds', 85, 3, 0, pri, 2),

                      Container(

                        padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                        decoration: BoxDecoration(color: pri.withOpacity(0.03), borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),

                        child: Column(children: [

                          _sRow('Subtotal', '675.00 ${s.currencySymbol}', txC),

                          _sRow('Discount', '- 5.00 ${s.currencySymbol}', Colors.red),

                          Divider(color: borderC),

                          _sRow('Total', '670.00 ${s.currencySymbol}', pri, big: true),

                          const SizedBox(height: 4),

                          _sRow('Paid', '0.00 ${s.currencySymbol}', Colors.grey),

                          _sRow('Remaining', '670.00 ${s.currencySymbol}', sec, big: true),

                        ]),

                      ),

                    ]),

                  ),

                  if (s.showTerms && s.termsText.isNotEmpty)

                    Padding(

                      padding: EdgeInsets.fromLTRB(s.sectionSpacing.toDouble(), 0, s.sectionSpacing.toDouble(), s.sectionSpacing.toDouble()),

                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                            decoration: BoxDecoration(color: pri.withOpacity(0.08), borderRadius: BorderRadius.circular(6)),

                            child: Text('Terms', style: TextStyle(fontSize: s.fontSize * 0.75, fontWeight: FontWeight.bold, color: pri))),

                        const SizedBox(height: 6),

                        ...s.termsText.take(3).map((t) => Padding(

                          padding: const EdgeInsets.only(bottom: 3),

                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Padding(padding: const EdgeInsets.only(top: 5, left: 4), child: Icon(Icons.circle, size: 5, color: pri)),

                            Expanded(child: Text(t, style: TextStyle(fontSize: s.fontSize * 0.7, color: txC.withOpacity(0.7), height: s.lineHeight))),

                          ]),

                        )),

                      ]),

                    ),

                  if (s.showStamps) Padding(

                    padding: EdgeInsets.symmetric(horizontal: s.sectionSpacing.toDouble()),

                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      _stampArea('Seller Stamp', pri), _stampArea('Buyer Signature', pri),

                    ]),

                  ),

                  if (s.showNotes) Padding(

                    padding: EdgeInsets.symmetric(horizontal: s.sectionSpacing.toDouble(), vertical: s.sectionSpacing.toDouble() / 2),

                    child: Container(

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(color: Colors.amber.withOpacity(0.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.withOpacity(0.2))),

                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Icon(Icons.sticky_note_2, size: 16, color: Colors.amber.shade700),

                        const SizedBox(width: 8),

                        Expanded(child: Text('Additional notes...', style: TextStyle(fontSize: s.fontSize * 0.7, color: txC.withOpacity(0.6), fontStyle: FontStyle.italic))),

                      ]),

                    ),

                  ),

                  if (s.showQrCode) Padding(

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    child: Center(child: Container(

                      width: s.qrSize, height: s.qrSize, padding: const EdgeInsets.all(6),

                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: borderC)),

                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                        Icon(Icons.qr_code_2, size: s.qrSize * 0.6, color: txC),

                        Text('QR', style: TextStyle(fontSize: 8, color: txC.withOpacity(0.4))),

                      ]),

                    )),

                  ),

                  if (s.footerText.isNotEmpty) Container(

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: [pri.withOpacity(0.08), sec.withOpacity(0.05)]),

                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(s.borderRadius)),

                    ),

                    child: Text(s.footerText, textAlign: TextAlign.center,

                        style: TextStyle(fontSize: s.fontSize * 0.7, color: pri, fontWeight: FontWeight.w600, height: s.lineHeight)),

                  ),

                ]),

              ),

            ),

          ),

        ),

      ]),

    );

  }



  Widget _infoCell(String label, String value, Color color) {

    return Column(children: [

      Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),

      const SizedBox(height: 2),

      Text(value, style: TextStyle(fontSize: 10, color: color.withOpacity(0.7))),

    ]);

  }



  Widget _tHead(String text, DataStore s) {

    final isLight = s.tableHeaderStyle == 'outline' || s.tableHeaderStyle == 'clean';

    return Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isLight ? Colors.black87 : Colors.white));

  }



  Widget _tRow(DataStore s, String name, double price, int qty, double disc, Color primary, int idx) {

    final total = price * qty - disc;

    final isAlt = s.tableRowStyle == 'alternating' && idx.isOdd;

    return Container(

      padding: EdgeInsets.symmetric(horizontal: 8, vertical: s.rowPadding * 0.5),

      decoration: BoxDecoration(

        color: isAlt ? primary.withOpacity(0.03) : Colors.transparent,

        border: s.tableRowStyle == 'borders' ? Border(bottom: BorderSide(color: _h(s.tableBorderColor), width: 0.5)) : null,

      ),

      child: Row(children: [

        if (s.showItemNumber) Expanded(flex: 1, child: Text('${idx + 1}', style: TextStyle(fontSize: 9, color: Colors.grey.shade500))),

        Expanded(flex: 3, child: Text(name, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: _h(s.textColor)))),

        if (s.showUnitPrice) Expanded(flex: 2, child: Text('${price.toStringAsFixed(0)} ${s.currencySymbol}', style: TextStyle(fontSize: 9, color: _h(s.textColor).withOpacity(0.7)))),

        Expanded(flex: 1, child: Center(child: Text('$qty', style: TextStyle(fontSize: 9, color: _h(s.textColor))))),

        if (s.showDiscountCol) Expanded(flex: 1, child: Text(disc > 0 ? disc.toStringAsFixed(0) : '-', style: TextStyle(fontSize: 9, color: disc > 0 ? AppColors.danger : Colors.grey.shade400))),

        Expanded(flex: 2, child: Text('${total.toStringAsFixed(0)} ${s.currencySymbol}', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: primary))),

      ]),

    );

  }



  Widget _sRow(String label, String value, Color color, {bool big = false}) {

    return Padding(

      padding: const EdgeInsets.symmetric(vertical: 2),

      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

        Text(label, style: TextStyle(fontSize: big ? 12 : 10, fontWeight: big ? FontWeight.bold : FontWeight.normal, color: color.withOpacity(big ? 1 : 0.7))),

        Text(value, style: TextStyle(fontSize: big ? 13 : 10, fontWeight: FontWeight.bold, color: color)),

      ]),

    );

  }



  Widget _stampArea(String label, Color color) {

    return Container(width: 90, height: 60,

      decoration: BoxDecoration(border: Border.all(color: color.withOpacity(0.2)), borderRadius: BorderRadius.circular(8)),

      alignment: Alignment.center,

      child: Text(label, style: TextStyle(fontSize: 8, color: color.withOpacity(0.3))),

    );

  }



  Widget _colorsPanel(DataStore s) {

    final presets = [

      {'name': 'Blue', 'a': '#4f8ef7', 'b': '#6c5ce7', 'icon': Icons.business},

      {'name': 'Green', 'a': '#16a34a', 'b': '#059669', 'icon': Icons.eco},

      {'name': 'Royal', 'a': '#1e40af', 'b': '#7c3aed', 'icon': Icons.diamond},

      {'name': 'Dark', 'a': '#1e293b', 'b': '#475569', 'icon': Icons.dark_mode},

      {'name': 'Amber', 'a': '#d97706', 'b': '#ea580c', 'icon': Icons.local_fire_department},

    ];

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel('Preset Themes', Icons.auto_awesome),

      ...presets.map((p) {

        final active = s.primaryColor == p['a'] && s.accentColor == p['b'];

        return Padding(

          padding: const EdgeInsets.only(bottom: 8),

          child: GestureDetector(

            onTap: () { s.updateInvoiceSetting('primaryColor', p['a'] as String); s.updateInvoiceSetting('accentColor', p['b'] as String); },

            child: Container(

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(

                gradient: LinearGradient(colors: [_h(p['a'] as String), _h(p['b'] as String)]),

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: active ? Colors.white : Colors.transparent, width: 2),

                boxShadow: active ? [BoxShadow(color: _h(p['a'] as String).withOpacity(0.4), blurRadius: 12)] : [],

              ),

              child: Row(children: [

                Icon(p['icon'] as IconData, color: Colors.white, size: 20),

                const SizedBox(width: 10),

                Text((p['name'] as String?) ?? '', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),

                const Spacer(),

                if (active) const Icon(Icons.check_circle, color: Colors.white, size: 20),

              ]),

            ),

          ),

        );

      }),

      const SizedBox(height: 8),

      _sectionLabel('Custom Colors', Icons.palette),

      _colorPicker('Primary Color', s.primaryColor, (c) => s.updateInvoiceSetting('primaryColor', c)),

      const SizedBox(height: 8),

      _colorPicker('Secondary Color', s.accentColor, (c) => s.updateInvoiceSetting('accentColor', c)),

      const SizedBox(height: 8),

      _tile('Gradient', s.useGradient, () => s.updateInvoiceSetting('useGradient', !s.useGradient), icon: Icons.gradient),

      _divider(),

      _sectionLabel('Additional Colors', Icons.brush),

      _colorPicker('Background', s.invoiceBgColor, (c) => s.updateInvoiceSetting('invoiceBgColor', c)),

      const SizedBox(height: 8),

      _colorPicker('Text Color', s.textColor, (c) => s.updateInvoiceSetting('textColor', c)),

      const SizedBox(height: 8),

      _colorPicker('Border Color', s.tableBorderColor, (c) => s.updateInvoiceSetting('tableBorderColor', c)),

    ]);

  }



  Widget _layoutPanel(DataStore s) {

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel('Paper', Icons.pageview),

      Row(children: [

        Expanded(child: _optBtn('Portrait', s.paperSize, 'portrait', (v) => s.updateInvoiceSetting('paperSize', v))),

        const SizedBox(width: 8),

        Expanded(child: _optBtn('Landscape', s.paperSize, 'landscape', (v) => s.updateInvoiceSetting('paperSize', v))),

      ]),

      _sectionLabel('Dimensions', Icons.straighten),

      _slider('Border Radius', s.borderRadius, 0, 24, 'px', (v) => s.updateInvoiceSetting('borderRadius', v)),

      _slider('Accent Bar', s.accentBarHeight, 0, 10, 'px', (v) => s.updateInvoiceSetting('accentBarHeight', v)),

      _slider('Logo Height', s.logoHeight, 20, 150, 'px', (v) => s.updateInvoiceSetting('logoHeight', v)),

      _slider('Section Spacing', s.sectionSpacing, 4, 30, 'px', (v) => s.updateInvoiceSetting('sectionSpacing', v)),

      _slider('QR Size', s.qrSize, 40, 200, 'px', (v) => s.updateInvoiceSetting('qrSize', v)),

      _sectionLabel('Logo Position', Icons.open_with),

      Row(children: [

        Expanded(child: _optBtn('Left', s.logoPosition, 'left', (v) => s.updateInvoiceSetting('logoPosition', v))),

        const SizedBox(width: 6),

        Expanded(child: _optBtn('Center', s.logoPosition, 'center', (v) => s.updateInvoiceSetting('logoPosition', v))),

        const SizedBox(width: 6),

        Expanded(child: _optBtn('Right', s.logoPosition, 'right', (v) => s.updateInvoiceSetting('logoPosition', v))),

      ]),

    ]);

  }



  Widget _typographyPanel(DataStore s) {

    final fonts = [

      {'id': 'Cairo', 'name': 'Cairo'},

      {'id': 'Tajawal', 'name': 'Tajawal'},

      {'id': 'Almarai', 'name': 'Almarai'},

      {'id': 'IBM Plex Arabic', 'name': 'IBM Plex Arabic'},

      {'id': 'Noto Kufi Arabic', 'name': 'Noto Kufi Arabic'},

      {'id': 'Noto Naskh Arabic', 'name': 'Noto Naskh Arabic'},

    ];

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel('Font Family', Icons.font_download),

      ...fonts.map((f) {

        final active = s.fontFamily == f['id'];

        return Padding(

          padding: const EdgeInsets.only(bottom: 8),

          child: GestureDetector(

            onTap: () => s.updateInvoiceSetting('fontFamily', f['id']!),

            child: Container(

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(

                color: active ? AppColors.primary.withOpacity(0.1) : Colors.grey.shade50,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: active ? AppColors.primary : Colors.grey.shade200, width: active ? 2 : 1),

              ),

              child: Row(children: [

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(f['name']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: active ? AppColors.primary : _h(s.textColor))),

                  const Text('Sample text', style: TextStyle(fontSize: 12, color: Colors.grey)),

                ])),

                if (active) Icon(Icons.check_circle, color: AppColors.primary, size: 20),

              ]),

            ),

          ),

        );

      }),

      const SizedBox(height: 8),

      _sectionLabel('Sizes', Icons.format_size),

      _slider('Base Font', s.fontSize, 8, 18, 'px', (v) => s.updateInvoiceSetting('fontSize', v)),

      _slider('Company Name', s.companyNameSize, 10, 36, 'px', (v) => s.updateInvoiceSetting('companyNameSize', v)),

      _slider('Line Height', s.lineHeight, 1, 2.5, 'x', (v) => s.updateInvoiceSetting('lineHeight', v), step: 0.1),

      _slider('Row Padding', s.rowPadding, 2, 16, 'px', (v) => s.updateInvoiceSetting('rowPadding', v)),

    ]);

  }



  Widget _tablePanel(DataStore s) {

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel('Header Style', Icons.table_chart),

      Wrap(spacing: 8, runSpacing: 8, children: [

        _optBtn('Gradient', s.tableHeaderStyle, 'gradient', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

        _optBtn('Solid', s.tableHeaderStyle, 'solid', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

        _optBtn('Outline', s.tableHeaderStyle, 'outline', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

        _optBtn('Clean', s.tableHeaderStyle, 'clean', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

      ]),

      _sectionLabel('Row Style', Icons.view_list),

      Wrap(spacing: 8, runSpacing: 8, children: [

        _optBtn('Alternating', s.tableRowStyle, 'alternating', (v) => s.updateInvoiceSetting('tableRowStyle', v)),

        _optBtn('Borders', s.tableRowStyle, 'borders', (v) => s.updateInvoiceSetting('tableRowStyle', v)),

        _optBtn('Clean', s.tableRowStyle, 'clean', (v) => s.updateInvoiceSetting('tableRowStyle', v)),

      ]),

      _sectionLabel('Columns', Icons.view_column),

      _tile('Item Number', s.showItemCode, () => s.updateInvoiceSetting('showItemCode', !s.showItemCode), icon: Icons.tag),

      _tile('Barcode', s.showItemBarcode, () => s.updateInvoiceSetting('showItemBarcode', !s.showItemBarcode), icon: Icons.qr_code),

      _tile('Unit Price', s.showUnitPrice, () => s.updateInvoiceSetting('showUnitPrice', !s.showUnitPrice), icon: Icons.attach_money),

      _tile('Discount', s.showDiscountCol, () => s.updateInvoiceSetting('showDiscountCol', !s.showDiscountCol), icon: Icons.discount),

    ]);

  }



  Widget _sectionsPanel(DataStore s) {

    final items = [

      ['showLogo', 'Logo', Icons.business, s.showLogo],

      ['showCompanyInfo', 'Company Info', Icons.store, s.showCompanyInfo],

      ['showTaxNo', 'Tax Number', Icons.pin, s.showTaxNo],

      ['showBadge', 'Payment Badge', Icons.badge, s.showBadge],

      ['showInfoGrid', 'Info Grid', Icons.info, s.showInfoGrid],

      ['showQrCode', 'QR Code', Icons.qr_code_2, s.showQrCode],

      ['showTerms', 'Terms', Icons.description, s.showTerms],

      ['showStamps', 'Stamps', Icons.verified, s.showStamps],

      ['showNotes', 'Notes', Icons.sticky_note_2, s.showNotes],

      ['showPaymentDetails', 'Payment Details', Icons.payment, s.showPaymentDetails],

    ];

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel('Show / Hide Sections', Icons.visibility),

      ...items.map((item) {

        final key = item[0] as String;

        final label = item[1] as String;

        final icon = item[2] as IconData;

        final val = item[3] as bool;

        return Column(children: [

          _tile(label, val, () => s.updateInvoiceSetting(key, !val), icon: icon),

          _divider(),

        ]);

      }),

    ]);

  }



  Widget _contentPanel(DataStore s) {

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel('Invoice Info', Icons.receipt),

      _inputField('Invoice Title', s.invoiceTitle, (v) => s.updateInvoiceSetting('invoiceTitle', v)),

      _inputField('Subtitle', s.invoiceSubtitle, (v) => s.updateInvoiceSetting('invoiceSubtitle', v)),

      Row(children: [

        Expanded(child: _inputField('Start Number', s.invoiceStartNumber.toString(), (v) => s.updateInvoiceSetting('invoiceStartNumber', int.tryParse(v) ?? 1))),

        const SizedBox(width: 8),

        Expanded(child: _inputField('Currency', s.currencySymbol, (v) => s.updateInvoiceSetting('currencySymbol', v))),

      ]),

      _inputField('Footer Text', s.footerText, (v) => s.updateInvoiceSetting('footerText', v)),

      const SizedBox(height: 8),

      _sectionLabel('Terms & Conditions', Icons.description),

      TextFormField(

        initialValue: s.termsText.join('\n'), maxLines: 6, style: const TextStyle(fontSize: 13),

        decoration: InputDecoration(

          hintText: 'One term per line', hintStyle: TextStyle(color: Colors.grey.shade400),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),

          contentPadding: const EdgeInsets.all(14), filled: true, fillColor: Colors.grey.shade50,

        ),

        onChanged: (v) => s.updateInvoiceSetting('termsText', v.split('\n').where((l) => l.trim().isNotEmpty).toList()),

      ),

      const SizedBox(height: 12),

      _sectionLabel('Custom Title', Icons.edit),

      _inputField('Custom Invoice Title', s.customTitle, (v) => s.updateInvoiceSetting('customTitle', v), hint: 'Leave empty for default'),

    ]);

  }



  Widget _tabContent(DataStore s) {

    switch (_tab) {

      case 0: return _colorsPanel(s);

      case 1: return _layoutPanel(s);

      case 2: return _typographyPanel(s);

      case 3: return _tablePanel(s);

      case 4: return _sectionsPanel(s);

      case 5: return _contentPanel(s);

      default: return _colorsPanel(s);

    }

  }



  @override

  Widget build(BuildContext context) {

    final tabData = [

      {'icon': Icons.palette, 'label': 'Colors'},

      {'icon': Icons.dashboard, 'label': 'Layout'},

      {'icon': Icons.font_download, 'label': 'Font'},

      {'icon': Icons.table_chart, 'label': 'Table'},

      {'icon': Icons.list, 'label': 'Sections'},

      {'icon': Icons.edit, 'label': 'Content'},

    ];

    return Consumer<DataStore>(

      builder: (ctx, s, _) {

        return Scaffold(

          backgroundColor: AppColors.bgOf(context),

          appBar: AppBar(

            title: const Text('Invoice Settings', style: TextStyle(fontWeight: FontWeight.bold)),

            actions: [

              IconButton(

                onPressed: () {

                  s.updateInvoiceSetting('primaryColor', '#6366F1');

                  s.updateInvoiceSetting('accentColor', '#10B981');

                  s.updateInvoiceSetting('useGradient', true);

                  s.updateInvoiceSetting('borderRadius', 8);

                  s.updateInvoiceSetting('accentBarHeight', 5);

                  s.updateInvoiceSetting('logoHeight', 55);

                  s.updateInvoiceSetting('sectionSpacing', 14);

                  s.updateInvoiceSetting('fontFamily', 'Cairo');

                  s.updateInvoiceSetting('fontSize', 12);

                  s.updateInvoiceSetting('companyNameSize', 20);

                  s.updateInvoiceSetting('lineHeight', 1.5);

                  s.updateInvoiceSetting('rowPadding', 7);

                  s.updateInvoiceSetting('tableHeaderStyle', 'gradient');

                  s.updateInvoiceSetting('tableRowStyle', 'alternating');

                  s.updateInvoiceSetting('invoiceBgColor', '#ffffff');

                  s.updateInvoiceSetting('textColor', '#1e293b');

                  s.updateInvoiceSetting('tableBorderColor', '#e2e8f0');

                  s.updateInvoiceSetting('qrSize', 100);

                  showAppToast(context, 'Reset done', icon: Icons.restore, color: AppColors.primary);

                },

                tooltip: 'Reset', icon: const Icon(Icons.restore),

              ),

            ],

          ),

          body: Column(children: [

            Container(

              height: 56,

              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))]),

              child: ListView.builder(

                scrollDirection: Axis.horizontal,

                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

                itemCount: tabData.length,

                itemBuilder: (_, i) {

                  final t = tabData[i];

                  final active = _tab == i;

                  return GestureDetector(

                    onTap: () => setState(() => _tab = i),

                    child: AnimatedContainer(

                      duration: const Duration(milliseconds: 250),

                      margin: const EdgeInsets.symmetric(horizontal: 3),

                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      decoration: BoxDecoration(

                        gradient: active ? LinearGradient(colors: AppColors.gradient1) : null,

                        color: active ? null : Colors.transparent,

                        borderRadius: BorderRadius.circular(12),

                        border: active ? null : Border.all(color: Colors.grey.shade200),

                      ),

                      child: Row(mainAxisSize: MainAxisSize.min, children: [

                        Icon(t['icon'] as IconData, size: 16, color: active ? Colors.white : Colors.grey),

                        const SizedBox(width: 6),

                        Text(t['label'] as String, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: active ? Colors.white : Colors.grey)),

                      ]),

                    ),

                  );

                },

              ),

            ),

            Expanded(

              child: Row(children: [

                SizedBox(width: 380, child: Container(color: Colors.white, child: _tabContent(s))),

                Container(width: 1, color: Colors.grey.shade200),

                Expanded(child: Padding(padding: const EdgeInsets.all(12), child: _preview(s))),

              ]),

            ),

          ]),

        );

      },

    );

  }

}



// ==================== SETTINGS ====================

class SettingsScreen extends StatelessWidget {

  const SettingsScreen({super.key});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: AppColors.bgOf(context),

      appBar: AppBar(title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold))),

      body: Consumer<DataStore>(

        builder: (_, store, __) {

          return ListView(

            padding: const EdgeInsets.all(16),

            children: [

              GlassCard(

                child: SwitchListTile(

                  contentPadding: EdgeInsets.zero,

                  secondary: Container(

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(

                      gradient: store.isDarkMode ? LinearGradient(colors: [Colors.indigo, Colors.indigo[700]!]) : LinearGradient(colors: [AppColors.warning, AppColors.warning.withOpacity(0.7)]),

                      borderRadius: BorderRadius.circular(12),

                    ),

                    child: Icon(store.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.white, size: 22),

                  ),

                  title: const Text('الوضع الليلي', style: TextStyle(fontWeight: FontWeight.w600)),

                  subtitle: Text(store.isDarkMode ? 'مفعّل' : 'معطّل'),

                  value: store.isDarkMode,

                  onChanged: (_) { HapticFeedback.lightImpact(); store.toggleDarkMode(); },

                ),

              ),

              const SizedBox(height: 12),

              GlassCard(

                child: SwitchListTile(

                  contentPadding: EdgeInsets.zero,

                  secondary: Container(

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: [AppColors.secondary, const Color(0xFF0891B2)]),

                      borderRadius: BorderRadius.circular(12),

                    ),

                    child: Icon(store.isEnglish ? Icons.language : Icons.translate, color: Colors.white, size: 22),

                  ),

                  title: Text(store.isEnglish ? 'Language' : 'اللغة', style: const TextStyle(fontWeight: FontWeight.w600)),

                  subtitle: Text(store.isEnglish ? 'English' : 'العربية'),

                  value: store.isEnglish,

                  onChanged: (_) { HapticFeedback.lightImpact(); store.toggleLanguage(); },

                ),

              ),

              const SizedBox(height: 12),

              GlassCard(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(children: [

                      const Icon(Icons.store, color: AppColors.primary, size: 20),

                      const SizedBox(width: 8),

                      const Text('بيانات البائع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    ]),

                    const SizedBox(height: 16),

                    TextFormField(

                      initialValue: store.sellerName,

                      decoration: const InputDecoration(labelText: 'اسم البائع / المتجر', border: OutlineInputBorder()),

                      onChanged: (v) { store.sellerName = v; store.save(); },

                    ),

                    const SizedBox(height: 12),

                    TextFormField(

                      initialValue: store.sellerPhone,

                      decoration: const InputDecoration(labelText: 'الهاتف', border: OutlineInputBorder()),

                      keyboardType: TextInputType.phone,

                      onChanged: (v) { store.sellerPhone = v; store.save(); },

                    ),

                    const SizedBox(height: 12),

                    TextFormField(

                      initialValue: store.sellerAddress,

                      decoration: const InputDecoration(labelText: 'العنوان', border: OutlineInputBorder()),

                      onChanged: (v) { store.sellerAddress = v; store.save(); },

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 12),

              // Invoice Settings Navigation

              GlassCard(

                child: ListTile(

                  contentPadding: EdgeInsets.zero,

                  leading: Container(

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient1), borderRadius: BorderRadius.circular(12)),

                    child: const Icon(Icons.receipt_long, color: Colors.white),

                  ),

                  title: const Text('إعدادات الفاتورة', style: TextStyle(fontWeight: FontWeight.w600)),

                  subtitle: const Text('النموذج، العنوان، العرض، والخيارات'),

                  trailing: const Icon(Icons.chevron_left),

                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InvoiceSettingsScreen())),

                ),

              ),

              const SizedBox(height: 12),

              GlassCard(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(children: [

                      const Icon(Icons.storage, color: AppColors.primary, size: 20),

                      const SizedBox(width: 8),

                      const Text('إدارة البيانات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    ]),

                    const SizedBox(height: 12),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient3), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.backup, color: Colors.white),

                      ),

                      title: const Text('نسخ احتياطي', style: TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: const Text('تصدير جميع البيانات'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () async {

                        final data = {

                          'v': '2',

                          'p': store.products.map((p) => {

                            if (p.name.isNotEmpty) 'n': p.name,

                            if (p.barcode.isNotEmpty) 'b': p.barcode,

                            'bp': p.buyPrice,

                            'sp': p.sellPrice,

                            'q': p.quantity,

                            if (p.unit.isNotEmpty && p.unit != 'قطعة') 'u': p.unit,

                            if (p.category.isNotEmpty) 'c': p.category,

                          }).toList(),

                          'c': store.customers.map((cu) => {

                            if (cu.name.isNotEmpty) 'n': cu.name,

                            if (cu.phone.isNotEmpty) 'p': cu.phone,

                            if (cu.address.isNotEmpty) 'a': cu.address,

                            if (cu.advanceBalance > 0) 'ab': cu.advanceBalance,

                          }).toList(),

                          'i': store.invoices.map((inv) => {

                            'id': inv.id,

                            'bn': inv.buyerName,

                            if (inv.buyerPhone.isNotEmpty) 'bp': inv.buyerPhone,

                            'd': inv.date,

                            'it': inv.items.map((it) => [

                              it.name, it.price, it.quantity,

                              if (it.discountPct > 0) it.discountPct,

                              if (it.discountAmt > 0) it.discountAmt,

                            ]).toList(),

                            if (inv.payments.isNotEmpty) 'py': inv.payments.map((p) => [

                              p.amount, p.date, p.method.index,

                            ]).toList(),

                            if (inv.discountPct > 0) 'dp': inv.discountPct,

                            if (inv.discountAmt > 0) 'da': inv.discountAmt,

                            if (inv.notes.isNotEmpty) 'no': inv.notes,

                            if (inv.dueDate != null) 'dd': inv.dueDate,

                            't': inv.template,

                          }).toList(),

                          'n': store.invoiceCounter,

                        };

                        final json = jsonEncode(data);

                        final sizeKb = (json.length / 1024).toStringAsFixed(1);

                        if (context.mounted) {

                          showModalBottomSheet(

                            context: context,

                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),

                            builder: (ctx) => SafeArea(

                              child: Column(

                                mainAxisSize: MainAxisSize.min,

                                children: [

                                  Padding(

                                    padding: const EdgeInsets.all(16),

                                    child: Column(children: [

                                      const Icon(Icons.cloud_upload, size: 40, color: AppColors.primary),

                                      const SizedBox(height: 8),

                                      const Text('نسخة احتياطية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                                      Text('${store.products.length} منتج • ${store.customers.length} عميل • ${store.invoices.length} فاتورة • ${sizeKb}KB', style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                                    ]),

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.chat, color: AppColors.whatsapp),

                                    title: const Text('واتساب'),

                                    onTap: () { Navigator.pop(ctx); shareWhatsAppBackup(json); },

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.send, color: Colors.blue),

                                    title: const Text('تيليجرام'),

                                    onTap: () { Navigator.pop(ctx); shareTelegramBackup(json); },

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.email, color: Colors.red),

                                    title: const Text('البريد الإلكتروني'),

                                    onTap: () { Navigator.pop(ctx); shareEmailBackup(json); },

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.content_copy, color: Colors.grey),

                                    title: const Text('نسخ النص'),

                                    onTap: () {

                                      Clipboard.setData(ClipboardData(text: json));

                                      Navigator.pop(ctx);

                                      showAppToast(context, 'تم نسخ النص', icon: Icons.check, color: AppColors.success);

                                    },

                                  ),

                                  const SizedBox(height: 8),

                                ],

                              ),

                            ),

                          );

                        }

                      },

                    ),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.secondary, const Color(0xFF0891B2)]), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.restore, color: Colors.white),

                      ),

                      title: const Text('استرجاع نسخة احتياطية', style: TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: const Text('استيراد البيانات من ملف .abk'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () async {

                        final ctrl = TextEditingController();

                        final result = await showDialog<String>(

                          context: context,

                          builder: (ctx) => AlertDialog(

                            title: const Text('استرجاع نسخة احتياطية'),

                            content: TextField(

                              controller: ctrl,

                              maxLines: 8,

                              decoration: const InputDecoration(

                                hintText: 'الصق النص الاحتياطي هنا...',

                                border: OutlineInputBorder(),

                              ),

                            ),

                            actions: [

                              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),

                              TextButton(onPressed: () => Navigator.pop(ctx, ctrl.text), child: const Text('استرجاع')),

                            ],

                          ),

                        );

                        if (result != null && result.isNotEmpty) {

                          try {

                            final data = jsonDecode(result) as Map<String, dynamic>;

                            if (data.containsKey('p')) {

                              for (final pm in (data['p'] as List)) {

                                final m = Map<String, dynamic>.from(pm);

                                store.addProduct(Product(

                                  id: const Uuid().v4(),

                                  name: m['n'] ?? '',

                                  barcode: m['b'] ?? '',

                                  buyPrice: (m['bp'] ?? 0).toDouble(),

                                  sellPrice: (m['sp'] ?? 0).toDouble(),

                                  quantity: m['q'] ?? 0,

                                  unit: m['u'] ?? 'قطعة',

                                  category: m['c'] ?? '',

                                ));

                              }

                            }

                            if (data.containsKey('c')) {

                              for (final cm in (data['c'] as List)) {

                                final m = Map<String, dynamic>.from(cm);

                                store.addCustomer(Customer(

                                  id: const Uuid().v4(),

                                  name: m['n'] ?? '',

                                  phone: m['p'] ?? '',

                                  address: m['a'] ?? '',

                                  advanceBalance: (m['ab'] ?? 0).toDouble(),

                                ));

                              }

                            }

                            if (data.containsKey('i')) {

                              for (final im in (data['i'] as List)) {

                                final m = Map<String, dynamic>.from(im);

                                store.addInvoice(Invoice(

                                  id: m['id'] ?? '',

                                  buyerName: m['bn'] ?? '',

                                  buyerPhone: m['bp'] ?? '',

                                  date: m['d'] ?? '',

                                  items: (m['it'] as List? ?? []).map((it) {

                                    final l = it as List;

                                    return InvoiceItem(

                                      productId: '',

                                      name: l[0].toString(),

                                      price: (l[1] ?? 0).toDouble(),

                                      quantity: (l[2] ?? 1).toInt(),

                                      discountPct: l.length > 3 ? (l[3] ?? 0).toDouble() : 0,

                                      discountAmt: l.length > 4 ? (l[4] ?? 0).toDouble() : 0,

                                    );

                                  }).toList(),

                                  payments: (m['py'] as List? ?? []).map((p) {

                                    final l = p as List;

                                    return Payment(

                                      amount: (l[0] ?? 0).toDouble(),

                                      date: l[1].toString(),

                                      method: PaymentMethod.values[l[2] ?? 0],

                                    );

                                  }).toList(),

                                  discountPct: (m['dp'] ?? 0).toDouble(),

                                  discountAmt: (m['da'] ?? 0).toDouble(),

                                  notes: m['no'] ?? '',

                                  dueDate: m['dd'],

                                  template: m['t'] ?? 'classic',

                                ));

                              }

                            }

                            store.save();

                            if (context.mounted) {

                              showAppToast(context, 'تم الاسترجاع - ${data['i']?.length ?? 0} فاتورة', icon: Icons.check_circle, color: AppColors.success);

                            }

                          } catch (e) {

                            if (context.mounted) {

                              showAppToast(context, 'خطأ في البيانات', icon: Icons.error, color: AppColors.danger);

                            }

                          }

                        }

                      },

                    ),

                    const Divider(),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient4), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.table_chart, color: Colors.white),

                      ),

                      title: const Text('تصدير المنتجات CSV', style: TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text('${store.products.length} منتج'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () => exportProductsCsv(store.products),

                    ),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient5), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.people, color: Colors.white),

                      ),

                      title: const Text('تصدير العملاء CSV', style: TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text('${store.customers.length} عميل'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () => exportCustomersCsv(store.customers),

                    ),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.receipt_long, color: Colors.white),

                      ),

                      title: const Text('تصدير الفواتير CSV', style: TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text('${store.invoices.length} فاتورة'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () => exportInvoicesCsv(store.invoices),

                    ),

                    const Divider(),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.danger, AppColors.danger.withOpacity(0.7)]), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.delete_forever, color: Colors.white),

                      ),

                      title: const Text('مسح جميع البيانات', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),

                      subtitle: const Text('حذف جميع الفواتير والمنتجات'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () {

                        showDialog(

                          context: context,

                          builder: (_) => AlertDialog(

                            title: const Text('مسح جميع البيانات'),

                            content: const Text('هل أنت متأكد؟ لا يمكن التراجع.'),

                            actions: [

                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),

                              TextButton(

                                onPressed: () {

                                  store.products.clear(); store.customers.clear(); store.invoices.clear(); store.invoiceCounter = 0;

                                  store.save(); Navigator.pop(context);

                                  showAppToast(context, 'تم مسح جميع البيانات', icon: Icons.delete, color: AppColors.danger);

                                },

                                child: const Text('مسح', style: TextStyle(color: AppColors.danger)),

                              ),

                            ],

                          ),

                        );

                      },

                    ),

                  ],

                ),

              ),

            ],

          );

        },

      ),

    );

  }

}



// ==================== STATUS HELPERS ====================

Color statusColor(String s) => s == 'paid' ? AppColors.success : (s == 'partial' ? AppColors.warning : AppColors.danger);

