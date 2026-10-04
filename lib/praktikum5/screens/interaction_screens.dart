import 'dart:async';
import 'package:flutter/material.dart';

// 6. Dialog, Bottom Sheet, Snackbar, dan Overlay
class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  void showDialogExample(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text('Ini adalah contoh AlertDialog.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void showSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Bottom Sheet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Camera'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Gallery'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback UI')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => showDialogExample(context),
                child: const Text('Show Dialog'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => showSheet(context),
                child: const Text('Show Bottom Sheet'),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data berhasil disimpan')),
                  );
                },
                child: const Text('Show Snackbar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 12. Gesture dan Interaction
class GesturePage extends StatefulWidget {
  const GesturePage({super.key});

  @override
  State<GesturePage> createState() => _GesturePageState();
}

class _GesturePageState extends State<GesturePage> {
  String message = 'Coba berbagai gesture';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gesture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => setState(() => message = 'Tap'),
              onDoubleTap: () => setState(() => message = 'Double Tap'),
              onLongPress: () => setState(() => message = 'Long Press'),
              onPanUpdate: (_) => setState(() => message = 'Dragging'),
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.touch_app,
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// 13. Interactive Widgets
class InteractivePage extends StatefulWidget {
  const InteractivePage({super.key});

  @override
  State<InteractivePage> createState() => _InteractivePageState();
}

class _InteractivePageState extends State<InteractivePage> {
  bool notifications = true;
  bool darkMode = false;
  double volume = 50;
  bool checked = false;
  int radio = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Notifications'),
            value: notifications,
            onChanged: (value) => setState(() => notifications = value),
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: darkMode,
            onChanged: (value) => setState(() => darkMode = value),
          ),
          CheckboxListTile(
            title: const Text('Saya setuju'),
            value: checked,
            onChanged: (value) => setState(() => checked = value ?? false),
          ),
          RadioGroup<int>(
            groupValue: radio,
            onChanged: (value) => setState(() => radio = value!),
            child: Column(
              children: const [
                RadioListTile<int>(value: 1, title: Text('Option 1')),
                RadioListTile<int>(value: 2, title: Text('Option 2')),
                RadioListTile<int>(value: 3, title: Text('Option 3')),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Volume: ${volume.round()}'),
          Slider(
            value: volume,
            min: 0,
            max: 100,
            divisions: 10,
            label: volume.round().toString(),
            onChanged: (value) => setState(() => volume = value),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Flutter'),
                selected: checked,
                onSelected: (value) => setState(() => checked = value),
              ),
              FilterChip(
                label: const Text('Mobile'),
                selected: notifications,
                onSelected: (value) => setState(() => notifications = value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Helper untuk RadioGroup
class RadioGroup<T> extends StatelessWidget {
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final Widget child;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.onChanged,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

// 14. Advanced Form dan Input
class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  DateTime? birthDate;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> selectDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      initialDate: DateTime(2000),
    );
    if (date != null) {
      setState(() => birthDate = date);
    }
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form valid')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Form')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nama',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || !value.contains('@'))
                  ? 'Email tidak valid'
                  : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: passwordController,
              obscureText: obscurePassword,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  onPressed: () =>
                      setState(() => obscurePassword = !obscurePassword),
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.length < 6)
                  ? 'Minimal 6 karakter'
                  : null,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: selectDate,
              icon: const Icon(Icons.calendar_month),
              label: Text(
                birthDate == null
                    ? 'Pilih tanggal lahir'
                    : '${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
              ),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: submit, child: const Text('Submit')),
          ],
        ),
      ),
    );
  }
}

// 15. Loading dan Feedback UI
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool loading = false;
  double progress = 0;

  void startProcess() {
    setState(() {
      loading = true;
      progress = 0;
    });

    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() => progress += 0.05);
      if (progress >= 1) {
        timer.cancel();
        setState(() => loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Proses selesai')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loading & Feedback')),
      body: Center(
        child: loading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 250,
                    child: LinearProgressIndicator(value: progress),
                  ),
                  const SizedBox(height: 12),
                  Text('${(progress * 100).round()}%'),
                ],
              )
            : FilledButton(
                onPressed: startProcess,
                child: const Text('Mulai Proses'),
              ),
      ),
    );
  }
}
