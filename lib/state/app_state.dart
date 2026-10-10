import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/han_seed_data.dart';

class AppState extends ChangeNotifier {
  int xp = 0;
  int streak = 0;
  int gems = 500;
  int hearts = 5;
  int completedLessons = 0;
  Map<String, int> mastery = {};
  String? lastStudyDate;
  bool isReady = false;

  int get level => (xp ~/ 100) + 1;
  int get xpInLevel => xp % 100;
  int get unlockedLessons => (completedLessons + 1).clamp(1, lessonUnits.length) as int;

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      xp = prefs.getInt('xp') ?? 0;
      streak = prefs.getInt('streak') ?? 0;
      gems = prefs.getInt('gems') ?? 500;
      // Chuyển dữ liệu từ bản MVP trước: cấp số dư ban đầu đủ mua gói tim đầu tiên.
      if (!(prefs.getBool('heartShopMigrationV2') ?? false)) {
        if (gems < 500) gems = 500;
        await prefs.setInt('gems', gems);
        await prefs.setBool('heartShopMigrationV2', true);
      }
      hearts = prefs.getInt('hearts') ?? 5;
      completedLessons = prefs.getInt('completedLessons') ?? 0;
      lastStudyDate = prefs.getString('lastStudyDate');
      final rawMastery = prefs.getString('mastery');
      if (rawMastery != null) {
        final decoded = jsonDecode(rawMastery) as Map<String, dynamic>;
        mastery = decoded.map((key, value) => MapEntry(key, (value as num).toInt()));
      }
    } catch (_) {
      // Neu du lieu cu bi loi, app van mo voi tien do mac dinh.
    }
    isReady = true;
    notifyListeners();
  }

  int masteryOf(String character) => mastery[character] ?? 0;

  Future<void> recordWrongAnswer() async {
    if (hearts > 0) hearts--;
    await _save();
    notifyListeners();
  }

  Future<void> restoreHeart() async {
    if (hearts >= 5 || gems < 50) return;
    gems -= 50;
    hearts++;
    await _save();
    notifyListeners();
  }

  /// Mua một gói tim bằng đá quý. Trả về false nếu không đủ đá quý.
  Future<bool> buyHearts({required int cost, required int amount}) async {
    if (gems < cost || hearts >= 5 || amount <= 0) return false;
    gems -= cost;
    hearts = (hearts + amount).clamp(0, 5) as int;
    await _save();
    notifyListeners();
    return true;
  }

  /// Nhận tim thưởng (ví dụ sau quảng cáo giả lập).
  Future<void> addHeart(int amount) async {
    if (amount <= 0 || hearts >= 5) return;
    hearts = (hearts + amount).clamp(0, 5) as int;
    await _save();
    notifyListeners();
  }

  Future<void> finishLesson({
    required int? lessonIndex,
    required Set<String> masteredCharacters,
  }) async {
    xp += 20;
    gems += 5;
    hearts = hearts < 5 ? hearts + 1 : hearts;

    for (final character in masteredCharacters) {
      mastery[character] = ((mastery[character] ?? 0) + 1).clamp(0, 5) as int;
    }

    if (lessonIndex != null) {
      completedLessons = completedLessons < lessonIndex + 1
          ? lessonIndex + 1
          : completedLessons;
    }

    final today = _dateKey(DateTime.now());
    if (lastStudyDate != today) {
      final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
      streak = lastStudyDate == yesterday ? streak + 1 : 1;
      lastStudyDate = today;
    }

    await _save();
    notifyListeners();
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('xp', xp);
      await prefs.setInt('streak', streak);
      await prefs.setInt('gems', gems);
      await prefs.setInt('hearts', hearts);
      await prefs.setInt('completedLessons', completedLessons);
      if (lastStudyDate != null) await prefs.setString('lastStudyDate', lastStudyDate!);
      await prefs.setString('mastery', jsonEncode(mastery));
    } catch (_) {
      // Loi luu khong lam dung vong hoc; du lieu van duoc giu trong phien hien tai.
    }
  }

  String _dateKey(DateTime date) {
    final local = date.toLocal();
    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}';
  }
}
