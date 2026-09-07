import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/health_card.dart';
import 'help_screen.dart';
import 'login_screen.dart';

/// Vitals for a single patient. In production, an instance of this
/// would come from your backend (e.g. GET /latest?patient_id=...).
class _PatientVitals {
  final String heartRate;
  final String spo2;
  final String temperature;
  final String deviceStatus;
  final bool hasActiveAlert;

  const _PatientVitals({
    required this.heartRate,
    required this.spo2,
    required this.temperature,
    required this.deviceStatus,
    this.hasActiveAlert = false,
  });
}

class GuardianHomeScreen extends StatefulWidget {
  const GuardianHomeScreen({super.key});

  @override
  State<GuardianHomeScreen> createState() => _GuardianHomeScreenState();
}

class _GuardianHomeScreenState extends State<GuardianHomeScreen> {
  // TODO: replace with the real list of patients linked to this guardian,
  // fetched from your backend once a guardian-patient linking endpoint exists
  // (e.g. GET /guardian/{id}/patients). Each entry's vitals would then come
  // from GET /latest?patient_id=... instead of being hardcoded here.
  final Map<String, _PatientVitals> _patientVitals = const {
    'Grandma Asha': _PatientVitals(
      heartRate: '78 BPM',
      spo2: '98%',
      temperature: '36.7°C',
      deviceStatus: 'Connected',
    ),
    'Uncle Rohan': _PatientVitals(
      heartRate: '91 BPM',
      spo2: '95%',
      temperature: '37.4°C',
      deviceStatus: 'Connected',
      hasActiveAlert: true,
    ),
  };

  late String _selectedPatient = _patientVitals.keys.first;

  @override
  Widget build(BuildContext context) {
    final vitals = _patientVitals[_selectedPatient]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guardian Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Switch patient',
            onPressed: () => _showSwitchPatientSheet(context),
          ),
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
            // --- Patient switcher chip row, also tappable ---
            InkWell(
              onTap: () => _showSwitchPatientSheet(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Monitoring: $_selectedPatient',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Icon(Icons.unfold_more, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // --- Emergency status banner, reacts to the selected patient ---
            Card(
              color: vitals.hasActiveAlert
                  ? Colors.red.withOpacity(0.08)
                  : Colors.green.withOpacity(0.08),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      vitals.hasActiveAlert ? Icons.warning_amber_rounded : Icons.check_circle,
                      color: vitals.hasActiveAlert ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        vitals.hasActiveAlert
                            ? '$_selectedPatient has an abnormal reading — check vitals below.'
                            : '$_selectedPatient is stable. No active emergencies.',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text('Patient vitals', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                HealthCard(label: 'Heart Rate', value: vitals.heartRate, icon: Icons.favorite, color: Colors.red),
                HealthCard(label: 'SpO₂', value: vitals.spo2, icon: Icons.air, color: Colors.blue),
                HealthCard(label: 'Temperature', value: vitals.temperature, icon: Icons.thermostat, color: Colors.orange),
                HealthCard(label: 'Device', value: vitals.deviceStatus, icon: Icons.watch, color: Colors.green),
              ],
            ),
            const SizedBox(height: 28),

            Text('Actions', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: open a map screen (google_maps_flutter) using
                // coordinates from /patient-location for _selectedPatient
              },
              icon: const Icon(Icons.location_on_outlined),
              label: Text('View $_selectedPatient\'s Location'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: open a history/chart screen (fl_chart) using
                // /history for _selectedPatient
              },
              icon: const Icon(Icons.history),
              label: Text('View $_selectedPatient\'s History'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: launch a call with url_launcher, using
                // _selectedPatient's stored phone number
              },
              icon: const Icon(Icons.phone_outlined),
              label: Text('Call $_selectedPatient'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSwitchPatientSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Switch patient', style: Theme.of(context).textTheme.titleMedium),
              ),
              ..._patientVitals.keys.map((name) {
                final isSelected = name == _selectedPatient;
                final hasAlert = _patientVitals[name]!.hasActiveAlert;
                return ListTile(
                  leading: Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    color: isSelected ? Theme.of(context).colorScheme.primary : null,
                  ),
                  title: Text(name),
                  trailing: hasAlert
                      ? const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20)
                      : null,
                  onTap: () {
                    setState(() => _selectedPatient = name);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
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