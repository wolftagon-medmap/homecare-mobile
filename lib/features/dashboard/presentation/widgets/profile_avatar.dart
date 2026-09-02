import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? avatarUrl;
  final bool showSwitcherChevron;
  final VoidCallback onTap;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    required this.showSwitcherChevron,
    required this.onTap,
  });

  static const _size = 56.0;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: showSwitcherChevron ? 'Switch profile' : 'Profile',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: _size,
              height: _size,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: _image(),
              ),
            ),
            if (showSwitcherChevron)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 16,
                    color: Color(0xFF35C5CF),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _image() {
    final url = avatarUrl;
    if (url == null || url.isEmpty) return const _AvatarPlaceholder();

    return Image.network(
      url,
      width: _size,
      height: _size,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => const _AvatarPlaceholder(),
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return const _AvatarPlaceholder();
      },
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ProfileAvatar._size,
      height: ProfileAvatar._size,
      color: Colors.grey.shade200,
      child: const Icon(Icons.person, size: 40, color: Colors.grey),
    );
  }
}
