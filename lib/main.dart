import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const BrewBeanApp());
}

const coffeeBrown = Color(0xFF6F4E37);
const coffeeDark = Color(0xFF2E211B);
const cream = Color(0xFFFAF6F0);
const coffeeGold = Color(0xFFD6A56C);
const coffeeLight = Color(0xFFECE0D3);

class Coffee {
  final String name;
  final String description;
  final String image;
  final double price;
  final double rating;
  final bool isCold;

  const Coffee({
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    this.rating = 4.8,
    this.isCold = false,
  });
}

const coffees = [
  Coffee(
    name: 'Caramel Latte',
    description: 'Espresso, steamed milk & caramel',
    image: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=700',
    price: 180,
    rating: 4.9,
  ),
  Coffee(
    name: 'Cappuccino',
    description: 'Rich espresso with silky foam',
    image: 'https://images.unsplash.com/photo-1572442388796-11668a67e53d?w=700',
    price: 150,
  ),
  Coffee(
    name: 'Iced Americano',
    description: 'Bold, chilled and refreshing',
    image: 'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=700',
    price: 130,
    isCold: true,
  ),
  Coffee(
    name: 'Mocha Delight',
    description: 'Chocolate meets espresso',
    image: 'https://images.unsplash.com/photo-1578314675249-a6910f80cc4e?w=700',
    price: 200,
  ),
  Coffee(
    name: 'Cold Brew',
    description: 'Slow brewed, smooth and mellow',
    image: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=700',
    price: 170,
    isCold: true,
  ),
  Coffee(
    name: 'Flat White',
    description: 'Velvety milk and double espresso',
    image: 'https://images.unsplash.com/photo-1442512595331-e89e73853f31?w=700',
    price: 160,
  ),
];

class BrewBeanApp extends StatelessWidget {
  const BrewBeanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brew & Bean',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(
          seedColor: coffeeBrown,
          primary: coffeeBrown,
          surface: cream,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: cream,
          foregroundColor: coffeeDark,
          elevation: 0,
        ),
      ),
      home: const CoffeeShopHome(),
    );
  }
}

class CoffeeShopHome extends StatefulWidget {
  const CoffeeShopHome({super.key});

  @override
  State<CoffeeShopHome> createState() => _CoffeeShopHomeState();
}

class _CoffeeShopHomeState extends State<CoffeeShopHome> {
  int selectedTab = 0;
  String search = '';
  String category = 'All';

  final Map<String, int> cart = {};
  final Set<String> favorites = {};

  int get cartCount =>
      cart.values.fold(0, (total, quantity) => total + quantity);

  double get subtotal {
    double total = 0;
    for (final coffee in coffees) {
      total += coffee.price * (cart[coffee.name] ?? 0);
    }
    return total;
  }

  double get total => subtotal + (cartCount > 0 ? 30 : 0);

  void addToCart(Coffee coffee) {
    setState(() {
      cart[coffee.name] = (cart[coffee.name] ?? 0) + 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${coffee.name} added to your bag'),
        backgroundColor: coffeeBrown,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void updateQuantity(Coffee coffee, int change) {
    setState(() {
      final quantity = (cart[coffee.name] ?? 0) + change;
      if (quantity <= 0) {
        cart.remove(coffee.name);
      } else {
        cart[coffee.name] = quantity;
      }
    });
  }

  void toggleFavorite(Coffee coffee) {
    setState(() {
      if (!favorites.add(coffee.name)) {
        favorites.remove(coffee.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      buildHome(),
      buildMenu(),
      buildFavorites(),
      buildCart(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[selectedTab]),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: coffeeLight,
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.coffee_outlined),
            selectedIcon: Icon(Icons.coffee),
            label: 'Menu',
          ),
          const NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cartCount > 0,
              label: Text('$cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: const Icon(Icons.shopping_bag),
            label: 'Bag',
          ),
        ],
      ),
    );
  }

  Widget heading(String text, {double size = 27}) {
    return Text(
      text,
      style: GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: coffeeDark,
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: coffeeBrown,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.coffee_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BREW & BEAN',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: coffeeDark,
              ),
            ),
            Text(
              'YOUR DAILY COFFEE RITUAL',
              style: GoogleFonts.poppins(
                fontSize: 8,
                letterSpacing: 1.4,
                color: coffeeBrown,
              ),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => setState(() => selectedTab = 3),
          icon: const Icon(Icons.shopping_bag_outlined),
        ),
      ],
    );
  }

  Widget buildHome() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        buildHeader(),
        const SizedBox(height: 30),
        Text(
          'Good coffee,',
          style: GoogleFonts.playfairDisplay(
            fontSize: 35,
            color: coffeeDark,
          ),
        ),
        Text(
          'better days. ☕',
          style: GoogleFonts.playfairDisplay(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: coffeeBrown,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Find your favorite cup and enjoy the little things.',
          style: GoogleFonts.poppins(
            color: Colors.black54,
            fontSize: 12,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 24),
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1445116572660-236099ec97a0?w=1000',
                height: 235,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 235,
                  color: coffeeBrown,
                  child: const Icon(
                    Icons.coffee,
                    size: 65,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                height: 235,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SPECIALTY COFFEE',
                      style: GoogleFonts.poppins(
                        color: coffeeGold,
                        fontSize: 10,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'A little cup\nof happiness.',
                      style: GoogleFonts.playfairDisplay(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: coffeeGold,
                        foregroundColor: coffeeDark,
                      ),
                      onPressed: () => setState(() => selectedTab = 1),
                      child: const Text('Explore menu  →'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        sectionTitle('Our favorites', 'See all', () {
          setState(() => selectedTab = 1);
        }),
        const SizedBox(height: 14),
        SizedBox(
          height: 275,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: coffees.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (_, index) => SizedBox(
              width: 205,
              child: coffeeCard(coffees[index]),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: coffeeLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.local_cafe_rounded,
                color: coffeeBrown,
                size: 40,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heading('Made with love', size: 19),
                    const SizedBox(height: 5),
                    const Text('Freshly brewed, just for you.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(
    String title,
    String action,
    VoidCallback onTap,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        heading(title, size: 23),
        TextButton(
          onPressed: onTap,
          child: Text(action),
        ),
      ],
    );
  }

  Widget coffeeCard(Coffee coffee) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => showProduct(coffee),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  coffee.image,
                  width: double.infinity,
                  height: 145,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 145,
                    color: coffeeLight,
                    child: const Center(
                      child: Icon(Icons.coffee, size: 48),
                    ),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      iconSize: 19,
                      onPressed: () => toggleFavorite(coffee),
                      icon: Icon(
                        favorites.contains(coffee.name)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: coffeeBrown,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 3),
              child: Text(
                coffee.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: coffeeDark,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                coffee.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 9,
                  color: Colors.black54,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 5, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.star, size: 15, color: coffeeGold),
                  Text(
                    ' ${coffee.rating}',
                    style: const TextStyle(fontSize: 11),
                  ),
                  const Spacer(),
                  Text(
                    '₹${coffee.price.toInt()}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: coffeeBrown,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenu() {
    final filtered = coffees.where((coffee) {
      final matchesSearch =
          coffee.name.toLowerCase().contains(search.toLowerCase());

      final matchesCategory = category == 'All' ||
          (category == 'Cold' && coffee.isCold) ||
          (category == 'Hot' && !coffee.isCold);

      return matchesSearch && matchesCategory;
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        buildHeader(),
        const SizedBox(height: 25),
        heading('Coffee menu', size: 32),
        const SizedBox(height: 6),
        const Text('Find the perfect cup for your mood.'),
        const SizedBox(height: 20),
        TextField(
          onChanged: (value) => setState(() => search = value),
          decoration: InputDecoration(
            hintText: 'Search your coffee...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 10,
          children: ['All', 'Hot', 'Cold'].map((item) {
            return ChoiceChip(
              label: Text(item),
              selected: category == item,
              selectedColor: coffeeLight,
              onSelected: (_) => setState(() => category = item),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        if (filtered.isEmpty)
          const Padding(
            padding: EdgeInsets.all(30),
            child: Center(child: Text('No coffee found.')),
          )
        else
          ...filtered.map(
            (coffee) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 275,
                child: coffeeCard(coffee),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildFavorites() {
    final items =
        coffees.where((coffee) => favorites.contains(coffee.name)).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        buildHeader(),
        const SizedBox(height: 25),
        heading('Your favorites', size: 31),
        const SizedBox(height: 8),
        const Text('All the coffees you love, in one place.'),
        const SizedBox(height: 20),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Column(
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 65,
                  color: coffeeGold,
                ),
                SizedBox(height: 16),
                Text('No favorites yet'),
                SizedBox(height: 8),
                Text('Tap the heart on a coffee to save it.'),
              ],
            ),
          )
        else
          ...items.map(
            (coffee) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                height: 275,
                child: coffeeCard(coffee),
              ),
            ),
          ),
      ],
    );
  }

  Widget buildCart() {
    final items =
        coffees.where((coffee) => (cart[coffee.name] ?? 0) > 0).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        buildHeader(),
        const SizedBox(height: 25),
        heading('Your bag', size: 32),
        const SizedBox(height: 6),
        Text('$cartCount items selected'),
        const SizedBox(height: 22),
        if (items.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 55),
            child: Column(
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 70,
                  color: coffeeGold,
                ),
                SizedBox(height: 18),
                Text(
                  'Your bag is waiting.',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text('Add your favorite coffee to get started.'),
              ],
            ),
          )
        else
          ...items.map(
            (coffee) => Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      coffee.image,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        width: 75,
                        height: 75,
                        child: Icon(Icons.coffee),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coffee.name,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text('₹${coffee.price.toInt()}'),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => updateQuantity(coffee, -1),
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('${cart[coffee.name]}'),
                  IconButton(
                    onPressed: () => updateQuantity(coffee, 1),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
            ),
          ),
        if (items.isNotEmpty) ...[
          const Divider(height: 32),
          priceRow('Subtotal', subtotal),
          const SizedBox(height: 12),
          priceRow('Delivery', 30),
          const Divider(height: 32),
          priceRow('Total', total, bold: true),
          const SizedBox(height: 24),
          SizedBox(
            height: 54,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: coffeeBrown,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: showCheckout,
              child: const Text('Proceed to checkout  →'),
            ),
          ),
        ],
      ],
    );
  }

  Widget priceRow(
    String label,
    double amount, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? 17 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: TextStyle(
            fontSize: bold ? 19 : 14,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: bold ? coffeeBrown : coffeeDark,
          ),
        ),
      ],
    );
  }

  void showProduct(Coffee coffee) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 42,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.network(
                    coffee.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: coffeeLight,
                      child: const Icon(Icons.coffee, size: 60),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                heading(coffee.name, size: 29),
                const SizedBox(height: 8),
                Text(coffee.description),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.star, color: coffeeGold),
                    Text(' ${coffee.rating} · Freshly brewed'),
                    const Spacer(),
                    Text(
                      '₹${coffee.price.toInt()}',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: coffeeBrown,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: coffeeBrown,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      addToCart(coffee);
                    },
                    child: const Text('Add to bag  +'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showCheckout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: cream,
        icon: const Icon(
          Icons.coffee_rounded,
          color: coffeeBrown,
          size: 45,
        ),
        title: heading('Order preview', size: 24),
        content: Text(
          'Your total is ₹${total.toStringAsFixed(0)}.\n\n'
          'This is a UI demo. No payment will be collected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: coffeeBrown,
            ),
            onPressed: () {
              setState(() {
                cart.clear();
                selectedTab = 0;
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Demo order placed successfully!'),
                ),
              );
            },
            child: const Text('Place demo order'),
          ),
        ],
      ),
    );
  }
}
