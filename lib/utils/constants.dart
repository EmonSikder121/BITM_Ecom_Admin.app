const String currencySymbol = '৳';
//eta amar...don't use, use ur own key
const serverKey = 'AAAAbhC8-yI:APA91bE6HRRfa_k8RSO0Z5_ZpNKLAXNflKTycSt8AOTLO-Yzf7_6GRSFMmNx4VY8C_yymQPKeuDITlimy83ft0n0Occ2aGWe9NL6lSpABrCm3atk26qm2lJCjxmcMu2aEydXheshpcRu';
const cities = [
  'Dhaka',
  'Chittagong',
  'Rajshahi',
  'Khulna',
  'Barishal',
  'Sylhet',
  'Comilla',
  'Noakhali',
  'Faridpur',
  'Rangpur',
  'Gopalgonj'
];

abstract class OrderStatus {
  static const String pending = 'Pending';
  static const String processing = 'Processing';
  static const String delivered = 'Delivered';
  static const String cancelled = 'Cancelled';
  static const String returned = 'Returned';
}

abstract class PaymentMethod {
  static const String cod = 'Cash on Delivery';
  static const String online = 'Online Payment';
}

abstract class NotificationType {
  static const String comment = 'New Comment';
  static const String order = 'New Order';
  static const String user = 'New User';
}

class ScreenSizes {
  static const double xs = 480.0;
  static const double sm = 640.0;
  static const double md = 768.0;
  static const double lg = 1024.0;
  static const double xl = 1280.0;
  static const double xxl = 1536.0;
}
