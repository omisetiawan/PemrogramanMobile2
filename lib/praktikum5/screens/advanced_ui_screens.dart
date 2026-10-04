import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

// 16. Skeleton Loading dan Shimmer
class SkeletonPage extends StatefulWidget {
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Skeleton Loading')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 6,
        itemBuilder: (context, index) {
          if (loading) return const SkeletonCard();
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Data ${index + 1}'),
              subtitle: const Text('Data telah selesai dimuat.'),
            ),
          );
        },
      ),
    );
  }
}

class SkeletonCard extends StatefulWidget {
  const SkeletonCard({super.key});

  @override
  State<SkeletonCard> createState() => _SkeletonCardState();
}

class _SkeletonCardState extends State<SkeletonCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment(-1 + controller.value * 2, 0),
              end: Alignment(controller.value * 2, 0),
              colors: const [
                Color(0xFFE5E7EB),
                Color(0xFFF9FAFB),
                Color(0xFFE5E7EB),
              ],
            ),
          ),
        );
      },
    );
  }
}

// 17. Theme dan Dark Mode (Diadaptasi untuk single screen)
class ThemeModePage extends StatefulWidget {
  const ThemeModePage({super.key});

  @override
  State<ThemeModePage> createState() => _ThemeModePageState();
}

class _ThemeModePageState extends State<ThemeModePage> {
  ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;
    return Theme(
      data: isDark
          ? ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.dark,
            )
          : ThemeData(
              useMaterial3: true,
              colorSchemeSeed: Colors.blue,
              brightness: Brightness.light,
            ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Theme & Dark Mode')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.dark_mode, size: 80),
              const SizedBox(height: 20),
              Text(
                isDark ? 'Dark Mode' : 'Light Mode',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Switch(
                value: isDark,
                onChanged: (value) => setState(
                  () => themeMode = value ? ThemeMode.dark : ThemeMode.light,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 18. Custom Widget dan Reusable UI
class CustomWidgetPage extends StatelessWidget {
  const CustomWidgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reusable UI')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          ProfileCard(
            name: 'Ahmad',
            role: 'Flutter Developer',
            icon: Icons.code,
          ),
          ProfileCard(
            name: 'Budi',
            role: 'UI/UX Designer',
            icon: Icons.design_services,
          ),
          ProfileCard(
            name: 'Citra',
            role: 'Mobile Developer',
            icon: Icons.phone_android,
          ),
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String role;
  final IconData icon;

  const ProfileCard({
    super.key,
    required this.name,
    required this.role,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(radius: 30, child: Icon(icon)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(role),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

// 19. CustomPainter
class PainterPage extends StatelessWidget {
  const PainterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CustomPainter')),
      body: Center(
        child: CustomPaint(
          size: const Size(300, 300),
          painter: CirclePainter(),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.indigo.shade100;
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = Colors.indigo;

    canvas.drawCircle(center, radius, backgroundPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 1.5,
      false,
      circlePaint,
    );

    final textPainter = TextPainter(
      text: const TextSpan(
        text: '75%',
        style: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.bold,
          color: Colors.indigo,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// 20. Clip dan Visual Effects
class VisualPage extends StatelessWidget {
  const VisualPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clip & Visual Effects')),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  width: 300,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Glass Effect',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 21. Opacity, Transform, dan Filter
class TransformPage extends StatefulWidget {
  const TransformPage({super.key});

  @override
  State<TransformPage> createState() => _TransformPageState();
}

class _TransformPageState extends State<TransformPage> {
  double rotation = 0;
  double scale = 1;
  double opacity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transform & Filter')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Opacity(
              opacity: opacity,
              child: Transform.rotate(
                angle: rotation,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.flutter_dash,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text('Rotation', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 0,
            max: 6.28,
            value: rotation,
            onChanged: (value) => setState(() => rotation = value),
          ),
          Text('Scale', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 0.5,
            max: 2,
            value: scale,
            onChanged: (value) => setState(() => scale = value),
          ),
          Text('Opacity', style: Theme.of(context).textTheme.titleMedium),
          Slider(
            min: 0,
            max: 1,
            value: opacity,
            onChanged: (value) => setState(() => opacity = value),
          ),
          const SizedBox(height: 20),
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Blur',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 22. Accessibility
class AccessibilityPage extends StatelessWidget {
  const AccessibilityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accessibility')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Semantics(
            button: true,
            label: 'Tombol favorit',
            hint: 'Tekan untuk menambahkan favorit',
            child: Tooltip(
              message: 'Tambah ke favorit',
              child: IconButton(
                iconSize: 48,
                onPressed: () {},
                icon: const Icon(Icons.favorite_border),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Semantics(
            header: true,
            child: Text(
              'Accessibility Friendly UI',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Gunakan ukuran teks yang cukup besar, kontras warna yang baik, label yang jelas, dan area sentuh yang cukup.',
          ),
          const SizedBox(height: 30),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.accessibility),
            label: const Text('Accessible Button'),
          ),
        ],
      ),
    );
  }
}
