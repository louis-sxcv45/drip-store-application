import 'package:drip_store/provider/visibility_provider.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;
  const FormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final visibilityProvider = context.watch<VisibilityProvider>();
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: isPassword ? !visibilityProvider.isVisible : false,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            suffixIcon:
                isPassword
                    ? IconButton(
                      onPressed: () {
                        visibilityProvider.toggleVisibility();
                      },
                      icon: Icon(
                        visibilityProvider.isVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    )
                    : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
              borderSide: BorderSide(
                color: errorText != null
                       ? Colors.red
                       : Colors.grey,
              )
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.s12),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
