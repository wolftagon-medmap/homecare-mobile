import 'package:flutter/material.dart';
import 'package:m2health/const.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String? subtitle;
  final String? avatar;

  const ChatAppBar({
    super.key,
    required this.name,
    this.subtitle,
    this.avatar,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      title: Row(
        children: [
          _Avatar(name: name, avatar: avatar),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: ProText.sectionTitle
                      .copyWith(color: Const.primaryTextColor),
                ),
                if (subtitle != null && subtitle!.isNotEmpty)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Const.tosca),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final String? avatar;

  const _Avatar({required this.name, this.avatar});

  @override
  Widget build(BuildContext context) {
    if (avatar != null && avatar!.isNotEmpty) {
      return CircleAvatar(radius: 17, backgroundImage: NetworkImage(avatar!));
    }
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      radius: 17,
      backgroundColor: Const.aqua.withValues(alpha: 0.15),
      child: Text(
        initial,
        style: const TextStyle(
          color: Const.aqua,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
