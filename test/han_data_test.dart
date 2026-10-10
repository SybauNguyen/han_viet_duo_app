import 'package:flutter_test/flutter_test.dart';
import 'package:han_viet_duo/data/han_seed_data.dart';
import 'package:han_viet_duo/data/question.dart';

void main() {
  test('moi bai co 20 cau hoi co ban; bai co 學 co them cau dien khuyet', () {
    for (var index = 0; index < lessonUnits.length; index++) {
      final characters = charactersForUnit(index);
      final questions = generateQuestions(characters);
      final expected = characters.length * 4 + (characters.any((c) => c.character == '學') ? 1 : 0);
      expect(characters, hasLength(5));
      expect(questions, hasLength(expected));
      expect(questions.take(5).every((q) => q.type == QuestionType.radical), isTrue);
      expect(questions.skip(5).take(10).every((q) => q.sectionTitle == 'Phần 2: Học Âm & Nghĩa'), isTrue);
      expect(questions.skip(questions.length - 5).every((q) => q.type == QuestionType.typing), isTrue);
    }
  });

  test('cau trac nghiem co 4 lua chon duy nhat va chua dap an', () {
    for (var index = 0; index < lessonUnits.length; index++) {
      for (final question in generateQuestions(charactersForUnit(index))) {
        if (question.type == QuestionType.typing) {
          expect(question.options, isEmpty);
          expect(question.acceptedAnswers, isNotEmpty);
        } else {
          expect(question.options, hasLength(4), reason: question.prompt);
          expect(question.options.toSet(), hasLength(4), reason: question.prompt);
          expect(question.options, contains(question.correctAnswer), reason: question.prompt);
        }
      }
    }
  });

  test('bo du lieu gom 125 chu duy nhat va cac bai hoc deu tro den chu co that', () {
    expect(seedCharacters, hasLength(125));
    expect(seedCharacters.map((c) => c.character).toSet(), hasLength(125));
    expect(findCharacter('一')?.hanVietReading, 'nhất');
    expect(findCharacter('忠')?.hanVietReading, 'trung');
    expect(findCharacter('中')?.hanVietReading, 'trung');
    expect(findCharacter('犬')?.hanVietReading, 'khuyển');
    expect(findCharacter('青')?.meaning, 'màu xanh');
    expect(findCharacter('看')?.hanVietReading, 'khán');
    expect(findCharacter('年')?.hanVietReading, 'niên');
    expect(findCharacter('米')?.meaning, 'gạo');
    expect(lessonUnits, hasLength(25));
    for (final unit in lessonUnits) {
      expect(unit.characters, hasLength(5), reason: unit.title);
      for (final symbol in unit.characters) {
        expect(findCharacter(symbol), isNotNull, reason: 'Missing seed for $symbol');
      }
    }
  });

  test('typed answers accept both Han-Viet reading and meaning', () {
    final questions = generateQuestions(charactersForUnit(0));
    final typed = questions.where((q) => q.type == QuestionType.typing).first;
    expect(typed.acceptedAnswers, contains(typed.correctAnswer.toLowerCase()));
    expect(typed.acceptedAnswers, contains(findCharacter(typed.character)!.meaning.toLowerCase()));
  });
}
