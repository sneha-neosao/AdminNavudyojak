class CustomerDetailItem {
  final String? id;
  final String initials;
  final String name;
  final String phone;
  final String city;
  final String amount;
  final String code;

  const CustomerDetailItem({
    this.id,
    required this.initials,
    required this.name,
    required this.phone,
    required this.city,
    required this.amount,
    required this.code,
  });
}
