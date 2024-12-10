import 'package:flutter/material.dart';

class ManagePortfolioWidget extends StatelessWidget {
  final List<Map<String, dynamic>> portfolio;
  final void Function(Map<String, dynamic>) onPortfolioAdded;
  final void Function(int) onPortfolioDeleted;

  const ManagePortfolioWidget({
    required this.portfolio,
    required this.onPortfolioAdded,
    required this.onPortfolioDeleted,
    Key? key,
  }) : super(key: key);

  void _addPortfolioItem(BuildContext context) {
    if (portfolio.length >= 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You can only have up to 6 portfolio items.')),
      );
      return;
    }

    final newPortfolioItem = {
      'title': 'New Portfolio Item',
      'description': 'Description of the new item.',
      'images': [
        'https://via.placeholder.com/150',
      ],
    };

    onPortfolioAdded(newPortfolioItem);
    Navigator.pop(context); // Return to the previous screen after adding
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Portfolio')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: portfolio.length,
              itemBuilder: (context, index) {
                final item = portfolio[index];
                return ListTile(
                  key: Key('portfolio_item_$index'),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onPortfolioDeleted(index),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final newPortfolioItem = {
                'title': 'New Portfolio Item',
                'description': 'Description of the new item.',
                'images': ['https://via.placeholder.com/150'],
              };
              onPortfolioAdded(newPortfolioItem); // Add the portfolio item
              // Ensure there's no Navigator.pop(context) here unless explicitly intended
            },
            child: const Text('Add Portfolio Item'),
          ),
        ],
      ),
    );
  }
}
