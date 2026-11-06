import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'theme.dart';

/// Inserts [gap] between items.
List<Widget> gapped(List<Widget> items, double gap, {Axis axis = Axis.vertical}) {
  final out = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    if (i > 0) {
      out.add(axis == Axis.vertical ? SizedBox(height: gap) : SizedBox(width: gap));
    }
    out.add(items[i]);
  }
  return out;
}

BoxDecoration cardBox({Color color = AppColors.card, double radius = 16, bool border = true}) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radius),
    border: border ? Border.all(color: AppColors.line) : null,
  );
}

class Avatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color bg;
  final Color fg;
  const Avatar(this.initials, {super.key, this.size = 44, this.bg = AppColors.priSoft, this.fg = AppColors.priDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Text(initials, style: txt(size * 0.36, FontWeight.w600, fg)),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? link;
  const SectionHeader(this.title, {super.key, this.link});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: txt(17, FontWeight.w600, AppColors.ink)),
        if (link != null) Text(link!, style: txt(14, FontWeight.w500, AppColors.pri)),
      ],
    );
  }
}

class Pill extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final IconData? icon;
  final Color? iconColor;
  const Pill(this.label, {super.key, required this.bg, required this.fg, this.icon, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: icon != null ? 6 : 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: iconColor ?? fg),
            const SizedBox(width: 5),
          ],
          Text(label, style: txt(12, FontWeight.w600, fg)),
        ],
      ),
    );
  }
}

class BackCircle extends StatelessWidget {
  const BackCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: const CircleBorder(side: BorderSide(color: AppColors.line)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.maybePop(context),
        child: const SizedBox(width: 40, height: 40, child: Icon(Icons.arrow_back, size: 20, color: AppColors.ink)),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool ghost;
  final bool small;
  const AppButton(this.label, {super.key, this.onTap, this.icon, this.ghost = false, this.small = false});

  @override
  Widget build(BuildContext context) {
    final fg = ghost ? AppColors.pri : Colors.white;
    return Material(
      color: ghost ? Colors.white : AppColors.pri,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: small ? 9 : 15, horizontal: small ? 16 : 0),
          decoration: ghost
              ? BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.pri, width: 1.5))
              : null,
          child: Row(
            mainAxisSize: small ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
              ],
              Text(label, style: txt(small ? 14 : 16, FontWeight.w600, fg)),
            ],
          ),
        ),
      ),
    );
  }
}

class FooterBar extends StatelessWidget {
  final Widget child;
  const FooterBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final bottom = math.max(16.0, MediaQuery.of(context).padding.bottom);
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: child,
    );
  }
}

class AppBottomNav extends StatelessWidget {
  final int active;
  final ValueChanged<int>? onTap;

  const AppBottomNav({super.key, required this.active, this.onTap});

  static const _tabs = [
    (Icons.home_outlined, 'Home'),
    (Icons.work_outline, 'Jobs'),
    (Icons.chat_bubble_outline, 'Chat'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = math.max(16.0, MediaQuery.of(context).padding.bottom);
    return Container(
      padding: EdgeInsets.fromLTRB(12, 10, 12, bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < _tabs.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onTap?.call(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_tabs[i].$1, size: 24, color: i == active ? AppColors.pri : AppColors.mute),
                    const SizedBox(height: 4),
                    Text(
                      _tabs[i].$2,
                      style: txt(11, i == active ? FontWeight.w600 : FontWeight.w500, i == active ? AppColors.pri : AppColors.mute),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppInput extends StatelessWidget {
  final String label;
  final String value;
  final IconData? lead;
  final IconData? trail;
  final bool tall;
  final bool readOnly;
  const AppInput(this.label, this.value, {super.key, this.lead, this.trail, this.tall = false, this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: txt(13, FontWeight.w600, AppColors.ink)),
        const SizedBox(height: 6),
        Container(
          constraints: BoxConstraints(minHeight: tall ? 96 : 0),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
          decoration: cardBox(radius: 12),
          child: Row(
            crossAxisAlignment: tall ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              if (lead != null) ...[
                Icon(lead, size: 18, color: AppColors.pri),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: TextFormField(
                  initialValue: value,
                  readOnly: readOnly,
                  maxLines: tall ? null : 1,
                  style: txt(15, FontWeight.w400, AppColors.ink, lineHeight: tall ? 22 : null),
                  decoration: const InputDecoration(isCollapsed: true, border: InputBorder.none),
                ),
              ),
              if (trail != null) ...[
                const SizedBox(width: 8),
                Icon(trail, size: 18, color: AppColors.mute),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class DashedBox extends StatelessWidget {
  final Widget child;
  final Color color;
  final Color fill;
  final double radius;
  const DashedBox({super.key, required this.child, required this.color, required this.fill, this.radius = 12});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(color, radius),
      child: Container(
        decoration: BoxDecoration(color: fill, borderRadius: BorderRadius.circular(radius)),
        child: child,
      ),
    );
  }
}

class _DashedPainter extends CustomPainter {
  final Color color;
  final double radius;
  _DashedPainter(this.color, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)));
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        canvas.drawPath(metric.extractPath(d, math.min(d + 6, metric.length)), paint);
        d += 10;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedPainter old) => old.color != color || old.radius != radius;
}

Widget hairline() => Container(height: 1, color: AppColors.line);
