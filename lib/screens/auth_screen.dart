import 'package:flutter/material.dart';
import '../app_store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Amina Kibet');
  final _emailController = TextEditingController(text: 'james@demo.com');
  final _passwordController = TextEditingController(text: '123456');
  String _role = 'worker';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final store = MarketplaceStore.instance;
    final ok = _isLogin
        ? store.signIn(_emailController.text, _passwordController.text)
        : store.signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
            role: _role,
          );

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to continue. Check your details and try again.')),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _isLogin ? 'Welcome back' : 'Create account';
    final subtitle = _isLogin
        ? 'Sign in to keep hiring or finding work.'
        : 'Set up your profile and start using the marketplace.';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: cardBox(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(
                            color: AppColors.priSoft,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.work_outline_rounded, size: 36, color: AppColors.pri),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(title, textAlign: TextAlign.center, style: txt(28, FontWeight.w700, AppColors.ink)),
                      const SizedBox(height: 8),
                      Text(subtitle, textAlign: TextAlign.center, style: txt(14, FontWeight.w400, AppColors.mute)),
                      const SizedBox(height: 22),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.line),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _Segment(
                                label: 'Sign in',
                                active: _isLogin,
                                onTap: () => setState(() => _isLogin = true),
                              ),
                            ),
                            Expanded(
                              child: _Segment(
                                label: 'Create account',
                                active: !_isLogin,
                                onTap: () => setState(() => _isLogin = false),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (!_isLogin)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Full name'),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Enter your name' : null,
                        ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'Email address'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return 'Use at least 4 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      if (!_isLogin)
                        DropdownButtonFormField<String>(
                          value: _role,
                          decoration: const InputDecoration(labelText: 'Account type'),
                          items: const [
                            DropdownMenuItem(value: 'worker', child: Text('Worker')),
                            DropdownMenuItem(value: 'customer', child: Text('Customer')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _role = value);
                            }
                          },
                        ),
                      const SizedBox(height: 22),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.pri,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text(_isLogin ? 'Sign in' : 'Create account'),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Text(
                          _isLogin ? 'Need an account?' : 'Already have an account?',
                          style: txt(13, FontWeight.w500, AppColors.mute),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => setState(() => _isLogin = !_isLogin),
                        child: Text(
                          _isLogin ? 'Create account' : 'Sign in',
                          style: txt(15, FontWeight.w700, AppColors.pri),
                        ),
                      ),
                      const SizedBox(height: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.pri : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: txt(14, FontWeight.w700, active ? Colors.white : AppColors.mute),
        ),
      ),
    );
  }
}
