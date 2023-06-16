import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FlashFunctionIcon extends StatelessWidget {
  final FlashMode _flashMode;
  final FlashMode _selectedFlashMode;
  final Future<void> Function(FlashMode) _onTap;

  final Map<FlashMode, Widget> _icons = {
    FlashMode.off: const Icon(Icons.flash_off_rounded),
    FlashMode.always: const Icon(Icons.flash_on_rounded),
    FlashMode.auto: const Icon(Icons.flash_auto),
    FlashMode.torch: const Icon(Icons.flashlight_on_rounded)
  };

  // final void Function()? _onTap;

  FlashFunctionIcon(
      {super.key,
      required flashMode,
      required selectedFlashMode,
      required onTap})
      : _flashMode = flashMode,
        _selectedFlashMode = selectedFlashMode,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: _selectedFlashMode == _flashMode ? Colors.amber : Colors.grey,
      onPressed: () => _onTap(_flashMode),
      icon: _icons[_flashMode]!,
    );
  }
}
