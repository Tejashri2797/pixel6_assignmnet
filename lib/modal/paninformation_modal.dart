class PanInformationModal {
  String? status;
  int? statusCode;
  bool? isValid;
  String? fullName;

  PanInformationModal({
    this.status,
    this.statusCode,
    this.isValid,
    this.fullName,
  });

  factory PanInformationModal.fromJson(Map<String, dynamic> json) => PanInformationModal(
    status:    json["status"],
    statusCode: json["statusCode"],
    isValid:   json["isValid"],
    fullName:   json["fullName"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statusCode": statusCode,
    "isValid": isValid,
    "fullName": fullName,
  };
}
