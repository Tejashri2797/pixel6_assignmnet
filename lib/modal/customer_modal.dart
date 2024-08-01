
class CustomerModal {
  String? pan;
  String? name;
  String? email;
  String? mobile;
  String? addressLine1;
  String? addressLine2;
  String? postCode;
  String? state;
  String? city;

  CustomerModal({
     this.pan,
     this.name,
     this.email,
     this.mobile,
     this.addressLine1,
     this.addressLine2,
     this.postCode,
     this.state,
     this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      'pan': pan,
      'name': name,
      'email': email,
      'mobile': mobile,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'postCode': postCode,
      'state': state,
      'city': city,
    };
  }

  static CustomerModal fromJson(Map<String, dynamic> json) {
    return CustomerModal(
      pan: json['pan'],
      name: json['name'],
      email: json['email'],
      mobile: json['mobile'],
      addressLine1: json['addressLine1'],
      addressLine2: json['addressLine2'],
      postCode: json['postCode'],
      state: json['state'],
      city: json['city'],
    );
  }
}