import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/utils.dart';

class selectedChatUsersScreen extends ConsumerStatefulWidget {
  const selectedChatUsersScreen({super.key});

  @override
  CreateANewChatScreenState createState() => CreateANewChatScreenState();
}

class CreateANewChatScreenState extends ConsumerState<selectedChatUsersScreen> {
  final ScrollController _scrollController = ScrollController();
  // List<int> selected = List.empty(growable: true);

  void _onClossePressed() {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);

    return Container(
      height: size.height * 0.2,
      // clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size14,
        ),
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: isDark ? Colors.grey.shade800 : null,
        child: const Text("H"),
      ),
    );
  }
}
