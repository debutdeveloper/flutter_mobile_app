class CurrentUser{
  String id;
  Data data;

  CurrentUser.fromJSON(Map<String,dynamic> json){
    id = json["id"];
    data = new Data.fromJSON(json["data"]);
  }
}

class Data{
  String first_name;
  String last_name;
  String doc_type;
  String emp_id;
  String password;
  String country_code;
  int phone_number;
  String email;
  int role;
  String device_token;
  int status;
  bool is_random_password;
  String created_at;
  String updated_at;
  bool is_deleted;
  String deleted_at;
  String token;

  Data.fromJSON(Map<String,dynamic> json){
    first_name = json['first_name'];
    last_name= json['last_name'];
    doc_type = json['doc_type'];
    emp_id = json['emp_id'];
    password = json['password'];
    country_code = json['country_code'];
    phone_number = json['phone_number'];
    email = json['email'];
    role = json['role'];
    device_token = json['device_token'];
    status = json['status'];
    is_random_password = json['is_random_password'];
    created_at = json['created_at'];
    updated_at = json['updated_at'];
    is_deleted = json['is_deleted'];
    deleted_at = json['deleted_at'];
    token = json['token'];
  }
}
