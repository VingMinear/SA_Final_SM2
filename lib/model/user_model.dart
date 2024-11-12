// ignore_for_file: public_member_api_docs, sort_constructors_first
const defualtImage =
    'https://firebasestorage.googleapis.com/v0/b/fir-auth-1d214.appspot.com/o/empty.jpg?alt=media&token=34a0ae35-94b2-4007-97cb-e55797ab9257';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  late String photo;
  String? provide;
  bool isActive = true;
  bool isAdmin = false;
  UserModel(
      {this.id,
      this.name,
      this.email,
      this.photo = defualtImage,
      this.provide,
      this.isActive = true,
      this.phone,
      this.isAdmin = false});

  UserModel.fromJson(Map<String, dynamic> json) {
    provide = json["provide"];
    id = json['id'];
    name = json['name'];
    email = json['email'];
    photo = json['photo'] ?? '';
    phone = json['phone'];
    isActive = json['active'] ?? true;
    isAdmin = json['isAdmin'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['proide'] = this.provide;
    data['email'] = this.email;
    data['photo'] = this.photo;
    return data;
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, photo: $photo, provide: $provide)';
  }
}
