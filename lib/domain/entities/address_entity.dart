class AddressEntity {
  final String id;
  final String title;
  final String fullAddress;
  final bool isDefault;

  const AddressEntity({
    required this.id,
    required this.title,
    required this.fullAddress,
    this.isDefault = false,
  });
}
