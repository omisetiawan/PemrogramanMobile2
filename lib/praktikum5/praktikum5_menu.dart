import 'package:flutter/material.dart';
import 'screens/basic_ui_screens.dart';
import 'screens/interaction_screens.dart';
import 'screens/animation_screens.dart';
import 'screens/advanced_ui_screens.dart';
import 'screens/state_gallery_screens.dart';

class Praktikum5Menu extends StatelessWidget {
  const Praktikum5Menu({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('1. Material 3 & Design System', const MaterialExplorerPage()),
      ('2. Advanced Layout', const LayoutPage()),
      ('3. Responsive UI', const ResponsivePage()),
      ('4. Adaptive UI', const AdaptivePage()),
      ('5. Advanced Scrolling (Sliver)', const SliverPage()),
      ('6. Dialog, Bottom Sheet, Snackbar', const FeedbackPage()),
      ('7. Implicit Animation', const AnimationPage()),
      ('8. Explicit Animation', const ExplicitAnimationPage()),
      ('9. Curves dan Motion', const CurvePage()),
      ('10. Page Transition', const TransitionPage()),
      ('11. Hero Animation', const HeroListPage()),
      ('12. Gesture dan Interaction', const GesturePage()),
      ('13. Interactive Widgets', const InteractivePage()),
      ('14. Advanced Form dan Input', const FormPage()),
      ('15. Loading dan Feedback UI', const LoadingPage()),
      ('16. Skeleton Loading dan Shimmer', const SkeletonPage()),
      ('17. Theme dan Dark Mode', const ThemeModePage()),
      ('18. Custom Widget & Reusable UI', const CustomWidgetPage()),
      ('19. CustomPainter', const PainterPage()),
      ('20. Clip dan Visual Effects', const VisualPage()),
      ('21. Opacity, Transform, Filter', const TransformPage()),
      ('22. Accessibility', const AccessibilityPage()),
      ('23. UI State', const UiStatePage()),
      ('24. Micro Interaction', const MicroInteractionPage()),
      ('25. Widget Gallery', const WidgetGalleryPage()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Praktikum 5 - Advance UI/UX'),
        elevation: 1,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              items[index].$1,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => items[index].$2),
              );
            },
          );
        },
      ),
    );
  }
}
