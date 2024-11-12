class AddressModel {
  int? id;
  String? customerId;
  String? receiverName;
  String? phoneNumber;
  String? province;
  String? district;
  String? commune;
  String? house;

  AddressModel(
      {this.id,
      this.customerId,
      this.receiverName,
      this.phoneNumber,
      this.province,
      this.district,
      this.commune,
      this.house});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerId = json['customer_id'];
    receiverName = json['receiver_name'];
    phoneNumber = json['phone_number'];
    province = json['province'];
    district = json['district'];
    commune = json['commune'];
    house = json['house'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_id'] = this.customerId;
    data['receiver_name'] = this.receiverName;
    data['phone_number'] = this.phoneNumber;
    data['province'] = this.province;
    data['district'] = this.district;
    data['commune'] = this.commune;
    data['house'] = this.house;
    return data;
  }
}
