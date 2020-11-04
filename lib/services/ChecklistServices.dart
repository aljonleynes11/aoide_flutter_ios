import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';

checklist(int age, String gender, double bmi, String bmiCategory,
    bool sexualPartner, bool smoking, bool heartAttack, bool diabetes) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int id = prefs.getInt('id');
  var checkListCategory1 = [
    'High Blood Sugar (Diabetes)',
    'Lipid Disorders',
    'Hepatitis B and C, and HIV',
    'Hepatitis C',
    'HIV',
    'Sexually-transmitted Infections'
  ];

  var checkListCategory2 = [
    'Colorectal Cancer',
    'Lung Cancer',
    'Breast Cancer',
    'Cervical Cancer'
  ];

  var checkListCategory3 = [
    'Consider checking your Blood Pressure regularly',
    'Screening for elevated Cardiovascular risk',
    'Interventions to promote healthful diet and physical activity for prevention of cardiovascular diseases',
    'Starting aspirin for prevention of heart disease and colorectal cancer',
    'Screening for enlarged and weakened abdominal aorta (Abdominal Aortic Aneurysm)'
  ];
  var checkListCategory4 = [
    'Influenza',
    'Tetanus bacteria and bacteria that can cause upper respiratory illness (Diphtheria) and whooping cough (Pertussis)',
    'Zoster, the agent of shingles',
    'Human Papilloma Virus (HPV), the agent of genital warts and cervical cancer',
    'Pneumococcus, the agent of Pneumonia'
  ];
  var checkListCategory5 = [
    'Lifestyle changes for weight loss',
    'Stop smoking or Interventions to help stop smoking',
    'Screening for depression',
    'Screening for Osteoporosis'
  ];
  var checklistCategories = [1, 2, 3, 4, 5];
  try {
    for (var checklist in checklistCategories) {
      switch (checklist) {
        case 1:
          for (var checkListValue in checkListCategory1) {
            switch (checkListValue) {
              //start new case checklistvalue1-1
              case 'High Blood Sugar (Diabetes)':
                bool isActive = false;
                if ((age >= 40 && age <= 70) &&
                    (bmiCategory == 'Overweight' || bmiCategory == 'Obese')) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 1,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start new case checklistvalue1-2
              case 'Lipid Disorders':
                bool isActive = false;
                if ((gender == 'M' && age >= 35) ||
                    (gender == 'F' && age >= 45)) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 1,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start new case checklistvalue1-3
              case "Hepatitis B and C, and HIV":
                bool isActive = false;
                // if statement

                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 1,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start new case checklistvalue1-4
              case "Hepatitis C":
                bool isActive = false;
                if (age >= 53 && age <= 73) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 1,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start new case checklistvalue1-5
              case "HIV":
                bool isActive = false;
                if (age >= 15 && age <= 65) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 1,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start new case checklistvalue1-6

              default:
                bool isActive = false;
                if ((gender == "f") &&
                    ((age >= 16 && age <= 24) || (sexualPartner == true))) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 1,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
            }
          }
          break;
        case 2:
          for (var checkListValue in checkListCategory2) {
            // print(checkListValue);
            switch (checkListValue) {
              //start 2-1
              case "Colorectal Cancer":
                bool isActive = false;
                if (age >= 50 && age <= 75) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 2,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 2-2
              case "Lung Cancer":
                bool isActive = false;
                if ((age >= 55 && age <= 80) && (smoking == true)) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 2,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 2-3
              case "Breast Cancer":
                bool isActive = false;
                if ((gender == "F") && (age >= 50 && age <= 74)) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 2,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 2-4
              default:
                bool isActive = false;
                if ((gender == 'F' || gender == 'f') &&
                    (age >= 21 && age <= 65)) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 2,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
            }
          }
          break;
        case 3:
          for (var checkListValue in checkListCategory3) {
            switch (checkListValue) {
              //start 3-1
              case "Consider checking your Blood Pressure regularly":
                bool isActive = false;
                if (age >= 18) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 3,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 3-2
              case "Screening for elevated Cardiovascular risk":
                bool isActive = false;
                if (age >= 40 && age <= 75) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 3,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 3-3
              case "Interventions to promote healthful diet and physical activity for prevention of cardiovascular diseases":
                bool isActive = false;
                if ((bmiCategory == "Overweight" || bmiCategory == "Obese") &&
                    (smoking == true ||
                        heartAttack == true ||
                        diabetes == true)) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 3,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 3-4
              case "Starting aspirin for prevention of heart disease and colorectal cancer":
                bool isActive = false;
                if (age >= 50 && age <= 59) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 3,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start-3-5

              default:
                bool isActive = false;
                if ((gender == "M") &&
                    (age >= 65 && age <= 75) &&
                    (smoking == true)) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 3,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
            }
          }
          break;
        case 4:
          for (var checkListValue in checkListCategory4) {
            // print(checkListValue);
            switch (checkListValue) {
              //start 4-1
              case "Influenza":
                bool isActive = false;
                if (age >= 19) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 4,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 4-2
              case "Tetanus bacteria and bacteria that can cause upper respiratory illness (Diphtheria) and whooping cough (Pertussis)":
                bool isActive = false;
                if (age >= 19) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 4,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 4-3
              case "Zoster, the agent of shingles":
                bool isActive = false;
                if (age >= 50) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 4,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 4-4
              case "Human Papilloma Virus (HPV), the agent of genital warts and cervical cancer":
                bool isActive = false;
                if (age >= 19 && age <= 21) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 4,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              default:
                bool isActive = false;
                if (age >= 65) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 4,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
            }
          }
          break;
        case 5:
          for (var checkListValue in checkListCategory5) {
            switch (checkListValue) {
              //start 5-1
              case "Lifestyle changes for weight loss":
                bool isActive = false;
                if (bmiCategory == "Overweight" || bmiCategory == "Obese") {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 5,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
              //start 5-2
              case "Stop smoking or Interventions to help stop smoking":
                bool isActive = false;
                if (smoking == true) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 5,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;

              // start 5-3
              case "Screening for depression":
                bool isActive = false;
                if (age >= 12 && age <= 65) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 5,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }

                break;
              //osteoporosis
              default:
                bool isActive = false;
                if (gender == "F" && age >= 65) {
                  isActive = true;
                }
                final response = await post(
                  'https://aoide.tk/api/health-checklist/users/$id',
                  headers: <String, String>{
                    'Content-Type': 'application/json; charset=UTF-8',
                  },
                  body: jsonEncode(<String, dynamic>{
                    'feature': checkListValue,
                    'checklist_category_id': 5,
                    'is_active': isActive
                  }),
                );
                final res = json.decode(response.body);
                if (response.statusCode == 200) {
                  print('$checkListValue : $isActive');
                }
                break;
            }
          }
          break;
      }
    }
  } catch (e) {
    print(e);
  }
}
