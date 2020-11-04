class UserGeneralInfo {
  int userId;
  String birthday;
  int age;
  var image;
  var gender;
  var race;
  var height;
  var heightUnit;
  var weight;
  var weightUnit;
  var bmi;
  var bmiCategory;

  UserGeneralInfo(
      {this.userId,
      this.birthday,
      this.age,
      this.image,
      this.gender,
      this.race,
      this.height,
      this.heightUnit,
      this.weight,
      this.weightUnit,
      this.bmi,
      this.bmiCategory});

  UserGeneralInfo.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    birthday = json['birthday'];
    age = json['age'];
    image = json['image'];
    gender = json['gender'];
    race = json['race'];
    height = json['height'];
    heightUnit = json['height_unit'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    bmi = json['bmi'];
    bmiCategory = json['bmi_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['birthday'] = this.birthday;
    data['age'] = this.age;
    data['image'] = this.image;
    data['gender'] = this.gender;
    data['race'] = this.race;
    data['height'] = this.height;
    data['height_unit'] = this.heightUnit;
    data['weight'] = this.weight;
    data['weight_unit'] = this.weightUnit;
    data['bmi'] = this.bmi;
    data['bmi_category'] = this.bmiCategory;
    return data;
  }
}
