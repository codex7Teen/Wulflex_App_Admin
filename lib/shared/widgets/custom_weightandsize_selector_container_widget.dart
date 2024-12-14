import 'package:flutter/material.dart';
import 'package:wulflex_admin/core/config/app_colors.dart';
import 'package:wulflex_admin/core/config/text_styles.dart';

class CustomWeightandsizeSelectorContainerWidget extends StatefulWidget {
  final String weightOrSize;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomWeightandsizeSelectorContainerWidget({
    super.key,
    required this.weightOrSize,
    required this.isSelected,
    required this.onTap,
  });

  @override
  CustomWeightandsizeSelectorContainerWidgetState createState() =>
      CustomWeightandsizeSelectorContainerWidgetState();
}

class CustomWeightandsizeSelectorContainerWidgetState
    extends State<CustomWeightandsizeSelectorContainerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200), // Increased duration
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.8).animate(_controller); // More pronounced scale
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onContainerTapped() {
    _controller.forward().then((_) {
      _controller.reverse();
    });
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: GestureDetector(
        onTap: _onContainerTapped,
        child: Container(
          width: 62,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isSelected
                ? AppColors.lightBlueThemeColor
                : AppColors.lightGreyThemeColor,
          ),
          child: Center(
            child: Text(
              widget.weightOrSize,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.blackThemeColor),
            ),
          ),
        ),
      ),
    );
  }
}
