// // // To parse this JSON data, do
// // //
// // //     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.id,
    this.username,
    this.email,
    this.generalInfos,
    this.medicalConditions,
    this.badHabits,
    this.bloodPressureHistory,
    this.restingHeartRateHistory,
    this.bloodSugarHistory,
    this.weightHistory,
    this.morningMedications,
    this.afternoonMedications,
    this.eveningMedications,
  });

  int id;
  String username;
  String email;
  GeneralInfos generalInfos;
  MedicalConditions medicalConditions;
  BadHabits badHabits;
  List<dynamic> bloodPressureHistory;
  List<dynamic> restingHeartRateHistory;
  List<dynamic> bloodSugarHistory;
  List<dynamic> weightHistory;
  List<dynamic> morningMedications;
  List<dynamic> afternoonMedications;
  List<dynamic> eveningMedications;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"] == null ? null : json["id"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
        generalInfos: json["general_infos"] == null
            ? null
            : GeneralInfos.fromJson(json["general_infos"]),
        medicalConditions: json["medical_conditions"] == null
            ? null
            : MedicalConditions.fromJson(json["medical_conditions"]),
        badHabits: json["bad_habits"] == null
            ? null
            : BadHabits.fromJson(json["bad_habits"]),
        bloodPressureHistory: json["blood_pressure_history"] == null
            ? null
            : List<dynamic>.from(json["blood_pressure_history"].map((x) => x)),
        restingHeartRateHistory: json["resting_heart_rate_history"] == null
            ? null
            : List<dynamic>.from(
                json["resting_heart_rate_history"].map((x) => x)),
        bloodSugarHistory: json["blood_sugar_history"] == null
            ? null
            : List<dynamic>.from(json["blood_sugar_history"].map((x) => x)),
        weightHistory: json["weight_history"] == null
            ? null
            : List<dynamic>.from(json["weight_history"].map((x) => x)),
        morningMedications: json["morning_medications"] == null
            ? null
            : List<dynamic>.from(json["morning_medications"].map((x) => x)),
        afternoonMedications: json["afternoon_medications"] == null
            ? null
            : List<dynamic>.from(json["afternoon_medications"].map((x) => x)),
        eveningMedications: json["evening_medications"] == null
            ? null
            : List<dynamic>.from(json["evening_medications"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
        "general_infos": generalInfos == null ? null : generalInfos.toJson(),
        "medical_conditions":
            medicalConditions == null ? null : medicalConditions.toJson(),
        "bad_habits": badHabits == null ? null : badHabits.toJson(),
        "blood_pressure_history": bloodPressureHistory == null
            ? null
            : List<dynamic>.from(bloodPressureHistory.map((x) => x)),
        "resting_heart_rate_history": restingHeartRateHistory == null
            ? null
            : List<dynamic>.from(restingHeartRateHistory.map((x) => x)),
        "blood_sugar_history": bloodSugarHistory == null
            ? null
            : List<dynamic>.from(bloodSugarHistory.map((x) => x)),
        "weight_history": weightHistory == null
            ? null
            : List<dynamic>.from(weightHistory.map((x) => x)),
        "morning_medications": morningMedications == null
            ? null
            : List<dynamic>.from(morningMedications.map((x) => x)),
        "afternoon_medications": afternoonMedications == null
            ? null
            : List<dynamic>.from(afternoonMedications.map((x) => x)),
        "evening_medications": eveningMedications == null
            ? null
            : List<dynamic>.from(eveningMedications.map((x) => x)),
      };
}

class BadHabits {
  BadHabits({
    this.smoke,
    this.alcohol,
    this.illicitDrugs,
    this.moreThanOneSexualPartner,
  });

  dynamic smoke;
  dynamic alcohol;
  dynamic illicitDrugs;
  dynamic moreThanOneSexualPartner;

  factory BadHabits.fromJson(Map<String, dynamic> json) => BadHabits(
        smoke: json["smoke"],
        alcohol: json["alcohol"],
        illicitDrugs: json["illicit_drugs"],
        moreThanOneSexualPartner: json["more_than_one_sexual_partner"],
      );

  Map<String, dynamic> toJson() => {
        "smoke": smoke,
        "alcohol": alcohol,
        "illicit_drugs": illicitDrugs,
        "more_than_one_sexual_partner": moreThanOneSexualPartner,
      };
}

class GeneralInfos {
  GeneralInfos({
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
    this.bmiCategory,
  });

  dynamic birthday;
  dynamic age;
  dynamic image;
  dynamic gender;
  dynamic race;
  dynamic height;
  dynamic heightUnit;
  dynamic weight;
  dynamic weightUnit;
  dynamic bmi;
  dynamic bmiCategory;

  factory GeneralInfos.fromJson(Map<String, dynamic> json) => GeneralInfos(
        birthday: json["birthday"],
        age: json["age"],
        image: json["image"],
        gender: json["gender"],
        race: json["race"],
        height: json["height"],
        heightUnit: json["height_unit"],
        weight: json["weight"],
        weightUnit: json["weight_unit"],
        bmi: json["bmi"],
        bmiCategory: json["bmi_category"],
      );

  Map<String, dynamic> toJson() => {
        "birthday": birthday,
        "age": age,
        "image": image,
        "gender": gender,
        "race": race,
        "height": height,
        "height_unit": heightUnit,
        "weight": weight,
        "weight_unit": weightUnit,
        "bmi": bmi,
        "bmi_category": bmiCategory,
      };
}

class MedicalConditions {
  MedicalConditions({
    this.hasPriorHeartAttackOrCoronaryArteryDisease,
    this.hasStroke,
    this.hasDiabetes,
    this.hasHighBloodPressureOrHypertension,
    this.hasKidneyDisease,
    this.hasFamilyHistoryOfHeartAttackStrokeDiabetes,
  });

  dynamic hasPriorHeartAttackOrCoronaryArteryDisease;
  dynamic hasStroke;
  dynamic hasDiabetes;
  dynamic hasHighBloodPressureOrHypertension;
  dynamic hasKidneyDisease;
  dynamic hasFamilyHistoryOfHeartAttackStrokeDiabetes;

  factory MedicalConditions.fromJson(Map<String, dynamic> json) =>
      MedicalConditions(
        hasPriorHeartAttackOrCoronaryArteryDisease:
            json["has_prior_heart_attack_or_coronary_artery_disease"],
        hasStroke: json["has_stroke"],
        hasDiabetes: json["has_diabetes"],
        hasHighBloodPressureOrHypertension:
            json["has_high_blood_pressure_or_hypertension"],
        hasKidneyDisease: json["has_kidney_disease"],
        hasFamilyHistoryOfHeartAttackStrokeDiabetes:
            json["has_family_history_of_heart_attack_stroke_diabetes"],
      );

  Map<String, dynamic> toJson() => {
        "has_prior_heart_attack_or_coronary_artery_disease":
            hasPriorHeartAttackOrCoronaryArteryDisease,
        "has_stroke": hasStroke,
        "has_diabetes": hasDiabetes,
        "has_high_blood_pressure_or_hypertension":
            hasHighBloodPressureOrHypertension,
        "has_kidney_disease": hasKidneyDisease,
        "has_family_history_of_heart_attack_stroke_diabetes":
            hasFamilyHistoryOfHeartAttackStrokeDiabetes,
      };
}
// class User {
//   final int id;
//   final String username;

//   User({this.id, this.username});

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       username: json['username'],
//     );
//   }
// }
