import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

class CustomAddFieldsWidget extends StatelessWidget {
  final TextInputType? textInputType;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  const CustomAddFieldsWidget(
      {super.key,
      this.textInputType = TextInputType.text,
      this.minLines = 1,
      this.maxLines = 30,
      this.maxLength,
      this.validator,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.lightGreyThemeColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 3),
        child: TextFormField(
          autovalidateMode: AutovalidateMode.disabled,
          controller: controller,
          validator: validator,
          minLines: minLines,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: textInputType,
          style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
