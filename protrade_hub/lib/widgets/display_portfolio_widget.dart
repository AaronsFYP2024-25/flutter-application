import 'package:flutter/material.dart';

class DisplayPortfolioWidget extends StatelessWidget {
  final List<Map<String, dynamic>> portfolio;

  const DisplayPortfolioWidget({required this.portfolio, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Portfolio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        portfolio.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No portfolio items available.'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: portfolio.length,
                itemBuilder: (context, index) {
                  final item = portfolio[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['description']!,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: (item['images'] as List).length,
                              itemBuilder: (context, imageIndex) {
                                final imageUrl = item['images'][imageIndex];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Image.network(
                                    imageUrl,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }
}
