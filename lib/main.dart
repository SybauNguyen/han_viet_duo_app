import 'package:flutter/material.dart';

import 'data/han_character.dart';
import 'data/han_seed_data.dart';
import 'data/question.dart';
import 'state/app_state.dart';
import 'widgets/interactive_sentence.dart';

const Color kGreen = Color(0xFF28664F);
const Color kGreenLight = Color(0xFFE4F1E8);
const Color kPaper = Color(0xFFF7F8F3);
const Color kOrange = Color(0xFFCC6B3D);
const Color kBlue = Color(0xFF3186C8);
const Color kRed = Color(0xFFD94343);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HanVietApp());
}

class HanVietApp extends StatefulWidget {
  const HanVietApp({super.key});

  @override
  State<HanVietApp> createState() => _HanVietAppState();
}

class _HanVietAppState extends State<HanVietApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _appState.load();
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hán-Việt Duo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kGreen),
        scaffoldBackgroundColor: kPaper,
        appBarTheme: const AppBarTheme(
          backgroundColor: kPaper,
          foregroundColor: Color(0xFF20372C),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kGreen,
            foregroundColor: Colors.white,
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE4E9E3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: kGreen, width: 1.5),
          ),
        ),
      ),
      home: AppShell(appState: _appState),
    );
  }
}

class AppShell extends StatefulWidget {
  final AppState appState;
  const AppShell({super.key, required this.appState});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(appState: widget.appState),
      ReviewScreen(appState: widget.appState),
      DictionaryScreen(appState: widget.appState),
      ProfileScreen(appState: widget.appState),
    ];

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        indicatorColor: kGreenLight,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.route_outlined), selectedIcon: Icon(Icons.route), label: 'Học'),
          NavigationDestination(icon: Icon(Icons.refresh_rounded), label: 'Ôn tập'),
          NavigationDestination(icon: Icon(Icons.menu_book_outlined), selectedIcon: Icon(Icons.menu_book), label: 'Từ điển'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Hồ sơ'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final AppState appState;
  const HomeScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final nextUnit = appState.completedLessons.clamp(0, lessonUnits.length - 1);
        return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Icon(Icons.eco_rounded, color: kGreen, size: 27),
                SizedBox(width: 8),
                Text('Hán-Việt Duo', style: TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  tooltip: 'Khôi phục tim (50 đá quý)',
                  onPressed: appState.hearts < 5 && appState.gems >= 50
                      ? () async {
                          await appState.restoreHeart();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(appState.hearts < 5
                                    ? 'Đã khôi phục 1 tim.'
                                    : 'Đã khôi phục tim thành công!'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.favorite_rounded, color: kRed),
                ),
              ),
            ],
          ),
          body: SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
              children: [
                Text('Xin chào, học giả! 👋', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54)),
                const SizedBox(height: 5),
                Text('Mỗi ngày một chữ,\nthêm một điều hay.', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900, height: 1.12, color: const Color(0xFF20372C))),
                const SizedBox(height: 20),
                _StatsStrip(appState: appState),
                const SizedBox(height: 18),
                _DailyGoalCard(xp: appState.xpInLevel, level: appState.level),
                const SizedBox(height: 28),
                Row(
                  children: [
                    const Expanded(child: Text('LỘ TRÌNH HỌC', style: TextStyle(fontSize: 13, letterSpacing: 1.3, fontWeight: FontWeight.w900, color: kGreen))),
                    Text('${appState.completedLessons}/${lessonUnits.length} bài', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 12),
                for (var index = 0; index < lessonUnits.length; index++) ...[
                  _LessonUnitTile(
                    unit: lessonUnits[index],
                    index: index,
                    isUnlocked: index <= appState.completedLessons,
                    isCompleted: index < appState.completedLessons,
                    isCurrent: index == nextUnit,
                    onTap: () {
                      if (index <= appState.completedLessons) {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                          builder: (_) => LessonScreen(appState: appState, lessonIndex: index),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Hoàn thành bài trước để mở khóa bài này nhé!')),
                        );
                      }
                    },
                  ),
                  if (index != lessonUnits.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 36),
                      child: Container(width: 3, height: 14, color: const Color(0xFFDDE5DD)),
                    ),
                ],
                const SizedBox(height: 18),
                const Text('Mẹo hôm nay', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
                const SizedBox(height: 8),
                const _TipCard(
                  icon: Icons.lightbulb_outline_rounded,
                  title: 'Nhìn bộ thủ để nhớ chữ',
                  body: '忠 (trung thành) có 中 ở trên và 心 (tâm) ở dưới — gợi nhớ tấm lòng trung thành.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final AppState appState;
  const _StatsStrip({required this.appState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _MiniStat(icon: Icons.local_fire_department_rounded, value: '${appState.streak}', label: 'Chuỗi ngày', color: kOrange)),
        const SizedBox(width: 8),
        Expanded(child: _MiniStat(icon: Icons.diamond_rounded, value: '${appState.gems}', label: 'Đá quý', color: kBlue)),
        const SizedBox(width: 8),
        Expanded(child: _MiniStat(icon: Icons.favorite_rounded, value: '${appState.hearts}/5', label: 'Tim', color: kRed)),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  const _MiniStat({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 9),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE9EDE8))),
      child: Column(
        children: [
          Icon(icon, color: color, size: 23),
          const SizedBox(height: 5),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          const SizedBox(height: 1),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _DailyGoalCard extends StatelessWidget {
  final int xp;
  final int level;
  const _DailyGoalCard({required this.xp, required this.level});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF28664F), Color(0xFF184B39)]),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.school_rounded, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('CẤP ĐỘ $level', style: const TextStyle(color: Color(0xFFCBE7D3), fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w900)),
              const SizedBox(height: 3),
              const Text('Mục tiêu hôm nay', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(value: xp / 100, minHeight: 7, backgroundColor: Colors.white24, color: const Color(0xFFFFD27A)),
              ),
              const SizedBox(height: 5),
              Text('$xp/100 XP để lên cấp', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _LessonUnitTile extends StatelessWidget {
  final LessonUnit unit;
  final int index;
  final bool isUnlocked;
  final bool isCompleted;
  final bool isCurrent;
  final VoidCallback onTap;
  const _LessonUnitTile({required this.unit, required this.index, required this.isUnlocked, required this.isCompleted, required this.isCurrent, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isCompleted ? kGreen : isCurrent ? kOrange : Colors.grey;
    return Material(
      color: isCurrent ? const Color(0xFFF0F6EF) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: isCurrent ? const Color(0xFFB4D5BB) : const Color(0xFFE8ECE7), width: isCurrent ? 1.5 : 1)),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(color: isUnlocked ? color.withOpacity(0.12) : const Color(0xFFF0F1EF), borderRadius: BorderRadius.circular(17)),
                alignment: Alignment.center,
                child: isCompleted
                    ? const Icon(Icons.check_circle_rounded, color: kGreen, size: 30)
                    : isUnlocked
                        ? Text(unit.icon, style: const TextStyle(fontSize: 25))
                        : const Icon(Icons.lock_outline_rounded, color: Colors.black38),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('BÀI ${index + 1}', style: TextStyle(fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w900, color: color)),
                  const SizedBox(height: 3),
                  Text(unit.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                  const SizedBox(height: 3),
                  Text(unit.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 9),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(value: isCompleted ? 1 : isCurrent ? 0.12 : 0, minHeight: 5, backgroundColor: const Color(0xFFE9EDE8), color: color),
                  ),
                ]),
              ),
              const SizedBox(width: 8),
              Icon(isCompleted ? Icons.check_rounded : isUnlocked ? Icons.chevron_right_rounded : Icons.lock_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  final AppState appState;
  const ReviewScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final reviewCharacters = [...seedCharacters]
          ..sort((a, b) => appState.masteryOf(a.character).compareTo(appState.masteryOf(b.character)));
        final due = reviewCharacters.take(8).toList();
        return Scaffold(
          appBar: AppBar(title: const Text('Ôn tập mỗi ngày', style: TextStyle(fontWeight: FontWeight.w800))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(22)),
                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.psychology_alt_rounded, color: kGreen, size: 32),
                  SizedBox(height: 10),
                  Text('Nhớ lâu hơn bằng cách ôn lại', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Color(0xFF20372C))),
                  SizedBox(height: 6),
                  Text('Các chữ có mức thuần thục thấp được ưu tiên lên đầu danh sách.', style: TextStyle(height: 1.4, color: Colors.black54)),
                ]),
              ),
              const SizedBox(height: 18),
              Row(children: [const Expanded(child: Text('GỢI Ý ÔN TẬP', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, color: kGreen, fontSize: 12))), Text('${due.length} chữ', style: const TextStyle(color: Colors.black54))]),
              const SizedBox(height: 10),
              for (final character in due)
                Card(
                  child: ListTile(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CharacterDetailScreen(character: character, appState: appState))),
                    leading: Container(width: 48, height: 48, alignment: Alignment.center, decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(14)), child: Text(character.character, style: const TextStyle(fontSize: 27, color: kGreen, fontWeight: FontWeight.w600))),
                    title: Text(character.hanVietReading.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text('${character.meaning}  •  Thuần thục ${appState.masteryOf(character.character)}/5'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                  ),
                ),
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => LessonScreen(appState: appState, reviewMode: true))),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Bắt đầu ôn tập'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class DictionaryScreen extends StatefulWidget {
  final AppState appState;
  const DictionaryScreen({super.key, required this.appState});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final results = seedCharacters.where((character) {
      if (query.isEmpty) return true;
      return character.character.toLowerCase().contains(query) ||
          character.hanVietReading.toLowerCase().contains(query) ||
          character.meaning.toLowerCase().contains(query) ||
          character.radical.toLowerCase().contains(query) ||
          character.examples.any((word) => word.toLowerCase().contains(query));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Từ điển Hán-Việt', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
        children: [
          const Text('Tra chữ, nhớ nghĩa, hiểu cấu tạo.', style: TextStyle(color: Colors.black54, fontSize: 15)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(hintText: 'Tìm chữ, âm Hán-Việt hoặc nghĩa...', prefixIcon: Icon(Icons.search_rounded)),
          ),
          const SizedBox(height: 16),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final popular in ['nhất', 'trung', 'học', 'tâm', 'người'])
              ActionChip(label: Text(popular), onPressed: () { _controller.text = popular; setState(() => _query = popular); }),
          ]),
          const SizedBox(height: 18),
          Text('${results.length} kết quả', style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (results.isEmpty)
            const Padding(padding: EdgeInsets.all(32), child: Column(children: [Icon(Icons.search_off_rounded, size: 44, color: Colors.black38), SizedBox(height: 8), Text('Chưa tìm thấy chữ phù hợp.')]))
          else
            for (final character in results)
              Card(
                child: ListTile(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => CharacterDetailScreen(character: character, appState: widget.appState))),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  leading: Container(width: 54, height: 54, alignment: Alignment.center, decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(16)), child: Text(character.character, style: const TextStyle(fontSize: 30, color: kGreen))),
                  title: Text(character.hanVietReading.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  subtitle: Text('${character.meaning}\nBộ: ${character.radical}', maxLines: 2),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
              ),
        ],
      ),
    );
  }
}

class CharacterDetailScreen extends StatelessWidget {
  final HanCharacter character;
  final AppState appState;
  const CharacterDetailScreen({super.key, required this.character, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thẻ học Hán tự', style: TextStyle(fontWeight: FontWeight.w800))),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(26)),
            child: Column(children: [
              Text(character.character, style: const TextStyle(fontSize: 104, height: 1.15, fontWeight: FontWeight.w500, color: kGreen)),
              const SizedBox(height: 8),
              Text(character.hanVietReading.toUpperCase(), style: const TextStyle(color: kOrange, fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 1.6)),
              const SizedBox(height: 7),
              Text(character.meaning, textAlign: TextAlign.center, style: const TextStyle(fontSize: 17, color: Color(0xFF32473B))),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('THÔNG TIN CHỮ', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.3, color: kGreen)),
          const SizedBox(height: 8),
          _InfoCard(label: 'Bộ thủ', value: character.radical, icon: Icons.category_outlined),
          const SizedBox(height: 8),
          _InfoCard(label: 'Cấu tạo', value: character.structure, icon: Icons.dashboard_customize_outlined),
          const SizedBox(height: 8),
          _InfoCard(label: 'Độ khó', value: 'Cấp ${character.difficulty}', icon: Icons.stairs_outlined),
          const SizedBox(height: 20),
          const Text('TỪ GHÉP GỢI Ý', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.3, color: kGreen)),
          const SizedBox(height: 8),
          if (character.examples.isEmpty)
            const Text('Chưa có từ ghép cho chữ này.')
          else
            for (final example in character.examples)
              Card(child: ListTile(leading: const Icon(Icons.auto_stories_outlined, color: kGreen), title: Text(example, style: const TextStyle(fontWeight: FontWeight.w700)))),
          const SizedBox(height: 18),
          AnimatedBuilder(
            animation: appState,
            builder: (context, _) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Row(children: [const Icon(Icons.insights_rounded, color: kBlue), const SizedBox(width: 10), Expanded(child: Text('Mức thuần thục: ${appState.masteryOf(character.character)}/5', style: const TextStyle(fontWeight: FontWeight.w800))), const Icon(Icons.auto_awesome, color: kOrange)]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _InfoCard({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(leading: Icon(icon, color: kGreen), title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)), subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF20372C)))));
  }
}

class ProfileScreen extends StatelessWidget {
  final AppState appState;
  const ProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        final masteredCount = appState.mastery.values.where((value) => value >= 3).length;
        return Scaffold(
          appBar: AppBar(title: const Text('Hồ sơ học tập', style: TextStyle(fontWeight: FontWeight.w800))),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                child: Column(children: [
                  Container(width: 84, height: 84, decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(28)), child: const Icon(Icons.person_rounded, color: kGreen, size: 48)),
                  const SizedBox(height: 12),
                  const Text('Học giả Hán-Việt', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22)),
                  const SizedBox(height: 5),
                  Text('Cấp độ ${appState.level} • ${appState.xp} XP tích lũy', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 20),
                  Row(children: [
                    Expanded(child: _ProfileMetric(value: '${appState.completedLessons}', label: 'Bài hoàn thành', icon: Icons.flag_rounded)),
                    Expanded(child: _ProfileMetric(value: '${appState.streak}', label: 'Chuỗi ngày', icon: Icons.local_fire_department_rounded)),
                    Expanded(child: _ProfileMetric(value: '$masteredCount', label: 'Chữ nhớ tốt', icon: Icons.school_rounded)),
                  ]),
                ]),
              ),
              const SizedBox(height: 24),
              const Text('THÀNH TỰU', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2, fontSize: 12, color: kGreen)),
              const SizedBox(height: 10),
              _AchievementTile(title: 'Bước đầu tiên', description: 'Hoàn thành bài học đầu tiên', icon: Icons.flag_rounded, unlocked: appState.completedLessons >= 1),
              const SizedBox(height: 8),
              _AchievementTile(title: 'Người học chăm chỉ', description: 'Hoàn thành 3 bài học', icon: Icons.local_fire_department_rounded, unlocked: appState.completedLessons >= 3),
              const SizedBox(height: 8),
              _AchievementTile(title: 'Tích lũy kiến thức', description: 'Đạt 100 XP', icon: Icons.bolt_rounded, unlocked: appState.xp >= 100),
              const SizedBox(height: 8),
              _AchievementTile(title: 'Học giả', description: 'Thuần thục ít nhất 5 chữ', icon: Icons.workspace_premium_rounded, unlocked: masteredCount >= 5),
              const SizedBox(height: 20),
              const _TipCard(icon: Icons.cloud_done_outlined, title: 'Tiến độ được lưu trên thiết bị', body: 'XP, đá quý, tim, bài đã mở khóa và mức độ ghi nhớ được lưu cục bộ trên máy này.'),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileMetric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  const _ProfileMetric({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(children: [Icon(icon, color: kGreen, size: 22), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, color: Colors.black54))]);
  }
}

class _AchievementTile extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  const _AchievementTile({required this.title, required this.description, required this.icon, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(leading: CircleAvatar(backgroundColor: unlocked ? const Color(0xFFFFE9B5) : const Color(0xFFEDEEEB), child: Icon(icon, color: unlocked ? kOrange : Colors.black38)), title: Text(title, style: TextStyle(fontWeight: FontWeight.w800, color: unlocked ? const Color(0xFF20372C) : Colors.black54)), subtitle: Text(description), trailing: Icon(unlocked ? Icons.check_circle_rounded : Icons.lock_outline_rounded, color: unlocked ? kGreen : Colors.black26)));
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _TipCard({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), border: Border.all(color: const Color(0xFFE6EBE4))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: const Color(0xFFFFF1D7), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: kOrange)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(body, style: const TextStyle(color: Colors.black54, height: 1.45))])),
      ]),
    );
  }
}

class LessonScreen extends StatefulWidget {
  final AppState appState;
  final int? lessonIndex;
  final bool reviewMode;
  const LessonScreen({super.key, required this.appState, this.lessonIndex, this.reviewMode = false});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  late final List<HanCharacter> _characters;
  late final List<Question> _questions;
  int _questionIndex = 0;
  String? _selectedOption;
  bool _checked = false;
  bool _isCorrect = false;
  bool _finishing = false;
  bool _outOfHeartsDialogOpen = false;
  final Set<String> _correctCharacters = {};
  final TextEditingController _typingController = TextEditingController();

  Question get _question => _questions[_questionIndex];

  @override
  void initState() {
    super.initState();
    if (widget.reviewMode) {
      _characters = [...seedCharacters]
        ..sort((a, b) => widget.appState.masteryOf(a.character).compareTo(widget.appState.masteryOf(b.character)));
      _characters.removeRange(5, _characters.length);
    } else {
      _characters = charactersForUnit(widget.lessonIndex ?? 0);
    }
    _questions = generateQuestions(_characters);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.appState.hearts <= 0) _showOutOfHeartsDialog();
    });
  }

  String _normalizeAnswer(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  Future<void> _checkAnswer() async {
    if (_selectedOption == null || _selectedOption!.trim().isEmpty || _checked) return;

    final typed = _normalizeAnswer(_selectedOption!);
    final accepted = _question.acceptedAnswers?.map(_normalizeAnswer).toList() ?? const <String>[];
    final correct = _question.type == QuestionType.typing
        ? accepted.contains(typed)
        : _selectedOption == _question.correctAnswer;

    setState(() {
      _checked = true;
      _isCorrect = correct;
      if (correct) _correctCharacters.add(_question.character);
    });
    FocusManager.instance.primaryFocus?.unfocus();

    if (!correct) {
      await widget.appState.recordWrongAnswer();
      if (!mounted) return;
      setState(() {});
      if (widget.appState.hearts <= 0) await _showOutOfHeartsDialog();
    }
  }

  Future<void> _showOutOfHeartsDialog() async {
    if (!mounted || _outOfHeartsDialogOpen || widget.appState.hearts > 0) return;
    _outOfHeartsDialogOpen = true;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.heart_broken_rounded, color: kRed, size: 48),
        title: const Text('Hết tim rồi!', textAlign: TextAlign.center, style: TextStyle(fontSize: 23, fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Bạn đã dùng hết trái tim. Hãy nạp thêm để tiếp tục bài học nhé!', textAlign: TextAlign.center),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () async {
                final success = await widget.appState.buyHearts(cost: 350, amount: 5);
                if (!mounted) return;
                if (success) {
                  Navigator.of(dialogContext).pop();
                  setState(() {});
                } else {
                  showDialog<void>(
                    context: context,
                    builder: (messageContext) => AlertDialog(
                      title: const Text('Chưa đủ đá quý'),
                      content: const Text('Bạn cần 350 đá quý để nạp đầy 5 tim.'),
                      actions: [TextButton(onPressed: () => Navigator.of(messageContext).pop(), child: const Text('Đã hiểu'))],
                    ),
                  );
                }
              },
              icon: const Icon(Icons.diamond_rounded),
              label: const Text('Nạp đầy 5 tim · 350 đá quý'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.of(dialogContext).pop();
                showDialog<void>(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const AlertDialog(
                    content: Row(children: [CircularProgressIndicator(), SizedBox(width: 18), Expanded(child: Text('Đang xem quảng cáo giả lập...'))]),
                  ),
                );
                await Future<void>.delayed(const Duration(seconds: 2));
                if (!mounted) return;
                Navigator.of(context).pop();
                await widget.appState.addHeart(1);
                if (!mounted) return;
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã nhận +1 tim! ❤️')));
              },
              icon: const Icon(Icons.ondemand_video_rounded),
              label: const Text('Xem quảng cáo giả lập · +1 tim'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Thoát bài học', style: TextStyle(color: kRed, fontWeight: FontWeight.w800)),
            ),
          ],
        ),
      ),
    );
    _outOfHeartsDialogOpen = false;
  }

  Future<void> _nextQuestion() async {
    if (!_checked) return;
    if (_questionIndex < _questions.length - 1) {
      setState(() {
        _questionIndex++;
        _selectedOption = null;
        _checked = false;
        _isCorrect = false;
        _typingController.clear();
      });
      return;
    }
    await _finishLesson();
  }

  Future<void> _finishLesson() async {
    if (_finishing) return;
    _finishing = true;
    await widget.appState.finishLesson(lessonIndex: widget.reviewMode ? null : widget.lessonIndex, masteredCharacters: _correctCharacters);
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.celebration_rounded, color: kOrange, size: 52),
        title: const Text('Hoàn thành bài học!'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Text('Bạn trả lời đúng ${_correctCharacters.length} chữ khác nhau.'),
          const SizedBox(height: 10),
          const Text('+20 XP     +5 đá quý', style: TextStyle(color: kGreen, fontWeight: FontWeight.w900, fontSize: 16)),
        ]),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              if (mounted) Navigator.of(context).pop();
            },
            child: const Text('Tiếp tục'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _typingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final question = _question;
    final character = findCharacter(question.character);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.of(context).maybePop()),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(value: (_questionIndex + 1) / _questions.length, minHeight: 9, backgroundColor: const Color(0xFFE0E7DF), color: kGreen),
        ),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 15), child: Row(children: [const Icon(Icons.favorite_rounded, color: kRed), const SizedBox(width: 5), Text('${widget.appState.hearts}', style: const TextStyle(fontWeight: FontWeight.w900))])),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                children: [
                  Text(widget.reviewMode ? 'ÔN TẬP' : 'BÀI ${(widget.lessonIndex ?? 0) + 1}', style: const TextStyle(color: kGreen, letterSpacing: 1.5, fontWeight: FontWeight.w900, fontSize: 12)),
                  const SizedBox(height: 7),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(color: const Color(0xFFFFF1D7), borderRadius: BorderRadius.circular(12)),
                    child: Text(question.sectionTitle, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF9A5A20), fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                  const SizedBox(height: 14),
                  Text(question.prompt, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, height: 1.2, color: Color(0xFF20372C)), textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  if (question.type == QuestionType.fillInTheBlank && question.sentenceTokens != null)
                    Container(
                      constraints: const BoxConstraints(minHeight: 172),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                      decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(24)),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.touch_app_rounded, color: kGreen, size: 18),
                          SizedBox(width: 6),
                          Text('CHẠM VÀO CHỮ ĐỂ XEM NGHĨA', style: TextStyle(fontSize: 10, letterSpacing: 1.1, color: kGreen, fontWeight: FontWeight.w900)),
                        ]),
                        const SizedBox(height: 18),
                        InteractiveSentence(tokens: question.sentenceTokens!, selectedAnswer: _selectedOption),
                      ]),
                    )
                  else
                    Container(
                      constraints: const BoxConstraints(minHeight: 172),
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: kGreenLight, borderRadius: BorderRadius.circular(24)),
                      alignment: Alignment.center,
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(
                          question.type == QuestionType.character ? (character?.meaning ?? '') : question.character,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: question.type == QuestionType.character ? 26 : 82, color: kGreen, fontWeight: FontWeight.w700),
                        ),
                        if (question.type == QuestionType.radical) ...[
                          const SizedBox(height: 8),
                          Text('Âm Hán-Việt: ${character?.hanVietReading ?? ''}', style: const TextStyle(color: kOrange, fontWeight: FontWeight.w800)),
                        ],
                        if (question.type == QuestionType.typing) ...[
                          const SizedBox(height: 8),
                          const Text('Hãy tự nhớ âm đọc hoặc nghĩa', style: TextStyle(color: kGreen, fontWeight: FontWeight.w700)),
                        ],
                      ]),
                    ),
                  const SizedBox(height: 18),
                  if (question.type == QuestionType.typing) ...[
                    TextField(
                      controller: _typingController,
                      enabled: !_checked,
                      autofocus: false,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
                      decoration: InputDecoration(
                        hintText: 'Nhập âm Hán-Việt hoặc nghĩa…',
                        filled: true,
                        fillColor: _checked ? (_isCorrect ? const Color(0xFFE4F5E8) : const Color(0xFFFFE9E7)) : Colors.white,
                      ),
                      onChanged: (value) => setState(() => _selectedOption = value),
                      onSubmitted: (_) { if (!_checked) _checkAnswer(); },
                    ),
                  ] else ...[
                    Text(
                      question.type == QuestionType.radical ? 'CHỌN BỘ THỦ' : 'CHỌN MỘT ĐÁP ÁN',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 1.4, color: Colors.black45),
                    ),
                    const SizedBox(height: 10),
                    for (var index = 0; index < question.options.length; index++)
                      _AnswerOption(
                        label: question.options[index],
                        letter: String.fromCharCode(65 + index),
                        selected: _selectedOption == question.options[index],
                        checked: _checked,
                        correct: question.options[index] == question.correctAnswer,
                        onTap: _checked ? null : () => setState(() => _selectedOption = question.options[index]),
                      ),
                  ],
                  if (_checked) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(color: _isCorrect ? const Color(0xFFE4F5E8) : const Color(0xFFFFE9E7), borderRadius: BorderRadius.circular(16)),
                      child: Row(children: [
                        Icon(_isCorrect ? Icons.check_circle_rounded : Icons.info_rounded, color: _isCorrect ? kGreen : kRed),
                        const SizedBox(width: 10),
                        Expanded(child: Text(
                          _isCorrect
                              ? 'Chính xác! Cố gắng giữ nhịp học nhé.'
                              : question.type == QuestionType.typing
                                  ? 'Đáp án có thể là: ${(question.acceptedAnswers ?? [question.correctAnswer]).join(" / ")}'
                                  : 'Đáp án đúng: ${question.correctAnswer}',
                          style: TextStyle(fontWeight: FontWeight.w800, color: _isCorrect ? kGreen : kRed),
                        )),
                      ]),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
              decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Color(0xFFE8ECE7)))),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _checked ? (_isCorrect ? kGreen : kOrange) : kGreen),
                  onPressed: (_selectedOption == null || _selectedOption!.trim().isEmpty) ? null : () { if (!_checked) { _checkAnswer(); } else { _nextQuestion(); } },
                  child: Text(_checked ? (_questionIndex == _questions.length - 1 ? 'Hoàn thành' : 'Tiếp tục') : question.type == QuestionType.typing ? 'Kiểm tra đáp án' : 'Kiểm tra'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnswerOption extends StatelessWidget {
  final String label;
  final String letter;
  final bool selected;
  final bool checked;
  final bool correct;
  final VoidCallback? onTap;
  const _AnswerOption({required this.label, required this.letter, required this.selected, required this.checked, required this.correct, required this.onTap});

  @override
  Widget build(BuildContext context) {
    Color background = Colors.white;
    Color border = const Color(0xFFE1E7E0);
    Color textColor = const Color(0xFF263A2F);
    if (checked && correct) {
      background = const Color(0xFFE3F3E7);
      border = kGreen;
      textColor = kGreen;
    } else if (checked && selected && !correct) {
      background = const Color(0xFFFFE9E7);
      border = kRed;
      textColor = kRed;
    } else if (selected) {
      background = kGreenLight;
      border = kGreen;
      textColor = kGreen;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: border, width: selected || (checked && correct) ? 1.7 : 1)),
            child: Row(children: [
              Container(width: 34, height: 34, alignment: Alignment.center, decoration: BoxDecoration(color: selected ? border.withOpacity(0.12) : const Color(0xFFF2F4F0), borderRadius: BorderRadius.circular(10)), child: Text(letter, style: TextStyle(fontWeight: FontWeight.w900, color: textColor))),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: TextStyle(fontWeight: FontWeight.w700, color: textColor, fontSize: 16))),
              if (checked && correct) const Icon(Icons.check_circle_rounded, color: kGreen),
            ]),
          ),
        ),
      ),
    );
  }
}
