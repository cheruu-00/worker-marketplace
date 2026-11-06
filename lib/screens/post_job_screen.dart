import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class PostJobScreen extends StatelessWidget {
  const PostJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  const BackCircle(),
                  const SizedBox(width: 12),
                  Text('Post a job', style: txt(20, FontWeight.w700, AppColors.ink)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gapped([
                    const AppInput('Job title', 'Fix leaking kitchen sink'),
                    const AppInput('Category', 'Plumbing', trail: Icons.keyboard_arrow_down, readOnly: true),
                    const AppInput(
                      'Description',
                      'Water drips from the pipe under the sink. Need it fixed today if possible.',
                      tall: true,
                    ),
                    const AppInput('Location', 'Kilimani, Nairobi', lead: Icons.location_on_outlined),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: gapped([
                        const Expanded(child: AppInput('Budget (KSh)', '3,500')),
                        const Expanded(
                          child: AppInput('When', 'Today, 4 PM', trail: Icons.keyboard_arrow_down, readOnly: true),
                        ),
                      ], 12, axis: Axis.horizontal),
                    ),
                    DashedBox(
                      color: AppColors.pri,
                      fill: AppColors.priSoft,
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.add, size: 18, color: AppColors.pri),
                            const SizedBox(width: 8),
                            Text('Add photos (optional)', style: txt(14, FontWeight.w500, AppColors.pri)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: AppColors.priSoft, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.verified_user_outlined, size: 20, color: AppColors.pri),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Your payment is held in escrow and only released when you confirm the job is done.',
                              style: txt(13, FontWeight.w400, AppColors.priDark, lineHeight: 19),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ], 14),
                ),
              ),
            ),
            FooterBar(
              child: SizedBox(width: double.infinity, child: AppButton('Post job', onTap: () {})),
            ),
          ],
        ),
      ),
    );
  }
}
