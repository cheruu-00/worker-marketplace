import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../app_store.dart';
import '../theme.dart';
import '../widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, this.threadId, this.title = 'Job conversation'});

  final String? threadId;
  final String title;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = MarketplaceStore.instance;
    final thread = widget.threadId == null
        ? (store.threads.isNotEmpty ? store.threads.first : null)
        : store.threads.firstWhere(
            (element) => element.id == widget.threadId,
            orElse: () => store.threads.first,
          );

    if (thread == null) {
      return const SizedBox();
    }

    final otherUserId = thread.participantA == store.currentUser?.id ? thread.participantB : thread.participantA;
    final bottom = math.max(16.0, MediaQuery.of(context).padding.bottom);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.line)),
              ),
              child: Row(
                children: [
                  const BackCircle(),
                  const SizedBox(width: 12),
                  Avatar(store.userName(otherUserId).substring(0, 2).toUpperCase(), size: 40),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(store.userName(otherUserId), style: txt(16, FontWeight.w600, AppColors.ink)),
                        const SizedBox(height: 2),
                        Text(widget.title, style: txt(12, FontWeight.w400, AppColors.mute)),
                      ],
                    ),
                  ),
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.pri, shape: BoxShape.circle)),
                  const SizedBox(width: 5),
                  Text('Online', style: txt(12, FontWeight.w500, AppColors.pri)),
                ],
              ),
            ),
            Container(
              color: AppColors.priSoft,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 18, color: AppColors.pri),
                      const SizedBox(width: 8),
                      Text('KSh 3,675 held in escrow', style: txt(13, FontWeight.w600, AppColors.priDark)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _rateUser(context, otherUserId),
                    child: Text('Rate', style: txt(13, FontWeight.w600, AppColors.pri)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Center(child: Text('Today', style: txt(12, FontWeight.w500, AppColors.mute))),
                  ...thread.messages.map((message) {
                    final mine = message.senderId == store.currentUser?.id;
                    return _Bubble(message.text, mine: mine, textWidth: mine ? 210 : 230);
                  }).toList(),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(16, 10, 16, bottom),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.line)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(999)),
                      child: TextField(
                        controller: _controller,
                        style: txt(15, FontWeight.w400, AppColors.ink),
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type a message',
                          hintStyle: txt(15, FontWeight.w400, AppColors.mute),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      final text = _controller.text.trim();
                      if (text.isEmpty) {
                        return;
                      }
                      store.sendMessage(thread.id, text);
                      _controller.clear();
                      setState(() {});
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: AppColors.pri, shape: BoxShape.circle),
                      child: const Icon(Icons.send, size: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _rateUser(BuildContext context, String userId) async {
    final controller = TextEditingController();
    double score = 5;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Rate this user'),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Slider(
                  min: 1,
                  max: 5,
                  divisions: 4,
                  value: score,
                  onChanged: (value) {
                    setState(() {
                      score = value;
                    });
                  },
                ),
                Text('Selected: ${score.toStringAsFixed(1)} / 5', style: txt(14, FontWeight.w600, AppColors.ink)),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Share a short review',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
          ],
        ),
      ),
    );

    if (result == true) {
      MarketplaceStore.instance.rateUser(userId, score, controller.text);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thanks for your feedback.')),
        );
      }
    }
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool mine;
  final double textWidth;
  const _Bubble(this.text, {required this.mine, required this.textWidth});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: textWidth + 28),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: mine ? AppColors.pri : AppColors.card,
            border: mine ? null : Border.all(color: AppColors.line),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(mine ? 16 : 4),
              bottomRight: Radius.circular(mine ? 4 : 16),
            ),
          ),
          child: Text(text, style: txt(14, FontWeight.w400, mine ? Colors.white : AppColors.ink, lineHeight: 20)),
        ),
      ),
    );
  }
}
