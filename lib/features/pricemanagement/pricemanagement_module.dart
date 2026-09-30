import 'package:flutter/material.dart';

class PriceManagement extends StatefulWidget {
  const PriceManagement({super.key});

  @override
  State<PriceManagement> createState() => _PriceManagementState();
}

class _PriceManagementState extends State<PriceManagement> {
  // ------------------------------------------------------------
  // COLORS
  // ------------------------------------------------------------

  final Color primaryColor = const Color(0xFFFF6B4A);
  final Color primaryLight = const Color(0xFFFFEEE9);
  final Color backgroundColor = const Color(0xFFF7F8FA);
  final Color textColor = const Color(0xFF202124);
  final Color secondaryText = const Color(0xFF777777);

  // ------------------------------------------------------------
  // SERVICES
  // ------------------------------------------------------------

  final List<String> services = [
    'All',
    'Ironing',
    'Dry Cleaning',
    'Raffu',
    'Dying',
  ];

  String selectedService = 'All';
  String searchText = '';

  // ------------------------------------------------------------
  // PRICE DATA
  // ------------------------------------------------------------

  List<PriceItem> priceItems = [
    PriceItem(
      id: '1',
      clothingItem: 'Shirt',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '2',
      clothingItem: 'Shirt',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '3',
      clothingItem: 'Shirt',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '4',
      clothingItem: 'Shirt',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '5',
      clothingItem: 'Formal Pant',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '6',
      clothingItem: 'Formal Pant',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '7',
      clothingItem: 'Formal Pant',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '8',
      clothingItem: 'Formal Pant',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '9',
      clothingItem: 'Jeans',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '10',
      clothingItem: 'Jeans',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '11',
      clothingItem: 'Jeans',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '12',
      clothingItem: 'Jeans',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '13',
      clothingItem: 'T-Shirt',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '14',
      clothingItem: 'T-Shirt',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '15',
      clothingItem: 'T-Shirt',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '16',
      clothingItem: 'T-Shirt',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '17',
      clothingItem: 'Kurti',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '18',
      clothingItem: 'Kurti',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '19',
      clothingItem: 'Kurti',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '20',
      clothingItem: 'Kurti',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '21',
      clothingItem: 'Pajama',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '22',
      clothingItem: 'Pajama',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '23',
      clothingItem: 'Pajama',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '24',
      clothingItem: 'Pajama',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '25',
      clothingItem: 'Suit',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '26',
      clothingItem: 'Suit',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '27',
      clothingItem: 'Suit',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '28',
      clothingItem: 'Suit',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '29',
      clothingItem: 'Saree',
      service: 'Ironing',
      price: 30,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '30',
      clothingItem: 'Saree',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '31',
      clothingItem: 'Saree',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '32',
      clothingItem: 'Saree',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '33',
      clothingItem: 'Blouse',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '34',
      clothingItem: 'Blouse',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '35',
      clothingItem: 'Blouse',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '36',
      clothingItem: 'Blouse',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '37',
      clothingItem: 'Saree & Blouse',
      service: 'Ironing',
      price: 40,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '38',
      clothingItem: 'Saree & Blouse',
      service: 'Dry Cleaning',
      price: 120,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '39',
      clothingItem: 'Saree & Blouse',
      service: 'Raffu',
      price: 180,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '40',
      clothingItem: 'Saree & Blouse',
      service: 'Dying',
      price: 200,
      unit: 'Per Item',
      isActive: true,
    ),

    PriceItem(
      id: '41',
      clothingItem: 'Kurta',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '42',
      clothingItem: 'Kurta',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '43',
      clothingItem: 'Kurta',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '44',
      clothingItem: 'Kurta',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '45',
      clothingItem: 'Dupatta',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '46',
      clothingItem: 'Dupatta',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '47',
      clothingItem: 'Dupatta',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '48',
      clothingItem: 'Dupatta',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '49',
      clothingItem: 'Trousers',
      service: 'Ironing',
      price: 20,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '50',
      clothingItem: 'Trousers',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '51',
      clothingItem: 'Trousers',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '52',
      clothingItem: 'Trousers',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '53',
      clothingItem: 'School Uniform',
      service: 'Ironing',
      price: 20,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '54',
      clothingItem: 'School Uniform',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '55',
      clothingItem: 'School Uniform',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '56',
      clothingItem: 'School Uniform',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '57',
      clothingItem: 'Bedsheets',
      service: 'Ironing',
      price: 30,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '58',
      clothingItem: 'Bedsheets',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '59',
      clothingItem: 'Bedsheets',
      service: 'Raffu',
      price: 180,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '60',
      clothingItem: 'Bedsheets',
      service: 'Dying',
      price: 200,
      unit: 'Per Item',
      isActive: true,
    ),

    PriceItem(
      id: '61',
      clothingItem: 'Pillow Cover',
      service: 'Ironing',
      price: 9,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '62',
      clothingItem: 'Pillow Cover',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '63',
      clothingItem: 'Pillow Cover',
      service: 'Raffu',
      price: 180,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '64',
      clothingItem: 'Pillow Cover',
      service: 'Dying',
      price: 200,
      unit: 'Per Item',
      isActive: true,
    ),

    PriceItem(
      id: '65',
      clothingItem: 'Dhoti',
      service: 'Ironing',
      price: 30,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '66',
      clothingItem: 'Dhoti',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '67',
      clothingItem: 'Dhoti',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '68',
      clothingItem: 'Dhoti',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '69',
      clothingItem: 'Shorts',
      service: 'Ironing',
      price: 9,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '70',
      clothingItem: 'Shorts',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '71',
      clothingItem: 'Shorts',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '72',
      clothingItem: 'Shorts',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '73',
      clothingItem: 'Table Cloths',
      service: 'Ironing',
      price: 9,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '74',
      clothingItem: 'Table Cloths',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '75',
      clothingItem: 'Table Cloths',
      service: 'Raffu',
      price: 180,
      unit: 'Per Item',
      isActive: true,
    ),
    PriceItem(
      id: '76',
      clothingItem: 'Table Cloths',
      service: 'Dying',
      price: 200,
      unit: 'Per Item',
      isActive: true,
    ),

    PriceItem(
      id: '77',
      clothingItem: 'Blazer',
      service: 'Ironing',
      price: 35,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '78',
      clothingItem: 'Blazer',
      service: 'Dry Cleaning',
      price: 60,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '79',
      clothingItem: 'Blazer',
      service: 'Raffu',
      price: 180,
      unit: 'Per Cloth',
      isActive: true,
    ),
    PriceItem(
      id: '80',
      clothingItem: 'Blazer',
      service: 'Dying',
      price: 200,
      unit: 'Per Cloth',
      isActive: true,
    ),

    PriceItem(
      id: '81',
      clothingItem: 'Coat Pant Set',
      service: 'Ironing',
      price: 35,
      unit: 'Per Set',
      isActive: true,
    ),
    PriceItem(
      id: '82',
      clothingItem: 'Coat Pant Set',
      service: 'Dry Cleaning',
      price: 150,
      unit: 'Per Set',
      isActive: true,
    ),
    PriceItem(
      id: '83',
      clothingItem: 'Coat Pant Set',
      service: 'Raffu',
      price: 180,
      unit: 'Per Set',
      isActive: true,
    ),
    PriceItem(
      id: '84',
      clothingItem: 'Coat Pant Set',
      service: 'Dying',
      price: 200,
      unit: 'Per Set',
      isActive: true,
    ),
  ];

  // ------------------------------------------------------------
  // GET UNIQUE CLOTHING ITEMS
  // ------------------------------------------------------------

  List<String> get clothingItems {
    return priceItems
        .map((item) => item.clothingItem)
        .toSet()
        .toList();
  }

  // ------------------------------------------------------------
  // FILTERED DATA
  // ------------------------------------------------------------

  List<String> get filteredClothingItems {
    final query = searchText.toLowerCase().trim();

    return clothingItems.where((clothing) {
      final matchesSearch =
          clothing.toLowerCase().contains(query) ||
          priceItems.any(
            (item) =>
                item.clothingItem == clothing &&
                item.service.toLowerCase().contains(query),
          );

      if (selectedService == 'All') {
        return matchesSearch;
      }

      final matchesService = priceItems.any(
        (item) =>
            item.clothingItem == clothing &&
            item.service == selectedService,
      );

      return matchesSearch && matchesService;
    }).toList();
  }

  // ------------------------------------------------------------
  // PRICE LOOKUP
  // ------------------------------------------------------------

  PriceItem? getPrice(
    String clothing,
    String service,
  ) {
    for (final item in priceItems) {
      if (item.clothingItem == clothing &&
          item.service == service) {
        return item;
      }
    }

    return null;
  }

  // ------------------------------------------------------------
  // FORMAT PRICE
  // ------------------------------------------------------------

  String formatPrice(double price) {
    return '₹${price.toStringAsFixed(0)}';
  }

  // ------------------------------------------------------------
  // SERVICE ICON
  // ------------------------------------------------------------

  IconData serviceIcon(String service) {
    switch (service) {
      case 'Ironing':
        return Icons.iron_outlined;
      case 'Dry Cleaning':
        return Icons.local_laundry_service_outlined;
      case 'Raffu':
        return Icons.content_cut_outlined;
      case 'Dying':
        return Icons.color_lens_outlined;
      default:
        return Icons.apps_outlined;
    }
  }

  // ------------------------------------------------------------
  // SERVICE COLOR
  // ------------------------------------------------------------

  Color serviceColor(String service) {
    switch (service) {
      case 'Ironing':
        return const Color(0xFFFF6B4A);
      case 'Dry Cleaning':
        return const Color(0xFF4D8DFF);
      case 'Raffu':
        return const Color(0xFF9B59B6);
      case 'Dying':
        return const Color(0xFF20A779);
      default:
        return primaryColor;
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        title: const Text(
          'Price Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              onPressed: () {
                _showAddPriceDialog();
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.add,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                30,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderCard(),

                  const SizedBox(height: 18),

                  _buildSearchBar(),

                  const SizedBox(height: 14),

                  _buildServiceFilters(),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Text(
                        selectedService == 'All'
                            ? 'All Prices'
                            : '$selectedService Prices',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${filteredClothingItems.length} items',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (filteredClothingItems.isEmpty)
                    _buildEmptyState()
                  else
                    ...filteredClothingItems.map(
                      (clothing) {
                        return _buildClothingCard(clothing);
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPriceDialog,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Price',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER CARD
  // ------------------------------------------------------------

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            const Color(0xFFFF8A72),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.price_change_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Price Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Manage your laundry service prices',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SEARCH BAR
  // ------------------------------------------------------------

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
      decoration: InputDecoration(
        hintText: 'Search clothes or service...',
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 13,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: primaryColor,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.4),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // SERVICE FILTERS
  // ------------------------------------------------------------

  Widget _buildServiceFilters() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },
        itemBuilder: (context, index) {
          final service = services[index];
          final selected = selectedService == service;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedService = service;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? primaryColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: selected
                      ? primaryColor
                      : Colors.grey.shade200,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (service != 'All') ...[
                    Icon(
                      serviceIcon(service),
                      size: 16,
                      color: selected
                          ? Colors.white
                          : serviceColor(service),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    service,
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // CLOTHING CARD
  // ------------------------------------------------------------

  Widget _buildClothingCard(String clothing) {
    final List<String> displayedServices;

    if (selectedService == 'All') {
      displayedServices = services
          .where((service) => service != 'All')
          .toList();
    } else {
      displayedServices = [selectedService];
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  color: primaryLight,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.checkroom_outlined,
                  color: primaryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  clothing,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey.shade500,
                ),
                onSelected: (value) {
                  if (value == 'edit') {
                    _showEditClothingDialog(clothing);
                  } else if (value == 'delete') {
                    _deleteClothing(clothing);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          Divider(
            height: 1,
            color: Colors.grey.shade100,
          ),

          const SizedBox(height: 13),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: displayedServices.map(
              (service) {
                final item = getPrice(
                  clothing,
                  service,
                );

                if (item == null) {
                  return const SizedBox();
                }

                return _buildPriceChip(item);
              },
            ).toList(),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PRICE CHIP
  // ------------------------------------------------------------

  Widget _buildPriceChip(PriceItem item) {
    final color = serviceColor(item.service);

    return Container(
      width: 150,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Row(
        children: [
          Icon(
            serviceIcon(item.service),
            color: color,
            size: 17,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.service,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 9,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formatPrice(item.price),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              _showEditPriceDialog(item);
            },
            child: Icon(
              Icons.edit_outlined,
              color: color,
              size: 15,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(
            Icons.price_change_outlined,
            size: 55,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 15),
          Text(
            'No prices available',
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No matching clothing or service was found.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddPriceDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add Price'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ADD PRICE DIALOG
  // ------------------------------------------------------------

  void _showAddPriceDialog() {
    final clothingController = TextEditingController();
    final priceController = TextEditingController();

    String selectedDialogService = 'Ironing';
    String selectedUnit = 'Per Cloth';
    bool active = true;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                'Add New Price',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _dialogTextField(
                      controller: clothingController,
                      label: 'Clothing Item',
                      hint: 'Example: Shirt',
                      icon: Icons.checkroom_outlined,
                    ),

                    const SizedBox(height: 14),

                    _dialogDropdown(
                      label: 'Service',
                      value: selectedDialogService,
                      items: services
                          .where((e) => e != 'All')
                          .toList(),
                      onChanged: (value) {
                        setDialogState(() {
                          selectedDialogService = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    _dialogTextField(
                      controller: priceController,
                      label: 'Price',
                      hint: 'Enter price',
                      icon: Icons.currency_rupee,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),

                    const SizedBox(height: 14),

                    _dialogDropdown(
                      label: 'Unit',
                      value: selectedUnit,
                      items: const [
                        'Per Cloth',
                        'Per Item',
                        'Per Set',
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedUnit = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 5),

                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Active',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      value: active,
                      activeColor: primaryColor,
                      onChanged: (value) {
                        setDialogState(() {
                          active = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final clothing =
                        clothingController.text.trim();

                    final price =
                        double.tryParse(
                      priceController.text.trim(),
                    );

                    if (clothing.isEmpty) {
                      _showMessage(
                        'Please enter clothing item.',
                      );
                      return;
                    }

                    if (price == null || price < 0) {
                      _showMessage(
                        'Please enter a valid price.',
                      );
                      return;
                    }

                    setState(() {
                      priceItems.add(
                        PriceItem(
                          id: DateTime.now()
                              .millisecondsSinceEpoch
                              .toString(),
                          clothingItem: clothing,
                          service: selectedDialogService,
                          price: price,
                          unit: selectedUnit,
                          isActive: active,
                        ),
                      );
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      'Price added successfully.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // EDIT PRICE DIALOG
  // ------------------------------------------------------------

  void _showEditPriceDialog(PriceItem item) {
    final priceController = TextEditingController(
      text: item.price.toStringAsFixed(0),
    );

    bool active = item.isActive;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Edit ${item.clothingItem}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          serviceIcon(item.service),
                          color: primaryColor,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.service,
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  _dialogTextField(
                    controller: priceController,
                    label: 'Price',
                    hint: 'Enter price',
                    icon: Icons.currency_rupee,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),

                  const SizedBox(height: 8),

                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    value: active,
                    activeColor: primaryColor,
                    onChanged: (value) {
                      setDialogState(() {
                        active = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final price = double.tryParse(
                      priceController.text.trim(),
                    );

                    if (price == null || price < 0) {
                      _showMessage(
                        'Please enter a valid price.',
                      );
                      return;
                    }

                    setState(() {
                      item.price = price;
                      item.isActive = active;
                    });

                    Navigator.pop(dialogContext);

                    _showMessage(
                      'Price updated successfully.',
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ------------------------------------------------------------
  // EDIT ALL PRICES FOR A CLOTHING ITEM
  // ------------------------------------------------------------

  void _showEditClothingDialog(String clothing) {
    final items = priceItems
        .where((item) => item.clothingItem == clothing)
        .toList();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            clothing,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: items.map(
                  (item) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor:
                            serviceColor(item.service)
                                .withOpacity(0.1),
                        child: Icon(
                          serviceIcon(item.service),
                          color: serviceColor(item.service),
                          size: 18,
                        ),
                      ),
                      title: Text(item.service),
                      subtitle: Text(
                        '${formatPrice(item.price)} / ${item.unit}',
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit_outlined,
                          color: primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          _showEditPriceDialog(item);
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DELETE CLOTHING
  // ------------------------------------------------------------

  void _deleteClothing(String clothing) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Delete Price',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete all prices for "$clothing"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  priceItems.removeWhere(
                    (item) =>
                        item.clothingItem == clothing,
                  );
                });

                Navigator.pop(dialogContext);

                _showMessage(
                  '$clothing prices deleted.',
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DIALOG TEXT FIELD
  // ------------------------------------------------------------

  Widget _dialogTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: primaryColor,
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // DIALOG DROPDOWN
  // ------------------------------------------------------------

  Widget _dialogDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      items: items.map(
        (item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        },
      ).toList(),
      onChanged: onChanged,
    );
  }

  // ------------------------------------------------------------
  // MESSAGE
  // ------------------------------------------------------------

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

// ============================================================
// PRICE MODEL
// ============================================================

class PriceItem {
  String id;
  String clothingItem;
  String service;
  double price;
  String unit;
  bool isActive;

  PriceItem({
    required this.id,
    required this.clothingItem,
    required this.service,
    required this.price,
    required this.unit,
    required this.isActive,
  });
}