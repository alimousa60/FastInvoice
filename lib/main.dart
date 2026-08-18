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

import 'package:shimmer/shimmer.dart';

import 'package:path_provider/path_provider.dart';



String fixPdfArabic(String text) {

  if (text.isEmpty) return text;

  const isolated = {0x0621: '\uFE8D', 0x0622: '\uFE8F', 0x0623: '\uFE93', 0x0624: '\uFE95', 0x0625: '\uFE99', 0x0626: '\uFE9B', 0x0627: '\uFE8D', 0x0628: '\uFE8F', 0x0629: '\uFE93', 0x062A: '\uFE95', 0x062B: '\uFE99', 0x062C: '\uFE9D', 0x062D: '\uFEA1', 0x062E: '\uFEA5', 0x062F: '\uFEA9', 0x0630: '\uFEAB', 0x0631: '\uFEAD', 0x0632: '\uFEAF', 0x0633: '\uFEB1', 0x0634: '\uFEB5', 0x0635: '\uFEB9', 0x0636: '\uFEBD', 0x0637: '\uFEC1', 0x0638: '\uFEC5', 0x0639: '\uFEC9', 0x063A: '\uFECD', 0x0640: '\uFE70', 0x0641: '\uFED1', 0x0642: '\uFED5', 0x0643: '\uFED9', 0x0644: '\uFEDD', 0x0645: '\uFEE1', 0x0646: '\uFEE5', 0x0647: '\uFEE9', 0x0648: '\uFEED', 0x0649: '\uFEEF', 0x064A: '\uFEF1'};

  final initial = {0x0622: '\uFE82', 0x0623: '\uFE84', 0x0625: '\uFE88', 0x0626: '\uFE9C', 0x0627: '\uFE8E', 0x0628: '\uFE91', 0x0629: '\uFE94', 0x062A: '\uFE97', 0x062B: '\uFE9C', 0x062C: '\uFE9F', 0x062D: '\uFEA3', 0x062E: '\uFEA7', 0x0633: '\uFEB3', 0x0634: '\uFEB7', 0x0635: '\uFEBB', 0x0636: '\uFEBF', 0x0637: '\uFEC3', 0x0638: '\uFEC7', 0x0639: '\uFECB', 0x063A: '\uFECF', 0x0641: '\uFED3', 0x0642: '\uFED7', 0x0643: '\uFEDB', 0x0644: '\uFEDF', 0x0645: '\uFEE3', 0x0646: '\uFEE7', 0x0647: '\uFEEB', 0x0649: '\uFEF0', 0x064A: '\uFEF3'};

  final medial = {0x0622: '\uFE83', 0x0623: '\uFE85', 0x0625: '\uFE89', 0x0626: '\uFE9D', 0x0627: '\uFE8F', 0x0628: '\uFE92', 0x062A: '\uFE98', 0x062B: '\uFE9D', 0x062C: '\uFEA0', 0x062D: '\uFEA4', 0x062E: '\uFEA8', 0x0633: '\uFEB4', 0x0634: '\uFEB8', 0x0635: '\uFEBC', 0x0636: '\uFEC0', 0x0637: '\uFEC4', 0x0638: '\uFEC8', 0x0639: '\uFECC', 0x063A: '\uFED0', 0x0641: '\uFED4', 0x0642: '\uFED8', 0x0643: '\uFEDC', 0x0644: '\uFEE0', 0x0645: '\uFEE4', 0x0646: '\uFEE8', 0x0647: '\uFEEC', 0x0649: '\uFEF1', 0x064A: '\uFEF4'};

  final finalF = {0x0622: '\uFE82', 0x0623: '\uFE84', 0x0625: '\uFE8A', 0x0626: '\uFE9A', 0x0627: '\uFE8E', 0x0628: '\uFE90', 0x062A: '\uFE96', 0x062B: '\uFE9B', 0x062C: '\uFE9E', 0x062D: '\uFEA2', 0x062E: '\uFEA6', 0x0633: '\uFEB2', 0x0634: '\uFEB6', 0x0635: '\uFEBA', 0x0636: '\uFEBE', 0x0637: '\uFEC2', 0x0638: '\uFEC6', 0x0639: '\uFECA', 0x063A: '\uFECE', 0x0640: '\uFE71', 0x0641: '\uFED2', 0x0642: '\uFED6', 0x0643: '\uFEDA', 0x0644: '\uFEDE', 0x0645: '\uFEE2', 0x0646: '\uFEE6', 0x0647: '\uFEEA', 0x0649: '\uFEEE', 0x064A: '\uFEF2'};

  final lamAlef = {0x0622: '\uFEF6', 0x0623: '\uFEF8', 0x0625: '\uFEFA', 0x0627: '\uFEFC'};

  bool isArabic(int c) => (c >= 0x0600 && c <= 0x06FF) || (c >= 0x0750 && c <= 0x077F) || (c >= 0x08A0 && c <= 0x08FF) || (c >= 0xFB50 && c <= 0xFDFF) || (c >= 0xFE70 && c <= 0xFEFF);

  bool isJoining(int c) => isArabic(c) && c != 0x0621 && c != 0x0622 && c != 0x0623 && c != 0x0624 && c != 0x0625 && c != 0x0627 && c != 0x0629 && c != 0x062F && c != 0x0630 && c != 0x0631 && c != 0x0632 && c != 0x0648 && c != 0x0649;

  final words = text.split(' ');

  final buffer = StringBuffer();

  for (final word in words) {

    if (word.isEmpty) { buffer.write(' '); continue; }

    final chars = word.codeUnits;

    final shaped = <int>[];

    for (int i = 0; i < chars.length; i++) {

      final c = chars[i];

      if (!isArabic(c)) { shaped.add(c); continue; }

      final prevJoin = i > 0 && isJoining(chars[i - 1]);

      final nextJoin = i < chars.length - 1 && isJoining(chars[i + 1]);

      if (c == 0x0644 && i < chars.length - 1 && lamAlef.containsKey(chars[i + 1])) {

        shaped.add(lamAlef[chars[i + 1]]!.codeUnitAt(0));

        i++;

        continue;

      }

      int form = 0;

      if (!prevJoin && !nextJoin) form = 0;

      else if (!prevJoin && nextJoin) form = 1;

      else if (prevJoin && nextJoin) form = 2;

      else form = 3;

      int mapped;

      switch (form) {

        case 1: mapped = (initial[c] ?? isolated[c] ?? String.fromCharCode(c)).codeUnitAt(0); break;

        case 2: mapped = (medial[c] ?? initial[c] ?? isolated[c] ?? String.fromCharCode(c)).codeUnitAt(0); break;

        case 3: mapped = (finalF[c] ?? isolated[c] ?? String.fromCharCode(c)).codeUnitAt(0); break;

        default: mapped = (isolated[c] ?? String.fromCharCode(c)).codeUnitAt(0); break;

      }

      shaped.add(mapped);

    }

    for (int i = shaped.length - 1; i >= 0; i--) {

      buffer.writeCharCode(shaped[i]);

    }

    buffer.write(' ');

  }

  return buffer.toString().trim();

}



pw.Text pdfText(String text, {pw.TextStyle? style}) =>

    pw.Text(fixPdfArabic(text), style: style);



// ==================== TRANSLATIONS ====================

final Map<String, String> _en = {
  'الفواتير': 'Invoices',
  'الدفعات': 'Payments',
  'المنتجات': 'Products',
  'العملاء': 'Customers',
  'الإحصائيات': 'Statistics',
  'الإعدادات': 'Settings',
  'فاتورة جديدة': 'New Invoice',
  'الوضع الليلي': 'Night Mode',
  'مفعّل': 'Enabled',
  'معطّل': 'Disabled',
  'اللغة': 'Language',
  'العربية': 'Arabic',
  'English': 'English',
  'بحث...': 'Search...',
  'ترتيب': 'Sort',
  'تصفية': 'Filter',
  'الكل': 'All',
  'مدفوعة': 'Paid',
  'جزئية': 'Partial',
  'غير مدفوعة': 'Unpaid',
  'الإجمالي': 'Total',
  'المتبقي': 'Remaining',
  'المدفوع': 'Paid',
  'المبلغ': 'Amount',
  'حفظ': 'Save',
  'إلغاء': 'Cancel',
  'حذف': 'Delete',
  'إضافة': 'Add',
  'تأكيد': 'Confirm',
  'استرجاع': 'Restore',
  'تطبيق': 'Apply',
  'إغلاق': 'Close',
  'مشاركة': 'Share',
  'تصدير': 'Export',
  'نسخ احتياطي': 'Backup',
  'استرجاع نسخة احتياطية': 'Restore Backup',
  'تصدير جميع البيانات': 'Export all data',
  'استيراد من ملف نسخ احتياطي': 'Import from backup file',
  'تصدير المنتجات CSV': 'Export Products CSV',
  'تصدير العملاء CSV': 'Export Customers CSV',
  'تصدير الفواتير CSV': 'Export Invoices CSV',
  'مسح جميع البيانات': 'Clear All Data',
  'هل أنت متأكد من حذف جميع الفواتير والمنتجات؟': 'Delete all invoices and products?',
  'لا توجد فواتير': 'No Invoices',
  'لا توجد منتجات': 'No Products',
  'لا يوجد عملاء': 'No Customers',
  'لا توجد دفعات بعد': 'No Payments Yet',
  'ابدأ بإنشاء فاتورة جديدة': 'Start by creating a new invoice',
  'أضف منتجاتك للبدء': 'Add your products to start',
  'أضف عملاءك لتتبع فواتيرهم': 'Add your customers to track their invoices',
  'إضافة منتج': 'Add Product',
  'إضافة عميل': 'Add Customer',
  'اسم المنتج *': 'Product Name *',
  'الباركود': 'Barcode',
  'سعر الشراء': 'Buy Price',
  'سعر البيع *': 'Sell Price *',
  'الكمية': 'Quantity',
  'الفئة': 'Category',
  'الوحدة': 'Unit',
  'اسم العميل *': 'Customer Name *',
  'الهاتف': 'Phone',
  'العنوان': 'Address',
  'طريقة الدفع': 'Payment Method',
  'نقدي': 'Cash',
  'تحويل بنكي': 'Bank Transfer',
  'جوال': 'Mobile',
  'شيك': 'Check',
  'بطاقة ائتمان': 'Credit Card',
  'أخرى': 'Other',
  'خصم': 'Discount',
  'المجموع الفرعي': 'Subtotal',
  'ملاحظات': 'Notes',
  'تاريخ الاستحقاق': 'Due Date',
  'القالب': 'Template',
  'كلاسيكي': 'Classic',
  'عصري': 'Modern',
  'بسيط': 'Simple',
  'مؤسسي': 'Corporate',
  'ملون': 'Colorful',
  'داكن': 'Dark',
  'الأحدث أولاً': 'Newest First',
  'الأقدم أولاً': 'Oldest First',
  'الأعلى مبلغاً': 'Highest Amount',
  'الأقل مبلغاً': 'Lowest Amount',
  'حسب اسم العميل': 'By Customer Name',
  'تصفية متقدمة': 'Advanced Filter',
  'مسح التصفية': 'Clear Filter',
  'من تاريخ:': 'From Date:',
  'إلى تاريخ:': 'To Date:',
  'الحد الأدنى:': 'Min Amount:',
  'الحد الأقصى:': 'Max Amount:',
  'معلومات البائع': 'Seller Info',
  'إعدادات الفاتورة': 'Invoice Settings',
  'إدارة البيانات': 'Data Management',
  'القالب الافتراضي': 'Default Template',
  'يُستخدم تلقائياً عند إنشاء فاتورة جديدة': 'Used automatically when creating new invoice',
  'تم تغيير القالب الافتراضي': 'Default template changed',
  'تم الحفظ': 'Saved',
  'تم الحذف': 'Deleted',
  'خطأ في البيانات': 'Error in data',
  'واتساب': 'WhatsApp',
  'تيليجرام': 'Telegram',
  'نسخ النص': 'Copy Text',
  'دفع سريع': 'Quick Pay',
  'النصف': 'Half',
  'الربع': 'Quarter',
  'الثلث': 'Third',
  'كشف حساب العميل': 'Customer Statement',
  'شراء': 'Purchase',
  'بيع': 'Sale',
  'قطعة': 'Piece',
  'قطعة2': 'pcs',
  'إجمالي المبيعات': 'Total Sales',
  'المتوسط': 'Average',
  'أكبر العملاء': 'Top Customers',
  'أحدث الفواتير': 'Recent Invoices',
  'فواتير متأخرة': 'Overdue Invoices',
  'أيام تأخير': 'days overdue',
  'أيام متبقية': 'days left',
  'متأخرة': 'Overdue',
  'إنشاء فواتير': 'Create Invoices',
  'أنشئ فواتير مبيعات احترافية بنقرة واحدة': 'Create professional sales invoices with one tap',
  'مشاركة فورية': 'Instant Sharing',
  'شارك الفواتير عبر واتساب أو تيليجرام أو PDF': 'Share invoices via WhatsApp, Telegram or PDF',
  'تتبع ذكي': 'Smart Tracking',
  'تتبع المبيعات والعملاء بإحصائيات تفصيلية': 'Track sales and customers with detailed statistics',
  'تخطي': 'Skip',
  'التالي': 'Next',
  'ابدأ': 'Start',
  'أدخل المبلغ': 'Enter amount',
  'اختر العميل': 'Select customer',
  'نوع الدفعة': 'Payment Type',
  'فاتورة واحدة': 'Single Invoice',
  'عدة فواتير': 'Multi Invoice',
  'دفعة مقدمة': 'Advance Payment',
  'حفظ الدفعة المقدمة': 'Save Advance Payment',
  'تأكيد الدفع': 'Confirm Payment',
  'تأكيد الاستلام': 'Confirm Receive',
  'استلام': 'Receive',
  'العناصر': 'Items',
  'اختر تاريخ الاستحقاق': 'Tap to select due date',
  '(يمكن تغييره في الإعدادات)': '(can be changed in settings)',
  'الصورة': 'Image',
  'حذف المنتج': 'Delete Product',
  'حذف العميل': 'Delete Customer',
  'هل أنت متأكد من الحذف': 'Are you sure you want to delete',
  'قائمة الأسعار': 'Price List',
  'تنبيه التأخير': 'Overdue Alert',
  'ما الجديد': "What's New",
  'تم': 'Done',
  'الصق نص النسخة الاحتياطية هنا...': 'Paste backup text here...',
  'فاتورة': 'Invoice',
  'دفعة': 'Payment',
  'فواتير اليوم': 'Today Invoices',
  'مبيعات الشهر': 'Month Sales',
  'المتبقي الكلي': 'Total Remaining',
  'لا توجد نتائج': 'No results',
  'بحث بالاسم أو الفئة...': 'Search by name, category or barcode...',
  'جميع العناصر': 'All Items',
  'متوفر': 'In Stock',
  'غير متوفر': 'Out of Stock',
  'بالاسم أ-ي': 'Name A-Z',
  'بالاسم ي-أ': 'Name Z-A',
  'بالسعر من الأقل': 'Price Low-High',
  'بالسعر من الأعلى': 'Price High-Low',
  'بالكمية من الأقل': 'Qty Low-High',
  'بالكمية من الأعلى': 'Qty High-Low',
  'تعديل المنتج': 'Edit Product',
  'إضافة منتج جديد': 'Add New Product',
  'حفظ التغييرات': 'Save Changes',
  'الرصيد': 'Balance',
  'لديهم رصيد': 'With Balance',
  'لديهم فواتير': 'With Invoices',
  'بدون فواتير': 'Without Invoices',
  'لديهم هاتف': 'With Phone',
  'عميل': 'customers',
  'الإشعارات': 'Notifications',
  'نفذ من المخزون': 'Out of Stock',
  'مخزون منخفض': 'Low Stock',
  'لا توجد إشعارات': 'No notifications',
  'كل شيء محدث!': 'All caught up!',
  'لاحقاً': 'Later',
  'عرض الكل': 'View All',
  'ما الجديد في هذا الإصدار': "What's New in This Version",
  'النسخ الاحتياطي': 'Backup',
  'استيراد من نص نسخة احتياطية': 'Import from backup text',
  'حذف جميع الفواتير والمنتجات': 'Delete all invoices and products',
  'هل أنت متأكد؟ لا يمكن التراجع': 'Are you sure? Cannot be undone.',
  'تأكيد الحذف': 'Confirm Delete',
  'نعم': 'Yes',
  'لا': 'No',
  'اسم العنصر': 'Item Name',
  'السعر': 'Price',
  'الخصم': 'Discount',
  'اختر اللغة': 'Select Language',
  'الوضع النهاري': 'Light Mode',
  'التوفير': 'Savings',
  'الرصيد المقدم': 'Advance Balance',
  'استخدام الرصيد المقدم': 'Use advance balance',
  'تم حفظ الدفعة المقدمة': 'Advance payment saved',
  'تم استلام الدفعة': 'Payment received',
  'يتجاوز المتبقي': 'Exceeds remaining amount',
  'أدخل اسم المنتج': 'Enter product name',
  'أدخل رقم الهاتف': 'Enter phone number',
  'أدخل العنوان': 'Enter address',
  'طباعة الإيصال': 'Print Receipt',
  'مبيعات يومية': 'Daily Sales',
  'مبيعات شهرية': 'Monthly Sales',
  'أعلى المنتجات': 'Top Products',
  'أحدث الدفعات': 'Recent Payments',
  'بيانات البائع': 'Seller Info',
  'اسم البائع / المتجر': 'Seller / Shop Name',
  'البريدي': 'Email',
  'البريد الإلكتروني': 'Email',
  'النموذج، العنوان، العرض، والخيارات': 'Template, layout, display & options',
  'نسخة احتياطية': 'Backup',
  'منتج • … عميل • … فاتورة • …': 'product • ... customer • ... invoice • ...',
  'إلغاء': 'Cancel',
  'الصق النص الاحتياطي هنا...': 'Paste backup text here...',
  'تم الترحيل من نسخة احتياطية': 'Migrated from backup',
  '-msl': '',
  'msl-sdg': '',
  'الإصدار': 'Version',
  'مسح': 'Clear',
  'الميزات الجديدة': 'New Features',
  'إصلاحات': 'Fixes',
  'نظام فواتير متكامل': 'Complete Invoice System',
  'إنشاء فواتير احترافية': 'Create Professional Invoices',
  'قم بإنشاء فواتير مبيعات احترافية بضغطة زر': 'Create professional sales invoices with one tap',
  'شارك الفواتير عبر واتساب أو تيليجرام أو PDF': 'Share invoices via WhatsApp, Telegram or PDF',
  'تتبع المبيعات والعملاء مع إحصائيات مفصلة': 'Track sales and customers with detailed statistics',
  'تنبيه: فواتير متأخرة': 'Alert: Overdue Invoices',
  'لحظة...': 'Moment...',
  'عرض الكل': 'View All',
  'استلام دفعة': 'Receive Payment',
  'الزبون': 'Customer',
  'اختر الزبون': 'Select Customer',
  'balancecustomers': 'Customer Balance',
  'توزيع المبلغ على الفواتير': 'Distribute amount across invoices',
  'حفظ دفعة مقدمة': 'Save Advance Payment',
  'توزيع على': 'Distribute to',
  'فاتور(s)': 'invoice(s)',
  'تأكيد الدفعة': 'Confirm Payment',
  'تم حفظ دفعة مقدمة': 'Advance payment saved',
  'تم استلام': 'Received',
  'للفاتورة': 'for invoice',
  'المبلغ يتجاوز المتبقي': 'Amount exceeds remaining',
  'ضع الباركود داخل الإطار': 'Place barcode inside frame',
  'مسح الباركود': 'Scan Barcode',
  'المحصّل': 'Collected',
  'فواتير مفتوحة': 'Open Invoices',
  'استلام دفعة سريعة': 'Quick Payment',
  'جميع الفواتير مدفوعة!': 'All invoices paid!',
  'جميع الفواتير مدفوعة': 'All invoices paid',
  'بحث في الدفعات...': 'Search payments...',
  '💵 نقدي': '💵 Cash',
  '🏦 بنكي': '🏦 Bank',
  '📱 موبايل': '📱 Mobile',
  '📄 شيك': '📄 Check',
  '💳 ائتمان': '💳 Card',
  'لا نتائج': 'No results',
  'الكل': 'All',
  'التنبيهات': 'Notifications',
  'انتهى من المخزون': 'Out of stock',
  'متبقي فقط': 'only left',
  'بحث...': 'Search...',
  'فلتر': 'Filter',
  'ابدأ بإنشاء فاتورة جديدة': 'Start by creating a new invoice',
  'جرّب البحث بكلمات مختلفة': 'Try different keywords',
  'فاتورة جديدة': 'New Invoice',
  'ترتيب حسب': 'Sort by',
  'فلتر متقدم': 'Advanced Filter',
  'مسح الفلتر': 'Clear Filter',
  'اختر التاريخ': 'Select Date',
  'الحد الأدنى:': 'Min:',
  'الحد الأعلى:': 'Max:',
  'اليوم': 'Today',
  'الشهر': 'Month',
  'تم السداد': 'Paid',
  'تعديل السعر': 'Edit Price',
  'سعر البيع': 'Sell Price',
  'تعديل الكمية': 'Edit Quantity',
  'اختر المنتج': 'Select Product',
  'لا توجد منتجات': 'No Products',
  'أضف أصنافاً أولاً': 'Add items first',
  'أدخل اسم العميل': 'Enter customer name',
  'تم حفظ الفاتورة': 'Invoice saved',
  'الأصناف': 'Items',
  'اضغط "إضافة" لاختيار منتج': 'Press "Add" to select a product',
  'مشاركة الفاتورة': 'Share Invoice',
  'اسم العميل': 'Customer Name',
  'بيانات العميل': 'Customer Info',
  'اختر عميل': 'Select Customer',
  'الخصم والمجموع': 'Discount & Total',
  'خصم %': 'Discount %',
  'خصم مبلغ': 'Discount Amount',
  'الإجمالي الفرعي': 'Subtotal',
  'المجموع': 'Total',
  'اضغط لاختيار تاريخ الاستحقاق': 'Tap to select due date',
  'رجوع': 'Back',
  'حفظ الفاتورة': 'Save Invoice',
  'إضافة دفعة': 'Add Payment',
  'رقم المرجع/المعاملة': 'Reference / Transaction #',
  'ملاحظات (اختياري)': 'Notes (optional)',
  'تم تسجيل دفعة': 'Payment recorded',
  'فاتورة': 'Invoice',
  'سجل الدفعات': 'Payment History',
  'دفعة': 'Payment',
  'دفعة -': 'Payment -',
  'إيصال الدفع': 'Payment Receipt',
  'كشف حساب': 'Statement',
  'المشتريات': 'Purchases',
  'المدفوعات': 'Payments',
  'لا توجد فواتير لهذا العميل': 'No invoices for this customer',
  'سجل المعاملات': 'Transaction History',
  'صورة': 'Image',
  'التصنيف': 'Category',
  'شراء': 'Buy',
  'بيع': 'Sell',
  'حفظ المنتج': 'Save Product',
  'تم إضافة المنتج': 'Product added',
  'بحث بالاسم أو التصنيف أو الباركود...': 'Search by name, category or barcode...',
  'متوفر': 'In Stock',
  'نفذ': 'Out',
  'اسم': 'Name',
  'سعر ↑': 'Price ↑',
  'سعر ↓': 'Price ↓',
  'كمية ↑': 'Qty ↑',
  'كمية ↓': 'Qty ↓',
  'هل أنت متأكد من حذف': 'Are you sure you want to delete',
  'تم حذف': 'Deleted',
  'حفظ التعديلات': 'Save Changes',
  'تم تعديل المنتج': 'Product updated',
  'حذف العميل': 'Delete Customer',
  'هل أنت متأكد من حذف': 'Are you sure you want to delete',
  'تم حذف العميل': 'Customer deleted',
  'يمكن': 'can',
  'لديه فواتير': 'has invoices',
  'بدون فواتير': 'without invoices',
  'رصيد مقدم': 'Advance balance',
  'مع هاتف': 'with phone',
  'بحث بالاسم أو الهاتف...': 'Search by name or phone...',
  'عدد الفواتير': 'Invoice count',
  'الرصيد الأعلى': 'Highest balance',
  'الإحصائيات': 'Statistics',
  'أفضل العملاء': 'Top Customers',
  'آخر الفواتير': 'Recent Invoices',
  'د.ل': 'LYD',
  'قوالب محفوظة': 'Saved Templates',
  'تم تحميل القالب': 'Template loaded',
  'تم حذف القالب': 'Template deleted',
  'حفظ كقالب': 'Save as Template',
  'حفظ القالب': 'Save Template',
  'اسم القالب': 'Template Name',
  ' invoices': 'invoices',
  'الإجمالي': 'Total',
  'الفواتير': 'Invoices',
  'المدفوع': 'Paid',
  'المتوسط': 'Average',
  'المتبقي': 'Remaining',
  'المنتجات': 'Products',
  'العملاء': 'Customers',
  'الإعدادات': 'Settings',
  'مدفوع': 'Paid',
  'جزئي': 'Partial',
  'غير مدفوع': 'Unpaid',
  'نقدي': 'Cash',
  'تحويل بنكي': 'Bank Transfer',
  'موبايل موني': 'Mobile Money',
  'شيك': 'Check',
  'بطاقة ائتمان': 'Credit Card',
  'أخرى': 'Other',
  'سعر البيع *': 'Sell Price *',
  'الكمية': 'Quantity',
  'تم التوزيع. متبقي': 'Distributed. Remaining',
  'غير موزع': 'undistributed',
  'تم توزيع': 'Distributed',
  'على الفواتير': 'across invoices',
  'حفظ الدفعة': 'Save Payment',
  'فواتير': 'invoices',
  'تعديل الفاتورة': 'Edit Invoice',
  'مدفوع': 'Paid',
  'جزئي': 'Partial',
  'غير مدفوع': 'Unpaid',
  'نقدي': 'Cash',
  'تحويل بنكي': 'Bank Transfer',
  'موبايل موني': 'Mobile Money',
  'شيك': 'Check',
  'بطاقة ائتمان': 'Credit Card',
  'أخرى': 'Other',
  'العميل': 'Customer',
  'فاتورة رقم': 'Invoice #',
  'التاريخ': 'Date',
  'نص': 'Text',
  'الألوان': 'Colors',
  'التخطيط': 'Layout',
  'الخط': 'Font',
  'الجدول': 'Table',
  'الأقسام': 'Sections',
  'المحتوى': 'Content',
  'الثيمات الجاهزة': 'Preset Themes',
  'ألوان مخصصة': 'Custom Colors',
  'اللون الأساسي': 'Primary Color',
  'اللون الثانوي': 'Secondary Color',
  'ألوان إضافية': 'Additional Colors',
  'لون النص': 'Text Color',
  'لون الحدود': 'Border Color',
  'الورقة': 'Paper',
  'عمودي': 'Portrait',
  'أفقي': 'Landscape',
  'الأبعاد': 'Dimensions',
  'نصف قطر الحدود': 'Border Radius',
  'شريط التمييز': 'Accent Bar',
  'ارتفاع الشعار': 'Logo Height',
  'تباعد الأقسام': 'Section Spacing',
  'حجم رمز QR': 'QR Size',
  'موضع الشعار': 'Logo Position',
  'يسار': 'Left',
  'وسط': 'Center',
  'يمين': 'Right',
  'نوع الخط': 'Font Family',
  'أمثلة نصية': 'Sample text',
  'الأحجام': 'Sizes',
  'الخط الأساسي': 'Base Font',
  'اسم الشركة': 'Company Name',
  'ارتفاع السطر': 'Line Height',
  'حشو الصف': 'Row Padding',
  'نمط الرأس': 'Header Style',
  'صلب': 'Solid',
  'مخطط': 'Outline',
  'نظيف': 'Clean',
  'نمط الصف': 'Row Style',
  'متناوب': 'Alternating',
  'حدود': 'Borders',
  'الأعمدة': 'Columns',
  'رقم الصنف': 'Item Number',
  'سعر الوحدة': 'Unit Price',
  'الخصم': 'Discount',
  'إظهار / إخفاء الأقسام': 'Show / Hide Sections',
  'الشعار': 'Logo',
  'معلومات الشركة': 'Company Info',
  'الرقم الضريبي': 'Tax Number',
  'شارة الدفع': 'Payment Badge',
  'شبكة المعلومات': 'Info Grid',
  'رمز QR': 'QR Code',
  'الشروط': 'Terms',
  'الختم': 'Stamps',
  'ملاحظات': 'Notes',
  'تفاصيل الدفع': 'Payment Details',
  'معلومات الفاتورة': 'Invoice Info',
  'عنوان الفاتورة': 'Invoice Title',
  'العنوان الفرعي': 'Subtitle',
  'الرقم الابتدائي': 'Start Number',
  'العملة': 'Currency',
  'نص التذييل': 'Footer Text',
  'الشروط والأحكام': 'Terms & Conditions',
  'شريطة واحدة لكل سطر': 'One term per line',
  'عنوان مخصص': 'Custom Title',
  'عنوان فاتورة مخصص': 'Custom Invoice Title',
  'اتركه فارغاً للإفتراضي': 'Leave empty for default',
  'معاينة': 'Preview',
  'غير مدفوعة': 'Unpaid',
  'اسم المتجر': 'Store Name',
  'الإجمالي الفرعي': 'Subtotal',
  'المتبقي': 'Remaining',
  'ملاحظات إضافية...': 'Additional notes...',
  'ختم البائع': 'Seller Stamp',
  'توقيع المشتري': 'Buyer Signature',
  'المنتج': 'Product',
  'السعر': 'Price',
  'الكمية': 'Qty',
  'الإجمالي': 'Total',
  'المدفوع': 'Paid',
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



Future<void> exportCustomersCsv(List<Customer> customers, DataStore store) async {

  final rows = <String>[

    _csvRow(['اسم العميل', 'الهاتف', 'العنوان', 'الرصيد']),

    ...customers.map((c) => _csvRow([

      c.name, c.phone, c.address, store.getCustomerAdvanceBalance(c.name).toStringAsFixed(2),

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



String paymentMethodName(PaymentMethod m, {bool isEnglish = false}) {

  switch (m) {

    case PaymentMethod.cash: return tr('نقدي', isEng: isEnglish);

    case PaymentMethod.bankTransfer: return tr('تحويل بنكي', isEng: isEnglish);

    case PaymentMethod.mobileMoney: return tr('موبايل موني', isEng: isEnglish);

    case PaymentMethod.check: return tr('شيك', isEng: isEnglish);

    case PaymentMethod.creditCard: return tr('بطاقة ائتمان', isEng: isEnglish);

    case PaymentMethod.other: return tr('أخرى', isEng: isEnglish);

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

  double appliedAmount;



  Payment({required this.amount, required this.date, this.method = PaymentMethod.cash, this.receiptNumber, this.referenceNumber, this.notes, this.customerId, this.invoiceId, this.appliedAmount = 0})

    : id = 'PAY-${DateTime.now().millisecondsSinceEpoch}';



  double get remainingAmount => amount - appliedAmount;



  Map<String, dynamic> toMap() => {

    'id': id, 'amount': amount, 'date': date, 'method': method.index,

    'receiptNumber': receiptNumber, 'referenceNumber': referenceNumber, 'notes': notes,

    'customerId': customerId, 'invoiceId': invoiceId, 'appliedAmount': appliedAmount,

  };

  factory Payment.fromMap(Map<String, dynamic> m) {

    PaymentMethod method = PaymentMethod.cash;

    final rawMethod = m['method'];

    if (rawMethod is int && rawMethod < PaymentMethod.values.length) {

      method = PaymentMethod.values[rawMethod];

    } else if (rawMethod is String) {

      if (rawMethod.contains('تحويل')) {
        method = PaymentMethod.bankTransfer;
      } else if (rawMethod.contains('موبايل')) method = PaymentMethod.mobileMoney;

      else if (rawMethod.contains('شيك')) method = PaymentMethod.check;

      else if (rawMethod.contains('بطاقة')) method = PaymentMethod.creditCard;

      else if (rawMethod.contains('أخرى')) method = PaymentMethod.other;

    }

    return Payment(

      amount: (m['amount'] ?? 0).toDouble(), date: m['date'] ?? '',

      method: method,

      receiptNumber: m['receiptNumber'], referenceNumber: m['referenceNumber'], notes: m['notes'],

      customerId: m['customerId'], invoiceId: m['invoiceId'],

      appliedAmount: (m['appliedAmount'] ?? 0).toDouble(),

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

  double allocatedFromAdvance;

  String? advancePaymentId;



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

    this.allocatedFromAdvance = 0,

    this.advancePaymentId,

  });



  double get subtotal => items.fold(0, (s, i) => s + i.lineTotal);

  double get total => subtotal - discountAmt - (subtotal * discountPct / 100);

  double get totalPaid => payments.fold(0.0, (s, p) => s + p.amount) + allocatedFromAdvance;

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

    'allocatedFromAdvance': allocatedFromAdvance, 'advancePaymentId': advancePaymentId,

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

    allocatedFromAdvance: (m['allocatedFromAdvance'] ?? 0).toDouble(),

    advancePaymentId: m['advancePaymentId'],

  );

}



// ==================== DESIGN SYSTEM ====================

class AppColors {

  static const primary = Color(0xFF6366F1);

  static const primaryLight = Color(0xFF818CF8);

  static const primaryDark = Color(0xFF4F46E5);

  static const secondary = Color(0xFF06B6D4);

  static const accent = Color(0xFF8B5CF6);

  static const success = Color(0xFF10B981);

  static const danger = Color(0xFFEF4444);

  static const warning = Color(0xFFF59E0B);

  static const whatsapp = Color(0xFF25D366);

  static const bg = Color(0xFFFFFFFF);

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

  static Color bgOf(BuildContext c) => _isDark(c) ? const Color(0xFF0F172A) : const Color(0xFFFFFFFF);

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

  static Color shimmerBaseOf(BuildContext c) => _isDark(c) ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0);

  static Color shimmerHighlightOf(BuildContext c) => _isDark(c) ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

}



// ==================== APP ====================

class MainApp extends StatelessWidget {

  const MainApp({super.key});



  @override

  Widget build(BuildContext context) {

    return ChangeNotifierProvider(

      create: (_) => DataStore()..load(),

      child: Consumer<DataStore>(

        builder: (_, store, _) {

          return MaterialApp(

            title: 'FastInvoice',

            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primary,
                secondary: AppColors.secondary,
                error: AppColors.danger,
                surface: Colors.white,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                iconTheme: IconThemeData(color: AppColors.textPrimary),
                titleTextStyle: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cardTheme: CardThemeData(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: Colors.white,
                elevation: 0,
                indicatorColor: AppColors.primary.withValues(alpha: 0.12),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 11);
                  }
                  return TextStyle(color: AppColors.textSecondary, fontSize: 11);
                }),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                filled: true,
                fillColor: Colors.white,
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              ),
            ),

            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
                primary: AppColors.primaryLight,
                secondary: AppColors.secondary,
                error: AppColors.danger,
                surface: const Color(0xFF1E293B),
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              cardTheme: CardThemeData(
                color: const Color(0xFF1E293B),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                margin: const EdgeInsets.only(bottom: 12),
              ),
              navigationBarTheme: NavigationBarThemeData(
                backgroundColor: const Color(0xFF1E293B),
                elevation: 0,
                indicatorColor: AppColors.primaryLight.withValues(alpha: 0.2),
                labelTextStyle: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return const TextStyle(color: AppColors.primaryLight, fontWeight: FontWeight.w600, fontSize: 11);
                  }
                  return const TextStyle(color: Color(0xFF94A3B8), fontSize: 11);
                }),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                filled: true,
                fillColor: const Color(0xFF334155),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Color(0xFF1E293B),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              ),
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

    final shadowColor = isDark ? Colors.black.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.05);

    final borderColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.3);

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: margin ?? const EdgeInsets.only(bottom: 12),

        clipBehavior: Clip.antiAlias,

        decoration: BoxDecoration(

          color: cardColor.withValues(alpha: opacity),

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

        child: Container(

          padding: padding ?? const EdgeInsets.all(16),

          decoration: BoxDecoration(

            gradient: LinearGradient(

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

              colors: [

                cardColor.withValues(alpha: 0.5),

                cardColor.withValues(alpha: 0.2),

              ],

            ),

          ),

          child: child,

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



class GradientButton extends StatefulWidget {

  final String label;

  final IconData icon;

  final List<Color> gradient;

  final VoidCallback onPressed;

  final bool isExpanded;

  final bool isLoading;

  final bool enabled;



  const GradientButton({

    super.key,

    required this.label,

    required this.icon,

    required this.gradient,

    required this.onPressed,

    this.isExpanded = false,

    this.isLoading = false,

    this.enabled = true,

  });



  @override

  State<GradientButton> createState() => _GradientButtonState();

}



class _GradientButtonState extends State<GradientButton> {

  bool _isPressed = false;



  @override

  Widget build(BuildContext context) {

    final btn = GestureDetector(

      onTapDown: widget.enabled ? (_) => setState(() => _isPressed = true) : null,

      onTapUp: widget.enabled ? (_) => setState(() => _isPressed = false) : null,

      onTapCancel: widget.enabled ? () => setState(() => _isPressed = false) : null,

      child: AnimatedScale(

        scale: _isPressed ? 0.95 : 1.0,

        duration: const Duration(milliseconds: 100),

        curve: Curves.easeInOut,

        child: Opacity(

          opacity: widget.enabled ? 1.0 : 0.5,

          child: Material(

            color: Colors.transparent,

            child: InkWell(

              onTap: widget.enabled && !widget.isLoading ? widget.onPressed : null,

              borderRadius: BorderRadius.circular(16),

              child: Ink(

                decoration: BoxDecoration(

                  gradient: LinearGradient(colors: widget.gradient),

                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [

                    BoxShadow(

                      color: widget.gradient.first.withValues(alpha: 0.4),

                      blurRadius: 12,

                      offset: const Offset(0, 4),

                    ),

                  ],

                ),

                child: Padding(

                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),

                  child: Row(

                    mainAxisSize: widget.isExpanded ? MainAxisSize.max : MainAxisSize.min,

                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [

                      widget.isLoading

                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))

                          : Icon(widget.icon, color: Colors.white, size: 20),

                      const SizedBox(width: 8),

                      Text(widget.label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),

                    ],

                  ),

                ),

              ),

            ),

          ),

        ),

      ),

    );

    return widget.isExpanded ? SizedBox(width: double.infinity, child: btn) : btn;

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

      builder: (_, _) => Text(

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

            color: gradient.first.withValues(alpha: 0.3),

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

            Text(subtitle!, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),

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

        color: color.withValues(alpha: 0.1),

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: color.withValues(alpha: 0.3)),

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

  void saveCurrentAsTemplate(String name) {

    final template = {

      'name': name,

      'date': DateTime.now().toIso8601String(),

      'primaryColor': _primaryColor,

      'accentColor': _accentColor,

      'useGradient': _useGradient,

      'borderRadius': _borderRadius,

      'accentBarHeight': _accentBarHeight,

      'logoHeight': _logoHeight,

      'sectionSpacing': _sectionSpacing,

      'fontFamily': _fontFamily,

      'fontSize': _fontSize,

      'companyNameSize': _companyNameSize,

      'lineHeight': _lineHeight,

      'showLogo': _showLogo,

      'showCompanyInfo': _showCompanyInfo,

      'showSellerInfo': _showSellerInfo,

      'showInfoGrid': _showInfoGrid,

      'showBadge': _showBadge,

      'showNotes': _showNotes,

      'showQrCode': _showQrCode,

      'showStamps': _showStamps,

      'showTerms': _showTerms,

      'showTaxNo': _showTaxNo,

      'invoiceTitle': _invoiceTitle,

      'invoiceSubtitle': _invoiceSubtitle,

      'currencySymbol': _currencySymbol,

      'footerText': _footerText,

      'tableHeaderStyle': _tableHeaderStyle,

      'tableRowStyle': _tableRowStyle,

      'paperSize': _paperSize,

      'textColor': _textColor,

      'accentBorderColor': _accentBorderColor,

    };

    _savedTemplates.add(template);

    _activeTemplate = name;

    save();

  }

  void loadTemplate(int index) {

    if (index < 0 || index >= _savedTemplates.length) return;

    final t = _savedTemplates[index];

    _primaryColor = t['primaryColor'] ?? '#6366F1';

    _accentColor = t['accentColor'] ?? '#10B981';

    _useGradient = t['useGradient'] ?? true;

    _borderRadius = (t['borderRadius'] ?? 8).toDouble();

    _accentBarHeight = (t['accentBarHeight'] ?? 5).toDouble();

    _logoHeight = (t['logoHeight'] ?? 55).toDouble();

    _sectionSpacing = (t['sectionSpacing'] ?? 14).toDouble();

    _fontFamily = t['fontFamily'] ?? 'Cairo';

    _fontSize = (t['fontSize'] ?? 12).toDouble();

    _companyNameSize = (t['companyNameSize'] ?? 20).toDouble();

    _lineHeight = (t['lineHeight'] ?? 1.5).toDouble();

    _showLogo = t['showLogo'] ?? true;

    _showCompanyInfo = t['showCompanyInfo'] ?? true;

    _showSellerInfo = t['showSellerInfo'] ?? true;

    _showInfoGrid = t['showInfoGrid'] ?? true;

    _showBadge = t['showBadge'] ?? true;

    _showNotes = t['showNotes'] ?? true;

    _showQrCode = t['showQrCode'] ?? false;

    _showStamps = t['showStamps'] ?? true;

    _showTerms = t['showTerms'] ?? true;

    _showTaxNo = t['showTaxNo'] ?? false;

    _invoiceTitle = t['invoiceTitle'] ?? 'فاتورة مبيعات';

    _invoiceSubtitle = t['invoiceSubtitle'] ?? '';

    _currencySymbol = t['currencySymbol'] ?? 'د.ل';

    _footerText = t['footerText'] ?? '';

    _tableHeaderStyle = t['tableHeaderStyle'] ?? 'gradient';

    _tableRowStyle = t['tableRowStyle'] ?? 'alternating';

    _paperSize = t['paperSize'] ?? 'landscape';

    _textColor = t['textColor'] ?? '#1F2937';

    _accentBorderColor = t['accentBorderColor'] ?? '#E5E7EB';

    _activeTemplate = t['name'] ?? '';

    save();

  }

  void deleteTemplate(int index) {

    if (index >= 0 && index < _savedTemplates.length) {

      _savedTemplates.removeAt(index);

      save();

    }

  }



  void toggleDarkMode() {

    _isDarkMode = !_isDarkMode;

    save();

  }

  void toggleLanguage() {

    _isEnglish = !_isEnglish;

    save();

    notifyListeners();

  }



  void addProduct(Product p) { products.add(p); save(); }

  void updateProduct(int i, Product p) { products[i] = p; save(); }

  void updateProductSellPrice(String productId, double newPrice) {

    final idx = products.indexWhere((p) => p.id == productId);

    if (idx >= 0) { products[idx].sellPrice = newPrice; save(); }

  }

  void deleteProduct(int i) { products.removeAt(i); save(); }

  void addCustomer(Customer c) { customers.add(c); save(); }

  void updateCustomer(int i, Customer c) { customers[i] = c; save(); }

  void deleteCustomer(int i) { customers.removeAt(i); save(); }

  void addInvoice(Invoice inv) { invoices.insert(0, inv); invoiceCounter++; save(); }

  void updateInvoice(int i, Invoice inv) { invoices[i] = inv; save(); }

  void deleteInvoice(int i) {

    final inv = invoices[i];

    if (inv.allocatedFromAdvance > 0) {

      final custName = inv.buyerName;

      final advIdx = standalonePayments.indexWhere((p) =>

        p.customerId == custName && p.invoiceId == null && p.appliedAmount > 0);

      if (advIdx >= 0) {

        standalonePayments[advIdx].appliedAmount = (standalonePayments[advIdx].appliedAmount - inv.allocatedFromAdvance).clamp(0.0, standalonePayments[advIdx].amount);

      }

    }

    invoices.removeAt(i);

    save();

  }



  // ==================== CUSTOMER BALANCE & MULTI-INVOICE PAYMENT ====================



  /// حساب رصيد الزبون (المقدم - المُستخدم)

  double getCustomerAdvanceBalance(String customerName) {

    final advancePayments = standalonePayments

        .where((p) => p.customerId == customerName && p.invoiceId == null)

        .fold(0.0, (s, p) => s + p.amount - p.appliedAmount);

    final usedFromAdvance = invoices

        .where((i) => i.buyerName == customerName && i.allocatedFromAdvance > 0)

        .fold(0.0, (s, i) => s + i.allocatedFromAdvance);

    return advancePayments - usedFromAdvance;

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



  /// إضافة دفعة لفاتورة (method مركزي آمن)

  /// يُعيد true إذا تمت الإضافة بنجاح

  bool addPaymentToInvoice(Invoice inv, double amount, PaymentMethod method, {String? referenceNumber, String? notes}) {

    final idx = invoices.indexWhere((i) => i.id == inv.id);

    if (idx == -1) return false;

    final safeAmt = amount.clamp(0.0, inv.remaining);

    if (safeAmt <= 0) return false;

    final now = DateFormat('yyyy-MM-dd').format(DateTime.now());

    inv.payments.add(Payment(

      amount: safeAmt,

      date: now,

      method: method,

      customerId: inv.buyerName,

      invoiceId: inv.id,

      receiptNumber: 'RCP-${inv.id}-${inv.payments.length + 1}',

      referenceNumber: referenceNumber,

      notes: notes,

    ));

    updateInvoice(idx, inv);

    return true;

  }



  /// تطبيق رصيد مقدم على فاتورة

  /// يُعيد true إذا تمت العملية بنجاح

  bool applyAdvanceToInvoice(String customerName, Invoice inv, double amount) {

    final advance = getCustomerAdvanceBalance(customerName);

    if (advance <= 0 || amount <= 0) return false;

    final safeAmt = amount.clamp(0.0, advance < inv.remaining ? advance : inv.remaining).toDouble();

    if (safeAmt <= 0) return false;



    final invIdx = invoices.indexWhere((i) => i.id == inv.id);

    if (invIdx == -1) return false;



    inv.allocatedFromAdvance += safeAmt;

    inv.advancePaymentId = customerName;



    final advanceIdx = standalonePayments.indexWhere((p) =>

      p.customerId == customerName && p.invoiceId == null && p.remainingAmount > 0);

    if (advanceIdx >= 0) {

      standalonePayments[advanceIdx].appliedAmount += safeAmt;

    }



    updateInvoice(invIdx, inv);

    return true;

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

                    color: widget.color.withValues(alpha: 0.2),

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

Future<void> shareWhatsApp(String phone, Invoice inv, {bool sharePdf = false}) async {

  if (sharePdf) {

    await shareInvoicePdf(inv);

    return;

  }

  final msg = '🧾 ${"فاتورة رقم"}: ${inv.id}\n👤 ${"العميل"}: ${inv.buyerName}\n💰 ${"الإجمالي"}: ${inv.total.toStringAsFixed(2)} د.ل\n📅 ${"التاريخ"}: ${inv.date}${inv.remaining > 0 ? '\n⏳ ${"المتبقي"}: ${inv.remaining.toStringAsFixed(2)} د.ل' : ''}';

  final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\+]'), '');

  final url = Uri.parse('https://wa.me/${cleanPhone.isNotEmpty ? cleanPhone : ''}?text=${Uri.encodeComponent(msg)}');

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

  final msg = '🧾 ${"فاتورة رقم"}: ${inv.id}\n👤 ${"العميل"}: ${inv.buyerName}\n💰 ${"الإجمالي"}: ${inv.total.toStringAsFixed(2)} د.ل\n📅 ${"التاريخ"}: ${inv.date}${inv.remaining > 0 ? '\n⏳ ${"المتبقي"}: ${inv.remaining.toStringAsFixed(2)} د.ل' : ''}';

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



Future<void> printInvoice(Invoice inv, {bool isEnglish = false}) async {

  final pdf = pw.Document();

  final font = await PdfGoogleFonts.cairoRegular();

  final fontBold = await PdfGoogleFonts.cairoBold();

  final template = getTemplate(inv.template);



  switch (inv.template) {

    case 'modern':

      _buildModernTemplate(pdf, inv, template, font, fontBold);

      break;

    case 'minimal':

      _buildMinimalTemplate(pdf, inv, template, font, fontBold, isEnglish: isEnglish);

      break;

    case 'corporate':

      _buildCorporateTemplate(pdf, inv, template, font, fontBold, isEnglish: isEnglish);

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



Future<void> shareInvoicePdf(Invoice inv, {bool isEnglish = false}) async {

  final pdf = pw.Document();

  final font = await PdfGoogleFonts.cairoRegular();

  final fontBold = await PdfGoogleFonts.cairoBold();

  final template = getTemplate(inv.template);



  switch (inv.template) {

    case 'modern': _buildModernTemplate(pdf, inv, template, font, fontBold); break;

    case 'minimal': _buildMinimalTemplate(pdf, inv, template, font, fontBold, isEnglish: isEnglish); break;

    case 'corporate': _buildCorporateTemplate(pdf, inv, template, font, fontBold, isEnglish: isEnglish); break;

    case 'colorful': _buildColorfulTemplate(pdf, inv, template, font, fontBold); break;

    case 'dark': _buildDarkTemplate(pdf, inv, template, font, fontBold); break;

    default: _buildClassicTemplate(pdf, inv, template, font, fontBold);

  }



  final bytes = await pdf.save();

  final dir = await getTemporaryDirectory();

  final file = File('${dir.path}/invoice_${inv.id}.pdf');

  await file.writeAsBytes(bytes);

  await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], text: '🧾 ${isEnglish ? 'Invoice' : 'فاتورة'} ${inv.id}'));

}



Future<void> sharePaymentReceiptPdf(Invoice inv, Payment payment, {bool isEnglish = false}) async {

  final pdf = pw.Document();

  final font = await PdfGoogleFonts.cairoRegular();

  final fontBold = await PdfGoogleFonts.cairoBold();



  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (_) => [

      pw.Header(level: 0, child: pdfText(isEnglish ? 'Payment Receipt' : 'إيصال دفع', style: pw.TextStyle(font: fontBold, fontSize: 22))),

      pw.Divider(),

      pw.SizedBox(height: 16),

      _receiptRow(isEnglish ? 'Invoice' : 'رقم الفاتورة', inv.id, font, fontBold),

      _receiptRow(isEnglish ? 'Customer' : 'العميل', inv.buyerName, font, fontBold),

      _receiptRow(isEnglish ? 'Date' : 'التاريخ', payment.date, font, fontBold),

      pw.SizedBox(height: 16),

      pw.Container(

        padding: const pw.EdgeInsets.all(16),

        decoration: pw.BoxDecoration(color: PdfColor(0.07, 0.53, 0.3), borderRadius: pw.BorderRadius.circular(12)),

        child: pw.Column(children: [

          pdfText(isEnglish ? 'Amount Paid' : 'المبلغ المدفوع', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.white)),

          pw.SizedBox(height: 4),

          pdfText('${payment.amount.toStringAsFixed(2)} LYD', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.white)),

        ]),

      ),

      pw.SizedBox(height: 16),

      _receiptRow(isEnglish ? 'Method' : 'طريقة الدفع', paymentMethodName(payment.method, isEnglish: isEnglish), font, fontBold),

      if (payment.notes != null && payment.notes!.isNotEmpty) _receiptRow(isEnglish ? 'Notes' : 'ملاحظات', payment.notes!, font, fontBold),

      pw.SizedBox(height: 24),

      pw.Center(child: pdfText(isEnglish ? 'Thank you for your business' : 'شكراً لتعاملكم معنا', style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.grey600))),

    ],

  ));



  final bytes = await pdf.save();

  final dir = await getTemporaryDirectory();

  final file = File('${dir.path}/receipt_${payment.id}.pdf');

  await file.writeAsBytes(bytes);

  await SharePlus.instance.share(ShareParams(files: [XFile(file.path)], text: isEnglish ? 'Payment Receipt' : 'إيصال دفع'));
}



Future<void> printPaymentReceipt(Invoice inv, Payment payment, {bool isEnglish = false}) async {

  final pdf = pw.Document();

  final font = await PdfGoogleFonts.cairoRegular();

  final fontBold = await PdfGoogleFonts.cairoBold();



  pdf.addPage(pw.MultiPage(

    pageFormat: PdfPageFormat.a4,

    build: (_) => [

      pw.Header(level: 0, child: pdfText(isEnglish ? 'Payment Receipt' : 'إيصال دفع', style: pw.TextStyle(font: fontBold, fontSize: 22))),

      pw.Divider(),

      pw.SizedBox(height: 16),

      _receiptRow(isEnglish ? 'Invoice' : 'رقم الفاتورة', inv.id, font, fontBold),

      _receiptRow(isEnglish ? 'Customer' : 'العميل', inv.buyerName, font, fontBold),

      _receiptRow(isEnglish ? 'Date' : 'التاريخ', payment.date, font, fontBold),

      pw.SizedBox(height: 16),

      pw.Container(

        padding: const pw.EdgeInsets.all(16),

        decoration: pw.BoxDecoration(color: PdfColor(0.07, 0.53, 0.3), borderRadius: pw.BorderRadius.circular(12)),

        child: pw.Column(children: [

          pdfText(isEnglish ? 'Amount Paid' : 'المبلغ المدفوع', style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.white)),

          pw.SizedBox(height: 4),

          pdfText('${payment.amount.toStringAsFixed(2)} LYD', style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.white)),

        ]),

      ),

      pw.SizedBox(height: 16),

      _receiptRow(isEnglish ? 'Method' : 'طريقة الدفع', paymentMethodName(payment.method, isEnglish: isEnglish), font, fontBold),

      pw.SizedBox(height: 24),

      pw.Center(child: pdfText(isEnglish ? 'Thank you' : 'شكراً لتعاملكم معنا', style: pw.TextStyle(font: fontBold, fontSize: 14, color: PdfColors.grey600))),

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



void _buildMinimalTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold, {bool isEnglish = false}) {

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

            child: pdfText(_statusLabel(inv.status, isEnglish: isEnglish), style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColor.fromHex('#EC4899'))),

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



void _buildCorporateTemplate(pw.Document pdf, Invoice inv, InvoiceTemplate template, pw.Font font, pw.Font fontBold, {bool isEnglish = false}) {

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

              pdfText(_statusLabel(inv.status, isEnglish: isEnglish), style: pw.TextStyle(font: fontBold, fontSize: 12, color: PdfColors.white)),

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

    headers: ['المنتج', 'السعر', 'الكمية', 'الخصم', 'الإجمالي'].map((h) => fixPdfArabic(h)).toList(),

    data: inv.items.map((item) => [

      fixPdfArabic(item.name),

      fixPdfArabic('${item.price.toStringAsFixed(2)} د.ل'),

      '${item.quantity}',

      (item.discountAmt.toStringAsFixed(2)),

      fixPdfArabic('${item.lineTotal.toStringAsFixed(2)} د.ل'),

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



String _statusLabel(String s, {bool isEnglish = false}) => s == 'paid' ? tr('مدفوع', isEng: isEnglish) : (s == 'partial' ? tr('جزئي', isEng: isEnglish) : tr('غير مدفوع', isEng: isEnglish));



// ==================== UPDATE SYSTEM ====================

const String appVersion = '1.2.0';

const String appBuildNumber = '1';

const Map<String, Map<String, dynamic>> appChangelog = {

  '1.2.0': {

    'title': 'الإصدار 1.2.0',

    'date': '2026-08-18',

    'features': [

      'إصلاح نظام إشعارات التحديث',

      'نظام تسويات م红楼梦ي بالكامل',

      'تتبع دقيق للرصيد المقدم',

      'حماية من الدفع الزائد',

      'عرض الدفعات المستقلة في شاشة الدفعات',

      'خيار استخدام الرصيد عند إنشاء فاتورة',

      'كشف حساب يشمل الرصيد المقدم',

      'نسخة احتياطية شاملة لجميع البيانات',

    ],

    'fixes': [

      'إصلاح حساب الرصيد المقدم الذي كان معطلاً',

      'إصلاح فقدان بيانات الدفعات في النسخة الاحتياطية',

      'إصلاح عدم تنظيف الرصيد عند حذف الفاتورة',

      'إصلاح خطأ indexOf في الدفع',

    ],

  },

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

void _showWhatsNewDialog(BuildContext context, {VoidCallback? onDismissed}) {

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

              Row(children: [

                Icon(Icons.new_releases, color: AppColors.primary, size: 18),

                SizedBox(width: 6),

                Text(tr('الميزات الجديدة', isEng: context.read<DataStore>().isEnglish), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

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

              Row(children: [

                Icon(Icons.bug_report, color: AppColors.success, size: 18),

                SizedBox(width: 6),

                Text(tr('إصلاحات', isEng: context.read<DataStore>().isEnglish), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),

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

              onDismissed?.call();

            },

          ),

        ),

      ],

    ),

  );

}



Future<void> checkForUpdate(BuildContext context) async {

  try {

    final prefs = await SharedPreferences.getInstance();

    final lastSeenVersion = prefs.getString('lastSeenVersion') ?? '';

    if (lastSeenVersion != appVersion && context.mounted) {

      _showWhatsNewDialog(context, onDismissed: () async {

        await prefs.setString('lastSeenVersion', appVersion);

      });

    }

  } catch (e) {

    // تجاهل الأخطاء بهدوء

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

          pageBuilder: (_, _, _) => onboardingDone ? const HomeScreen() : const OnboardingScreen(),

          transitionsBuilder: (_, anim, _, child) => FadeTransition(opacity: anim, child: child),

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

                        color: Colors.white.withValues(alpha: 0.2),

                        shape: BoxShape.circle,

                        boxShadow: [

                          BoxShadow(

                            color: Colors.white.withValues(alpha: 0.3),

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

              child: Text(tr('نظام فواتير متكامل', isEng: context.read<DataStore>().isEnglish), style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.8))),

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

              _pages[_currentPage].gradient[0].withValues(alpha: 0.1),

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

                  child: Text(tr('تخطي', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(color: Colors.grey)),

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

                                      color: page.gradient[0].withValues(alpha: 0.3),

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

                          Text(tr(page.title, isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold), textAlign: TextAlign.center),

                          const SizedBox(height: 16),

                          Text(tr(page.subtitle, isEng: context.read<DataStore>().isEnglish), style: TextStyle(fontSize: 16, color: Colors.grey[600]), textAlign: TextAlign.center),

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

                      label: _currentPage < _pages.length - 1 ? tr('التالي', isEng: context.read<DataStore>().isEnglish) : tr('ابدأ', isEng: context.read<DataStore>().isEnglish),

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

        pageBuilder: (_, _, _) => const HomeScreen(),

        transitionsBuilder: (_, anim, _, child) => SlideTransition(

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

      _checkOverdueInvoices(context);

    });

  }

  void _checkOverdueInvoices(BuildContext context) async {

    final prefs = await SharedPreferences.getInstance();

    final lastAlertDate = prefs.getString('lastOverdueAlertDate') ?? '';

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (lastAlertDate == today) return;



    final store = context.read<DataStore>();

    final overdueInvoices = store.invoices.where((inv) => inv.isOverdue).toList();

    if (overdueInvoices.isEmpty || !context.mounted) return;



    await prefs.setString('lastOverdueAlertDate', today);

    HapticFeedback.heavyImpact();



    final totalRemaining = overdueInvoices.fold(0.0, (s, i) => s + i.remaining);

    final maxDays = overdueInvoices.map((i) => i.daysUntilDue.abs()).reduce((a, b) => a > b ? a : b);



    if (!context.mounted) return;

    showDialog(

      context: context,

      builder: (ctx) => AlertDialog(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

        content: Column(

          mainAxisSize: MainAxisSize.min,

          children: [

            Container(

              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(

                color: AppColors.danger.withValues(alpha: 0.1),

                shape: BoxShape.circle,

              ),

              child: const Icon(Icons.warning_amber, color: AppColors.danger, size: 48),

            ),

            const SizedBox(height: 16),

            Text(tr('تنبيه: فواتير متأخرة', isEng: store.isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Text('لديك ${overdueInvoices.length} فاتورة متأخرة', style: TextStyle(color: Colors.grey[600])),

            const SizedBox(height: 4),

            Text('أخرها $maxDays يوم - إجمالي ${totalRemaining.toStringAsFixed(0)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger)),

            const SizedBox(height: 16),

            ...overdueInvoices.take(3).map((inv) => Padding(

              padding: const EdgeInsets.only(bottom: 8),

              child: Row(children: [

                const Icon(Icons.receipt_long, size: 16, color: AppColors.danger),

                const SizedBox(width: 8),

                Expanded(child: Text('${inv.id} - ${inv.buyerName}', style: const TextStyle(fontSize: 13))),

                Text('${inv.remaining.toStringAsFixed(0)} د.ل', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.danger)),

              ]),

            )),

            if (overdueInvoices.length > 3)

              Text('... و ${overdueInvoices.length - 3} فواتير أخرى', style: TextStyle(fontSize: 12, color: Colors.grey[500])),

          ],

        ),

        actions: [

          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(tr('لاحقاً', isEng: store.isEnglish))),

          GradientButton(

            label: tr('عرض الكل', isEng: store.isEnglish),

            icon: Icons.visibility,

            gradient: AppColors.gradient1,

            onPressed: () {

              Navigator.pop(ctx);

              setState(() => _currentIndex = 2);

            },

          ),

        ],

      ),

    );

  }



  @override

  void dispose() {

    _fabController.dispose();

    super.dispose();

  }



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: AnimatedSwitcher(

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

      ),

      bottomNavigationBar: Container(

        decoration: BoxDecoration(

          boxShadow: [

            BoxShadow(

              color: Colors.black.withValues(alpha: 0.05),

              blurRadius: 20,

              offset: const Offset(0, -5),

            ),

          ],

        ),

        child: Consumer<DataStore>(

          builder: (_, store, __) => NavigationBar(

          selectedIndex: _currentIndex,

          onDestinationSelected: (i) {

            HapticFeedback.selectionClick();

            setState(() => _currentIndex = i);

            _fabController.forward();

            _fabController.reset();

            _fabController.forward();

          },

          animationDuration: const Duration(milliseconds: 400),

          height: 70,

          backgroundColor: AppColors.cardOf(context),

          elevation: 0,

          destinations: [

            NavigationDestination(icon: const Icon(Icons.receipt_long), selectedIcon: Icon(Icons.receipt_long, color: AppColors.primary), label: tr('الفواتير', isEng: store.isEnglish)),

            NavigationDestination(icon: const Icon(Icons.payments), selectedIcon: Icon(Icons.payments, color: AppColors.primary), label: tr('الدفعات', isEng: store.isEnglish)),

            NavigationDestination(icon: const Icon(Icons.inventory_2), selectedIcon: Icon(Icons.inventory_2, color: AppColors.primary), label: tr('المنتجات', isEng: store.isEnglish)),

            NavigationDestination(icon: const Icon(Icons.people), selectedIcon: Icon(Icons.people, color: AppColors.primary), label: tr('العملاء', isEng: store.isEnglish)),

            NavigationDestination(icon: const Icon(Icons.bar_chart), selectedIcon: Icon(Icons.bar_chart, color: AppColors.primary), label: tr('الإحصائيات', isEng: store.isEnglish)),

            NavigationDestination(icon: const Icon(Icons.settings), selectedIcon: Icon(Icons.settings, color: AppColors.primary), label: tr('الإعدادات', isEng: store.isEnglish)),

          ],

        ),

        ),

      ),

      floatingActionButton: _currentIndex == 0

          ? ScaleTransition(

              scale: _fabScale,

              child: FloatingActionButton.extended(

                onPressed: () => Navigator.push(context, PageRouteBuilder(

                  pageBuilder: (_, _, _) => const CreateInvoiceScreen(),

                  transitionsBuilder: (_, anim, _, child) => ScaleTransition(

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

                      builder: (_, store, _) {

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
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(children: [
                const Icon(Icons.payments, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(tr('استلام دفعة', isEng: store.isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 16),

              Text(tr('الزبون', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedCustomer,
                isExpanded: true,
                decoration: InputDecoration(border: const OutlineInputBorder(), hintText: tr('اختر الزبون', isEng: store.isEnglish)),
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
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
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
              Text(tr('المبلغ', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                decoration: InputDecoration(border: const OutlineInputBorder(), suffixText: 'د.ل', hintText: tr('أدخل المبلغ', isEng: store.isEnglish)),
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
              Text(tr('طريقة الدفع', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),
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
                      child: Text('${paymentMethodIcon(m)} ${paymentMethodName(m, isEnglish: store.isEnglish)}',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSel ? Colors.white : AppColors.textPrimaryOf(context))),
                    ),
                  );
                }).toList(),
              ),

              if (selectedCustomer != null) ...[
                const SizedBox(height: 16),
                Text(tr('نوع الدفعة', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Row(children: [
                  _modeChip(tr('فاتورة واحدة', isEng: store.isEnglish), 'single', unpaidInvoices.length == 1),
                  const SizedBox(width: 8),
                  _modeChip(tr('عدة فواتير', isEng: store.isEnglish), 'multi', unpaidInvoices.length > 1),
                  const SizedBox(width: 8),
                  _modeChip(tr('دفعة مقدمة', isEng: store.isEnglish), 'advance', true),
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(tr('الكل', isEng: store.isEnglish), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
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
    final isEng = context.read<DataStore>().isEnglish;
    switch (mode) {
      case 'advance': return tr('حفظ دفعة مقدمة', isEng: isEng);
      case 'multi': return '${tr('توزيع على', isEng: isEng)} $count ${tr('فواتير', isEng: isEng)}';
      default: return tr('تأكيد الدفعة', isEng: isEng);
    }
  }

  Widget _amtQuickBtn(String label, double amount) {
    return GestureDetector(
      onTap: () { amtCtrl.text = amount.toStringAsFixed(0); setState(() {}); },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.success.withValues(alpha: 0.1), AppColors.success.withValues(alpha: 0.05)]),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
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

    if (paymentMode == 'advance') {
      store.addAdvancePayment(selectedCustomer!, Payment(
        amount: amt, date: DateFormat('yyyy-MM-dd').format(DateTime.now()), method: selectedMethod,
        receiptNumber: 'ADV-$selectedCustomer-${DateTime.now().millisecondsSinceEpoch}',
      ));
      Navigator.pop(context);
      HapticFeedback.heavyImpact();
      showAppToast(context, '${tr('تم حفظ دفعة مقدمة', isEng: store.isEnglish)} ${amt.toStringAsFixed(2)} د.ل', icon: Icons.savings, color: AppColors.success);
      return;
    }

    final unpaidInvoices = store.getCustomerUnpaidInvoices(selectedCustomer!);

    if (paymentMode == 'single' || unpaidInvoices.length == 1) {
      final inv = unpaidInvoices.first;
      final success = store.addPaymentToInvoice(inv, amt, selectedMethod);
      Navigator.pop(context);
      HapticFeedback.heavyImpact();
      if (success) {
        showAppToast(context, '${tr('تم استلام', isEng: store.isEnglish)} ${amt.clamp(0.0, inv.remaining).toStringAsFixed(2)} د.ل ${tr('للفاتورة', isEng: store.isEnglish)} ${inv.id}', icon: Icons.check_circle, color: AppColors.success);
      } else {
        showAppToast(context, tr('المبلغ يتجاوز المتبقي', isEng: store.isEnglish), icon: Icons.warning, color: AppColors.warning);
      }
      return;
    }

    if (paymentMode == 'multi') {
      final remaining = store.allocatePaymentToInvoices(
        selectedCustomer!, amt, allocations, selectedMethod,
      );
      Navigator.pop(context);
      HapticFeedback.heavyImpact();
      final msg = remaining > 0
          ? '${tr('تم التوزيع. متبقي', isEng: store.isEnglish)} ${remaining.toStringAsFixed(2)} د.ل ${tr('غير موزع', isEng: store.isEnglish)}'
          : '${tr('تم توزيع', isEng: store.isEnglish)} ${amt.toStringAsFixed(2)} د.ل ${tr('على الفواتير', isEng: store.isEnglish)}';
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

        title: Text(tr('مسح الباركود', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

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

                border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 3),

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

                color: Colors.black.withValues(alpha: 0.7),

                borderRadius: BorderRadius.circular(16),

              ),

              child: Text(

                tr('ضع الباركود داخل الإطار', isEng: context.read<DataStore>().isEnglish),

                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),

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

      builder: (_, store, _) {

        final allPayments = <Map<String, dynamic>>[];

        for (final inv in store.invoices) {

          for (final p in inv.payments) {

            allPayments.add({

              'payment': p,

              'invoice': inv,

              'isAdvance': false,

            });

          }

        }

        for (final p in store.standalonePayments) {

          allPayments.add({

            'payment': p,

            'invoice': null,

            'isAdvance': true,

          });

        }

        allPayments.sort((a, b) => (b['payment'] as Payment).date.compareTo((a['payment'] as Payment).date));



        final unpaidInvoices = store.invoices.where((i) => i.remaining > 0).toList();

        final invoicePaymentsTotal = allPayments.where((e) => !(e['isAdvance'] as bool)).fold(0.0, (s, e) => s + (e['payment'] as Payment).amount);

        final advancePaymentsTotal = store.standalonePayments.fold(0.0, (s, p) => s + p.amount);

        final totalCollected = invoicePaymentsTotal + advancePaymentsTotal;

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

            title: Text(tr('الدفعات', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

            backgroundColor: Colors.transparent,

            elevation: 0,

          ),

          body: ListView(

            padding: const EdgeInsets.all(16),

            children: [

              Row(

                children: [

                  Expanded(child: _summaryCard(tr('المحصّل', isEng: store.isEnglish), totalCollected, AppColors.gradient4, Icons.check_circle)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard(tr('المتبقي', isEng: store.isEnglish), totalRemaining, [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)], Icons.pending)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard(tr('فواتير مفتوحة', isEng: store.isEnglish), unpaidInvoices.length.toDouble(), AppColors.gradient1, Icons.receipt_long)),

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

                              Icon(Icons.check_circle, size: 48, color: AppColors.success.withValues(alpha: 0.3)),

                              const SizedBox(height: 8),

                              Text(tr('جميع الفواتير مدفوعة!', isEng: store.isEnglish), style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),

                            ],

                          ),

                        ),

                      )

                    else

                      ...unpaidInvoices.take(5).map((inv) {

                        return Container(

                          margin: const EdgeInsets.only(bottom: 12),

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

                    hintText: tr('بحث في الدفعات...', isEng: store.isEnglish),

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

                    _methodChip(tr('الكل', isEng: store.isEnglish), 'all'),

                    _methodChip(tr('💵 نقدي', isEng: store.isEnglish), 'cash'),

                    _methodChip(tr('🏦 بنكي', isEng: store.isEnglish), 'bankTransfer'),

                    _methodChip(tr('📱 موبايل', isEng: store.isEnglish), 'mobileMoney'),

                    _methodChip(tr('📄 شيك', isEng: store.isEnglish), 'check'),

                    _methodChip(tr('💳 ائتمان', isEng: store.isEnglish), 'creditCard'),

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

                      Text(allPayments.isEmpty ? tr('لا توجد دفعات بعد', isEng: store.isEnglish) : tr('لا نتائج', isEng: store.isEnglish), style: TextStyle(color: Colors.grey[600])),

                    ],

                  ),

                )

              else

                ...filtered.map((e) {

                  final p = e['payment'] as Payment;

                  final inv = e['invoice'] as Invoice?;

                  final isAdvance = e['isAdvance'] as bool;

                  return GlassCard(

                    margin: const EdgeInsets.only(bottom: 12),

                    child: Row(

                      children: [

                        Container(

                          padding: const EdgeInsets.all(10),

                          decoration: BoxDecoration(

                            gradient: LinearGradient(colors: isAdvance ? AppColors.gradient2 : AppColors.gradient4),

                            borderRadius: BorderRadius.circular(12),

                          ),

                          child: Text(isAdvance ? '💰' : paymentMethodIcon(p.method), style: const TextStyle(fontSize: 18)),

                        ),

                        const SizedBox(width: 12),

                        Expanded(

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [

                              Row(children: [

                                Text(isAdvance ? tr('دفعة مقدمة', isEng: store.isEnglish) : (inv?.id ?? ''), style: const TextStyle(fontWeight: FontWeight.bold)),

                                const SizedBox(width: 8),

                                Text(isAdvance ? (p.customerId ?? '') : (inv?.buyerName ?? ''), style: TextStyle(color: Colors.grey[600], fontSize: 12)),

                              ]),

                              const SizedBox(height: 4),

                              Text('${p.date} | ${paymentMethodName(p.method, isEnglish: store.isEnglish)}${p.receiptNumber != null ? ' | #${p.receiptNumber!}' : ''}', style: TextStyle(fontSize: 11, color: Colors.grey[500])),

                            ],

                          ),

                        ),

                        Column(

                          crossAxisAlignment: CrossAxisAlignment.end,

                          children: [

                            Text('${p.amount.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 14)),

                            const SizedBox(height: 4),

                            GestureDetector(

                              onTap: inv != null ? () => printPaymentReceipt(inv, p, isEnglish: store.isEnglish) : null,

                              child: Icon(Icons.receipt, size: 18, color: inv != null ? AppColors.primary : Colors.grey[400]),

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

        boxShadow: [BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],

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

                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Row(children: [

                  const Icon(Icons.payment, color: AppColors.primary, size: 24),

                  const SizedBox(width: 8),

                  Text('${tr('استلام', isEng: store.isEnglish)} - ${inv.id}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const Spacer(),

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),

                    child: Text('المتبقي: ${inv.remaining.toStringAsFixed(2)} د.ل', style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.bold)),

                  ),

                ]),

                const SizedBox(height: 12),

                Text('${tr('عميل', isEng: store.isEnglish)}: ${inv.buyerName}', style: TextStyle(color: Colors.grey[600])),

                const SizedBox(height: 16),

                TextField(

                  controller: amtCtrl, keyboardType: TextInputType.number, autofocus: true,

                  decoration: InputDecoration(labelText: tr('المبلغ', isEng: store.isEnglish), border: const OutlineInputBorder(), suffixText: 'د.ل'),

                ),

                const SizedBox(height: 8),

                Row(

                  children: [

                    _quickPayBtn(tr('الكل', isEng: store.isEnglish), inv.remaining, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn(tr('النصف', isEng: store.isEnglish), inv.remaining / 2, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn(tr('الربع', isEng: store.isEnglish), inv.remaining / 4, amtCtrl, setSheetState),

                  ],

                ),

                const SizedBox(height: 12),

                Text(tr('طريقة الدفع', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

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

                            Text(paymentMethodName(m, isEnglish: store.isEnglish), style: TextStyle(

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

                  label: tr('تأكيد الاستلام', isEng: store.isEnglish),

                  icon: Icons.check,

                  gradient: AppColors.gradient4,

                  onPressed: () {

                    final amt = double.tryParse(amtCtrl.text) ?? 0;

                    if (amt > 0) {

                      final success = store.addPaymentToInvoice(inv, amt, selectedMethod);

                      Navigator.pop(ctx);

                      HapticFeedback.heavyImpact();

                      if (success) {

                        showAppToast(ctx, '${tr('تم استلام', isEng: store.isEnglish)} ${amt.toStringAsFixed(2)} د.ل', icon: Icons.check_circle, color: AppColors.success);

                      } else {

                        showAppToast(ctx, tr('المبلغ يتجاوز المتبقي', isEng: store.isEnglish), icon: Icons.warning, color: AppColors.warning);

                      }

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

            gradient: LinearGradient(colors: [AppColors.success.withValues(alpha: 0.1), AppColors.success.withValues(alpha: 0.05)]),

            borderRadius: BorderRadius.circular(10),

            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),

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

        Text(tr('التنبيهات', isEng: store.isEnglish), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

        const SizedBox(height: 16),

        if (overdue.isNotEmpty) ...[

          Row(children: [Icon(Icons.warning_amber, color: AppColors.danger, size: 20), const SizedBox(width: 8), Text('${tr('فواتير متأخرة', isEng: store.isEnglish)} (${overdue.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger))]),

          const SizedBox(height: 8),

          ...overdue.map((inv) => GlassCard(margin: const EdgeInsets.only(bottom: 12), child: ListTile(

            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.receipt_long, color: AppColors.danger, size: 20)),

            title: Text('${inv.id} - ${inv.buyerName}', style: const TextStyle(fontWeight: FontWeight.bold)),

            subtitle: Text('متأخر ${inv.daysUntilDue.abs()} يوم - متبقي ${inv.remaining.toStringAsFixed(0)} د.ل', style: TextStyle(color: Colors.grey[600], fontSize: 12)),

          ))),

          const SizedBox(height: 12),

        ],

        if (outOfStock.isNotEmpty) ...[

          Row(children: [Icon(Icons.inventory, color: AppColors.danger, size: 20), const SizedBox(width: 8), Text('${tr('نفذ من المخزون', isEng: store.isEnglish)} (${outOfStock.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.danger))]),

          const SizedBox(height: 8),

          ...outOfStock.map((p) => GlassCard(margin: const EdgeInsets.only(bottom: 12), child: ListTile(

            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.inventory_2, color: AppColors.danger, size: 20)),

            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),

            subtitle: const Text('انتهى من المخزون', style: TextStyle(color: AppColors.danger, fontSize: 12)),

          ))),

          const SizedBox(height: 12),

        ],

        if (lowStock.isNotEmpty) ...[

          Row(children: [Icon(Icons.info_outline, color: AppColors.warning, size: 20), const SizedBox(width: 8), Text('${tr('مخزون منخفض', isEng: store.isEnglish)} (${lowStock.length})', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning))]),

          const SizedBox(height: 8),

          ...lowStock.map((p) => GlassCard(margin: const EdgeInsets.only(bottom: 12), child: ListTile(

            leading: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.inventory_2, color: AppColors.warning, size: 20)),

            title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),

            subtitle: Text('متبقي ${p.quantity} فقط', style: TextStyle(color: Colors.grey[600], fontSize: 12)),

          ))),

        ],

        if (overdue.isEmpty && outOfStock.isEmpty && lowStock.isEmpty)

          Center(child: Padding(padding: const EdgeInsets.all(40), child: Column(children: [

            Icon(Icons.check_circle, color: AppColors.success, size: 64),

            const SizedBox(height: 16),

            Text(tr('لا توجد تنبيهات', isEng: store.isEnglish), style: TextStyle(color: Colors.grey[500], fontSize: 16)),

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

            title: Text(tr('الفواتير', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

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

                      hintText: tr('بحث...', isEng: store.isEnglish),

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

                    _filterChip(tr('الكل', isEng: store.isEnglish), 'all'),

                    _filterChip(tr('مدفوعة', isEng: store.isEnglish), 'paid'),

                    _filterChip(tr('جزئية', isEng: store.isEnglish), 'partial'),

                    _filterChip(tr('غير مدفوعة', isEng: store.isEnglish), 'unpaid'),

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

                        label: Text(tr('ترتيب', isEng: store.isEnglish)),

                      ),

                      TextButton.icon(

                        onPressed: _showFilterSheet,

                        icon: Icon(Icons.filter_list, size: 14, color: (_dateFrom != null || _dateTo != null || _amountMin != null || _amountMax != null) ? AppColors.primary : null),

                        label: Text(tr('فلتر', isEng: store.isEnglish), style: TextStyle(color: (_dateFrom != null || _dateTo != null || _amountMin != null || _amountMax != null) ? AppColors.primary : null)),

                      ),

                    ],

                  ],

                ),

              ),

              Expanded(

                child: filtered.isEmpty

                    ? EmptyState(

                        icon: Icons.receipt_long,

                        title: store.invoices.isEmpty ? tr('لا توجد فواتير', isEng: store.isEnglish) : tr('لا نتائج', isEng: store.isEnglish),

                        subtitle: store.invoices.isEmpty ? tr('ابدأ بإنشاء فاتورة جديدة', isEng: store.isEnglish) : 'جرّب البحث بكلمات مختلفة',

                        actionLabel: store.invoices.isEmpty ? tr('فاتورة جديدة', isEng: store.isEnglish) : null,

                        onAction: store.invoices.isEmpty ? () => Navigator.push(context, PageRouteBuilder(
                          pageBuilder: (_, _, _) => const CreateInvoiceScreen(),
                          transitionsBuilder: (_, anim, _, child) => FadeTransition(
                            opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                            child: SlideTransition(
                              position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                              child: child,
                            ),
                          ),
                          transitionDuration: const Duration(milliseconds: 400),
                        )) : null,

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

                              onTap: () { HapticFeedback.selectionClick(); Navigator.push(context, PageRouteBuilder(

                                pageBuilder: (_, _, _) => InvoiceDetailScreen(invoice: inv, index: actualIndex),

                                transitionsBuilder: (_, anim, _, child) => SlideTransition(

                                  position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),

                                  child: child,

                                ),

                              )); },

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

          onSelected: (_) { HapticFeedback.selectionClick(); setState(() => _filterStatus = value); },

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

            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(

              padding: EdgeInsets.all(16),

              child: Text(tr('ترتيب حسب', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

            ),

            ...[

              ('date_desc', tr('الأحدث أولاً', isEng: context.read<DataStore>().isEnglish), Icons.access_time),

              ('date_asc', tr('الأقدم أولاً', isEng: context.read<DataStore>().isEnglish), Icons.history),

              ('amount_desc', tr('الأعلى مبلغاً', isEng: context.read<DataStore>().isEnglish), Icons.arrow_downward),

              ('amount_asc', tr('الأقل مبلغاً', isEng: context.read<DataStore>().isEnglish), Icons.arrow_upward),

              ('name', tr('اسم العميل', isEng: context.read<DataStore>().isEnglish), Icons.person),

            ].map((s) => ListTile(

              leading: Icon(s.$3, color: _sortBy == s.$1 ? AppColors.primary : null),

              title: Text(s.$2, style: TextStyle(fontWeight: _sortBy == s.$1 ? FontWeight.bold : FontWeight.normal)),

              trailing: _sortBy == s.$1 ? const Icon(Icons.check, color: AppColors.primary) : null,

              onTap: () { HapticFeedback.selectionClick(); setState(() => _sortBy = s.$1); Navigator.pop(ctx); },

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

          builder: (_, setSheetState) => SingleChildScrollView(

            child: Column(

            mainAxisSize: MainAxisSize.min,

            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

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

                decoration: InputDecoration(hintText: 'اختر التاريخ', prefixIcon: const Icon(Icons.calendar_today, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),

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

                decoration: InputDecoration(hintText: 'اختر التاريخ', prefixIcon: const Icon(Icons.calendar_today, size: 18), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),

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

                    decoration: InputDecoration(hintText: '0', suffixText: 'د.ل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),

                  ),

                ])),

                const SizedBox(width: 12),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  const Text('الحد الأعلى:', style: TextStyle(fontWeight: FontWeight.w600)),

                  const SizedBox(height: 4),

                  TextField(

                    controller: maxCtrl,

                    keyboardType: TextInputType.number,

                    decoration: InputDecoration(hintText: '∞', suffixText: 'د.ل', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14)),

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

    final monthInvoices = store.invoices.where((inv) => inv.date.startsWith(thisMonth)).toList();

    final monthSales = monthInvoices.fold(0.0, (s, inv) => s + inv.total);

    final totalRemaining = store.invoices.fold(0.0, (s, inv) => s + inv.remaining);

    return Padding(

      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),

      child: LayoutBuilder(

        builder: (context, constraints) {

          final cards = [

            _dashCard(context, tr('اليوم', isEng: store.isEnglish), '${todaySales.toStringAsFixed(0)} د.ل', Icons.today, AppColors.gradient1),

            _dashCard(context, tr('فواتير', isEng: store.isEnglish), '${todayInvoices.length}', Icons.receipt_long, AppColors.gradient2),

            _dashCard(context, tr('الشهر', isEng: store.isEnglish), '${monthSales.toStringAsFixed(0)} د.ل', Icons.calendar_month, AppColors.gradient4),

            _dashCard(context, tr('المتبقي', isEng: store.isEnglish), '${totalRemaining.toStringAsFixed(0)} د.ل', Icons.pending, [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)]),

          ];

          if (constraints.maxWidth > 600) {

            return Row(children: [

              Expanded(child: cards[0]),

              const SizedBox(width: 8),

              Expanded(child: cards[1]),

              const SizedBox(width: 8),

              Expanded(child: cards[2]),

              const SizedBox(width: 8),

              Expanded(child: cards[3]),

            ]);

          }

          return Wrap(

            spacing: 8,

            runSpacing: 8,

            children: [

              for (final card in cards)

                SizedBox(width: (constraints.maxWidth - 8) / 2, child: card),

            ],

          );

        },

      ),

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

          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 9)),

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

                Text(invoice.buyerName.isEmpty ? tr('عميل', isEng: context.read<DataStore>().isEnglish) : invoice.buyerName, style: const TextStyle(fontWeight: FontWeight.w600)),

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

                    Text(tr('الإجمالي', isEng: context.read<DataStore>().isEnglish), style: TextStyle(fontSize: 11, color: AppColors.textSecondaryOf(context))),

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

                      Text(tr('المتبقي', isEng: context.read<DataStore>().isEnglish), style: TextStyle(fontSize: 11, color: AppColors.textSecondaryOf(context))),

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

                    child: Row(

                      mainAxisSize: MainAxisSize.min,

                      children: [

                        const Icon(Icons.check, color: Colors.white, size: 14),

                        const SizedBox(width: 4),

                        Text(tr('تم السداد', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),

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

  bool _useAdvanceBalance = false;

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

  void _editItemPrice(int i, InvoiceItem item) {

    final ctrl = TextEditingController(text: item.price.toStringAsFixed(2));

    showDialog(context: context, builder: (_) => AlertDialog(

      title: Text(tr('تعديل السعر', isEng: context.read<DataStore>().isEnglish)),

      content: TextField(controller: ctrl, keyboardType: TextInputType.number, autofocus: true, decoration: InputDecoration(labelText: tr('سعر البيع', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder(), suffixText: 'د.ل')),

      actions: [

        TextButton(onPressed: () => Navigator.pop(context), child: Text(tr('إلغاء', isEng: context.read<DataStore>().isEnglish))),

        TextButton(onPressed: () {

          final newPrice = double.tryParse(ctrl.text) ?? item.price;

          setState(() => _items[i] = InvoiceItem(

            productId: item.productId, name: item.name, price: newPrice,

            quantity: item.quantity, discountPct: item.discountPct, discountAmt: item.discountAmt,

          ));

          context.read<DataStore>().updateProductSellPrice(item.productId, newPrice);

          Navigator.pop(context);

        }, child: Text(tr('حفظ', isEng: context.read<DataStore>().isEnglish))),

      ],

    ));

  }

  void _editItemQty(int i, InvoiceItem item) {

    final ctrl = TextEditingController(text: '${item.quantity}');

    showDialog(context: context, builder: (_) => AlertDialog(

      title: Text(tr('تعديل الكمية', isEng: context.read<DataStore>().isEnglish)),

      content: TextField(controller: ctrl, keyboardType: TextInputType.number, autofocus: true, decoration: InputDecoration(labelText: tr('الكمية', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

      actions: [

        TextButton(onPressed: () => Navigator.pop(context), child: Text(tr('إلغاء', isEng: context.read<DataStore>().isEnglish))),

        TextButton(onPressed: () {

          final newQty = int.tryParse(ctrl.text) ?? item.quantity;

          if (newQty <= 0) { _removeItem(i); Navigator.pop(context); return; }

          setState(() => _items[i] = InvoiceItem(

            productId: item.productId, name: item.name, price: item.price,

            quantity: newQty, discountPct: item.discountPct, discountAmt: item.discountAmt,

          ));

          Navigator.pop(context);

        }, child: Text(tr('حفظ', isEng: context.read<DataStore>().isEnglish))),

      ],

    ));

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

              builder: (_, store, _) {

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

                                  final result = await Navigator.push<String>(ctx, PageRouteBuilder(
                                    pageBuilder: (_, _, _) => const BarcodeScannerScreen(),
                                    transitionsBuilder: (_, anim, _, child) => FadeTransition(
                                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                                      child: SlideTransition(
                                        position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                        child: child,
                                      ),
                                    ),
                                    transitionDuration: const Duration(milliseconds: 400),
                                  ));

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

                              ? Center(

                                  child: Column(

                                    mainAxisSize: MainAxisSize.min,

                                    children: [

                                      Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey[400]),

                                      const SizedBox(height: 12),

                                      Text(query.isNotEmpty ? tr('لا توجد نتائج', isEng: store.isEnglish) : tr('لا توجد منتجات', isEng: store.isEnglish), style: TextStyle(color: Colors.grey[600], fontSize: 16)),

                                      const SizedBox(height: 16),

                                      GradientButton(

                                        label: tr('إضافة منتج جديد', isEng: store.isEnglish),

                                        icon: Icons.add,

                                        gradient: AppColors.gradient1,

                                        onPressed: () {

                                          Navigator.pop(ctx);

                                          _showAddProductDialog();

                                        },

                                      ),

                                    ],

                                  ),

                                )

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



  void _showAddProductDialog() {

    final nameCtrl = TextEditingController();

    final barcodeCtrl = TextEditingController();

    final buyPriceCtrl = TextEditingController(text: '0');

    final sellPriceCtrl = TextEditingController();

    final qtyCtrl = TextEditingController(text: '1');

    final categoryCtrl = TextEditingController();

    final eng = context.read<DataStore>().isEnglish;

    showDialog(

      context: context,

      builder: (ctx) => AlertDialog(

        title: Row(children: [

          const Icon(Icons.add_circle, color: AppColors.primary),

          const SizedBox(width: 8),

          Text(tr('إضافة منتج', isEng: eng), style: const TextStyle(fontWeight: FontWeight.bold)),

        ]),

        content: SingleChildScrollView(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: tr('اسم المنتج *', isEng: eng), border: const OutlineInputBorder()), autofocus: true),

              const SizedBox(height: 12),

              TextField(controller: barcodeCtrl, decoration: InputDecoration(labelText: tr('الباركود', isEng: eng), border: const OutlineInputBorder()), keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              TextField(controller: buyPriceCtrl, decoration: InputDecoration(labelText: tr('شراء', isEng: eng), border: const OutlineInputBorder()), keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              TextField(controller: sellPriceCtrl, decoration: InputDecoration(labelText: tr('بيع *', isEng: eng), border: const OutlineInputBorder()), keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              TextField(controller: qtyCtrl, decoration: InputDecoration(labelText: tr('الكمية', isEng: eng), border: const OutlineInputBorder()), keyboardType: TextInputType.number),

              const SizedBox(height: 12),

              TextField(controller: categoryCtrl, decoration: InputDecoration(labelText: tr('التصنيف', isEng: eng), border: const OutlineInputBorder())),

            ],

          ),

        ),

        actions: [

          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(tr('إلغاء', isEng: eng))),

          FilledButton.icon(

            onPressed: () {

              if (nameCtrl.text.isEmpty || sellPriceCtrl.text.isEmpty) return;

              final store = context.read<DataStore>();

              final product = Product(

                id: const Uuid().v4(),

                name: nameCtrl.text,

                barcode: barcodeCtrl.text,

                buyPrice: double.tryParse(buyPriceCtrl.text) ?? 0,

                sellPrice: double.tryParse(sellPriceCtrl.text) ?? 0,

                quantity: int.tryParse(qtyCtrl.text) ?? 1,

                category: categoryCtrl.text,

                unit: 'قطعة',

                imagePath: '',

              );

              store.addProduct(product);

              Navigator.pop(ctx);

              _addItem(product);

              showAppToast(context, '${tr('تم إضافة المنتج', isEng: eng)}: ${product.name}', icon: Icons.check_circle, color: AppColors.success);

            },

            icon: const Icon(Icons.add, size: 18),

            label: Text(tr('إضافة', isEng: eng)),

          ),

        ],

      ),

    );

  }



  void _showAddCustomerDialog() {

    final nameCtrl = TextEditingController();

    final phoneCtrl = TextEditingController();

    final addressCtrl = TextEditingController();

    final eng = context.read<DataStore>().isEnglish;

    showDialog(

      context: context,

      builder: (ctx) => AlertDialog(

        title: Row(children: [

          const Icon(Icons.person_add, color: AppColors.primary),

          const SizedBox(width: 8),

          Text(tr('إضافة عميل', isEng: eng), style: const TextStyle(fontWeight: FontWeight.bold)),

        ]),

        content: SingleChildScrollView(

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: tr('اسم العميل *', isEng: eng), border: const OutlineInputBorder()), autofocus: true),

              const SizedBox(height: 12),

              TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: tr('الهاتف', isEng: eng), border: const OutlineInputBorder()), keyboardType: TextInputType.phone),

              const SizedBox(height: 12),

              TextField(controller: addressCtrl, decoration: InputDecoration(labelText: tr('العنوان', isEng: eng), border: const OutlineInputBorder())),

            ],

          ),

        ),

        actions: [

          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(tr('إلغاء', isEng: eng))),

          FilledButton.icon(

            onPressed: () {

              if (nameCtrl.text.isEmpty) return;

              final store = context.read<DataStore>();

              final customer = Customer(

                id: const Uuid().v4(),

                name: nameCtrl.text,

                phone: phoneCtrl.text,

                address: addressCtrl.text,

              );

              store.addCustomer(customer);

              setState(() {

                _buyerController.text = customer.name;

                _phoneController.text = customer.phone;

                _addressController.text = customer.address;

                _selectedCustomerId = customer.id;

              });

              Navigator.pop(ctx);

              showAppToast(context, '${tr('تم إضافة العميل', isEng: eng)}: ${customer.name}', icon: Icons.check_circle, color: AppColors.success);

            },

            icon: const Icon(Icons.person_add, size: 18),

            label: Text(tr('إضافة', isEng: eng)),

          ),

        ],

      ),

    );

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

      if (_useAdvanceBalance && inv.total > 0) {

        store.applyAdvanceToInvoice(_buyerController.text, inv, inv.total);

      }

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

              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(tr('مشاركة الفاتورة', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              _shareOption(Icons.chat, AppColors.whatsapp, 'واتساب PDF', () { Navigator.pop(context); shareWhatsApp(_phoneController.text, inv, sharePdf: true); }),

              _shareOption(Icons.chat, AppColors.whatsapp, 'واتساب ${tr('نص', isEng: context.read<DataStore>().isEnglish)}', () { Navigator.pop(context); shareWhatsApp(_phoneController.text, inv); }),

              _shareOption(Icons.send, Colors.blue, tr('تيليجرام', isEng: context.read<DataStore>().isEnglish), () { Navigator.pop(context); shareTelegram(inv); }),

              _shareOption(Icons.content_copy, Colors.grey, tr('نسخ النص', isEng: context.read<DataStore>().isEnglish), () {

                Navigator.pop(context);

                SharePlus.instance.share(ShareParams(text: 'فاتورة: ${inv.id} | العميل: ${inv.buyerName} | الإجمالي: ${inv.total.toStringAsFixed(2)} د.ل'));

              }),

              _shareOption(Icons.picture_as_pdf, Colors.red, 'PDF', () { Navigator.pop(context); shareInvoicePdf(inv, isEnglish: context.read<DataStore>().isEnglish); }),

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

        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),

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

        title: Text(widget.editInvoice != null ? tr('تعديل الفاتورة', isEng: context.read<DataStore>().isEnglish) : tr('فاتورة جديدة', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

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

                Row(children: [const Icon(Icons.person, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(tr('بيانات العميل', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                const SizedBox(height: 16),

                Consumer<DataStore>(

                  builder: (_, store, _) {

                    return Row(

                      children: [

                        Expanded(

                          child: DropdownButtonFormField<String>(

                            initialValue: _selectedCustomerId,

                            decoration: InputDecoration(labelText: tr('اختر عميل', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder()),

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

                          ),

                        ),

                        const SizedBox(width: 8),

                        IconButton(

                          onPressed: _showAddCustomerDialog,

                          icon: const Icon(Icons.person_add, color: AppColors.primary),

                          tooltip: tr('إضافة عميل', isEng: context.read<DataStore>().isEnglish),

                          style: IconButton.styleFrom(

                            backgroundColor: AppColors.primary.withValues(alpha: 0.1),

                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                          ),

                        ),

                      ],

                    );

                  },

                ),

                const SizedBox(height: 12),

                TextField(controller: _buyerController, decoration: InputDecoration(labelText: tr('اسم العميل *', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                const SizedBox(height: 12),

                TextField(controller: _phoneController, decoration: InputDecoration(labelText: tr('الهاتف', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.phone),

                const SizedBox(height: 12),

                TextField(controller: _addressController, decoration: InputDecoration(labelText: tr('العنوان', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                Consumer<DataStore>(builder: (_, store, _) {

                  final custName = _buyerController.text;

                  final advance = custName.isNotEmpty ? store.getCustomerAdvanceBalance(custName) : 0.0;

                  if (advance <= 0 || widget.editInvoice != null) return const SizedBox.shrink();

                  final total = _subtotal - _discAmt - (_subtotal * _discPct / 100);

                  final applyAmt = advance.clamp(0.0, total);

                  return Column(children: [

                    const SizedBox(height: 12),

                    Container(

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(

                        color: AppColors.success.withValues(alpha: 0.08),

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),

                      ),

                      child: Row(children: [

                        Icon(Icons.account_balance_wallet, color: AppColors.success, size: 20),

                        const SizedBox(width: 8),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text('رصيد الزبون: ${advance.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.success)),

                          if (applyAmt > 0) Text('سيُخصم ${applyAmt.toStringAsFixed(2)} د.ل من الفاتورة', style: TextStyle(fontSize: 11, color: Colors.grey[600])),

                        ])),

                        Switch(value: _useAdvanceBalance, onChanged: (v) => setState(() => _useAdvanceBalance = v), activeThumbColor: AppColors.success),

                      ]),

                    ),

                  ]);

                }),

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

                    Text('${tr('الأصناف', isEng: context.read<DataStore>().isEnglish)} (${_items.length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    const Spacer(),

                    GradientButton(label: 'إضافة', icon: Icons.add, gradient: AppColors.gradient1, onPressed: _showProductPicker),

                  ],

                ),

                const SizedBox(height: 12),

                if (_items.isEmpty)

                  Container(

                    padding: const EdgeInsets.all(32),

                    decoration: BoxDecoration(

                      color: AppColors.primary.withValues(alpha: 0.05),

                      borderRadius: BorderRadius.circular(16),

                    ),

                    child: Center(child: Column(

                      children: [

                        Icon(Icons.shopping_cart_outlined, size: 48, color: AppColors.primary.withValues(alpha: 0.3)),

                        const SizedBox(height: 8),

                        Text(tr('اضغط "إضافة" لاختيار منتج', isEng: context.read<DataStore>().isEnglish), style: TextStyle(color: AppColors.textSecondaryOf(context))),

                      ],

                    )),

                  )

                else

                   ...List.generate(_items.length, (i) {

                    final item = _items[i];

                    return AnimatedSize(

                      duration: const Duration(milliseconds: 200),

                      child: Container(

                        margin: const EdgeInsets.only(bottom: 12),

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(

                          color: AppColors.primary.withValues(alpha: 0.05),

                          borderRadius: BorderRadius.circular(12),

                        ),

                        child: Row(

                          children: [

                            Expanded(

                              child: Column(

                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [

                                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600)),

                                  Row(children: [

                                    GestureDetector(

                                      onTap: () => _editItemPrice(i, item),

                                      child: Container(

                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),

                                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),

                                        child: Text('${item.price.toStringAsFixed(2)} د.ل', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),

                                      ),

                                    ),

                                    Text(' x ', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                                    GestureDetector(

                                      onTap: () => _editItemQty(i, item),

                                      child: Container(

                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),

                                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),

                                        child: Text('${item.quantity}', style: TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w600)),

                                      ),

                                    ),

                                  ]),

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

                Row(children: [const Icon(Icons.calculate, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(tr('الخصم والمجموع', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                const SizedBox(height: 12),

                Row(

                  children: [

                    Expanded(child: TextField(controller: _discountPctController, decoration: InputDecoration(labelText: tr('خصم %', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (_) => setState(() {}))),

                    const SizedBox(width: 12),

                    Expanded(child: TextField(controller: _discountAmtController, decoration: InputDecoration(labelText: tr('خصم مبلغ', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number, onChanged: (_) => setState(() {}))),

                  ],

                ),

                const SizedBox(height: 16),

                Container(

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(

                    gradient: LinearGradient(colors: AppColors.gradient1.map((c) => c.withValues(alpha: 0.1)).toList()),

                    borderRadius: BorderRadius.circular(16),

                  ),

                  child: Column(

                    children: [

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text(tr('الإجمالي الفرعي', isEng: context.read<DataStore>().isEnglish)),

                        Text('${_subtotal.toStringAsFixed(2)} د.ل', style: const TextStyle(fontWeight: FontWeight.bold)),

                      ]),

                      const SizedBox(height: 8),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text(tr('الخصم', isEng: context.read<DataStore>().isEnglish)),

                        Text('${(_discAmt + _subtotal * _discPct / 100).toStringAsFixed(2)} د.ل', style: const TextStyle(color: AppColors.danger)),

                      ]),

                      const Divider(),

                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                        Text(tr('المجموع', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

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

              const SizedBox(height: 12),

              GlassCard(

                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Row(children: [const Icon(Icons.calendar_today, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(tr('تاريخ الاستحقاق', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

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

                              _dueDate != null ? _dueDate! : tr('اضغط لاختيار تاريخ الاستحقاق', isEng: context.read<DataStore>().isEnglish),

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

                    Row(children: [const Icon(Icons.notes, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(tr('ملاحظات', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                    const SizedBox(height: 12),

                    TextField(controller: _notesController, decoration: InputDecoration(labelText: tr('ملاحظات', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder()), maxLines: 2),

                  ],

                ),

              ),

              const SizedBox(height: 20),

          Row(

            children: [

              Expanded(child: OutlinedButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_forward), label: Text(tr('رجوع', isEng: context.read<DataStore>().isEnglish)))),

              const SizedBox(width: 12),

              Expanded(flex: 2, child: GradientButton(label: tr('حفظ الفاتورة', isEng: context.read<DataStore>().isEnglish), icon: Icons.save, gradient: AppColors.gradient1, onPressed: _saveInvoice, enabled: !_saved, isExpanded: true)),

            ],

          ),

          if (_saved) ...[

            const SizedBox(height: 12),

            Row(

              children: [

                Expanded(child: GradientButton(label: tr('مشاركة', isEng: context.read<DataStore>().isEnglish), icon: Icons.share, gradient: [AppColors.whatsapp, const Color(0xFF128C7E)], onPressed: () => _shareBottomSheet(_buildInvoice()), isExpanded: true)),

                const SizedBox(width: 12),

                Expanded(child: GradientButton(label: 'PDF', icon: Icons.picture_as_pdf, gradient: AppColors.gradient2, onPressed: () => printInvoice(_buildInvoice(), isEnglish: context.read<DataStore>().isEnglish), isExpanded: true)),

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



  void _showShareSheet(BuildContext context) {

    final store = context.read<DataStore>();

    final eng = store.isEnglish;

    showModalBottomSheet(

      context: context,

      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),

      builder: (_) => SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Text(tr('مشاركة الفاتورة', isEng: eng), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              const SizedBox(height: 16),

              ListTile(

                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.whatsapp.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.chat, color: AppColors.whatsapp)),

                title: Text('واتساب PDF', style: const TextStyle(fontWeight: FontWeight.w600)),

                subtitle: Text(eng ? 'Share PDF via WhatsApp' : 'مشاركة الفاتورة كـ PDF', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                trailing: const Icon(Icons.chevron_left),

                onTap: () { Navigator.pop(context); shareWhatsApp(invoice.buyerPhone, invoice, sharePdf: true); },

              ),

              ListTile(

                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: AppColors.whatsapp.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.chat, color: AppColors.whatsapp)),

                title: Text('واتساب ${tr('نص', isEng: eng)}', style: const TextStyle(fontWeight: FontWeight.w600)),

                subtitle: Text(eng ? 'Share text via WhatsApp' : 'مشاركة الفاتورة كنص', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                trailing: const Icon(Icons.chevron_left),

                onTap: () { Navigator.pop(context); shareWhatsApp(invoice.buyerPhone, invoice); },

              ),

              ListTile(

                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.send, color: Colors.blue)),

                title: Text(tr('تيليجرام', isEng: eng), style: const TextStyle(fontWeight: FontWeight.w600)),

                trailing: const Icon(Icons.chevron_left),

                onTap: () { Navigator.pop(context); shareTelegram(invoice); },

              ),

              ListTile(

                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.picture_as_pdf, color: Colors.red)),

                title: const Text('PDF', style: TextStyle(fontWeight: FontWeight.w600)),

                trailing: const Icon(Icons.chevron_left),

                onTap: () { Navigator.pop(context); shareInvoicePdf(invoice, isEnglish: eng); },

              ),

              ListTile(

                leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.content_copy, color: Colors.grey)),

                title: Text(tr('نسخ النص', isEng: eng), style: const TextStyle(fontWeight: FontWeight.w600)),

                trailing: const Icon(Icons.chevron_left),

                onTap: () {

                  Navigator.pop(context);

                  SharePlus.instance.share(ShareParams(text: '${tr("فاتورة", isEng: eng)}: ${invoice.id} | ${tr("العميل", isEng: eng)}: ${invoice.buyerName} | ${tr("الإجمالي", isEng: eng)}: ${invoice.total.toStringAsFixed(2)} د.ل'));

                },

              ),

            ],

          ),

        ),

      ),

    );

  }



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

                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Row(children: [

                  const Icon(Icons.payment, color: AppColors.primary, size: 24),

                  const SizedBox(width: 8),

                  Text(tr('إضافة دفعة', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                  const Spacer(),

                  Container(

                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

                    decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),

                    child: Text('المتبقي: ${invoice.remaining.toStringAsFixed(2)} د.ل', style: const TextStyle(fontSize: 12, color: AppColors.danger, fontWeight: FontWeight.bold)),

                  ),

                ]),

                const SizedBox(height: 16),

                Text(tr('المبلغ', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                TextField(

                  controller: amtCtrl, keyboardType: TextInputType.number, autofocus: true,

                  decoration: InputDecoration(border: const OutlineInputBorder(), suffixText: 'د.ل', hintText: tr('أدخل المبلغ', isEng: ctx.read<DataStore>().isEnglish)),

                ),

                const SizedBox(height: 12),

                Text(tr('دفع سريع', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                const SizedBox(height: 8),

                Row(

                  children: [

                    _quickPayBtn(tr('الكل', isEng: ctx.read<DataStore>().isEnglish), invoice.remaining, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn(tr('النصف', isEng: ctx.read<DataStore>().isEnglish), invoice.remaining / 2, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn(tr('الربع', isEng: ctx.read<DataStore>().isEnglish), invoice.remaining / 4, amtCtrl, setSheetState),

                    const SizedBox(width: 8),

                    _quickPayBtn(tr('الثلث', isEng: ctx.read<DataStore>().isEnglish), invoice.remaining / 3, amtCtrl, setSheetState),

                  ],

                ),

                const SizedBox(height: 16),

                Text(tr('طريقة الدفع', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

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

                            Text(paymentMethodName(m, isEnglish: ctx.read<DataStore>().isEnglish), style: TextStyle(

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

                  TextField(controller: refCtrl, decoration: InputDecoration(labelText: tr('رقم المرجع/المعاملة', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                ],

                const SizedBox(height: 12),

                TextField(controller: notesCtrl, decoration: InputDecoration(labelText: tr('ملاحظات (اختياري)', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), maxLines: 2),

                const SizedBox(height: 16),

                GradientButton(

                  label: tr('حفظ الدفعة', isEng: ctx.read<DataStore>().isEnglish),

                  icon: Icons.check,

                  gradient: AppColors.gradient4,

                  onPressed: () {

                    final amt = double.tryParse(amtCtrl.text) ?? 0;

                    if (amt > 0) {

                      final store = ctx.read<DataStore>();

                      final success = store.addPaymentToInvoice(

                        invoice, amt, selectedMethod,

                        referenceNumber: refCtrl.text.isNotEmpty ? refCtrl.text : null,

                        notes: notesCtrl.text.isNotEmpty ? notesCtrl.text : null,

                      );

                      Navigator.pop(ctx);

                      HapticFeedback.heavyImpact();

                      if (success) {

                        showAppToast(ctx, '${tr('تم تسجيل دفعة', isEng: ctx.read<DataStore>().isEnglish)} ${amt.toStringAsFixed(2)} د.ل');

                      } else {

                        showAppToast(ctx, tr('المبلغ يتجاوز المتبقي', isEng: ctx.read<DataStore>().isEnglish), icon: Icons.warning, color: AppColors.warning);

                      }

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

            gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)]),

            borderRadius: BorderRadius.circular(10),

            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),

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

        title: Text('${tr('فاتورة', isEng: context.read<DataStore>().isEnglish)} ${invoice.id}', style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

        actions: [

          IconButton(icon: const Icon(Icons.share), onPressed: () => _showShareSheet(context)),

          IconButton(icon: const Icon(Icons.print), onPressed: () => printInvoice(invoice, isEnglish: context.read<DataStore>().isEnglish)),

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

              leading: CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: 0.1), child: const Icon(Icons.person, color: AppColors.primary)),

              title: Text(invoice.buyerName.isEmpty ? tr('عميل', isEng: context.read<DataStore>().isEnglish) : invoice.buyerName, style: const TextStyle(fontWeight: FontWeight.bold)),

              subtitle: Text([invoice.buyerPhone, invoice.buyerAddress].where((s) => s.isNotEmpty).join(' | ')),

            ),

          ),

          if (invoice.dueDate != null)

            GlassCard(

              child: Container(

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(

                  color: (invoice.isOverdue ? AppColors.danger : AppColors.success).withValues(alpha: 0.05),

                  borderRadius: BorderRadius.circular(12),

                  border: Border.all(color: (invoice.isOverdue ? AppColors.danger : AppColors.success).withValues(alpha: 0.3)),

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

                Text(tr('الأصناف', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

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

                _totalRow(tr('الإجمالي', isEng: context.read<DataStore>().isEnglish), '${invoice.total.toStringAsFixed(2)} د.ل', AppColors.primary),

                if (invoice.totalPaid > 0) ...[

                  const Divider(), _totalRow(tr('المدفوع', isEng: context.read<DataStore>().isEnglish), '${invoice.totalPaid.toStringAsFixed(2)} د.ل', AppColors.success),

                ],

                if (invoice.remaining > 0) ...[

                  const Divider(), _totalRow(tr('المتبقي', isEng: context.read<DataStore>().isEnglish), '${invoice.remaining.toStringAsFixed(2)} د.ل', AppColors.danger),

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

                    Text(tr('سجل الدفعات', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    const Spacer(),

                    Text('${invoice.payments.length} دفعة', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                  ]),

                  const SizedBox(height: 12),

                  ...invoice.payments.asMap().entries.map((entry) {

                    final p = entry.value;

                    return Container(

                      margin: const EdgeInsets.only(bottom: 12),

                      padding: const EdgeInsets.all(12),

                      decoration: BoxDecoration(

                        color: AppColors.success.withValues(alpha: 0.05),

                        borderRadius: BorderRadius.circular(12),

                        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),

                      ),

                      child: Row(

                        children: [

                          Container(

                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),

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

                                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),

                                    child: Text(paymentMethodName(p.method, isEnglish: context.read<DataStore>().isEnglish), style: TextStyle(fontSize: 10, color: AppColors.primary)),

                                  ),

                                ]),

                                const SizedBox(height: 4),

                                Text('${p.date}${p.referenceNumber != null ? ' | #${p.referenceNumber!}' : ''}', style: TextStyle(fontSize: 11, color: Colors.grey[600])),

                              ],

                            ),

                          ),

                          IconButton(

                            icon: const Icon(Icons.receipt, size: 20),

                            color: AppColors.primary,

                            onPressed: () => printPaymentReceipt(invoice, p, isEnglish: context.read<DataStore>().isEnglish),

                            tooltip: tr('إيصال الدفع', isEng: context.read<DataStore>().isEnglish),

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

              label: tr('إضافة دفعة', isEng: context.read<DataStore>().isEnglish),

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

        title: Text('${tr('كشف حساب', isEng: context.read<DataStore>().isEnglish)}: $customerName', style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

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

        builder: (_, store, _) {

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

                  Expanded(child: _summaryCard(tr('المشتريات', isEng: store.isEnglish), totalPurchased, AppColors.gradient1, Icons.shopping_cart)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard(tr('المدفوعات', isEng: store.isEnglish), totalPaid, AppColors.gradient4, Icons.payment)),

                  const SizedBox(width: 8),

                  Expanded(child: _summaryCard(tr('المتبقي', isEng: store.isEnglish), totalRemaining, totalRemaining > 0 ? [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)] : AppColors.gradient4, Icons.account_balance_wallet)),

                  if (advanceBalance > 0) ...[

                    const SizedBox(width: 8),

                    Expanded(child: _summaryCard(tr('الرصيد', isEng: store.isEnglish), advanceBalance, [AppColors.success, AppColors.success.withValues(alpha: 0.7)], Icons.savings)),

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

                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),

                      child: Text(customerName.substring(0, 1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),

                    ),

                    const SizedBox(width: 16),

                    Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text(customerName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                        const SizedBox(height: 4),

                        Text('${customerInvoices.length} ${tr('فاتورة', isEng: store.isEnglish)}', style: TextStyle(color: Colors.grey[600])),

                        if (totalRemaining > 0)

                          Text('${tr('المتبقي', isEng: store.isEnglish)}: ${totalRemaining.toStringAsFixed(2)} د.ل', style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),

                      ],

                    ),

                  ],

                ),

              ),

              const SizedBox(height: 16),

              // Transactions Timeline

              Text(tr('سجل المعاملات', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

              const SizedBox(height: 12),

              if (customerInvoices.isEmpty)

                GlassCard(

                  child: Column(

                    children: [

                      Icon(Icons.receipt_long, size: 48, color: Colors.grey[400]),

                      const SizedBox(height: 12),

              Text(tr('لا توجد فواتير لهذا العميل', isEng: store.isEnglish), style: TextStyle(color: Colors.grey[600])),

                    ],

                  ),

                )

              else

                ...customerInvoices.expand((inv) => [

                  _transactionCard(inv, context),

                  ...inv.payments.map((p) => _paymentCard(p, inv.id, context)),

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

        boxShadow: [BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],

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



  Widget _transactionCard(Invoice inv, BuildContext context) {

    return GlassCard(

      onTap: () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, _, _) => InvoiceDetailScreen(invoice: inv, index: context.read<DataStore>().invoices.indexOf(inv)),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      )),

      child: Row(

        children: [

          Container(

            padding: const EdgeInsets.all(10),

            decoration: BoxDecoration(

              gradient: LinearGradient(colors: inv.status == 'paid' ? AppColors.gradient4 : [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)]),

              borderRadius: BorderRadius.circular(12),

            ),

            child: Icon(inv.status == 'paid' ? Icons.check_circle : Icons.receipt_long, color: Colors.white, size: 20),

          ),

          const SizedBox(width: 12),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text('${tr('فاتورة', isEng: context.read<DataStore>().isEnglish)} ${inv.id}', style: const TextStyle(fontWeight: FontWeight.bold)),

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



  Widget _paymentCard(Payment payment, String invoiceId, BuildContext context) {

    final store = context.read<DataStore>();

    final linkedInv = store.invoices.where((i) => i.id == invoiceId).isNotEmpty ? store.invoices.firstWhere((i) => i.id == invoiceId) : null;

    return GlassCard(

      onTap: linkedInv != null ? () => Navigator.push(context, PageRouteBuilder(
        pageBuilder: (_, _, _) => InvoiceDetailScreen(invoice: linkedInv, index: store.invoices.indexOf(linkedInv)),
        transitionsBuilder: (_, anim, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 400),
      )) : null,

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

                Text('${tr("دفعة", isEng: context.read<DataStore>().isEnglish)} - $invoiceId', style: const TextStyle(fontWeight: FontWeight.bold)),

                const SizedBox(height: 4),

                Text('${payment.date} | ${paymentMethodIcon(payment.method)} ${paymentMethodName(payment.method, isEnglish: context.read<DataStore>().isEnglish)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

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

          headers: ['الفاتورة', 'التاريخ', 'المبلغ', 'المدفوع', 'المتبقي'].map((h) => fixPdfArabic(h)).toList(),

          data: customerInvoices.map((inv) => [inv.id, inv.date, fixPdfArabic('${inv.total.toStringAsFixed(2)} د.ل'), fixPdfArabic('${inv.totalPaid.toStringAsFixed(2)} د.ل'), fixPdfArabic('${inv.remaining.toStringAsFixed(2)} د.ل')]).toList(),

          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),

        ),

        pw.Divider(),

        pw.SizedBox(height: 8),

        pdfText('إجمالي المشتريات: ${totalPurchased.toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        pdfText('إجمالي المدفوعات: ${totalPaid.toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

        pdfText('المتبقي: ${(totalPurchased - totalPaid).toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.red)),

        if (store.getCustomerAdvanceBalance(customerName) > 0) ...[

          pw.SizedBox(height: 4),

          pdfText('الرصيد المقدم: ${store.getCustomerAdvanceBalance(customerName).toStringAsFixed(2)} د.ل', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.green)),

        ],

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

        text += '  💰 ${p.date} | -${p.amount.toStringAsFixed(2)} د.ل | ${paymentMethodName(p.method, isEnglish: store.isEnglish)}\n';

      }

    }

    text += '━━━━━━━━━━━━━━━━━━━━\n';

    text += 'المشتريات: ${totalPurchased.toStringAsFixed(2)} د.ل\n';

    text += 'المدفوعات: ${totalPaid.toStringAsFixed(2)} د.ل\n';

    text += 'المتبقي: ${(totalPurchased - totalPaid).toStringAsFixed(2)} د.ل\n';

    final adv = store.getCustomerAdvanceBalance(customerName);

    if (adv > 0) text += 'الرصيد المقدم: ${adv.toStringAsFixed(2)} د.ل';



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

                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Text(tr('إضافة منتج', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 16),

                GestureDetector(

                  onTap: () async {

                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) setSheetState(() => imagePath = image.path);

                  },

                  child: Container(

                    width: 100, height: 100,

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: AppColors.gradient3.map((c) => c.withValues(alpha: 0.2)).toList()),

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),

                    ),

                    child: imagePath != null

                        ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(File(imagePath!), width: 100, height: 100, fit: BoxFit.cover))

                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            Icon(Icons.camera_alt, color: AppColors.primary, size: 32),

                            const SizedBox(height: 4),

                            Text(tr('صورة', isEng: ctx.read<DataStore>().isEnglish), style: TextStyle(fontSize: 12, color: AppColors.primary)),

                          ]),

                  ),

                ),

                const SizedBox(height: 16),

                TextField(controller: nameCtrl, decoration: InputDecoration(labelText: tr('اسم المنتج *', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: TextField(controller: barcodeCtrl, decoration: InputDecoration(labelText: tr('الباركود', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()))),

                  const SizedBox(width: 8),

                  GradientButton(label: '', icon: Icons.qr_code_scanner, gradient: AppColors.gradient3, onPressed: () async {

                    final result = await Navigator.push<String>(ctx, PageRouteBuilder(
                      pageBuilder: (_, _, _) => const BarcodeScannerScreen(),
                      transitionsBuilder: (_, anim, _, child) => FadeTransition(
                        opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                          child: child,
                        ),
                      ),
                      transitionDuration: const Duration(milliseconds: 400),
                    ));

                    if (result != null) setSheetState(() => barcodeCtrl.text = result);

                  }),

                ]),

                const SizedBox(height: 12),

                TextField(controller: categoryCtrl, decoration: InputDecoration(labelText: tr('التصنيف', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: TextField(controller: buyPriceCtrl, decoration: InputDecoration(labelText: tr('شراء', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number)),

                  const SizedBox(width: 12),

                  Expanded(child: TextField(controller: sellPriceCtrl, decoration: InputDecoration(labelText: tr('بيع *', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number)),

                ]),

                const SizedBox(height: 12),

                TextField(controller: qtyCtrl, decoration: InputDecoration(labelText: tr('الكمية', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number),

                const SizedBox(height: 16),

                GradientButton(

                  label: tr('حفظ المنتج', isEng: ctx.read<DataStore>().isEnglish), icon: Icons.save, gradient: AppColors.gradient4, isExpanded: true,

                  onPressed: () {

                    if (nameCtrl.text.isEmpty) return;

                    ctx.read<DataStore>().addProduct(Product(

                      id: const Uuid().v4(), name: nameCtrl.text, barcode: barcodeCtrl.text,

                      category: categoryCtrl.text, buyPrice: double.tryParse(buyPriceCtrl.text) ?? 0,

                      sellPrice: double.tryParse(sellPriceCtrl.text) ?? 0, quantity: int.tryParse(qtyCtrl.text) ?? 0,

                      imagePath: imagePath ?? '',

                    ));

                    Navigator.pop(ctx);

                    showAppToast(ctx, tr('تم إضافة المنتج', isEng: ctx.read<DataStore>().isEnglish));

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

        title: Text(tr('المنتجات', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

        actions: [

          IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary), onPressed: () => _showAddDialog(context)),

        ],

      ),

      body: Consumer<DataStore>(

        builder: (_, store, _) {

          if (store.products.isEmpty) {

            return EmptyState(

              icon: Icons.inventory_2,

              title: tr('لا توجد منتجات', isEng: store.isEnglish),

              subtitle: tr('أضف منتجاتك لتبدأ', isEng: store.isEnglish),

              actionLabel: tr('إضافة منتج', isEng: store.isEnglish),

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

                    hintText: tr('بحث بالاسم أو التصنيف أو الباركود...', isEng: store.isEnglish),

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

                _filterChip(tr('الكل', isEng: store.isEnglish), 'all'), _filterChip(tr('متوفر', isEng: store.isEnglish), 'inStock'), _filterChip(tr('نفذ', isEng: store.isEnglish), 'outOfStock'),

                const SizedBox(width: 8),

                PopupMenuButton<String>(

                  icon: Container(

                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),

                    child: Row(mainAxisSize: MainAxisSize.min, children: [

                      Icon(Icons.sort, size: 14, color: AppColors.primary),

                      const SizedBox(width: 4),

                      Text(tr('ترتيب', isEng: store.isEnglish), style: TextStyle(fontSize: 12, color: AppColors.primary)),

                    ]),

                  ),

                  onSelected: (v) => setState(() => _sortBy = v),

                  itemBuilder: (_) => [

                    CheckedPopupMenuItem(value: 'name', checked: _sortBy == 'name', child: Text(tr('الاسم', isEng: store.isEnglish))),

                    CheckedPopupMenuItem(value: 'price_asc', checked: _sortBy == 'price_asc', child: Text(tr('سعر ↑', isEng: store.isEnglish))),

                    CheckedPopupMenuItem(value: 'price_desc', checked: _sortBy == 'price_desc', child: Text(tr('سعر ↓', isEng: store.isEnglish))),

                    CheckedPopupMenuItem(value: 'qty_asc', checked: _sortBy == 'qty_asc', child: Text(tr('كمية ↑', isEng: store.isEnglish))),

                    CheckedPopupMenuItem(value: 'qty_desc', checked: _sortBy == 'qty_desc', child: Text(tr('كمية ↓', isEng: store.isEnglish))),

                  ],

                ),

              ]),

            ),

            if (filtered.isEmpty)

              Expanded(child: Center(child: Text(tr('لا توجد نتائج', isEng: store.isEnglish), style: TextStyle(color: Colors.grey[500], fontSize: 16)))),

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

                          title: Text(tr('حذف المنتج', isEng: store.isEnglish)), content: Text('${tr('هل أنت متأكد من حذف', isEng: store.isEnglish)} ${p.name}؟'),

                          actions: [

                            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr('إلغاء', isEng: store.isEnglish))),

                            TextButton(onPressed: () => Navigator.pop(context, true), child: Text(tr('حذف', isEng: store.isEnglish), style: const TextStyle(color: AppColors.danger))),

                          ],

                        ));

                      },

                      onDismissed: (_) { store.deleteProduct(idx); showAppToast(context, '${tr('تم حذف', isEng: store.isEnglish)} ${p.name}', icon: Icons.delete, color: AppColors.danger); },

                      background: Container(

                    margin: const EdgeInsets.only(bottom: 12),

                    decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(16)),

                    alignment: Alignment.centerLeft,

                    padding: const EdgeInsets.only(left: 24),

                    child: const Icon(Icons.delete, color: Colors.white),

                  ),

                  child: GestureDetector(
                    onTap: () {
                      final idx = store.products.indexWhere((x) => x.id == p.id);
                      if (idx >= 0) _showEditDialog(context, store, p, idx);
                    },
                    child: GlassCard(

                    margin: const EdgeInsets.only(bottom: 12),

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

                              Text('${tr('شراء', isEng: store.isEnglish)}: ${p.buyPrice.toStringAsFixed(2)} | ${tr('بيع', isEng: store.isEnglish)}: ${p.sellPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),

                            ],

                          ),

                        ),

                        Container(

                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

                          decoration: BoxDecoration(

                            color: p.quantity > 0 ? AppColors.success.withValues(alpha: 0.1) : AppColors.danger.withValues(alpha: 0.1),

                            borderRadius: BorderRadius.circular(8),

                          ),

                          child: Text('${p.quantity}', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: p.quantity > 0 ? AppColors.success : AppColors.danger)),

                        ),

                       ],

                    ),

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

        backgroundColor: AppColors.primary.withValues(alpha: 0.08),

        onSelected: (_) { HapticFeedback.selectionClick(); setState(() => _filterType = value); },

      ),

    );

  }

  void _showEditDialog(BuildContext ctx, DataStore store, Product p, int idx) {

    final nameCtrl = TextEditingController(text: p.name);

    final barcodeCtrl = TextEditingController(text: p.barcode);

    final buyPriceCtrl = TextEditingController(text: p.buyPrice.toString());

    final sellPriceCtrl = TextEditingController(text: p.sellPrice.toString());

    final qtyCtrl = TextEditingController(text: p.quantity.toString());

    final categoryCtrl = TextEditingController(text: p.category);

    String? imagePath = p.imagePath.isNotEmpty ? p.imagePath : null;

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

                Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                Text(tr('تعديل المنتج', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(height: 16),

                GestureDetector(

                  onTap: () async {

                    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                    if (image != null) setSheetState(() => imagePath = image.path);

                  },

                  child: Container(

                    width: 100, height: 100,

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: AppColors.gradient3.map((c) => c.withValues(alpha: 0.2)).toList()),

                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),

                    ),

                    child: imagePath != null

                        ? ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(File(imagePath!), width: 100, height: 100, fit: BoxFit.cover))

                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                            Icon(Icons.camera_alt, color: AppColors.primary, size: 32),

                            const SizedBox(height: 4),

                            Text(tr('صورة', isEng: ctx.read<DataStore>().isEnglish), style: TextStyle(fontSize: 12, color: AppColors.primary)),

                          ]),

                  ),

                ),

                const SizedBox(height: 16),

                TextField(controller: nameCtrl, decoration: InputDecoration(labelText: tr('اسم المنتج *', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: TextField(controller: barcodeCtrl, decoration: InputDecoration(labelText: tr('الباركود', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()))),

                  const SizedBox(width: 8),

                  GradientButton(label: '', icon: Icons.qr_code_scanner, gradient: AppColors.gradient3, onPressed: () async {

                    final result = await Navigator.push<String>(ctx, PageRouteBuilder(
                      pageBuilder: (_, _, _) => const BarcodeScannerScreen(),
                      transitionsBuilder: (_, anim, _, child) => FadeTransition(
                        opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                        child: SlideTransition(
                          position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                          child: child,
                        ),
                      ),
                      transitionDuration: const Duration(milliseconds: 400),
                    ));

                    if (result != null) setSheetState(() => barcodeCtrl.text = result);

                  }),

                ]),

                const SizedBox(height: 12),

                TextField(controller: categoryCtrl, decoration: InputDecoration(labelText: tr('التصنيف', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: TextField(controller: buyPriceCtrl, decoration: InputDecoration(labelText: tr('شراء', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number)),

                  const SizedBox(width: 12),

                  Expanded(child: TextField(controller: sellPriceCtrl, decoration: InputDecoration(labelText: tr('بيع *', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number)),

                ]),

                const SizedBox(height: 12),

                TextField(controller: qtyCtrl, decoration: InputDecoration(labelText: tr('الكمية', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.number),

                const SizedBox(height: 16),

                GradientButton(

                  label: tr('حفظ التعديلات', isEng: ctx.read<DataStore>().isEnglish), icon: Icons.save, gradient: AppColors.gradient4, isExpanded: true,

                  onPressed: () {

                    if (nameCtrl.text.isEmpty) return;

                    store.updateProduct(idx, Product(

                      id: p.id, name: nameCtrl.text, barcode: barcodeCtrl.text,

                      category: categoryCtrl.text, buyPrice: double.tryParse(buyPriceCtrl.text) ?? 0,

                      sellPrice: double.tryParse(sellPriceCtrl.text) ?? 0, quantity: int.tryParse(qtyCtrl.text) ?? 0,

                      imagePath: imagePath ?? '',

                    ));

                    Navigator.pop(ctx);

                    showAppToast(ctx, tr('تم تعديل المنتج', isEng: ctx.read<DataStore>().isEnglish), icon: Icons.check, color: AppColors.success);

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

            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Text(tr('إضافة عميل', isEng: ctx.read<DataStore>().isEnglish), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 16),

            TextField(controller: nameCtrl, decoration: InputDecoration(labelText: tr('اسم العميل *', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

            const SizedBox(height: 12),

            TextField(controller: phoneCtrl, decoration: InputDecoration(labelText: tr('الهاتف', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder()), keyboardType: TextInputType.phone),

            const SizedBox(height: 12),

            TextField(controller: addrCtrl, decoration: InputDecoration(labelText: tr('العنوان', isEng: ctx.read<DataStore>().isEnglish), border: const OutlineInputBorder())),

            const SizedBox(height: 16),

            GradientButton(

              label: tr('حفظ', isEng: ctx.read<DataStore>().isEnglish), icon: Icons.save, gradient: AppColors.gradient4, isExpanded: true,

              onPressed: () {

                if (nameCtrl.text.isEmpty) return;

                ctx.read<DataStore>().addCustomer(Customer(id: const Uuid().v4(), name: nameCtrl.text, phone: phoneCtrl.text, address: addrCtrl.text));

                Navigator.pop(ctx);

                showAppToast(ctx, tr('تم إضافة العميل', isEng: ctx.read<DataStore>().isEnglish));

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

      case 'withBalance': list = list.where((c) => store.getCustomerAdvanceBalance(c.name) > 0).toList(); break;

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

      case 'balance': list.sort((a, b) => store.getCustomerAdvanceBalance(b.name).compareTo(store.getCustomerAdvanceBalance(a.name))); break;

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

        title: Text(tr('العملاء', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

        actions: [

          IconButton(icon: const Icon(Icons.add_circle, color: AppColors.primary), onPressed: () => _showAddDialog(context)),

        ],

      ),

      body: Consumer<DataStore>(

        builder: (_, store, _) {

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

                      hintText: tr('بحث بالاسم أو الهاتف...', isEng: store.isEnglish),

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

                    _filterChip(tr('الكل', isEng: store.isEnglish), 'all'),

                    _filterChip(tr('لديه فواتير', isEng: store.isEnglish), 'withInvoices'),

                    _filterChip(tr('بدون فواتير', isEng: store.isEnglish), 'withoutInvoices'),

                    _filterChip(tr('رصيد مقدم', isEng: store.isEnglish), 'withBalance'),

                    _filterChip(tr('مع هاتف', isEng: store.isEnglish), 'withPhone'),

                  ],

                ),

              ),

              Padding(

                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

                child: Row(children: [

                  Text('${filtered.length} ${tr('عميل', isEng: store.isEnglish)}', style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                  const Spacer(),

                  TextButton.icon(

                    onPressed: () {

                      showModalBottomSheet(

                        context: context,

                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),

                        builder: (ctx) => SafeArea(

                          child: Column(mainAxisSize: MainAxisSize.min, children: [

                            Container(
                              width: 40, height: 4,
                              margin: const EdgeInsets.only(top: 12, bottom: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            Padding(padding: const EdgeInsets.all(16), child: Text(tr('ترتيب حسب', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),

                            ...[

                              ('name', tr('الاسم (أ-ي)', isEng: store.isEnglish), Icons.sort_by_alpha),

                              ('name_desc', tr('الاسم (ي-أ)', isEng: store.isEnglish), Icons.sort_by_alpha),

                              ('invoices', tr('عدد الفواتير', isEng: store.isEnglish), Icons.receipt),

                              ('balance', tr('الرصيد الأعلى', isEng: store.isEnglish), Icons.account_balance_wallet),

                            ].map((s) => ListTile(

                              leading: Icon(s.$3, color: _sortBy == s.$1 ? AppColors.primary : null),

                              title: Text(s.$2, style: TextStyle(fontWeight: _sortBy == s.$1 ? FontWeight.bold : FontWeight.normal)),

                              trailing: _sortBy == s.$1 ? const Icon(Icons.check, color: AppColors.primary) : null,

              onTap: () { HapticFeedback.selectionClick(); setState(() => _sortBy = s.$1); Navigator.pop(ctx); },

                            )),

                            const SizedBox(height: 8),

                          ]),

                        ),

                      );

                    },

                    icon: const Icon(Icons.sort, size: 14),

                    label: Text(tr('ترتيب', isEng: store.isEnglish)),

                  ),

                ]),

              ),

              Expanded(

                child: store.customers.isEmpty

                    ? EmptyState(icon: Icons.people, title: tr('لا يوجد عملاء', isEng: store.isEnglish), subtitle: tr('أضف عملاءك لتتبع فواتيرهم', isEng: store.isEnglish), actionLabel: tr('إضافة عميل', isEng: store.isEnglish), onAction: () => _showAddDialog(context))

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

                                      title: Text(tr('حذف العميل', isEng: store.isEnglish)), content: Text('${tr('هل أنت متأكد من حذف', isEng: store.isEnglish)} ${c.name}؟'),

                                      actions: [

                                        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(tr('إلغاء', isEng: store.isEnglish))),

                                        TextButton(onPressed: () => Navigator.pop(context, true), child: Text(tr('حذف', isEng: store.isEnglish), style: const TextStyle(color: AppColors.danger))),

                                      ],

                                    ));

                                  },

                                  onDismissed: (_) { store.deleteCustomer(actualIndex); showAppToast(context, '${tr('تم حذف', isEng: store.isEnglish)} ${c.name}', icon: Icons.delete, color: AppColors.danger); },

                                  background: Container(

                                    margin: const EdgeInsets.only(bottom: 12),

                                    decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(16)),

                                    alignment: Alignment.centerLeft,

                                    padding: const EdgeInsets.only(left: 24),

                                    child: const Icon(Icons.delete, color: Colors.white),

                                  ),

                                   child: GlassCard(

                                     margin: const EdgeInsets.only(bottom: 12),

                                     child: InkWell(

                                      onTap: () => Navigator.push(context, PageRouteBuilder(
                                        pageBuilder: (_, _, _) => CustomerStatementScreen(customerName: c.name),
                                        transitionsBuilder: (_, anim, _, child) => FadeTransition(
                                          opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                                          child: SlideTransition(
                                            position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                            child: child,
                                          ),
                                        ),
                                        transitionDuration: const Duration(milliseconds: 400),
                                      )),

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

                                            if (store.getCustomerAdvanceBalance(c.name) > 0) ...[

                                              Text(' | ', style: TextStyle(fontSize: 12, color: Colors.grey[400])),

                                              Text('${store.getCustomerAdvanceBalance(c.name).toStringAsFixed(0)} د.ل', style: const TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),

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

        onSelected: (_) { HapticFeedback.selectionClick(); setState(() => _filterType = value); },

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

      appBar: AppBar(title: Text(tr('الإحصائيات', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),

      body: Consumer<DataStore>(

        builder: (_, store, _) {

          final totalSales = store.invoices.fold<double>(0, (s, i) => s + i.total);

          final totalPaid = store.invoices.fold<double>(0, (s, i) => s + i.totalPaid);

          final totalRemaining = store.invoices.fold<double>(0, (s, i) => s + i.remaining);

          final avgInvoice = store.invoices.isEmpty ? 0.0 : totalSales / store.invoices.length;



          Map<String, int> customerInvoiceCount = {};

          Map<String, double> customerTotalSales = {};

          for (var inv in store.invoices) {

            final name = inv.buyerName.isEmpty ? tr('عميل', isEng: store.isEnglish) : inv.buyerName;

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

                  Expanded(child: _statCard(tr('الإجمالي', isEng: store.isEnglish), totalSales, AppColors.gradient1, Icons.attach_money, context)),

                  const SizedBox(width: 12),

                  Expanded(child: _statCard(tr('الفواتير', isEng: store.isEnglish), store.invoices.length.toDouble(), AppColors.gradient2, Icons.receipt, context)),

                ]),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: _statCard(tr('المدفوع', isEng: store.isEnglish), totalPaid, AppColors.gradient4, Icons.check_circle, context)),

                  const SizedBox(width: 12),

                  Expanded(child: _statCard(tr('المتبقي', isEng: store.isEnglish), totalRemaining, [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)], Icons.pending, context)),

                ]),

                const SizedBox(height: 12),

                Row(children: [

                  Expanded(child: _statCard(tr('المتوسط', isEng: store.isEnglish), avgInvoice, AppColors.gradient5, Icons.analytics, context)),

                  const SizedBox(width: 12),

                  Expanded(child: _statCard(tr('المنتجات', isEng: store.isEnglish), store.products.length.toDouble(), AppColors.gradient3, Icons.inventory_2, context)),

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

                          Text(tr('أفضل العملاء', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

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

                                gradient: idx == 0 ? LinearGradient(colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)]) : null,

                                color: idx != 0 ? AppColors.primary.withValues(alpha: 0.1) : null,

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

                          Text('${tr('فواتير متأخرة', isEng: store.isEnglish)} (${store.invoices.where((i) => i.isOverdue).length})', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.danger)),

                        ]),

                        const SizedBox(height: 12),

                        ...store.invoices.where((i) => i.isOverdue).take(5).map((inv) => ListTile(

                          dense: true,

                          leading: CircleAvatar(backgroundColor: AppColors.danger.withValues(alpha: 0.1), child: const Icon(Icons.warning_amber, color: AppColors.danger, size: 18)),

                          title: Text('${inv.id} - ${inv.buyerName}', style: const TextStyle(fontWeight: FontWeight.w600)),

                          subtitle: Text('متأخر ${-inv.daysUntilDue} يوم | متبقي ${inv.remaining.toStringAsFixed(2)} د.ل'),

                          trailing: const Icon(Icons.chevron_left, color: AppColors.danger),

                          onTap: () => Navigator.push(context, PageRouteBuilder(
                            pageBuilder: (_, _, _) => InvoiceDetailScreen(invoice: inv, index: store.invoices.indexOf(inv)),
                            transitionsBuilder: (_, anim, _, child) => FadeTransition(
                              opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                              child: SlideTransition(
                                position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                                child: child,
                              ),
                            ),
                            transitionDuration: const Duration(milliseconds: 400),
                          )),

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

                        Text(tr('آخر الفواتير', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                      ]),

                      const SizedBox(height: 12),

                      if (store.invoices.isEmpty)

                        Center(child: Padding(padding: const EdgeInsets.all(20), child: Text(tr('لا توجد فواتير', isEng: store.isEnglish))))

                      else

                        ...store.invoices.take(5).map((inv) => ListTile(

                          dense: true,

                          leading: Container(

                            padding: const EdgeInsets.all(8),

                            decoration: BoxDecoration(

                              color: statusColor(inv.status).withValues(alpha: 0.1),

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

                BoxShadow(color: gradient.first.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),

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

            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),

            child: Text('${val.round()}$unit', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),

          ),

        ]),

        SliderTheme(data: SliderTheme.of(context).copyWith(

          activeTrackColor: AppColors.primary, thumbColor: AppColors.primary,

          inactiveTrackColor: AppColors.primary.withValues(alpha: 0.15),

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

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).size.width / 180).floor().clamp(2, 4), crossAxisSpacing: 10, mainAxisSpacing: 10),

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

                        boxShadow: sel ? [BoxShadow(color: c.withValues(alpha: 0.5), blurRadius: 8)] : []),

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

          color: _h(hex).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12),

          border: Border.all(color: _h(hex).withValues(alpha: 0.2)),

        ),

        child: Row(children: [

          Container(width: 36, height: 36, decoration: BoxDecoration(color: _h(hex), borderRadius: BorderRadius.circular(10),

              boxShadow: [BoxShadow(color: _h(hex).withValues(alpha: 0.3), blurRadius: 6)])),

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

            Text(tr('معاينة', isEng: s.isEnglish), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

            const Spacer(),

            Container(

              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),

              child: Text(s.paperSize == 'landscape' ? tr('أفقي', isEng: s.isEnglish) : tr('عمودي', isEng: s.isEnglish), style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),

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

                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 20, offset: const Offset(0, 8))],

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

                              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),

                              child: Icon(Icons.store, color: Colors.white, size: s.logoHeight * 0.4)),

                          const SizedBox(height: 8),

                        ],

                        Text(s.customTitle.isNotEmpty ? s.customTitle : s.invoiceTitle,

                            style: TextStyle(fontSize: s.companyNameSize * 0.7, fontWeight: FontWeight.bold, color: Colors.white, height: s.lineHeight),

                            textAlign: s.logoPosition == 'center' ? TextAlign.center : (s.logoPosition == 'left' ? TextAlign.left : TextAlign.right)),

                        if (s.invoiceSubtitle.isNotEmpty) Text(s.invoiceSubtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: s.fontSize * 0.8)),

                        const SizedBox(height: 6),

                        if (s.showBadge) Align(

                          alignment: s.logoPosition == 'center' ? Alignment.center : (s.logoPosition == 'left' ? Alignment.centerLeft : Alignment.centerRight),

                          child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

                              decoration: BoxDecoration(color: sec, borderRadius: BorderRadius.circular(20)),

                              child: Text(tr('غير مدفوعة', isEng: s.isEnglish), style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),

                        ),

                      ],

                    ),

                  ),

                  if (s.showSellerInfo && s.showCompanyInfo)

                    Padding(

                      padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                      child: Row(children: [

                        CircleAvatar(radius: 16, backgroundColor: pri.withValues(alpha: 0.1), child: Icon(Icons.person, color: pri, size: 18)),

                        const SizedBox(width: 10),

                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                          Text(s.sellerName.isNotEmpty ? s.sellerName : tr('اسم المتجر', isEng: s.isEnglish), style: TextStyle(fontSize: s.fontSize, fontWeight: FontWeight.bold, color: txC)),

                          if (s.showSellerPhone && s.sellerPhone.isNotEmpty) Text(s.sellerPhone, style: TextStyle(fontSize: s.fontSize * 0.75, color: txC.withValues(alpha: 0.6))),

                          if (s.showSellerAddress && s.sellerAddress.isNotEmpty) Text(s.sellerAddress, style: TextStyle(fontSize: s.fontSize * 0.75, color: txC.withValues(alpha: 0.6))),

                        ])),

                      ]),

                    ),

                  if (s.showInfoGrid) Container(

                    margin: EdgeInsets.symmetric(horizontal: s.sectionSpacing.toDouble()),

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    decoration: BoxDecoration(color: pri.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(8)),

                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [

                      _infoCell(tr('فاتورة #', isEng: s.isEnglish), '#001', pri),

                      _infoCell(tr('التاريخ', isEng: s.isEnglish), '2025-01-01', pri),

                      if (s.showSellerPhone) _infoCell(tr('الهاتف', isEng: s.isEnglish), s.sellerPhone.isNotEmpty ? s.sellerPhone : '---', pri),

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

                          Expanded(flex: 3, child: _tHead(tr('المنتج', isEng: s.isEnglish), s)),

                          if (s.showUnitPrice) Expanded(flex: 2, child: _tHead(tr('السعر', isEng: s.isEnglish), s)),

                          Expanded(flex: 1, child: _tHead(tr('الكمية', isEng: s.isEnglish), s)),

                          if (s.showDiscountCol) Expanded(flex: 1, child: _tHead(tr('الخصم', isEng: s.isEnglish), s)),

                          Expanded(flex: 2, child: _tHead(tr('الإجمالي', isEng: s.isEnglish), s)),

                        ]),

                      ),

                      _tRow(s, 'Wireless Charger', 150, 2, 0, pri, 0),

                      _tRow(s, 'Phone Case', 45, 1, 5, pri, 1),

                      _tRow(s, 'BT Earbuds', 85, 3, 0, pri, 2),

                      Container(

                        padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                        decoration: BoxDecoration(color: pri.withValues(alpha: 0.03), borderRadius: BorderRadius.vertical(bottom: Radius.circular(8))),

                        child: Column(children: [

                          _sRow(tr('الإجمالي الفرعي', isEng: s.isEnglish), '675.00 ${s.currencySymbol}', txC),

                          _sRow(tr('الخصم', isEng: s.isEnglish), '- 5.00 ${s.currencySymbol}', Colors.red),

                          Divider(color: borderC),

                          _sRow(tr('الإجمالي', isEng: s.isEnglish), '670.00 ${s.currencySymbol}', pri, big: true),

                          const SizedBox(height: 4),

                          _sRow(tr('المدفوع', isEng: s.isEnglish), '0.00 ${s.currencySymbol}', Colors.grey),

                          _sRow(tr('المتبقي', isEng: s.isEnglish), '670.00 ${s.currencySymbol}', sec, big: true),

                        ]),

                      ),

                    ]),

                  ),

                  if (s.showTerms && s.termsText.isNotEmpty)

                    Padding(

                      padding: EdgeInsets.fromLTRB(s.sectionSpacing.toDouble(), 0, s.sectionSpacing.toDouble(), s.sectionSpacing.toDouble()),

                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

                            decoration: BoxDecoration(color: pri.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(6)),

                            child: Text(tr('الشروط', isEng: s.isEnglish), style: TextStyle(fontSize: s.fontSize * 0.75, fontWeight: FontWeight.bold, color: pri))),

                        const SizedBox(height: 6),

                        ...s.termsText.take(3).map((t) => Padding(

                          padding: const EdgeInsets.only(bottom: 3),

                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                            Padding(padding: const EdgeInsets.only(top: 5, left: 4), child: Icon(Icons.circle, size: 5, color: pri)),

                            Expanded(child: Text(t, style: TextStyle(fontSize: s.fontSize * 0.7, color: txC.withValues(alpha: 0.7), height: s.lineHeight))),

                          ]),

                        )),

                      ]),

                    ),

                  if (s.showStamps) Padding(

                    padding: EdgeInsets.symmetric(horizontal: s.sectionSpacing.toDouble()),

                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

                      _stampArea(tr('ختم البائع', isEng: s.isEnglish), pri), _stampArea(tr('توقيع المشتري', isEng: s.isEnglish), pri),

                    ]),

                  ),

                  if (s.showNotes) Padding(

                    padding: EdgeInsets.symmetric(horizontal: s.sectionSpacing.toDouble(), vertical: s.sectionSpacing.toDouble() / 2),

                    child: Container(

                      padding: const EdgeInsets.all(10),

                      decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber.withValues(alpha: 0.2))),

                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Icon(Icons.sticky_note_2, size: 16, color: Colors.amber.shade700),

                        const SizedBox(width: 8),

                        Expanded(child: Text(tr('ملاحظات إضافية...', isEng: s.isEnglish), style: TextStyle(fontSize: s.fontSize * 0.7, color: txC.withValues(alpha: 0.6), fontStyle: FontStyle.italic))),

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

                        Text('QR', style: TextStyle(fontSize: 8, color: txC.withValues(alpha: 0.4))),

                      ]),

                    )),

                  ),

                  if (s.footerText.isNotEmpty) Container(

                    padding: EdgeInsets.all(s.sectionSpacing.toDouble()),

                    decoration: BoxDecoration(

                      gradient: LinearGradient(colors: [pri.withValues(alpha: 0.08), sec.withValues(alpha: 0.05)]),

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

      Text(value, style: TextStyle(fontSize: 10, color: color.withValues(alpha: 0.7))),

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

        color: isAlt ? primary.withValues(alpha: 0.03) : Colors.transparent,

        border: s.tableRowStyle == 'borders' ? Border(bottom: BorderSide(color: _h(s.tableBorderColor), width: 0.5)) : null,

      ),

      child: Row(children: [

        if (s.showItemNumber) Expanded(flex: 1, child: Text('${idx + 1}', style: TextStyle(fontSize: 9, color: Colors.grey.shade500))),

        Expanded(flex: 3, child: Text(name, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: _h(s.textColor)))),

        if (s.showUnitPrice) Expanded(flex: 2, child: Text('${price.toStringAsFixed(0)} ${s.currencySymbol}', style: TextStyle(fontSize: 9, color: _h(s.textColor).withValues(alpha: 0.7)))),

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

        Text(label, style: TextStyle(fontSize: big ? 12 : 10, fontWeight: big ? FontWeight.bold : FontWeight.normal, color: color.withValues(alpha: big ? 1 : 0.7))),

        Text(value, style: TextStyle(fontSize: big ? 13 : 10, fontWeight: FontWeight.bold, color: color)),

      ]),

    );

  }



  Widget _stampArea(String label, Color color) {

    return Container(width: 90, height: 60,

      decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.2)), borderRadius: BorderRadius.circular(8)),

      alignment: Alignment.center,

      child: Text(label, style: TextStyle(fontSize: 8, color: color.withValues(alpha: 0.3))),

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

      _sectionLabel(tr('الثيمات الجاهزة', isEng: s.isEnglish), Icons.auto_awesome),

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

                boxShadow: active ? [BoxShadow(color: _h(p['a'] as String).withValues(alpha: 0.4), blurRadius: 12)] : [],

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

      _sectionLabel(tr('ألوان مخصصة', isEng: s.isEnglish), Icons.palette),

      _colorPicker(tr('اللون الأساسي', isEng: s.isEnglish), s.primaryColor, (c) => s.updateInvoiceSetting('primaryColor', c)),

      const SizedBox(height: 8),

      _colorPicker(tr('اللون الثانوي', isEng: s.isEnglish), s.accentColor, (c) => s.updateInvoiceSetting('accentColor', c)),

      const SizedBox(height: 8),

      _tile(tr('التدرج', isEng: s.isEnglish), s.useGradient, () => s.updateInvoiceSetting('useGradient', !s.useGradient), icon: Icons.gradient),

      _divider(),

      _sectionLabel(tr('ألوان إضافية', isEng: s.isEnglish), Icons.brush),

      _colorPicker(tr('الخلفية', isEng: s.isEnglish), s.invoiceBgColor, (c) => s.updateInvoiceSetting('invoiceBgColor', c)),

      const SizedBox(height: 8),

      _colorPicker(tr('لون النص', isEng: s.isEnglish), s.textColor, (c) => s.updateInvoiceSetting('textColor', c)),

      const SizedBox(height: 8),

      _colorPicker(tr('لون الحدود', isEng: s.isEnglish), s.tableBorderColor, (c) => s.updateInvoiceSetting('tableBorderColor', c)),

    ]);

  }



  Widget _layoutPanel(DataStore s) {

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel(tr('الورقة', isEng: s.isEnglish), Icons.pageview),

      Row(children: [

        Expanded(child: _optBtn(tr('عمودي', isEng: s.isEnglish), s.paperSize, 'portrait', (v) => s.updateInvoiceSetting('paperSize', v))),

        const SizedBox(width: 8),

        Expanded(child: _optBtn(tr('أفقي', isEng: s.isEnglish), s.paperSize, 'landscape', (v) => s.updateInvoiceSetting('paperSize', v))),

      ]),

      _sectionLabel(tr('الأبعاد', isEng: s.isEnglish), Icons.straighten),

      _slider(tr('نصف قطر الحدود', isEng: s.isEnglish), s.borderRadius, 0, 24, 'px', (v) => s.updateInvoiceSetting('borderRadius', v)),

      _slider(tr('شريط التمييز', isEng: s.isEnglish), s.accentBarHeight, 0, 10, 'px', (v) => s.updateInvoiceSetting('accentBarHeight', v)),

      _slider(tr('ارتفاع الشعار', isEng: s.isEnglish), s.logoHeight, 20, 150, 'px', (v) => s.updateInvoiceSetting('logoHeight', v)),

      _slider(tr('تباعد الأقسام', isEng: s.isEnglish), s.sectionSpacing, 4, 30, 'px', (v) => s.updateInvoiceSetting('sectionSpacing', v)),

      _slider(tr('حجم رمز QR', isEng: s.isEnglish), s.qrSize, 40, 200, 'px', (v) => s.updateInvoiceSetting('qrSize', v)),

      _sectionLabel(tr('موضع الشعار', isEng: s.isEnglish), Icons.open_with),

      Row(children: [

        Expanded(child: _optBtn(tr('يسار', isEng: s.isEnglish), s.logoPosition, 'left', (v) => s.updateInvoiceSetting('logoPosition', v))),

        const SizedBox(width: 6),

        Expanded(child: _optBtn(tr('وسط', isEng: s.isEnglish), s.logoPosition, 'center', (v) => s.updateInvoiceSetting('logoPosition', v))),

        const SizedBox(width: 6),

        Expanded(child: _optBtn(tr('يمين', isEng: s.isEnglish), s.logoPosition, 'right', (v) => s.updateInvoiceSetting('logoPosition', v))),

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

      _sectionLabel(tr('نوع الخط', isEng: s.isEnglish), Icons.font_download),

      ...fonts.map((f) {

        final active = s.fontFamily == f['id'];

        return Padding(

          padding: const EdgeInsets.only(bottom: 8),

          child: GestureDetector(

            onTap: () => s.updateInvoiceSetting('fontFamily', f['id']!),

            child: Container(

              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(

                color: active ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.shade50,

                borderRadius: BorderRadius.circular(12),

                border: Border.all(color: active ? AppColors.primary : Colors.grey.shade200, width: active ? 2 : 1),

              ),

              child: Row(children: [

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(f['name']!, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: active ? AppColors.primary : _h(s.textColor))),

                  Text(tr('أمثلة نصية', isEng: s.isEnglish), style: TextStyle(fontSize: 12, color: Colors.grey)),

                ])),

                if (active) Icon(Icons.check_circle, color: AppColors.primary, size: 20),

              ]),

            ),

          ),

        );

      }),

      const SizedBox(height: 8),

      _sectionLabel(tr('الأحجام', isEng: s.isEnglish), Icons.format_size),

      _slider(tr('الخط الأساسي', isEng: s.isEnglish), s.fontSize, 8, 18, 'px', (v) => s.updateInvoiceSetting('fontSize', v)),

      _slider(tr('اسم الشركة', isEng: s.isEnglish), s.companyNameSize, 10, 36, 'px', (v) => s.updateInvoiceSetting('companyNameSize', v)),

      _slider(tr('ارتفاع السطر', isEng: s.isEnglish), s.lineHeight, 1, 2.5, 'x', (v) => s.updateInvoiceSetting('lineHeight', v), step: 0.1),

      _slider(tr('حشو الصف', isEng: s.isEnglish), s.rowPadding, 2, 16, 'px', (v) => s.updateInvoiceSetting('rowPadding', v)),

    ]);

  }



  Widget _tablePanel(DataStore s) {

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel(tr('نمط الرأس', isEng: s.isEnglish), Icons.table_chart),

      Wrap(spacing: 8, runSpacing: 8, children: [

        _optBtn(tr('التدرج', isEng: s.isEnglish), s.tableHeaderStyle, 'gradient', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

        _optBtn(tr('صلب', isEng: s.isEnglish), s.tableHeaderStyle, 'solid', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

        _optBtn(tr('مخطط', isEng: s.isEnglish), s.tableHeaderStyle, 'outline', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

        _optBtn(tr('نظيف', isEng: s.isEnglish), s.tableHeaderStyle, 'clean', (v) => s.updateInvoiceSetting('tableHeaderStyle', v)),

      ]),

      _sectionLabel(tr('نمط الصف', isEng: s.isEnglish), Icons.view_list),

      Wrap(spacing: 8, runSpacing: 8, children: [

        _optBtn(tr('متناوب', isEng: s.isEnglish), s.tableRowStyle, 'alternating', (v) => s.updateInvoiceSetting('tableRowStyle', v)),

        _optBtn(tr('حدود', isEng: s.isEnglish), s.tableRowStyle, 'borders', (v) => s.updateInvoiceSetting('tableRowStyle', v)),

        _optBtn(tr('نظيف', isEng: s.isEnglish), s.tableRowStyle, 'clean', (v) => s.updateInvoiceSetting('tableRowStyle', v)),

      ]),

      _sectionLabel(tr('الأعمدة', isEng: s.isEnglish), Icons.view_column),

      _tile(tr('رقم الصنف', isEng: s.isEnglish), s.showItemCode, () => s.updateInvoiceSetting('showItemCode', !s.showItemCode), icon: Icons.tag),

      _tile(tr('الباركود', isEng: s.isEnglish), s.showItemBarcode, () => s.updateInvoiceSetting('showItemBarcode', !s.showItemBarcode), icon: Icons.qr_code),

      _tile(tr('سعر الوحدة', isEng: s.isEnglish), s.showUnitPrice, () => s.updateInvoiceSetting('showUnitPrice', !s.showUnitPrice), icon: Icons.attach_money),

      _tile(tr('الخصم', isEng: s.isEnglish), s.showDiscountCol, () => s.updateInvoiceSetting('showDiscountCol', !s.showDiscountCol), icon: Icons.discount),

    ]);

  }



  Widget _sectionsPanel(DataStore s) {

    final items = [

      ['showLogo', tr('الشعار', isEng: s.isEnglish), Icons.business, s.showLogo],

      ['showCompanyInfo', tr('معلومات الشركة', isEng: s.isEnglish), Icons.store, s.showCompanyInfo],

      ['showTaxNo', tr('الرقم الضريبي', isEng: s.isEnglish), Icons.pin, s.showTaxNo],

      ['showBadge', tr('شارة الدفع', isEng: s.isEnglish), Icons.badge, s.showBadge],

      ['showInfoGrid', tr('شبكة المعلومات', isEng: s.isEnglish), Icons.info, s.showInfoGrid],

      ['showQrCode', tr('رمز QR', isEng: s.isEnglish), Icons.qr_code_2, s.showQrCode],

      ['showTerms', tr('الشروط', isEng: s.isEnglish), Icons.description, s.showTerms],

      ['showStamps', tr('الختم', isEng: s.isEnglish), Icons.verified, s.showStamps],

      ['showNotes', tr('ملاحظات', isEng: s.isEnglish), Icons.sticky_note_2, s.showNotes],

      ['showPaymentDetails', tr('تفاصيل الدفع', isEng: s.isEnglish), Icons.payment, s.showPaymentDetails],

    ];

    return ListView(padding: const EdgeInsets.all(16), children: [

      _sectionLabel(tr('إظهار / إخفاء الأقسام', isEng: s.isEnglish), Icons.visibility),

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

      _sectionLabel(tr('معلومات الفاتورة', isEng: s.isEnglish), Icons.receipt),

      _inputField(tr('عنوان الفاتورة', isEng: s.isEnglish), s.invoiceTitle, (v) => s.updateInvoiceSetting('invoiceTitle', v)),

      _inputField(tr('العنوان الفرعي', isEng: s.isEnglish), s.invoiceSubtitle, (v) => s.updateInvoiceSetting('invoiceSubtitle', v)),

      Row(children: [

        Expanded(child: _inputField(tr('الرقم الابتدائي', isEng: s.isEnglish), s.invoiceStartNumber.toString(), (v) => s.updateInvoiceSetting('invoiceStartNumber', int.tryParse(v) ?? 1))),

        const SizedBox(width: 8),

        Expanded(child: _inputField(tr('العملة', isEng: s.isEnglish), s.currencySymbol, (v) => s.updateInvoiceSetting('currencySymbol', v))),

      ]),

      _inputField(tr('نص التذييل', isEng: s.isEnglish), s.footerText, (v) => s.updateInvoiceSetting('footerText', v)),

      const SizedBox(height: 8),

      _sectionLabel(tr('الشروط والأحكام', isEng: s.isEnglish), Icons.description),

      TextFormField(

        initialValue: s.termsText.join('\n'), maxLines: 6, style: const TextStyle(fontSize: 13),

        decoration: InputDecoration(

          hintText: tr('شريطة واحدة لكل سطر', isEng: s.isEnglish), hintStyle: TextStyle(color: Colors.grey.shade400),

          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),

          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),

          contentPadding: const EdgeInsets.all(14), filled: true, fillColor: Colors.grey.shade50,

        ),

        onChanged: (v) => s.updateInvoiceSetting('termsText', v.split('\n').where((l) => l.trim().isNotEmpty).toList()),

      ),

      const SizedBox(height: 12),

      _sectionLabel(tr('عنوان مخصص', isEng: s.isEnglish), Icons.edit),

      _inputField(tr('عنوان فاتورة مخصص', isEng: s.isEnglish), s.customTitle, (v) => s.updateInvoiceSetting('customTitle', v), hint: tr('اتركه فارغاً للإفتراضي', isEng: s.isEnglish)),

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

    return Consumer<DataStore>(

      builder: (ctx, s, _) {

        final tabData = [

          {'icon': Icons.palette, 'label': tr('الألوان', isEng: s.isEnglish)},

          {'icon': Icons.dashboard, 'label': tr('التخطيط', isEng: s.isEnglish)},

          {'icon': Icons.font_download, 'label': tr('الخط', isEng: s.isEnglish)},

          {'icon': Icons.table_chart, 'label': tr('الجدول', isEng: s.isEnglish)},

          {'icon': Icons.list, 'label': tr('الأقسام', isEng: s.isEnglish)},

          {'icon': Icons.edit, 'label': tr('المحتوى', isEng: s.isEnglish)},

        ];

        return Scaffold(

          backgroundColor: AppColors.bgOf(context),

          appBar: AppBar(

            title: Text(tr('إعدادات الفاتورة', isEng: s.isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),

            actions: [

              if (s.savedTemplates.isNotEmpty)

                PopupMenuButton<int>(

                  icon: const Icon(Icons.folder_open, color: AppColors.primary),

                  tooltip: tr('قوالب محفوظة', isEng: context.read<DataStore>().isEnglish),

                  onSelected: (i) {

                    s.loadTemplate(i);

                    showAppToast(context, 'تم تحميل القالب', icon: Icons.check, color: AppColors.success);

                  },

                  itemBuilder: (_) => [

                    for (int i = 0; i < s.savedTemplates.length; i++)

                      PopupMenuItem(value: i, child: Row(children: [

                        Icon(s.activeTemplate == s.savedTemplates[i]['name'] ? Icons.radio_button_checked : Icons.radio_button_unchecked, size: 18, color: AppColors.primary),

                        const SizedBox(width: 8),

                        Expanded(child: Text('${s.savedTemplates[i]['name']}', style: const TextStyle(fontWeight: FontWeight.w600))),

                        IconButton(icon: const Icon(Icons.delete, size: 18, color: AppColors.danger), onPressed: () {

                          s.deleteTemplate(i);

                          showAppToast(context, 'تم حذف القالب', icon: Icons.delete, color: AppColors.danger);

                        }),

                      ])),

                  ],

                ),

              IconButton(

                icon: const Icon(Icons.save_alt, color: AppColors.primary),

                tooltip: tr('حفظ كقالب', isEng: context.read<DataStore>().isEnglish),

                onPressed: () {

                  final ctrl = TextEditingController();

                  showDialog(context: context, builder: (_) => AlertDialog(

                    title: Text(tr('حفظ القالب', isEng: context.read<DataStore>().isEnglish)),

                    content: TextField(controller: ctrl, decoration: InputDecoration(labelText: tr('اسم القالب', isEng: context.read<DataStore>().isEnglish), border: const OutlineInputBorder()), autofocus: true),

                    actions: [

                      TextButton(onPressed: () => Navigator.pop(context), child: Text(tr('إلغاء', isEng: context.read<DataStore>().isEnglish))),

                      TextButton(onPressed: () {

                        if (ctrl.text.isNotEmpty) {

                          s.saveCurrentAsTemplate(ctrl.text);

                          Navigator.pop(context);

                          showAppToast(context, 'تم حفظ القالب: ${ctrl.text}', icon: Icons.check, color: AppColors.success);

                        }

                      }, child: Text(tr('حفظ', isEng: context.read<DataStore>().isEnglish))),

                    ],

                  ));

                },

              ),

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

              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))]),

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

              child: LayoutBuilder(

                builder: (ctx, constraints) {

                  if (constraints.maxWidth < 600) {

                    return Column(children: [

                      Expanded(child: _preview(s)),

                      Container(height: 1, color: Colors.grey.shade200),

                      SizedBox(height: 300, child: Container(color: Colors.white, child: _tabContent(s))),

                    ]);

                  }

                  return Row(children: [

                    SizedBox(width: 380, child: Container(color: Colors.white, child: _tabContent(s))),

                    Container(width: 1, color: Colors.grey.shade200),

                    Expanded(child: Padding(padding: const EdgeInsets.all(12), child: _preview(s))),

                  ]);

                },

              ),

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

      appBar: AppBar(title: Text(tr('الإعدادات', isEng: context.read<DataStore>().isEnglish), style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1)),

      body: Consumer<DataStore>(

        builder: (_, store, _) {

          return ListView(

            padding: const EdgeInsets.all(16),

            children: [

              GlassCard(

                child: SwitchListTile(

                  contentPadding: EdgeInsets.zero,

                  secondary: Container(

                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(

                      gradient: store.isDarkMode ? LinearGradient(colors: [Colors.indigo, Colors.indigo[700]!]) : LinearGradient(colors: [AppColors.warning, AppColors.warning.withValues(alpha: 0.7)]),

                      borderRadius: BorderRadius.circular(12),

                    ),

                    child: Icon(store.isDarkMode ? Icons.dark_mode : Icons.light_mode, color: Colors.white, size: 22),

                  ),

                  title: Text(tr('الوضع الليلي', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                  subtitle: Text(store.isDarkMode ? tr('مفعّل', isEng: store.isEnglish) : tr('معطّل', isEng: store.isEnglish)),

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

                    Row(children: [const Icon(Icons.palette, color: AppColors.primary, size: 20), const SizedBox(width: 8), Text(tr('القالب الافتراضي', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))]),

                    const SizedBox(height: 8),

                    Text(tr('يُستخدم تلقائياً عند إنشاء فاتورة جديدة', isEng: store.isEnglish), style: TextStyle(fontSize: 12, color: Colors.grey[500])),

                    const SizedBox(height: 8),

                    SizedBox(

                      height: 36,

                      child: ListView(

                        scrollDirection: Axis.horizontal,

                        children: invoiceTemplates.map((t) {

                          final selected = store.defaultTemplate == t.id;

                          return Padding(

                            padding: const EdgeInsets.only(right: 6),

                            child: ChoiceChip(

                              label: Text('${t.icon} ${t.name}', style: TextStyle(fontSize: 12, color: selected ? Colors.white : AppColors.primary)),

                              selected: selected,

                              selectedColor: AppColors.primary,

                              backgroundColor: AppColors.primary.withValues(alpha: 0.08),

                              onSelected: (_) {

                                HapticFeedback.lightImpact();

                                store.updateInvoiceSetting('defaultTemplate', t.id);

                                showAppToast(context, 'تم تغيير القالب الافتراضي', icon: Icons.check, color: AppColors.success);

                              },

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

                    Row(children: [

                      const Icon(Icons.store, color: AppColors.primary, size: 20),

                      const SizedBox(width: 8),

                      Text(tr('بيانات البائع', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    ]),

                    const SizedBox(height: 16),

                    TextFormField(

                      initialValue: store.sellerName,

                      decoration: InputDecoration(labelText: tr('اسم البائع / المتجر', isEng: store.isEnglish), border: const OutlineInputBorder()),

                      onChanged: (v) { store.sellerName = v; store.save(); },

                    ),

                    const SizedBox(height: 12),

                    TextFormField(

                      initialValue: store.sellerPhone,

                      decoration: InputDecoration(labelText: tr('الهاتف', isEng: store.isEnglish), border: const OutlineInputBorder()),

                      keyboardType: TextInputType.phone,

                      onChanged: (v) { store.sellerPhone = v; store.save(); },

                    ),

                    const SizedBox(height: 12),

                    TextFormField(

                      initialValue: store.sellerAddress,

                      decoration: InputDecoration(labelText: tr('العنوان', isEng: store.isEnglish), border: const OutlineInputBorder()),

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

                  title: Text(tr('إعدادات الفاتورة', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                  subtitle: Text(tr('النموذج، العنوان، العرض، والخيارات', isEng: store.isEnglish)),

                  trailing: const Icon(Icons.chevron_left),

                  onTap: () => Navigator.push(context, PageRouteBuilder(
                    pageBuilder: (_, _, _) => const InvoiceSettingsScreen(),
                    transitionsBuilder: (_, anim, _, child) => FadeTransition(
                      opacity: CurvedAnimation(parent: anim, curve: Curves.easeInOut),
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0.3, 0), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
                        child: child,
                      ),
                    ),
                    transitionDuration: const Duration(milliseconds: 400),
                  )),

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

                      Text(tr('إدارة البيانات', isEng: store.isEnglish), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                    ]),

                    const SizedBox(height: 12),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient3), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.backup, color: Colors.white),

                      ),

                      title: Text(tr('نسخ احتياطي', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text(tr('تصدير جميع البيانات', isEng: store.isEnglish)),

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

                            if (store.getCustomerAdvanceBalance(cu.name) > 0) 'ab': store.getCustomerAdvanceBalance(cu.name),

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

                              if (p.customerId != null) p.customerId,

                              if (p.invoiceId != null) p.invoiceId,

                              if (p.receiptNumber != null) p.receiptNumber,

                              if (p.appliedAmount > 0) p.appliedAmount,

                            ]).toList(),

                            if (inv.discountPct > 0) 'dp': inv.discountPct,

                            if (inv.discountAmt > 0) 'da': inv.discountAmt,

                            if (inv.notes.isNotEmpty) 'no': inv.notes,

                            if (inv.dueDate != null) 'dd': inv.dueDate,

                            't': inv.template,

                            if (inv.allocatedFromAdvance > 0) 'afa': inv.allocatedFromAdvance,

                            if (inv.advancePaymentId != null) 'api': inv.advancePaymentId,

                          }).toList(),

                          if (store.standalonePayments.isNotEmpty) 'sap': store.standalonePayments.map((p) => [

                            p.amount, p.date, p.method.index,

                            p.customerId ?? '', p.appliedAmount,

                            if (p.receiptNumber != null) p.receiptNumber,

                          ]).toList(),

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

                                  Container(
                                    width: 40, height: 4,
                                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),

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

                                    title: Text(tr('واتساب', isEng: store.isEnglish)),

                                    onTap: () { Navigator.pop(ctx); shareWhatsAppBackup(json); },

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.send, color: Colors.blue),

                                    title: Text(tr('تيليجرام', isEng: store.isEnglish)),

                                    onTap: () { Navigator.pop(ctx); shareTelegramBackup(json); },

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.email, color: Colors.red),

                                    title: Text(tr('البريد الإلكتروني', isEng: store.isEnglish)),

                                    onTap: () { Navigator.pop(ctx); shareEmailBackup(json); },

                                  ),

                                  ListTile(

                                    leading: const Icon(Icons.content_copy, color: Colors.grey),

                                    title: Text(tr('نسخ النص', isEng: store.isEnglish)),

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

                      title: Text(tr('استرجاع نسخة احتياطية', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

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

                                final custName = m['n'] ?? '';

                                store.addCustomer(Customer(

                                  id: const Uuid().v4(),

                                  name: custName,

                                  phone: m['p'] ?? '',

                                  address: m['a'] ?? '',

                                ));

                                final oldBalance = (m['ab'] ?? 0).toDouble();

                                if (oldBalance > 0) {

                                  store.addAdvancePayment(custName, Payment(

                                    amount: oldBalance,

                                    date: DateFormat('yyyy-MM-dd').format(DateTime.now()),

                                    method: PaymentMethod.cash,

                                    receiptNumber: 'MIG-$custName-${DateTime.now().millisecondsSinceEpoch}',

                                    notes: 'تم الترحيل من نسخة احتياطية',

                                  ));

                                }

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

                                      customerId: l.length > 3 ? l[3]?.toString() : null,

                                      invoiceId: l.length > 4 ? l[4]?.toString() : null,

                                      receiptNumber: l.length > 5 ? l[5]?.toString() : null,

                                      appliedAmount: l.length > 6 ? (l[6] ?? 0).toDouble() : 0,

                                    );

                                  }).toList(),

                                  discountPct: (m['dp'] ?? 0).toDouble(),

                                  discountAmt: (m['da'] ?? 0).toDouble(),

                                  notes: m['no'] ?? '',

                                  dueDate: m['dd'],

                                  template: m['t'] ?? 'classic',

                                  allocatedFromAdvance: (m['afa'] ?? 0).toDouble(),

                                  advancePaymentId: m['api'],

                                ));

                              }

                            }

                            if (data.containsKey('sap')) {

                              for (final spm in (data['sap'] as List)) {

                                final l = spm as List;

                                store.standalonePayments.add(Payment(

                                  amount: (l[0] ?? 0).toDouble(),

                                  date: l[1].toString(),

                                  method: PaymentMethod.values[l[2] ?? 0],

                                  customerId: l.length > 3 ? l[3]?.toString() : null,

                                  appliedAmount: l.length > 4 ? (l[4] ?? 0).toDouble() : 0,

                                  receiptNumber: l.length > 5 ? l[5]?.toString() : null,

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

                      title: Text(tr('تصدير المنتجات CSV', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

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

                      title: Text(tr('تصدير العملاء CSV', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text('${store.customers.length} عميل'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () => exportCustomersCsv(store.customers, store),

                    ),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.receipt_long, color: Colors.white),

                      ),

                      title: Text(tr('تصدير الفواتير CSV', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text('${store.invoices.length} فاتورة'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () => exportInvoicesCsv(store.invoices),

                    ),

                    const Divider(),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.gradient1), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.system_update, color: Colors.white),

                      ),

                      title: Text(tr('ما الجديد في هذا الإصدار', isEng: store.isEnglish), style: const TextStyle(fontWeight: FontWeight.w600)),

                      subtitle: Text('الإصدار $appVersion'),

                      trailing: const Icon(Icons.chevron_left),

                      onTap: () => _showWhatsNewDialog(context),

                    ),

                    const Divider(),

                    ListTile(

                      contentPadding: EdgeInsets.zero,

                      leading: Container(

                        padding: const EdgeInsets.all(10),

                        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.danger, AppColors.danger.withValues(alpha: 0.7)]), borderRadius: BorderRadius.circular(12)),

                        child: const Icon(Icons.delete_forever, color: Colors.white),

                      ),

                      title: Text(tr('مسح جميع البيانات', isEng: store.isEnglish), style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),

                      subtitle: Text(tr('حذف جميع الفواتير والمنتجات', isEng: store.isEnglish)),

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

