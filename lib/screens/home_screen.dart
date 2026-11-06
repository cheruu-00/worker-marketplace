import 'package:flutter/material.dart';
import '../app_store.dart';
import '../theme.dart';
import '../widgets.dart';
import 'auth_screen.dart';
import 'chat_screen.dart';
import 'job_feed_screen.dart';
import 'worker_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const _tabScreens = [
    'home',
    'jobs',
    'chat',
    'profile',
  ];

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      _HomeContent(),
      const JobFeedScreen(),
      const ChatScreen(),
      const WorkerProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: AppBottomNav(
        active: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  static const _cats = [
    (Icons.water_drop_outlined, 'Plumbing', Color(0xFFE3F1FB), Color(0xFF2477B5)),
    (Icons.bolt, 'Electrical', Color(0xFFFFF3DC), Color(0xFFC77E00)),
    (Icons.auto_awesome, 'Cleaning', Color(0xFFF1E8FB), Color(0xFF7A4CB5)),
    (Icons.eco_outlined, 'Gardening', Color(0xFFE3F4EC), Color(0xFF12805C)),
    (Icons.local_shipping_outlined, 'Moving', Color(0xFFFDE9E4), Color(0xFFC4553A)),
    (Icons.build_outlined, 'Repairs', Color(0xFFE8EEF1), Color(0xFF4A5D68)),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: gapped([
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Habari, ${MarketplaceStore.instance.currentUser?.name.split(' ').first ?? 'there'}', style: txt(24, FontWeight.w700, AppColors.ink)),
                          const SizedBox(height: 2),
                          Text('Find trusted help nearby', style: txt(14, FontWeight.w400, AppColors.mute)),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          MarketplaceStore.instance.signOut();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                            (route) => false,
                          );
                        },
                        child: Avatar((MarketplaceStore.instance.currentUser?.name ?? 'U').substring(0, 2).toUpperCase(), size: 44),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: cardBox(radius: 999),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: AppColors.pri),
                          const SizedBox(width: 6),
                          Text('Kilimani, Nairobi', style: txt(13, FontWeight.w500, AppColors.ink)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    decoration: cardBox(radius: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 20, color: AppColors.mute),
                        const SizedBox(width: 10),
                        Text('What do you need help with?', style: txt(15, FontWeight.w400, AppColors.mute)),
                      ],
                    ),
                  ),
                  const SectionHeader('Categories', link: 'See all'),
                  for (var r = 0; r < 2; r++)
                    Row(
                      children: gapped([
                        for (var c = 0; c < 3; c++) Expanded(child: _CategoryTile(_cats[r * 3 + c])),
                      ], 12, axis: Axis.horizontal),
                    ),
                  const SectionHeader('Top-rated near you', link: 'See all'),
                  const _WorkerCard(initials: 'JM', name: 'James Mwangi', skill: 'Plumber · 6 yrs', rating: '4.9', jobs: '126', price: 'KSh 600'),
                  const _WorkerCard(initials: 'GA', name: 'Grace Achieng', skill: 'House cleaner · 4 yrs', rating: '4.8', jobs: '89', price: 'KSh 400'),
                ], 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final (IconData, String, Color, Color) data;
  const _CategoryTile(this.data);

  @override
  Widget build(BuildContext context) {
    final (icon, label, bg, fg) = data;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: cardBox(),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 22, color: fg),
          ),
          const SizedBox(height: 8),
          Text(label, style: txt(13, FontWeight.w500, AppColors.ink)),
        ],
      ),
    );
  }
}

class _WorkerCard extends StatelessWidget {
  final String initials, name, skill, rating, jobs, price;
  const _WorkerCard({
    required this.initials,
    required this.name,
    required this.skill,
    required this.rating,
    required this.jobs,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkerProfileScreen())),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: cardBox(),
        child: Row(
          children: [
            Avatar(initials, size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(name, overflow: TextOverflow.ellipsis, style: txt(16, FontWeight.w600, AppColors.ink)),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_user_outlined, size: 16, color: AppColors.pri),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(skill, style: txt(13, FontWeight.w400, AppColors.mute)),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: AppColors.acc),
                      const SizedBox(width: 4),
                      Text('$rating ($jobs)', style: txt(13, FontWeight.w500, AppColors.ink)),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(price, style: txt(16, FontWeight.w700, AppColors.ink)),
                const SizedBox(height: 2),
                Text('per hour', style: txt(12, FontWeight.w400, AppColors.mute)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
