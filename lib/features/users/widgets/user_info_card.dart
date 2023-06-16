import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class UserInfoCard extends StatelessWidget {
  final number;
  final infoName;

  const UserInfoCard({super.key, required this.number, required this.infoName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Sizes.size18,
            height: 1.1,
          ),
        ),
        Gaps.v3,
        Text(
          infoName,
          style: TextStyle(
            color: Colors.grey.shade500,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}
