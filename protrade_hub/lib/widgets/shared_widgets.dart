import 'package:flutter/material.dart';

/// ================= LOGOUT BUTTON =================
class LogoutButton extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButton({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onLogout,
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

/// ================= DISPLAY SPECIALIZATIONS WIDGET =================
class DisplaySpecializationsWidget extends StatelessWidget {
  final List<String> specializations;

  const DisplaySpecializationsWidget({super.key, required this.specializations});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Specializations:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...specializations.map((spec) => Text('- $spec')).toList(),
      ],
    );
  }
}

/// ================= DISPLAY AVAILABILITY WIDGET =================
class DisplayAvailabilityWidget extends StatelessWidget {
  final List<String> availability;

  const DisplayAvailabilityWidget({super.key, required this.availability});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Availability:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...availability.map((avail) => Text('- $avail')).toList(),
      ],
    );
  }
}

/// ================= DISPLAY PORTFOLIO WIDGET =================
class DisplayPortfolioWidget extends StatelessWidget {
  final List<String> portfolio;

  const DisplayPortfolioWidget({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Portfolio:', style: TextStyle(fontWeight: FontWeight.bold)),
        ...portfolio.map((item) => Text('- $item')).toList(),
      ],
    );
  }
}
