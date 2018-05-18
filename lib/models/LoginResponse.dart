import 'package:debut_assets/models/Data.dart';


class LoginResponse {


  int status;
  String message;
  String id;
  Data data;
  String eventStatus;

  int getStatus() {
    return status;
  }

  void setStatus(int status) {
    this.status = status;
  }

  String getMessage() {
    return message;
  }

  void setMessage(String message) {
    this.message = message;
  }

  String getId() {
    return id;
  }

  void setId(String id) {
    this.id = id;
  }

  Data getData() {
    return data;
  }

  void setData(Data data) {
    this.data = data;
  }

  String getEventStatus() {
    return eventStatus;
  }

  void setEventStatus(String eventStatus) {
    this.eventStatus = eventStatus;
  }

  LoginResponse.fromJson(this.status, this.message, this.id, this.data,
      this.eventStatus);

}