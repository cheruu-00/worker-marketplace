import 'package:flutter/material.dart';
import '../app_store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'chat_screen.dart';
import 'payment_screen.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Align(alignment: Alignment.centerLeft, child: BackCircle()),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gapped([
                    Column(
                      children: [
                        const Avatar('JM', size: 80),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('James Mwangi', style: txt(22, FontWeight.w700, AppColors.ink)),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_user_outlined, size: 20, color: AppColors.pri),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text('Plumber · Nairobi', style: txt(14, FontWeight.w400, AppColors.mute)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: cardBox(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(child: _Stat('4.9', 'Rating')),
                          Container(width: 1, height: 28, color: AppColors.line),
                          const Expanded(child: _Stat('126', 'Jobs done')),
                          Container(width: 1, height: 28, color: AppColors.line),
                          const Expanded(child: _Stat('6 yrs', 'Experience')),
                        ],
                      ),
                    ),
                    Row(
                      children: gapped([
                        const Pill('Verified ID', bg: AppColors.priSoft, fg: AppColors.priDark, icon: Icons.verified_user_outlined),
                        const Pill('Top rated', bg: AppColors.accSoft, fg: AppColors.accDark, icon: Icons.star_rounded, iconColor: AppColors.acc),
                        const Pill('Fast reply', bg: Color(0xFFE3F1FB), fg: Color(0xFF2477B5), icon: Icons.bolt),
                      ], 8, axis: Axis.horizontal),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            'Rate worker',
                            ghost: true,
                            onTap: () => _rateUser(context, 'user-worker-1'),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('About', style: txt(16, FontWeight.w600, AppColors.ink)),
                        const SizedBox(height: 6),
                        Text(
                          'Licensed plumber with 6 years of experience in home repairs, installations and emergency call-outs across Nairobi.',
                          style: txt(14, FontWeight.w400, AppColors.mute, lineHeight: 21),
                        ),
                      ],
                    ),
                    Row(
                      children: gapped([
                        for (final s in const ['Pipe repair', 'Water heaters', 'Drainage'])
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: cardBox(radius: 999),
                            child: Text(s, style: txt(13, FontWeight.w500, AppColors.ink)),
                          ),
                      ], 8, axis: Axis.horizontal),
                    ),
                    const SectionHeader('Recent work', link: 'See all'),
                    Row(
                      children: gapped([
                        const Expanded(child: _WorkTile(Icons.water_drop_outlined, Color(0xFFE3F1FB), Color(0xFF2477B5))),
                        const Expanded(child: _WorkTile(Icons.build_outlined, Color(0xFFE3F4EC), Color(0xFF12805C))),
                        const Expanded(child: _WorkTile(Icons.auto_awesome, Color(0xFFFFF3DC), Color(0xFFC77E00))),
                      ], 10, axis: Axis.horizontal),
                    ),
                  ], 14),
                ),
              ),
            ),
            FooterBar(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('KSh 600', style: txt(20, FontWeight.w700, AppColors.ink)),
                      const SizedBox(height: 1),
                      Text('per hour', style: txt(12, FontWeight.w400, AppColors.mute)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      'Message',
                      ghost: true,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen())),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppButton(
                      'Hire',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen())),
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
}

Future<void> _rateUser(BuildContext context, String userId) async {
  final controller = TextEditingController();
  double score = 5;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('Rate this worker'),
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
        const SnackBar(content: Text('Thanks for rating this worker.')),
      );
    }
  }
}

class _Stat extends StatelessWidget {
  final String value, label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: txt(18, FontWeight.w700, AppColors.ink)),
        const SizedBox(height: 2),
        Text(label, style: txt(12, FontWeight.w400, AppColors.mute)),
      ],
    );
  }
}

class _WorkTile extends StatelessWidget {
  final IconData icon;
  final Color bg, fg;
  const _WorkTile(this.icon, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 26, color: fg),
    );
  }
}
