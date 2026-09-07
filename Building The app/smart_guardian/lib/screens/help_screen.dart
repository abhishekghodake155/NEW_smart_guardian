import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & About')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('How to use Smart Guardian', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          const _HelpStep(number: '1', text: 'On the login screen, choose whether you are logging in as a Patient or a Guardian.'),
          const _HelpStep(number: '2', text: 'Enter your email and password, then tap Log in.'),
          const _HelpStep(number: '3', text: 'Patients see live vitals (heart rate, SpO₂, temperature) and can press SOS in an emergency.'),
          const _HelpStep(number: '4', text: "Guardians see the patient's vitals, location, and health history, and can call the patient or the family doctor directly."),
          const _HelpStep(number: '5', text: 'If a reading becomes abnormal, or SOS is pressed, guardians and the family doctor are notified automatically with the live location.'),
          const SizedBox(height: 28),

          Text('Why this app matters', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(
            "Smart Guardian continuously monitors a patient's vital signs and location so a guardian "
            "doesn't have to be physically present to know their loved one is safe. If something goes "
            "wrong — an abnormal reading or a manual SOS — the app automatically notifies guardians and "
            "the family doctor with the exact location, so help can reach the patient as quickly as possible.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text(
            'This matters most for elderly patients, people with chronic conditions, or anyone who '
            'lives alone and could face a medical emergency when no one else is around.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Note: Smart Guardian assists with health monitoring and emergency response — it does not diagnose medical conditions.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class _HelpStep extends StatelessWidget {
  final String number;
  final String text;
  const _HelpStep({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 14, child: Text(number, style: const TextStyle(fontSize: 13))),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}