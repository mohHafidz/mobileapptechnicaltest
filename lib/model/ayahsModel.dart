class Ayah {
  final String text;
  final String audio;
  final String translation;

  Ayah({required this.text, required this.audio, required this.translation});

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      text: json['text'],
      audio: json['audio'],
      translation: json['translation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'audio': audio, 'translation': translation};
  }
}
