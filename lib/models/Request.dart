class CurrentAsset {
  String description;
  String id;
  String name;

  CurrentAsset.fromJSON(Map<String,dynamic> json){
    description  = json["description"];
    id = json["id"];
    name = json["name"];
  }
}

class User {
  String first_name;
  String id;
  String last_name;

  User.fromJSON(Map<String,dynamic> json){
    first_name = json["first_name"];
    id= json["id"];
    last_name= json["last_name"];
  }
}

class Value {
  CurrentAsset currentAsset;
  String created_at;
  String description;
  String doc_type;
  String end_timing;
  bool is_deleted;
  int priority;
  String start_timing;
  int status;
  String updated_at;
  User user;

  Value.fromJSON(Map<String, dynamic> json) {
    currentAsset = CurrentAsset.fromJSON(json["asset"]);
    created_at = json["created_at"];
    description = json["description"];
    doc_type = json["doc_type"];
    end_timing = json["end_timing"];
    is_deleted = json["is_deleted"];
    priority = json["priority"];
    start_timing = json["start_timing"];
    status = json["status"];
    updated_at = json["updated_at"];
    user = User.fromJSON(json["user"]);
  }
}

class Request {
  String id;
  Value value;

  Request.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    value = Value.fromJSON(json["value"]);
  }
}
