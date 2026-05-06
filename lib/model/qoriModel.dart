// {
//             "identifier": "ar.abdulbasitmurattal",
//             "language": "ar",
//             "name": "عبد الباسط عبد الصمد المرتل",
//             "englishName": "Abdul Basit",
//             "format": "audio",
//             "type": "translation",
//             "direction": null
//         },

class QoriModel {
  final String identifier;

  final String englishName;

  QoriModel({required this.identifier, required this.englishName});

  factory QoriModel.fromJson(Map<String, dynamic> json) => QoriModel(
    identifier: json["identifier"],

    englishName: json["englishName"],
  );
}
