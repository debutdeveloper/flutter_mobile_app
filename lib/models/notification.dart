import 'package:debut_assets/models/Request.dart';

class AssetNotification {
  String id;
  String rev;
  int reqType;
  String requestId;
  String oldRequestId;
  String description;
  String startTiming;
  String endTiming;
  int priority;
  User user;
  CurrentAsset asset;
  Sender sender;
  String docType;
  String createdAt;
  String updatedAt;
  int action;

  AssetNotification.fromJSON(Map<String, dynamic> json) {
    id = json["_id"];
    rev = json["_rev"];
    reqType = json["req_type"];
    requestId = json["request_id"];
    oldRequestId = json["old_request_id"];
    description = json["description"];
    startTiming = json["start_timing"];
    endTiming = json["end_timing"];
    priority = json["priority"];
    user = new User.fromJSON(json["user"]);
    asset = new CurrentAsset.fromJSON(json["asset"]);
    sender = new Sender.fromJSON(json["sender"]);
    docType = json["doc_type"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    action = json["action"];
  }
}

class Sender {
  String id;
  String firstName;
  String lastName;

  Sender.fromJSON(Map<String, dynamic> json) {
    id = json["id"];
    firstName = json["first_name"];
    lastName = json["last_name"];
  }
}
