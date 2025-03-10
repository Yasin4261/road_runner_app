import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:road_runner_app/constants/colors.dart';
import 'package:road_runner_app/models/user_model.dart';
import 'package:road_runner_app/viewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 60),
          Icon(
            Icons.directions_bike_rounded,
            size: 80,
            color: AppColors.primary,
          ),
          const SizedBox(height: 24),
          Text(
            'Kurye Uygulaması',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          TextFormField(
            controller: _emailController,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'E-posta',
              labelStyle: TextStyle(color: AppColors.textSecondary),
              prefixIcon: Icon(Icons.email, color: AppColors.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.textSecondary),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen e-posta adresinizi girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              labelText: 'Şifre',
              labelStyle: TextStyle(color: AppColors.textSecondary),
              prefixIcon: Icon(Icons.lock, color: AppColors.primary),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.textSecondary),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Lütfen şifrenizi girin';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: viewModel.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      final user = UserModel(
                        name:
                            '', // Login formunda name alanı yok, bu yüzden boş bırakıyoruz
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        profileImageUrl:
                            '', // Login formunda profileImageUrl alanı yok, bu yüzden boş bırakıyoruz
                      );
                      viewModel.login(user, context);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
            ),
            child: viewModel.isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Giriş Yap',
                    style: TextStyle(fontSize: 16),
                  ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.go('/register');
            },
            child: Text(
              'Hesabınız yok mu? Kayıt olun',
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
