import 'package:drip_store/common_widgets/button_widget.dart';
import 'package:drip_store/common_widgets/form_field.dart';
import 'package:drip_store/common_widgets/text_button_widget.dart';
import 'package:drip_store/provider/auth_provider.dart';
import 'package:drip_store/provider/bottom_navigation_provider.dart';
import 'package:drip_store/styles_manager/colors_manager.dart';
import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _registerKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: AppSize.s80),
              Image.asset('assets/images/logo.png'),
              Container(
                decoration: BoxDecoration(
                  color: ColorsManager.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSize.s30),
                    topRight: Radius.circular(AppSize.s30),
                  ),
                ),

                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.p20,
                    vertical: AppPadding.p30,
                  ),
                  child: Form(
                    key: _registerKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create An Account',
                          style: TextStyle(
                            fontSize: AppSize.s24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text.rich(
                          TextSpan(
                            text: 'Already Have An Account?',
                            style: TextStyle(
                              fontSize: FontSizeManager.f16,
                              color: const Color.fromARGB(255, 87, 85, 85),
                            ),
                            children: [
                              TextSpan(
                                text: ' Sign In',
                                style: TextStyle(
                                  fontSize: FontSizeManager.f16,
                                  color: ColorsManager.black,
                                  fontWeight: FontWeightManager.bold,
                                ),
                                recognizer:
                                    TapGestureRecognizer()
                                      ..onTap = () {
                                        context.go('/login');
                                      },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSize.s20),

                        Row(
                          children: [
                            Expanded(
                              child: FormFieldWidget(
                                controller: _nameController,
                                hintText: 'Name',
                                errorText: authProvider.regisError,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }

                                  return null;
                                },
                              ),
                            ),

                            SizedBox(width: AppSize.s20),

                            Expanded(
                              child: FormFieldWidget(
                                controller: _emailController,
                                hintText: 'Email',
                                errorText: authProvider.regisError,
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
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.s20),

                        FormFieldWidget(
                          controller: _passwordController,
                          hintText: 'Password',
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: AppSize.s20),

                        FormFieldWidget(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Your Password',
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Confirm Password is required';
                            }

                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }

                            return null;
                          },
                        ),

                        SizedBox(height: AppSize.s24),

                        authProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ButtonWidget(
                              title: 'Sign Up',
                              onTapped: () async {
                                if (_registerKey.currentState!.validate()) {
                                  await authProvider.register(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _confirmPasswordController.text,
                                  );

                                  if (authProvider.isLoggedIn && context.mounted) {
                                    context.read<BottomNavigationProvider>().setIndexNav(0);
                                    context.go('/home');
                                  }
                                }
                                _nameController.clear();
                                _emailController.clear();
                                _passwordController.clear();
                                _confirmPasswordController.clear();
                              },
                            ),

                        SizedBox(height: AppSize.s20),

                        Text(
                          'By tap Sign Up button you accept terms and privacy this app',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: FontSizeManager.f16),
                        ),

                        SizedBox(height: AppSize.s6),

                        TextButtonWidget(
                          title: 'Back to Sign In Page',
                          onPressed: () {
                            context.push('/login');
                          },
                          size: AppSize.s20,
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
