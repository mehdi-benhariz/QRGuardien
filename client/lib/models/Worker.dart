class Worker {
  final String name;
  final String phone;
  final String password;
  final bool isAdmin;

  Worker(this.name, this.phone, this.password, this.isAdmin);
  Worker.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        phone = json['phone'],
        password = json['password'],
        isAdmin = json['isAdmin'];
  Map<String, dynamic> toJson() =>
      {'name': name, 'phone': phone, 'password': password, 'isAdmin': isAdmin};
}
