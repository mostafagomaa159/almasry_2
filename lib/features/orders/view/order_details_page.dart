part of '../orders_imports.dart';

class OrderDetailsPage extends StatelessWidget {
  final OrderDetailsArgs args;

  const OrderDetailsPage({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${args.incrementId}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionCard(
            title: 'Order Summary',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Status: Processing'),
                SizedBox(height: 8),
                Text('Date: 2026-06-03'),
                SizedBox(height: 8),
                Text('Payment Method: Cash on Delivery'),
                SizedBox(height: 8),
                Text('Grand Total: 350 EGP'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Shipping Address',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Ahmed Ali'),
                SizedBox(height: 8),
                Text('01000000000'),
                SizedBox(height: 8),
                Text('Nasr City, Cairo, Egypt'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionCard(
            title: 'Items',
            child: Column(
              children: const [
                _OrderItemTile(),
                SizedBox(height: 12),
                _OrderItemTile(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _OrderItemTile extends StatelessWidget {
  const _OrderItemTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://via.placeholder.com/70',
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product Name',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6),
              Text('Qty: 2'),
              SizedBox(height: 6),
              Text('Price: 150 EGP'),
            ],
          ),
        ),
      ],
    );
  }
}
