import 'package:drip_store/common_widgets/button_widget.dart';
import 'package:drip_store/common_widgets/form_field.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/styles_manager/assets_image_icon.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                ColorsManager.primary,
                ColorsManager.secondary,
                ColorsManager.cyan,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: AppSize.s80),

              Image.asset('${AssetsImageIcon.assetPath}/logo.png'),

              Container(
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s30),
                    topRight: Radius.circular(AppSize.s30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.s30,
                    vertical: AppSize.s30,
                  ),
                  child: Form(
                    key: _loginKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Login to your account',
                          style: TextStyle(
                            fontSize: FontSizeManager.f24,
                            fontWeight: FontWeightManager.bold,
                          ),
                        ),
              
                        SizedBox(height: AppSize.s20),
              
                        Text(
                          'Please enter your email and password to login before you place the order',
                          style: TextStyle(
                            fontSize: FontSizeManager.f16,
                            fontWeight: FontWeightManager.regular,
                            color: const Color.fromARGB(255, 87, 85, 85),
                          ),
                        ),
              
                        SizedBox(height: AppSize.s18),
              
                        FormFieldWidget(
                          controller: _emailController,
                          hintText: 'Email',
                          errorText: authProvider.emailError,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
              
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
              
                            return null;
                          },
                        ),
              
                        SizedBox(height: AppSize.s18),
              
                        FormFieldWidget(
                          controller: _passwordController,
                          hintText: 'Password',
                          isPassword: true,
                          errorText: authProvider.passwordError,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),
              
                        SizedBox(height: AppSize.s18),
              
                        authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ButtonWidget(
                              title: 'SIGN IN',
                              onTapped: () async {
                                if (_loginKey.currentState!.validate()) {
                                  await authProvider.login(
                                    _emailController.text,
                                    _passwordController.text,
                                  );
              
                                  if (authProvider.isLoggedIn && context.mounted)
                                    // ignore: curly_braces_in_flow_control_structures, use_build_context_synchronously
                                    context.go('/home');
                                }
              
                                _emailController.clear();
                                _passwordController.clear();
                              },
                            ),
              
                        SizedBox(height: AppSize.s24),
              
                        GestureDetector(
                          onTap: () => context.push('/register'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSize.s18,
                            ),
                            width: double.infinity,
                            height: AppSize.s60,
                            decoration: BoxDecoration(
                              color: ColorsManager.platinum,
                              borderRadius: BorderRadius.circular(AppSize.s12),
                            ),
                            child: Text(
                              'Create an account',
                              style: TextStyle(
                                fontWeight: FontWeightManager.bold,
                                fontSize: FontSizeManager.f18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
