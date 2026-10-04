import 'package:flutter/material.dart';

// 23. UI State
enum UiState { initial, loading, success, empty, error }

class UiStatePage extends StatefulWidget {
  const UiStatePage({super.key});

  @override
  State<UiStatePage> createState() => _UiStatePageState();
}

class _UiStatePageState extends State<UiStatePage> {
  UiState state = UiState.initial;

  Widget buildState() {
    switch (state) {
      case UiState.initial:
        return const StateView(
          icon: Icons.touch_app,
          title: 'Initial',
          message: 'Belum ada proses.',
        );
      case UiState.loading:
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        );
      case UiState.success:
        return const StateView(
          icon: Icons.check_circle,
          title: 'Success',
          message: 'Data berhasil dimuat.',
        );
      case UiState.empty:
        return const StateView(
          icon: Icons.inbox,
          title: 'Empty',
          message: 'Tidak ada data.',
        );
      case UiState.error:
        return const StateView(
          icon: Icons.error,
          title: 'Error',
          message: 'Terjadi kesalahan.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI State')),
      body: Column(
        children: [
          Expanded(child: Center(child: buildState())),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilledButton(
                  onPressed: () => setState(() => state = UiState.initial),
                  child: const Text('Initial'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => state = UiState.loading),
                  child: const Text('Loading'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => state = UiState.success),
                  child: const Text('Success'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => state = UiState.empty),
                  child: const Text('Empty'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () => setState(() => state = UiState.error),
                  child: const Text('Error'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StateView extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const StateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 80),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(message),
      ],
    );
  }
}

// 24. Micro Interaction
class MicroInteractionPage extends StatefulWidget {
  const MicroInteractionPage({super.key});

  @override
  State<MicroInteractionPage> createState() => _MicroInteractionPageState();
}

class _MicroInteractionPageState extends State<MicroInteractionPage> {
  bool favorite = false;
  bool expanded = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Micro Interaction')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => pressed = true),
            onTapUp: (_) => setState(() => pressed = false),
            onTapCancel: () => setState(() => pressed = false),
            child: AnimatedScale(
              scale: pressed ? 0.95 : 1,
              duration: const Duration(milliseconds: 100),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.flutter_dash),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Interactive Card',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => favorite = !favorite),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            favorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(favorite),
                            color: favorite ? Colors.red : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Expandable Card'),
                  trailing: IconButton(
                    onPressed: () => setState(() => expanded = !expanded),
                    icon: AnimatedRotation(
                      turns: expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Icon(Icons.expand_more),
                    ),
                  ),
                ),
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: expanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Konten tambahan ditampilkan dengan micro interaction.',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 25. Eksplorasi Widget Gallery
class WidgetGalleryPage extends StatelessWidget {
  const WidgetGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final widgets = [
      (
        'Buttons',
        Icons.smart_button,
        'FilledButton, OutlinedButton, TextButton',
      ),
      ('Input', Icons.input, 'TextField dan TextFormField'),
      ('Navigation', Icons.navigation, 'NavigationBar dan NavigationRail'),
      ('Feedback', Icons.notifications, 'Dialog, Snackbar, BottomSheet'),
      ('Selection', Icons.check_box, 'Checkbox, Radio, Switch'),
      ('Layout', Icons.dashboard, 'Row, Column, Stack, Wrap'),
      ('Animation', Icons.animation, 'Implicit dan Explicit Animation'),
      ('Scrolling', Icons.view_agenda, 'ListView dan Sliver'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Widget Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.15,
        ),
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          final item = widgets[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.$2, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    item.$1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.$3,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
