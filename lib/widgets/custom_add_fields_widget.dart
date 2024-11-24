import 'package:flutter/material.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';

class CustomAddFieldsWidget extends StatelessWidget {
  final TextInputType? textInputType;
  final int? minLines;
  final int? maxLines;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  const CustomAddFieldsWidget(
      {super.key,
      this.textInputType = TextInputType.text,
      this.minLines = 1,
      this.maxLines = 30,
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
          keyboardType: textInputType,
          style: AppTextStyles.titleMedium.copyWith(color: Colors.black),
          decoration: InputDecoration(border: InputBorder.none),
        ),
      ),
    );
  }
}
