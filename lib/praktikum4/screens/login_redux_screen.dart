import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/app_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_actions.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_state.dart';
import 'package:flutter_application_pos_praktikum/praktikum4/redux/auth/auth_thunks.dart';
import '../widgets/redux_badge.dart';

class LoginReduxScreen extends StatefulWidget {
  const LoginReduxScreen({super.key});

  @override
  State<LoginReduxScreen> createState() => _LoginReduxScreenState();
}

class _LoginReduxScreenState extends State<LoginReduxScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController(
    text: 'praktikum@gmail.com',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '12345678',
  );
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login berhasil! Mengalihkan ke Dashboard Redux...'),
        backgroundColor: Colors.teal,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StoreConnector<AppState, _LoginViewModel>(
      converter: (Store<AppState> store) => _LoginViewModel.fromStore(
        store,
        onSuccess: () => _onLoginSuccess(context),
      ),
      builder: (context, vm) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Login Praktikum 4'),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: Center(child: ReduxBadge(extraText: 'Store Connected')),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Icon & Title
                        Center(
                          child: CircleAvatar(
                            radius: 36,
                            backgroundColor: Colors.deepPurple.shade50,
                            child: const Icon(
                              Icons.account_tree_outlined,
                              size: 40,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Redux State Management',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Praktikum 4 • Unidirectional Data Flow',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Error Message from Redux State
                        if (vm.errorMessage != null)
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade300),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    vm.errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  onPressed: vm.clearError,
                                ),
                              ],
                            ),
                          ),

                        // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Masukkan email akun',
                            prefixIcon: Icon(Icons.email_outlined),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }
                            if (!value.contains('@')) {
                              return 'Format email tidak valid';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Password wajib diisi';
                            }
                            if (value.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Login Action Button
                        ElevatedButton.icon(
                          onPressed: vm.isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    vm.onLogin(
                                      _emailController.text,
                                      _passwordController.text,
                                    );
                                  }
                                },
                          icon: vm.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.login),
                          label: Text(
                            vm.isLoading
                                ? 'Memproses Redux Action...'
                                : 'Login (Directus API)',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dummy Login Button
                        OutlinedButton.icon(
                          onPressed: vm.isLoading ? null : vm.onDummyLogin,
                          icon: const Icon(Icons.flash_on, color: Colors.teal),
                          label: const Text(
                            'Dummy Login (Mode Mock Redux)',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.teal),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Info Footer
                        Text(
                          'Redux Pattern: Action -> Middleware/Thunk -> Reducer -> Store -> UI',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginViewModel {
  final bool isLoading;
  final String? errorMessage;
  final void Function(String email, String password) onLogin;
  final VoidCallback onDummyLogin;
  final VoidCallback clearError;

  _LoginViewModel({
    required this.isLoading,
    this.errorMessage,
    required this.onLogin,
    required this.onDummyLogin,
    required this.clearError,
  });

  factory _LoginViewModel.fromStore(
    Store<AppState> store, {
    required VoidCallback onSuccess,
  }) {
    return _LoginViewModel(
      isLoading: store.state.authState.status == AuthStatus.loading,
      errorMessage: store.state.authState.errorMessage,
      onLogin: (email, password) {
        store.dispatch(
          loginThunk(email: email, password: password, onSuccess: onSuccess),
        );
      },
      onDummyLogin: () {
        store.dispatch(dummyLoginThunk(onSuccess: onSuccess));
      },
      clearError: () {
        store.dispatch(ClearAuthErrorAction());
      },
    );
  }
}
