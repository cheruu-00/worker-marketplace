import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

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
                  Text('Secure payment', style: txt(20, FontWeight.w700, AppColors.ink)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gapped([
                    _summaryCard(),
                    _mpesaCard(),
                    _escrowCard(),
                  ], 14),
                ),
              ),
            ),
            FooterBar(
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  'Pay KSh 3,675',
                  icon: Icons.lock_outline,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Payment secured and the job is now in escrow.')),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: gapped([
          Row(
            children: [
              const Avatar('JM', size: 44),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('James Mwangi', style: txt(15, FontWeight.w600, AppColors.ink)),
                  const SizedBox(height: 2),
                  Text('Fix leaking kitchen sink', style: txt(13, FontWeight.w400, AppColors.mute)),
                ],
              ),
            ],
          ),
          hairline(),
          _priceRow('Job budget', 'KSh 3,500'),
          _priceRow('Service fee (5%)', 'KSh 175'),
          hairline(),
          _priceRow('Total', 'KSh 3,675', bold: true),
        ], 12),
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: txt(bold ? 16 : 14, bold ? FontWeight.w600 : FontWeight.w400, bold ? AppColors.ink : AppColors.mute)),
        Text(value, style: txt(bold ? 20 : 14, bold ? FontWeight.w700 : FontWeight.w500, bold ? AppColors.pri : AppColors.ink)),
      ],
    );
  }

  Widget _mpesaCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardBox(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: gapped([
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(color: AppColors.mpesa, borderRadius: BorderRadius.circular(8)),
                child: Text('M-PESA', style: txt(11, FontWeight.w700, Colors.white)),
              ),
              const SizedBox(width: 10),
              Text('Pay with M-Pesa', style: txt(16, FontWeight.w600, AppColors.ink)),
            ],
          ),
          Text('Phone number', style: txt(13, FontWeight.w600, AppColors.ink)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: cardBox(color: AppColors.bg, radius: 12),
            child: Row(
              children: [
                Text('+254', style: txt(15, FontWeight.w600, AppColors.ink)),
                const SizedBox(width: 10),
                Container(width: 1, height: 18, color: AppColors.line),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: '712 345 678',
                    keyboardType: TextInputType.phone,
                    style: txt(15, FontWeight.w400, AppColors.ink),
                    decoration: const InputDecoration(isCollapsed: true, border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "You'll get an M-Pesa prompt on this number. Enter your PIN to confirm.",
            style: txt(13, FontWeight.w400, AppColors.mute, lineHeight: 19),
          ),
        ], 12),
      ),
    );
  }

  Widget _escrowCard() {
    const steps = [
      'You pay now and the money is held safely',
      'James completes the job',
      'You confirm and we release the payment',
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.priSoft, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: gapped([
          Text('How escrow works', style: txt(14, FontWeight.w600, AppColors.priDark)),
          for (var i = 0; i < steps.length; i++)
            Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(color: AppColors.pri, shape: BoxShape.circle),
                  child: Text('${i + 1}', style: txt(12, FontWeight.w700, Colors.white)),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(steps[i], style: txt(13, FontWeight.w400, AppColors.priDark))),
              ],
            ),
        ], 10),
      ),
    );
  }
}
