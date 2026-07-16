import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final double borderRadius;

  const ProfileAvatarWidget({
    super.key,
    this.avatarUrl,
    this.size = 56,
    this.borderRadius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.network(
          avatarUrl ?? '',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: Icon(
                Icons.person,
                // Scales with the avatar: a fixed size overflowed and sat
                // off-centre once the widget was used smaller than 100.
                size: size * 0.6,
                color: Colors.grey,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              width: size,
              height: size,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
