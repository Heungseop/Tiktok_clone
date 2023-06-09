import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class MainButton extends StatelessWidget {
  final String text;
  final Color? backColor;
  final Function(BuildContext context)? _onTap;

  const MainButton({
    super.key,
    required this.text,
    Function(BuildContext)? onTap,
    this.backColor,
  }) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => (_onTap ?? (_) => {})(context),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          padding: const EdgeInsets.all(Sizes.size14),
          decoration: BoxDecoration(
              border: const Border.symmetric(),
              color: backColor ?? Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: Sizes.size16,
              fontWeight: FontWeight.w600,
              color: backColor != null ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
