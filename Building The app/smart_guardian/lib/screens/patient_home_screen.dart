import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/health_card.dart';
import 'help_screen.dart';
import 'login_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Help',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HelpScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () => _confirmLogout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Your vitals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            // TODO (Week 3): replace with real data from your FastAPI /latest endpoint
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: const [
                HealthCard(label: 'Heart Rate', value: '82 BPM', icon: Icons.favorite, color: Colors.red),
                HealthCard(label: 'SpO₂', value: '97%', icon: Icons.air, color: Colors.blue),
                HealthCard(label: 'Temperature', value: '36.7°C', icon: Icons.thermostat, color: Colors.orange),
                HealthCard(label: 'Device', value: 'Connected', icon: Icons.watch, color: Colors.green),
              ],
            ),
            const SizedBox(height: 28),

            Text('Emergency', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => _confirmSOS(context),
              icon: const Icon(Icons.warning_amber_rounded),
              label: const Text('SOS — I need help'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: use url_launcher, e.g.
                // launchUrl(Uri(scheme: 'tel', path: doctorPhoneNumber));
              },
              icon: const Icon(Icons.medical_services_outlined),
              label: const Text('Call Family Doctor'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSOS(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Send SOS?'),
        content: const Text(
          'This will alert your guardians and share your current location immediately.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              // TODO: call your backend's POST /emergency endpoint here.
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('SOS sent to your guardians')));
            },
            child: const Text('Send SOS'),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to continue.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}