import 'package:flutter/material.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_styles.dart';

class OutlineButton extends StatelessWidget {
  final double? height;
  final String? text;
  final void Function() onPress;
  final bool disabled;
  final Widget? widget;

  const OutlineButton({
    super.key,
    this.height,
    this.text,
    required this.onPress,
    this.disabled = false,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: height ?? 44,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(44)),
              border: BoxBorder.all(color: AppColors.primary, width: 1),
            ),
            child: widget != null
                ? InkWell(
                    borderRadius: BorderRadius.circular(44),

                    onTap: disabled ? null : onPress,
                    child: widget,
                  )
                : TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 0,
                      ),
                    ),
                    onPressed: disabled ? null : onPress,
                    child: Text(
                      text!,
                      style: Styles.large.regular.copyWith(
                        color: disabled
                            ? Colors.white.withValues(alpha: 0.7)
                            : AppColors.primary,
                      ),
                    ),
                  ),
          ),
        ),
        if (disabled) ...[
          Container(
            width: double.infinity,
            height: height ?? 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(44)),
              color: Colors.black.withValues(alpha: 0.4),
            ),
          ),
        ],
      ],
    );
  }
}
