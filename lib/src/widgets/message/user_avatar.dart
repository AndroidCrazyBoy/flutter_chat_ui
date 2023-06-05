import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../../conditional/conditional.dart';
import '../../models/bubble_rtl_alignment.dart';
import '../../util.dart';
import '../state/inherited_chat_theme.dart';

/// Renders user's avatar or initials next to a message.
class UserAvatar extends StatelessWidget {
  /// Creates user avatar.
  const UserAvatar({
    super.key,
    required this.author,
    this.bubbleRtlAlignment,
    this.imageHeaders,
    this.onAvatarTap,
  });

  /// Author to show image and name initials from.
  final types.User author;

  /// See [Message.bubbleRtlAlignment].
  final BubbleRtlAlignment? bubbleRtlAlignment;

  /// See [Chat.imageHeaders].
  final Map<String, String>? imageHeaders;

  /// Called when user taps on an avatar.
  final void Function(types.User)? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final hasImage = author.imageUrl != null;
    final initials = getUserInitials(author);

    return Container(
      // margin: bubbleRtlAlignment == BubbleRtlAlignment.left
      //     ? const EdgeInsetsDirectional.only(end: 8)
      //     : const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => onAvatarTap?.call(author),
        child: hasImage
            ? ClipOval(
                child: Image(
                  image: Conditional().getProvider(author.imageUrl!, headers: imageHeaders),
                  width: 36,
                  height: 36,
                ),
              )
            : CircleAvatar(
                radius: 18,
                child: Text(
                  initials,
                  style: InheritedChatTheme.of(context).theme.userAvatarTextStyle,
                ),
              ),
      ),
    );
  }
}
