// class Dashboard {
//   int id;
//   String username;
//   int followers;
//   int following;
//   Profile profile;
//   Null latestBloodPressure;
//   Null latestBloodSugar;
//   Null latestWeight;
//   Null latestRestingHeartRate;

//   Dashboard(
//       {this.id,
//       this.username,
//       this.followers,
//       this.following,
//       this.profile,
//       this.latestBloodPressure,
//       this.latestBloodSugar,
//       this.latestWeight,
//       this.latestRestingHeartRate});

//   Dashboard.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     username = json['username'];
//     followers = json['followers'];
//     following = json['following'];
//     profile =
//         json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
//     latestBloodPressure = json['latest_blood_pressure'];
//     latestBloodSugar = json['latest_blood_sugar'];
//     latestWeight = json['latest_weight'];
//     latestRestingHeartRate = json['latest_resting_heart_rate'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['username'] = this.username;
//     data['followers'] = this.followers;
//     data['following'] = this.following;
//     if (this.profile != null) {
//       data['profile'] = this.profile.toJson();
//     }
//     data['latest_blood_pressure'] = this.latestBloodPressure;
//     data['latest_blood_sugar'] = this.latestBloodSugar;
//     data['latest_weight'] = this.latestWeight;
//     data['latest_resting_heart_rate'] = this.latestRestingHeartRate;
//     return data;
//   }
// }

// class Profile {
//   String birthday;
//   int age;
//   Null image;
//   String gender;
//   String height;
//   String heightUnit;
//   String bmi;
//   String bmiCategory;

//   Profile(
//       {this.birthday,
//       this.age,
//       this.image,
//       this.gender,
//       this.height,
//       this.heightUnit,
//       this.bmi,
//       this.bmiCategory});

//   Profile.fromJson(Map<String, dynamic> json) {
//     birthday = json['birthday'];
//     age = json['age'];
//     image = json['image'];
//     gender = json['gender'];
//     height = json['height'];
//     heightUnit = json['height_unit'];
//     bmi = json['bmi'];
//     bmiCategory = json['bmi_category'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['birthday'] = this.birthday;
//     data['age'] = this.age;
//     data['image'] = this.image;
//     data['gender'] = this.gender;
//     data['height'] = this.height;
//     data['height_unit'] = this.heightUnit;
//     data['bmi'] = this.bmi;
//     data['bmi_category'] = this.bmiCategory;
//     return data;
//   }
// }

// To parse this JSON data, do
//
//     final dashboard = dashboardFromJson(jsonString);

import 'dart:convert';

Dashboard dashboardFromJson(String str) => Dashboard.fromJson(json.decode(str));

String dashboardToJson(Dashboard data) => json.encode(data.toJson());

class Dashboard {
  Dashboard({
    this.id,
    this.username,
    this.followers,
    this.following,
    this.profile,
    this.latestBloodPressure,
    this.latestBloodSugar,
    this.latestWeight,
    this.latestRestingHeartRate,
  });

  int id;
  String username;
  int followers;
  int following;
  Profile profile;
  dynamic latestBloodPressure;
  dynamic latestBloodSugar;
  dynamic latestWeight;
  dynamic latestRestingHeartRate;

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        followers: json["followers"] == null ? null : json["followers"],
        following: json["following"] == null ? null : json["following"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
        latestBloodPressure: json["latest_blood_pressure"],
        latestBloodSugar: json["latest_blood_sugar"],
        latestWeight: json["latest_weight"],
        latestRestingHeartRate: json["latest_resting_heart_rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "followers": followers == null ? null : followers,
        "following": following == null ? null : following,
        "profile": profile == null ? null : profile.toJson(),
        "latest_blood_pressure": latestBloodPressure,
        "latest_blood_sugar": latestBloodSugar,
        "latest_weight": latestWeight,
        "latest_resting_heart_rate": latestRestingHeartRate,
      };
}

class Profile {
  Profile({
    this.birthday,
    this.age,
    this.image,
    this.gender,
    this.height,
    this.heightUnit,
    this.bmi,
    this.bmiCategory,
  });

  DateTime birthday;
  int age;
  dynamic image;
  String gender;
  String height;
  String heightUnit;
  String bmi;
  String bmiCategory;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        birthday:
            json["birthday"] == null ? null : DateTime.parse(json["birthday"]),
        age: json["age"] == null ? null : json["age"],
        image: json["image"],
        gender: json["gender"] == null ? null : json["gender"],
        height: json["height"] == null ? null : json["height"],
        heightUnit: json["height_unit"] == null ? null : json["height_unit"],
        bmi: json["bmi"] == null ? null : json["bmi"],
        bmiCategory: json["bmi_category"] == null ? null : json["bmi_category"],
      );

  Map<String, dynamic> toJson() => {
        "birthday": birthday == null
            ? null
            : "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
        "age": age == null ? null : age,
        "image": image,
        "gender": gender == null ? null : gender,
        "height": height == null ? null : height,
        "height_unit": heightUnit == null ? null : heightUnit,
        "bmi": bmi == null ? null : bmi,
        "bmi_category": bmiCategory == null ? null : bmiCategory,
      };
}
