import 'package:flutter/material.dart';
import 'package:wulflex_admin/utils/consts/app_colors.dart';
import 'package:wulflex_admin/utils/consts/text_styles.dart';

class CustomCategoryButtonWidget extends StatefulWidget {
  final String name;
  final IconData icon;
  final VoidCallback? onTap;

  const CustomCategoryButtonWidget({
    super.key,
    required this.name,
    required this.icon,
    this.onTap,
  });

  @override
  State<CustomCategoryButtonWidget> createState() => _CustomCategoryButtonWidgetState();
}

class _CustomCategoryButtonWidgetState extends State<CustomCategoryButtonWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize AnimationController with a duration and repeat behavior
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true); // Repeat animation back and forth

    // Define scale animation to create a subtle "dance" effect
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller when widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapUp: (_) {
          _controller.reverse(); // Revert animation on tap release
          widget.onTap?.call();  // Trigger onTap callback if provided
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value, // Apply scaling effect to the container
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.blueThemeColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blueThemeColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    color: AppColors.lightScaffoldColor,
                    size: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.lightScaffoldColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
