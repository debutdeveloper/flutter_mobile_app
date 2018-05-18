class Data {

  String firstName;
  String lastName;
  String docType;
  String empId;
  String password;
  String countryCode;
  int phoneNumber;
  String email;
  int role;
  String deviceToken;
  int status;
  bool isRandomPassword;
  String createdAt;
  String updatedAt;
  bool isDeleted;
  String deletedAt;
  String token;

  Data.fromjson(this.firstName, this.lastName, this.docType, this.empId,
      this.password, this.countryCode, this.phoneNumber, this.email, this.role,
      this.deviceToken, this.status, this.isRandomPassword, this.createdAt,
      this.updatedAt, this.isDeleted, this.deletedAt, this.token);

  String getFirstName() {
    return firstName;
  }

  void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  String getLastName() {
    return lastName;
  }

  void setLastName(String lastName) {
    this.lastName = lastName;
  }

  String getDocType() {
    return docType;
  }

  void setDocType(String docType) {
    this.docType = docType;
  }

  String getEmpId() {
    return empId;
  }

  void setEmpId(String empId) {
    this.empId = empId;
  }

  String getPassword() {
    return password;
  }

  void setPassword(String password) {
    this.password = password;
  }

  String getCountryCode() {
    return countryCode;
  }

  void setCountryCode(String countryCode) {
    this.countryCode = countryCode;
  }

  int getPhoneNumber() {
    return phoneNumber;
  }

  void setPhoneNumber(int phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  int getRole() {
    return role;
  }

  void setRole(int role) {
    this.role = role;
  }

  String getDeviceToken() {
    return deviceToken;
  }

  void setDeviceToken(String deviceToken) {
    this.deviceToken = deviceToken;
  }

  int getStatus() {
    return status;
  }

  void setStatus(int status) {
    this.status = status;
  }

  bool getIsRandomPassword() {
    return isRandomPassword;
  }

  void setIsRandomPassword(bool isRandomPassword) {
    this.isRandomPassword = isRandomPassword;
  }

  String getCreatedAt() {
    return createdAt;
  }

  void setCreatedAt(String createdAt) {
    this.createdAt = createdAt;
  }

  String getUpdatedAt() {
    return updatedAt;
  }

  void setUpdatedAt(String updatedAt) {
    this.updatedAt = updatedAt;
  }

  bool getIsDeleted() {
    return isDeleted;
  }

  void setIsDeleted(bool isDeleted) {
    this.isDeleted = isDeleted;
  }

  String getDeletedAt() {
    return deletedAt;
  }

  void setDeletedAt(String deletedAt) {
    this.deletedAt = deletedAt;
  }

  String getToken() {
    return token;
  }

  void setToken(String token) {
    this.token = token;
  }

}