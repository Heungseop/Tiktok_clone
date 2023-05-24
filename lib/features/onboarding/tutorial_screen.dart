import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

enum Direction { right, left }

enum Page { first, sencond }

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({super.key});

  @override
  State<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen> {
  Direction _direction = Direction.right;
  Page _showingPage = Page.first;

  void _onPanUpdate(DragUpdateDetails details) {
    print(details);
    const minDragOffset = 20;
    if (details.delta.dx > minDragOffset) {
      //to the right
      setState(() {
        _direction = Direction.right;
      });
    } else if (details.delta.dx < -minDragOffset) {
      // to the left
      setState(() {
        _direction = Direction.left;
      });
    }
  }

  void _onPanEnd(DragEndDetails detail) {
    if (_direction == Direction.left) {
      setState(() {
        _showingPage = Page.sencond;
      });
    } else {
      setState(() {
        _showingPage = Page.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.size24),
          child: SafeArea(
            child: AnimatedCrossFade(
                firstChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Gaps.v80,
                    Text(
                      "Watch cool videos!",
                      style: TextStyle(
                        fontSize: Sizes.size40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Gaps.v16,
                    Text(
                      "Videos are personalized for you based on what you watch, like, and share.",
                      style: TextStyle(
                        fontSize: Sizes.size20,
                      ),
                    ),
                  ],
                ),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Gaps.v80,
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Text(
                        "Follow the Rules",
                        style: TextStyle(
                          fontSize: Sizes.size40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Gaps.v16,
                    Text(
                      "Take care of one another! please!",
                      style: TextStyle(
                        fontSize: Sizes.size20,
                      ),
                    ),
                  ],
                ),
                crossFadeState: _showingPage == Page.first
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300)),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size24,
              horizontal: Sizes.size24,
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _showingPage == Page.first ? 0 : 1,
              child: _showingPage == Page.first
                  ? const SizedBox(
                      height: 1,
                    )
                  : CupertinoButton(
                      onPressed: () {
                        print("onPressed!");
                      },
                      color: Theme.of(context).primaryColor,
                      child: const Text("Enter the App!"),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
