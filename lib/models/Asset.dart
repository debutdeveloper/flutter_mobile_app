class Asset {
  String key;
  Record record;

  Asset.fromJSON(Map<String,dynamic> json){
    key = json["Key"];
    record = new Record.fromJSON(json["Record"]);
  }
}

class Category {
  String id;
  String name;

  Category.fromJSON(Map<String,dynamic> json){
    id = json["id"];
    name = json["name"];
  }
}

class Record {
  int asset_number;
  Category category;
  String color;
  String created_at;
  String deleted_at;
  String description;
  String doc_type;
  bool is_deleted;
  String name;
  String purchase_date;
  int purchasing_amount;
  int quantity;
  String serial_number;
  int status;
  String updated_at;
  String warranty_upto;

  Record.fromJSON(Map<String,dynamic> json){
    asset_number = json["asset_number"];
    category = new Category.fromJSON(json["category"]);
    color = json["color"];
    created_at = json["created_at"];
    deleted_at = json["deleted_at"];
    description = json["description"];
    doc_type = json["doc_type"];
    is_deleted = json["is_deleted"];
    name = json["name"];
    purchase_date = json["purchase_date"];
    purchasing_amount = json["purchasing_amount"];
    quantity = json["quantity"];
    serial_number = json["serial_number"];
    status = json["status"];
    updated_at = json["updated_at"];
    warranty_upto = json["warranty_upto"];
  }
}
