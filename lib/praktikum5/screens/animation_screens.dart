import 'package:flutter/material.dart';

// 7. Implicit Animation
class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  State<AnimationPage> createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  bool active = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Implicit Animation')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              width: active ? 240 : 120,
              height: active ? 240 : 120,
              decoration: BoxDecoration(
                color: active ? Colors.purple : Colors.blue,
                borderRadius: BorderRadius.circular(active ? 40 : 100),
              ),
              child: const Icon(
                Icons.flutter_dash,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 40),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: active ? 1 : 0.3,
              child: const Text(
                'Animated UI',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 40),
            FilledButton(
              onPressed: () => setState(() => active = !active),
              child: const Text('Animate'),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. Explicit Animation
class ExplicitAnimationPage extends StatefulWidget {
  const ExplicitAnimationPage({super.key});

  @override
  State<ExplicitAnimationPage> createState() => _ExplicitAnimationPageState();
}

class _ExplicitAnimationPageState extends State<ExplicitAnimationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> rotation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    rotation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explicit Animation')),
      body: Center(
        child: AnimatedBuilder(
          animation: rotation,
          builder: (context, child) {
            return Transform.rotate(angle: rotation.value * 6.28, child: child);
          },
          child: const Icon(Icons.settings, size: 120),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.forward(from: 0),
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}

// 9. Curves dan Motion
class CurvePage extends StatefulWidget {
  const CurvePage({super.key});

  @override
  State<CurvePage> createState() => _CurvePageState();
}

class _CurvePageState extends State<CurvePage> {
  bool active = false;
  Curve selectedCurve = Curves.easeInOut;

  final curves = <String, Curve>{
    'easeInOut': Curves.easeInOut,
    'easeIn': Curves.easeIn,
    'easeOut': Curves.easeOut,
    'bounceOut': Curves.bounceOut,
    'elasticOut': Curves.elasticOut,
    'fastOutSlowIn': Curves.fastOutSlowIn,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Curves')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              initialValue: curves.entries
                  .firstWhere((entry) => entry.value == selectedCurve)
                  .key,
              decoration: const InputDecoration(
                labelText: 'Animation Curve',
                border: OutlineInputBorder(),
              ),
              items: curves.keys
                  .map(
                    (name) => DropdownMenuItem(value: name, child: Text(name)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedCurve = curves[value]!);
                }
              },
            ),
            const SizedBox(height: 50),
            Align(
              alignment: active ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                curve: selectedCurve,
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => setState(() => active = !active),
              child: const Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}

// 10. Page Transition
class TransitionPage extends StatelessWidget {
  const TransitionPage({super.key});

  void openPage(
    BuildContext context,
    Widget page,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
    builder,
  ) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: builder,
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page Transition')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                openPage(context, const DetailPage(title: 'Fade'), (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return FadeTransition(opacity: animation, child: child);
                });
              },
              child: const Text('Fade Transition'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                openPage(context, const DetailPage(title: 'Slide'), (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  final offset = Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return SlideTransition(position: offset, child: child);
                });
              },
              child: const Text('Slide Transition'),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                openPage(context, const DetailPage(title: 'Scale'), (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  return ScaleTransition(scale: animation, child: child);
                });
              },
              child: const Text('Scale Transition'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String title;
  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

// 11. Hero Animation
class HeroListPage extends StatelessWidget {
  const HeroListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero Animation')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 8,
        itemBuilder: (context, index) {
          final color = Colors.primaries[index % Colors.primaries.length];
          return Card(
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Hero(
                tag: 'hero-$index',
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.flutter_dash, color: Colors.white),
                ),
              ),
              title: Text('Item ${index + 1}'),
              subtitle: const Text('Tap untuk melihat Hero animation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => HeroDetailPage(index: index, color: color),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class HeroDetailPage extends StatelessWidget {
  final int index;
  final Color color;

  const HeroDetailPage({super.key, required this.index, required this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail ${index + 1}')),
      body: Center(
        child: Hero(
          tag: 'hero-$index',
          child: Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(
              Icons.flutter_dash,
              size: 120,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
