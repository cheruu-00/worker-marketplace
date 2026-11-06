import 'package:flutter/material.dart';
import '../app_store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'chat_screen.dart';

class JobFeedScreen extends StatefulWidget {
  const JobFeedScreen({super.key});

  @override
  State<JobFeedScreen> createState() => _JobFeedScreenState();
}

class _JobFeedScreenState extends State<JobFeedScreen> {
  @override
  Widget build(BuildContext context) {
    final jobs = MarketplaceStore.instance.jobs;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Jobs near you', style: txt(24, FontWeight.w700, AppColors.ink)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                        decoration: BoxDecoration(color: AppColors.priSoft, borderRadius: BorderRadius.circular(999)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.pri, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Text('Available', style: txt(13, FontWeight.w600, AppColors.priDark)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('${jobs.length} new jobs match your skills', style: txt(14, FontWeight.w400, AppColors.mute)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: gapped([
                  for (final f in const ['All', 'Plumbing', 'Repairs', 'Cleaning']) _FilterChip(f, active: f == 'All'),
                ], 8, axis: Axis.horizontal),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gapped([
                    for (final job in jobs)
                      _JobCard(
                        job: job,
                        onApply: () {
                          if (MarketplaceStore.instance.currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sign in to apply for jobs.')),
                            );
                            return;
                          }
                          MarketplaceStore.instance.applyToJob(job.id);
                          setState(() {});
                          final thread = MarketplaceStore.instance.threadForJobId(job.id);
                          if (thread != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatScreen(threadId: thread.id, title: thread.title),
                              ),
                            );
                          }
                        },
                      ),
                  ], 14),
                ),
              ),
            ),
            const AppBottomNav(active: 1),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;
  const _FilterChip(this.label, {required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? AppColors.pri : AppColors.card,
        borderRadius: BorderRadius.circular(999),
        border: active ? null : Border.all(color: AppColors.line),
      ),
      child: Text(label, style: txt(13, FontWeight.w500, active ? Colors.white : AppColors.ink)),
    );
  }
}

class _JobCard extends StatelessWidget {
  final JobListing job;
  final VoidCallback onApply;

  const _JobCard({required this.job, required this.onApply});

  @override
  Widget build(BuildContext context) {
    final catBg = job.category == 'Plumbing'
        ? const Color(0xFFE3F1FB)
        : job.category == 'Cleaning'
            ? const Color(0xFFF1E8FB)
            : const Color(0xFFE8EEF1);
    final catFg = job.category == 'Plumbing'
        ? const Color(0xFF2477B5)
        : job.category == 'Cleaning'
            ? const Color(0xFF7A4CB5)
            : const Color(0xFF4A5D68);

    final alreadyApplied = job.applicants.contains(MarketplaceStore.instance.currentUser?.id);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: gapped([
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Pill(job.category, bg: catBg, fg: catFg),
              Text('12 min ago', style: txt(12, FontWeight.w400, AppColors.mute)),
            ],
          ),
          Text(job.title, style: txt(16, FontWeight.w600, AppColors.ink)),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.mute),
              const SizedBox(width: 4),
              Text(job.location, style: txt(13, FontWeight.w400, AppColors.mute)),
              const SizedBox(width: 14),
              Text(job.when, style: txt(13, FontWeight.w400, AppColors.mute)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(job.price, style: txt(18, FontWeight.w700, AppColors.ink)),
                  const SizedBox(height: 3),
                  if (job.isEscrowProtected)
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, size: 12, color: AppColors.pri),
                        const SizedBox(width: 4),
                        Text('Escrow protected', style: txt(12, FontWeight.w500, AppColors.pri)),
                      ],
                    )
                  else
                    Text('Budget', style: txt(12, FontWeight.w400, AppColors.mute)),
                ],
              ),
              AppButton(alreadyApplied ? 'Applied' : 'Apply', small: true, onTap: onApply),
            ],
          ),
        ], 10),
      ),
    );
  }
}
