import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserInfoButton extends StatelessWidget {
  final double? width;
  final Widget content;
  final Color? color;
  final void Function()? _onTap;

  const UserInfoButton({
    super.key,
    this.width,
    required this.content,
    this.color,
    onTap,
  }) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: SizedBox(
        height: Sizes.size48,
        child: Container(
          alignment: Alignment.center,
          width: width,
          // padding: const EdgeInsets.all(
          //   Sizes.size12,
          // ),
          decoration: BoxDecoration(
            color: color,
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(
              Sizes.size2,
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}
