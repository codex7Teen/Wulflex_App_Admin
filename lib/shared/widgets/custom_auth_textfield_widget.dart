import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

class CustomAuthenticationTetxfieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final VoidCallback? toggleVisibility;
  final bool isPasswordVisible;
  const CustomAuthenticationTetxfieldWidget({super.key, required this.controller, required this.hintText, required this.icon, this.obscureText = false, this.validator, this.toggleVisibility, this.isPasswordVisible = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Icon(
            icon,
            color: AppColors.greyThemeColor,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w500, color: AppColors.blackThemeColor),
            controller: controller,
            obscureText: obscureText && !isPasswordVisible,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle:AppTextStyles.titleSmallThin.copyWith(fontWeight: FontWeight.w400),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.greyThemeColor,
                  width: 0.4,
                ),
              ),
              suffixIcon: toggleVisibility != null
                  ? GestureDetector(
                      onTap: toggleVisibility,
                      child: Icon(
                        isPasswordVisible
                            ? Icons.visibility_off_sharp
                            : Icons.visibility,
                        color: AppColors.greyThemeColor,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}