import 'package:flutter/material.dart';

class DisplayPortfolioWidget extends StatelessWidget {
  final List<String> portfolio;

  const DisplayPortfolioWidget({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Portfolio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        portfolio.isEmpty
            ? const Text("No portfolio images added.")
            : Column(
                children: portfolio
                    .map((imageUrl) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Image.network(imageUrl, height: 100, fit: BoxFit.cover),
                        ))
                    .toList(),
              ),
      ],
    );
  }
}
