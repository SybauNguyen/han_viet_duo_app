class HanCharacter {
  final String character;
  final String hanVietReading;
  final String meaning;
  final String radical;
  final String structure;
  final int difficulty;
  final List<String> examples;

  const HanCharacter({
    required this.character,
    required this.hanVietReading,
    required this.meaning,
    required this.radical,
    required this.structure,
    required this.difficulty,
    this.examples = const [],
  });
}

class LessonUnit {
  final String title;
  final String subtitle;
  final List<String> characters;
  final String icon;

  const LessonUnit({
    required this.title,
    required this.subtitle,
    required this.characters,
    required this.icon,
  });
}
