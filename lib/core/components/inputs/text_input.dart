import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:learning_app/core/constants/app_colors.dart';
import 'package:learning_app/core/constants/app_styles.dart';
import 'package:learning_app/core/utils/utils.dart';

class TextInput extends StatefulWidget {
  final TextInputType? keyboardType;
  final String? initialText;
  final String? placeholder;
  final TextEditingController? controller;
  final bool Function(String)? validator;
  final Widget? icon;
  final double? height;
  final String? errorMessage;
  final FocusNode? focusNode;

  const TextInput({
    super.key,
    this.keyboardType,
    this.initialText,
    this.placeholder,
    this.controller,
    this.icon,
    this.validator,
    this.height,
    this.errorMessage,
    this.focusNode,
  });

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  String _errorMessage = '';
  late FocusNode _focus;
  bool _isFocused = false;

  // --- methods ---
  void _setFocusState() {
    if (_focus.hasFocus == false) {
      setState(() {
        _isFocused = false;
      });
    } else {
      setState(() {
        _isFocused = true;
      });
    }
  }

  @override
  void initState() {
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(() {
      if (mounted) {
        _setFocusState();
      }
      // if (_focus.hasFocus) {
      //   if (_errorMessage.isNotEmpty) {
      //     Future.delayed(Duration(milliseconds: 50), () {
      //       // widget.formKey?.currentState!.reset();
      //     });
      //   }
      // }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),
          child: Container(
            height: widget.height ?? 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isFocused ? AppColors.primary : AppColors.borderColor,
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.icon != null) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 24, right: 8),
                    child: Center(child: widget.icon!),
                  ),
                ],
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,
                    textAlignVertical: TextAlignVertical.center,
                    style: Styles.medium.regular,
                    onTapOutside: (event) => Utils.hideKeyboard(),
                    cursorColor: AppColors.primary,
                    keyboardType: widget.keyboardType,
                    validator: (value) {
                      bool isTrue = widget.validator?.call(value ?? '') ?? true;
                      String errorMessage = !isTrue
                          ? widget.errorMessage ?? ""
                          : "";
                      setState(() {
                        _errorMessage = errorMessage;
                      });

                      return errorMessage.isEmpty ? null : errorMessage;
                    },
                    focusNode: _focus,
                    onChanged: (value) {
                      // widget.validator?.call(value);
                      if (_errorMessage.isNotEmpty) {
                        setState(() {
                          _errorMessage = '';
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                        top: 13,
                        bottom: 11,
                        left: 12,
                        right: 12,
                      ),
                      errorText: null, // or null
                      errorStyle: TextStyle(
                        height: 0, // 👈 hides error text layout
                        fontSize: 0.001, // 👈 makes it invisible
                        color: Colors.transparent, // 👈 hide just in case
                      ),
                      hintText: widget.placeholder,
                      hintStyle: Styles.medium.secondary,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      isCollapsed: false,
                      // icon: widget.icon,
                    ),
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(child: const SizedBox.shrink()),
      ],
    );
  }
}
