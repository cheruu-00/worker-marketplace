import 'package:flutter/material.dart';
import 'app_store.dart';
import 'theme.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_job_screen.dart';
import 'screens/job_feed_screen.dart';
import 'screens/worker_profile_screen.dart';
import 'screens/payment_screen.dart';
import 'screens/chat_screen.dart';

void main() => runApp(const WorkerMarketplaceApp());

class WorkerMarketplaceApp extends StatelessWidget {
  const WorkerMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isSignedIn = MarketplaceStore.instance.currentUser != null;

    return MaterialApp(
      title: 'Worker Marketplace',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: isSignedIn ? const HomeScreen() : const AuthScreen(),
    );
  }
}

/// Lists every screen so you can open each one directly.
class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = <(String, Widget)>[
      ('01 Customer – Home', const HomeScreen()),
      ('02 Customer – Post a Job', const PostJobScreen()),
      ('03 Worker – Job Feed', const JobFeedScreen()),
      ('04 Customer – Worker Profile', const WorkerProfileScreen()),
      ('05 Customer – Escrow Payment', const PaymentScreen()),
      ('06 Chat – Job conversation', const ChatScreen()),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text('Screens', style: txt(20, FontWeight.w700, AppColors.ink)),
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: entries.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final e = entries[i];
          return Material(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => e.$2)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.line),
                ),
                child: Row(
                  children: [
                    Expanded(child: Text(e.$1, style: txt(16, FontWeight.w600, AppColors.ink))),
                    const Icon(Icons.chevron_right, color: AppColors.mute),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
