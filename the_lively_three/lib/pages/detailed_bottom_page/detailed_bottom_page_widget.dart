// main.dart
import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

void main() => runApp(const BottomDetailedPage());

class BottomDetailedPage extends StatelessWidget {
  const BottomDetailedPage({super.key});

  static String routeName = 'BottomDetailedPage';
  static String routePath = '/bottomDetailedPage';
  @override
  Widget build(BuildContext context) {
    // Palette (5 colors total): primary blue, accent green, white, near-black text, light surface
    const primary = Color(0xFF0EA5E9); // blue
    const accent = Color(0xFF10B981); // green
    const background = Colors.white;
    const surface = Color(0xFFF5F7FA);
    const textColor = Color(0xFF111827);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Detailed Daily Log',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primary,
          onPrimary: Colors.white,
          secondary: accent,
          onSecondary: Colors.white,
          surface: background,
          onSurface: textColor,
          background: background,
          onBackground: textColor,
          error: const Color(0xFFEF4444),
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: background,
        fontFamily: 'Roboto',
      ),
      home: const DetailedLogPage(),
    );
  }
}

// -------------------- Data models --------------------

class DayLog {
  final DateTime date;
  final List<PortionItem> plantItems;
  final List<AnimalItem> animalItems;
  final int upfPortions; // processed food portions
  final int waterLitres; // litres consumed (integer for simple UI)
  final List<String> suggestions;

  const DayLog({
    required this.date,
    required this.plantItems,
    required this.animalItems,
    required this.upfPortions,
    required this.waterLitres,
    required this.suggestions,
  });

  double get totalPlant => plantItems.fold(0.0, (sum, p) => sum + p.amount);
}

class PortionItem {
  final String label;
  final double amount;
  const PortionItem(this.label, this.amount);
}

enum AnimalCategory { dairy, eggs, meat }

class AnimalItem {
  final AnimalCategory category;
  final String label;
  final String details;
  const AnimalItem(this.category, this.label, this.details);
}

// -------------------- Page scaffold --------------------

class DetailedLogPage extends StatefulWidget {
  const DetailedLogPage({super.key});

  @override
  State<DetailedLogPage> createState() => _DetailedLogPageState();
}

class _DetailedLogPageState extends State<DetailedLogPage> {
  final _controller = PageController();
  int _index = 0;

  late final List<DayLog> _days = [
    DayLog(
      date: DateTime.now(),
      plantItems: const [
        PortionItem('apple', 1.0),
        PortionItem('banana', 1.0),
        PortionItem('lettuce', 0.5),
        PortionItem('tomato', 0.5),
        PortionItem('onion', 0.5),
        PortionItem('potato', 1.0),
        PortionItem('wheat', 0.3),
        PortionItem('tofu', 2.0),
      ],
      animalItems: const [
        AnimalItem(AnimalCategory.dairy, 'Milk', '0.3 L'),
        AnimalItem(AnimalCategory.meat, 'Steak', '250 g'),
        AnimalItem(AnimalCategory.dairy, 'Hard cheese', '40 g'),
      ],
      upfPortions: 1,
      waterLitres: 3,
      suggestions: const [
        'Eat more high‑fibre plants',
        'Green beans',
        'Chia seeds',
        'Kidney beans',
        'Lupin beans',
        'Lentils',
      ],
    ),
    DayLog(
      date: DateTime.now().subtract(const Duration(days: 1)),
      plantItems: const [
        PortionItem('berries', 1.0),
        PortionItem('spinach', 0.5),
        PortionItem('broccoli', 1.0),
      ],
      animalItems: const [
        AnimalItem(AnimalCategory.eggs, 'Eggs', '2 pcs'),
      ],
      upfPortions: 3,
      waterLitres: 2,
      suggestions: const [
        'Add a fruit at breakfast',
        'Target 3–4 L water',
      ],
    ),
  ];

  void _goTo(int newIndex) {
    if (newIndex < 0 || newIndex >= _days.length) return;
    _controller.animateToPage(
      newIndex,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Daily Log'),
        centerTitle: true,
      ),
      // Suggestions are NOT fixed: they live inside each day below.
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (i) => setState(() => _index = i),
        itemCount: _days.length,
        itemBuilder: (context, i) => DayView(
          day: _days[i],
          onPrev: () => _goTo(i - 1),
          onNext: () => _goTo(i + 1),
        ),
      ),
    );
  }
}

// -------------------- Day view (one page) --------------------

class DayView extends StatelessWidget {
  final DayLog day;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const DayView({
    super.key,
    required this.day,
    required this.onPrev,
    required this.onNext,
  });

  bool get _isToday {
    final now = DateTime.now();
    return now.year == day.date.year &&
        now.month == day.date.month &&
        now.day == day.date.day;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        // Date header stacked above all consumptions
        DateHeader(
          label: _formatDate(day.date),
          isToday: _isToday,
          onPrev: onPrev,
          onNext: onNext,
        ),
        const SizedBox(height: 12),

        // Total plant portions
        LabeledCard(
          title:
              'Total plant portions • ${day.totalPlant.toStringAsFixed(1)}/5',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: day.plantItems
                .map((p) => PlantChip(text: '${p.label} ${p.amount}'))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),

        // Animal products log
        LabeledCard(
          title: 'Total animal products log',
          child: Column(
            children: day.animalItems.map((a) => AnimalRow(item: a)).toList(),
          ),
        ),
        const SizedBox(height: 12),

        // UPF portions
        LabeledCard(
          title: 'Total UPF portions',
          child: UpfPortionsRow(count: day.upfPortions, max: 6),
        ),
        const SizedBox(height: 12),

        // Water consumed
        LabeledCard(
          title: 'Total water consumed (in litres)',
          child: WaterRow(litres: day.waterLitres, target: 5),
        ),

        const SizedBox(height: 12),

        // Suggestions belong to the same scrollable container and sit at the bottom
        SuggestionsSection(suggestions: day.suggestions),

        const SizedBox(height: 8),
        Text(
          'Swipe left/right or use arrows to switch days',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: cs.onSurface.withOpacity(0.6),
            fontSize: FlutterFlowTheme.adjustScale(size: 12),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final today = DateTime.now();
    final isToday =
        d.year == today.year && d.month == today.month && d.day == today.day;
    final base = '${d.day} ${months[d.month - 1]}';
    return isToday ? '$base • Today' : base;
  }
}

// -------------------- Reusable UI pieces --------------------

class DateHeader extends StatelessWidget {
  final String label;
  final bool isToday;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const DateHeader({
    super.key,
    required this.label,
    required this.isToday,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous day',
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: FlutterFlowTheme.adjustScale(size: 16),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Next day',
            onPressed: onNext,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

class LabeledCard extends StatelessWidget {
  final String title;
  final Widget child;

  const LabeledCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 10.0, 10.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context)
                      .secondaryBackground, // surface card
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    child,
                  ],
                ),
              ),
              Positioned(
                  top: -16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: MediaQuery.sizeOf(context).width * 0.65,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(99.0),
                      ),
                      alignment: AlignmentDirectional(0.0, -1.0),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Icon(
                            //   Icons.chevron_left,
                            //   color: FlutterFlowTheme.of(context)
                            //       .secondaryText,
                            //   size: 24.0,
                            // ),
                            Text(
                              title,
                            ),
                            // Icon(
                            //   Icons.chevron_right,
                            //   color: FlutterFlowTheme.of(context)
                            //       .secondaryText,
                            //   size: 24.0,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class PlantChip extends StatelessWidget {
  final String text;
  const PlantChip({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: ShapeDecoration(
        color: cs.primary.withOpacity(0.08),
        shape: StadiumBorder(
          side: BorderSide(color: cs.primary.withOpacity(.2)),
        ),
      ),
      child: Text(
        '• $text',
        style: TextStyle(
            color: cs.onSurface,
            fontSize: FlutterFlowTheme.adjustScale(size: 14)),
      ),
    );
  }
}

class AnimalRow extends StatelessWidget {
  final AnimalItem item;
  const AnimalRow({super.key, required this.item});

  IconData _iconFor(AnimalCategory c) {
    switch (c) {
      case AnimalCategory.dairy:
        return Icons.local_cafe;
      case AnimalCategory.eggs:
        return Icons.egg;
      case AnimalCategory.meat:
        return Icons.set_meal;
    }
  }

  Color _colorFor(AnimalCategory c) {
    switch (c) {
      case AnimalCategory.dairy:
        return const Color(0xFF60A5FA);
      case AnimalCategory.eggs:
        return const Color(0xFFF59E0B);
      case AnimalCategory.meat:
        return const Color(0xFFF43F5E);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorFor(item.category);
    final icon = _iconFor(item.category);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color.withOpacity(.15),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 14),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Text(item.details,
              style:
                  TextStyle(fontSize: FlutterFlowTheme.adjustScale(size: 14))),
        ],
      ),
    );
  }
}

class UpfPortionsRow extends StatelessWidget {
  final int count;
  final int max;
  const UpfPortionsRow({super.key, required this.count, this.max = 6});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(max, (i) {
        final filled = i < count;
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? cs.secondary.withOpacity(.2) : Colors.transparent,
              border: Border.all(
                color: filled ? cs.secondary : Colors.black26,
                width: 2,
              ),
            ),
            child: Icon(
              Icons.restaurant,
              size: 14,
              color: filled ? cs.secondary : Colors.black38,
            ),
          ),
        );
      }),
    );
  }
}

class WaterRow extends StatelessWidget {
  final int litres;
  final int target;
  const WaterRow({super.key, required this.litres, this.target = 5});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: List.generate(target, (i) {
        final filled = i < litres;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              Icon(
                Icons.water_drop,
                size: 28,
                color: filled ? cs.primary : Colors.black26,
              ),
              const SizedBox(height: 2),
              Text(
                '${i + 1}L',
                style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 10),
                  color: filled ? cs.primary : Colors.black45,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class SuggestionsSection extends StatelessWidget {
  final List<String> suggestions;
  const SuggestionsSection({super.key, required this.suggestions});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggestions (example)',
              style: TextStyle(
                  fontSize: FlutterFlowTheme.adjustScale(size: 14),
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions
                .map(
                  (s) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const ShapeDecoration(
                      color: Colors.white,
                      shape: StadiumBorder(
                        side: BorderSide(color: Colors.black12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rate_rounded,
                            size: 14, color: Color(0xFF10B981)),
                        const SizedBox(width: 6),
                        Text(s,
                            style: TextStyle(
                                fontSize:
                                    FlutterFlowTheme.adjustScale(size: 13))),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
