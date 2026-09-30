// import 'package:flutter/material.dart';
// import 'dart:convert';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';

// class OwnerModule extends StatefulWidget {
//   final VoidCallback? onLogout;

//   const OwnerModule({super.key, this.onLogout});

//   @override
//   State<OwnerModule> createState() => _OwnerModuleState();
// }

// class _OwnerModuleState extends State<OwnerModule> {
//   // ============================================================
//   // CONSTANTS
//   // ============================================================

//   static const Color primary = Color(0xFFFF6B00);
//   static const Color lightOrange = Color(0xFFFFF3E0);
//   static const Color background = Color(0xFFF5F7FB);
//   static const Color darkText = Color(0xFF17213D);
//   static const Color grayText = Color(0xFF7B8494);

//   final FirebaseFirestore db = FirebaseFirestore.instance;

//   int selectedIndex = 0;

//   String searchText = '';

//   final TextEditingController searchController =
//       TextEditingController();

//   final List<String> menuItems = [
//     'Dashboard',
//     'Orders',
//     'Customers',
//     'Services & Prices',
//     'Deliveries',
//     'Payments',
//     'Bills',
//     'Notifications',
//     'Settings',
//     'Owner Details',
//   ];

//   final List<IconData> menuIcons = [
//     Icons.dashboard_outlined,
//     Icons.shopping_bag_outlined,
//     Icons.people_outline,
//     Icons.price_change_outlined,
//     Icons.local_shipping_outlined,
//     Icons.payment_outlined,
//     Icons.receipt_long_outlined,
//     Icons.notifications_none,
//     Icons.settings_outlined,
//     Icons.person_outline,
//   ];

//   final ImagePicker _imagePicker = ImagePicker();

//   final ownerNameController = TextEditingController();
//   final ownerAddressController = TextEditingController();
//   final ownerPhoneController = TextEditingController();
//   final ownerEmailController = TextEditingController();
//   final businessNameController = TextEditingController();
//   final businessAddressController = TextEditingController();
//   final businessPhoneController = TextEditingController();
//   final businessEmailController = TextEditingController();
//   final websiteController = TextEditingController();
//   final workingHoursController = TextEditingController();

//   String? ownerProfileImageBase64;
//   bool ownerDetailsLoading = false;
//   bool ownerDetailsSaving = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadOwnerDetails();
//   }

//   // ============================================================
//   // DISPOSE
//   // ============================================================

//   @override
//   void dispose() {
//     searchController.dispose();
//     ownerNameController.dispose();
//     ownerAddressController.dispose();
//     ownerPhoneController.dispose();
//     ownerEmailController.dispose();
//     businessNameController.dispose();
//     businessAddressController.dispose();
//     businessPhoneController.dispose();
//     businessEmailController.dispose();
//     websiteController.dispose();
//     workingHoursController.dispose();
//     super.dispose();
//   }

//   // ============================================================
//   // BUILD
//   // ============================================================

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final bool mobile = width < 850;

//     return Scaffold(
//       backgroundColor: background,
//       drawer: mobile ? _buildMobileDrawer() : null,
//       body: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/owner_dashboard_bg.jpeg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: Container(
//           color: Colors.white.withOpacity(.72),
//           child: Row(
//             children: [
//               if (!mobile) _buildSidebar(),
//               Expanded(
//                 child: Column(
//                   children: [
//                     _buildTopBar(mobile),
//                     Expanded(
//                       child: _buildPage(),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // SIDEBAR
//   // ============================================================

//   Widget _buildSidebar() {
//     return Container(
//       width: 240,
//       color: Colors.white.withOpacity(.82),
//       child: Column(
//         children: [
//           const SizedBox(height: 25),

//           _buildLogo(),

//           const SizedBox(height: 35),

//           Expanded(
//             child: ListView.builder(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 12),
//               itemCount: menuItems.length,
//               itemBuilder: (context, index) {
//                 return _buildMenuItem(index);
//               },
//             ),
//           ),

//           _buildOwnerBottomProfile(),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // MOBILE DRAWER
//   // ============================================================

//   Widget _buildMobileDrawer() {
//     return Drawer(
//       backgroundColor: Colors.white.withOpacity(.94),
//       child: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),

//             _buildLogo(),

//             const SizedBox(height: 25),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: menuItems.length,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 10),
//                 itemBuilder: (context, index) {
//                   return _buildMenuItem(index, closeDrawer: true);
//                 },
//               ),
//             ),

//             _buildOwnerBottomProfile(),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // LOGO
//   // ============================================================

//   Widget _buildLogo() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(13),
//             child: Image.asset(
//               'assets/images/washeasy_logo.png',
//               width: 44,
//               height: 44,
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 return Container(
//                   width: 44,
//                   height: 44,
//                   decoration: BoxDecoration(
//                     color: primary,
//                     borderRadius: BorderRadius.circular(13),
//                   ),
//                   child: const Icon(
//                     Icons.local_laundry_service,
//                     color: Colors.white,
//                     size: 25,
//                   ),
//                 );
//               },
//             ),
//           ),

//           const SizedBox(width: 10),

//           RichText(
//             text: TextSpan(
//               style: TextStyle(
//                 fontSize: 21,
//                 fontWeight: FontWeight.bold,
//               ),
//               children: [
//                 TextSpan(
//                   text: 'Wash',
//                   style: TextStyle(color: Color(0xFF1565C0)),
//                 ),
//                 TextSpan(
//                   text: 'Easy',
//                   style: TextStyle(color: primary),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // MENU ITEM
//   // ============================================================

//   Widget _buildMenuItem(
//     int index, {
//     bool closeDrawer = false,
//   }) {
//     final selected = selectedIndex == index;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 5),
//       child: ListTile(
//         onTap: () {
//           setState(() {
//             selectedIndex = index;
//             searchController.clear();
//             searchText = '';
//           });

//           if (closeDrawer) {
//             Navigator.pop(context);
//           }
//         },

//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(11),
//         ),

//         tileColor:
//             selected ? primary : Colors.transparent,

//         leading: Icon(
//           menuIcons[index],
//           color: selected
//               ? Colors.white
//               : const Color(0xFF687385),
//         ),

//         title: Text(
//           menuItems[index],
//           style: TextStyle(
//             color: selected
//                 ? Colors.white
//                 : const Color(0xFF424B57),
//             fontWeight:
//                 selected ? FontWeight.w700 : FontWeight.w500,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // OWNER BOTTOM PROFILE
//   // ============================================================

//   Widget _buildOwnerBottomProfile() {
//     return Container(
//       padding: const EdgeInsets.all(15),
//       decoration: const BoxDecoration(
//         border: Border(
//           top: BorderSide(
//             color: Color(0xFFE5E7EB),
//           ),
//         ),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(12),
//         onTap: _showOwnerProfile,
//         child: Padding(
//           padding: const EdgeInsets.all(5),
//           child: Row(
//             children: [
//               Container(
//                 width: 40,
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: lightOrange,
//                   shape: BoxShape.circle,
//                 ),
//                 child: ownerProfileImageBase64 != null && ownerProfileImageBase64!.isNotEmpty
//                     ? ClipOval(child: Image.memory(base64Decode(ownerProfileImageBase64!), fit: BoxFit.cover))
//                     : const Icon(Icons.person, color: primary),
//               ),

//               const SizedBox(width: 10),

//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Owner',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const Icon(
//                 Icons.more_vert,
//                 color: Colors.grey,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // TOP BAR
//   // ============================================================

//   Widget _buildTopBar(bool mobile) {
//     return Container(
//       height: 76,
//       padding: EdgeInsets.symmetric(
//         horizontal: mobile ? 15 : 30,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(.84),
//         border: const Border(
//           bottom: BorderSide(
//             color: Color(0xFFE5E7EB),
//           ),
//         ),
//       ),
//       child: Row(
//         children: [
//           if (mobile)
//             Builder(
//               builder: (context) {
//                 return IconButton(
//                   icon: const Icon(Icons.menu),
//                   onPressed: () {
//                     Scaffold.of(context).openDrawer();
//                   },
//                 );
//               },
//             ),

//           Expanded(
//             child: Text(
//               menuItems[selectedIndex],
//               style: TextStyle(
//                 fontSize: mobile ? 19 : 22,
//                 fontWeight: FontWeight.bold,
//                 color: darkText,
//               ),
//             ),
//           ),

//           if (!mobile)
//             SizedBox(
//               width: 280,
//               height: 43,
//               child: TextField(
//                 controller: searchController,
//                 onChanged: (value) {
//                   setState(() {
//                     searchText = value.trim().toLowerCase();
//                   });
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Search...',
//                   prefixIcon:
//                       const Icon(Icons.search),
//                   filled: true,
//                   fillColor: background,
//                   border: OutlineInputBorder(
//                     borderRadius:
//                         BorderRadius.circular(11),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//             ),

//           const SizedBox(width: 12),

//           // NOTIFICATION
//           Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: const Color(0xFFE0E0E0),
//               ),
//               borderRadius: BorderRadius.circular(11),
//             ),
//             child: IconButton(
//               tooltip: 'Notifications',
//               icon: const Icon(
//                 Icons.notifications_none,
//               ),
//               onPressed: _showNotifications,
//             ),
//           ),

//           const SizedBox(width: 10),

//           // OWNER PROFILE
//           InkWell(
//             borderRadius: BorderRadius.circular(30),
//             onTap: _showOwnerProfile,
//             child: Row(
//               children: [
//                 Container(
//                   width: 42,
//                   height: 42,
//                   decoration: BoxDecoration(
//                     color: lightOrange,
//                     shape: BoxShape.circle,
//                   ),
//                   child: ownerProfileImageBase64 != null && ownerProfileImageBase64!.isNotEmpty
//                       ? ClipOval(child: Image.memory(base64Decode(ownerProfileImageBase64!), fit: BoxFit.cover))
//                       : const Icon(Icons.person_outline, color: primary),
//                 ),

//                 if (!mobile) ...[
//                   const SizedBox(width: 8),

//                   const Text(
//                     'Owner',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),

//                   const Icon(
//                     Icons.keyboard_arrow_down,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // MAIN PAGE
//   // ============================================================

//   Widget _buildPage() {
//     switch (selectedIndex) {
//       case 0:
//         return _buildDashboard();

//       case 1:
//         return _buildOrdersPage();

//       case 2:
//         return _buildCustomersPage();

//       case 3:
//         return _buildServicesPage();

//       case 4:
//         return _buildDeliveriesPage();

//       case 5:
//         return _buildPaymentsPage();

//       case 6:
//         return _buildBillsPage();

//       case 7:
//         return _buildNotificationsPage();

//       case 8:
//         return _buildSettingsPage();

//       case 9:
//         return _buildOwnerDetailsPage();

//       default:
//         return _buildDashboard();
//     }
//   }

//   // ============================================================
//   // DASHBOARD
//   // ============================================================

//   Widget _buildDashboard() {
//     return StreamBuilder<
//         QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('orders').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return _errorPage(
//             'Unable to load dashboard data.',
//           );
//         }

//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return _loading();
//         }

//         final orders = snapshot.data?.docs ?? [];

//         final newOrders = orders.where((doc) {
//           final status =
//               _string(doc.data()['status']);

//           final normalized = status.toLowerCase();
//           return normalized == 'new' || normalized == 'order received';
//         }).length;

//         final inProgress = orders.where((doc) {
//           final status =
//               _string(doc.data()['status']);

//           final normalized = status.toLowerCase();
//           return normalized == 'in progress' || normalized == 'ironing started' || normalized == 'processing' || normalized == 'iron started';
//         }).length;

//         final ready = orders.where((doc) {
//           final status =
//               _string(doc.data()['status']);

//           final normalized = status.toLowerCase();
//           return normalized == 'ready' || normalized == 'clothes ready';
//         }).length;

//         final pendingDeliveries =
//             orders.where((doc) {
//           final data = doc.data();
//           final status =
//               _string(data['status']);

//           final deliveryStatus = _string(data['deliveryStatus'], fallback: 'Delivery Pending').toLowerCase();
//           return deliveryStatus != 'delivery done' && status.toLowerCase() != 'customer collected' && status.toLowerCase() != 'completed';
//         }).length;

//         final todayDeliveries =
//             orders.where((doc) {
//           final date =
//               _date(doc.data()['pickupDate']);

//           return date != null &&
//               _isToday(date);
//         }).length;

//         final pendingPayments = orders.where((doc) {
//           return _string(doc.data()['paymentStatus'], fallback: 'Pending').toLowerCase() != 'paid';
//         }).toList();

//         final pendingPaymentCustomers = pendingPayments.length;

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               _pageHeader(
//                 'Owner Dashboard',
//                 'Manage your laundry business from one place.',
//                 Icons.dashboard_outlined,
//               ),

//               const SizedBox(height: 25),

//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   int columns;

//                   if (constraints.maxWidth > 1100) {
//                     columns = 3;
//                   } else if (constraints.maxWidth > 650) {
//                     columns = 2;
//                   } else {
//                     columns = 1;
//                   }

//                   return GridView.count(
//                     crossAxisCount: columns,
//                     shrinkWrap: true,
//                     physics:
//                         const NeverScrollableScrollPhysics(),
//                     crossAxisSpacing: 16,
//                     mainAxisSpacing: 16,
//                     childAspectRatio: 2.6,
//                     children: [
//                       _summaryCard(
//                         'New Orders',
//                         '$newOrders',
//                         Icons.shopping_bag_outlined,
//                         primary,
//                       ),
//                       _summaryCard(
//                         'Orders In Progress',
//                         '$inProgress',
//                         Icons.autorenew_outlined,
//                         Colors.deepOrange,
//                       ),
//                       _summaryCard(
//                         'Ready for Delivery',
//                         '$ready',
//                         Icons.check_circle_outline,
//                         Colors.green,
//                       ),
//                       _summaryCard(
//                         'Pending Deliveries',
//                         '$pendingDeliveries',
//                         Icons.local_shipping_outlined,
//                         Colors.deepPurple,
//                       ),
//                       _summaryCard(
//                         "Today's Deliveries",
//                         '$todayDeliveries',
//                         Icons.delivery_dining_outlined,
//                         Colors.teal,
//                       ),
//                       _summaryCard(
//                         'Pending Payments',
//                         '$pendingPaymentCustomers',
//                         Icons.account_balance_wallet_outlined,
//                         Colors.redAccent,
//                       ),
//                     ],
//                   );
//                 },
//               ),

//               const SizedBox(height: 20),
//               _pendingPaymentsSection(pendingPayments),

//               const SizedBox(height: 25),

//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   if (constraints.maxWidth < 850) {
//                     return Column(
//                       children: [
//                         _recentOrders(orders),
//                         const SizedBox(height: 20),
//                         _todayDeliveries(orders),
//                       ],
//                     );
//                   }

//                   return Row(
//                     crossAxisAlignment:
//                         CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         flex: 2,
//                         child: _recentOrders(orders),
//                       ),
//                       const SizedBox(width: 20),
//                       Expanded(
//                         child:
//                             _todayDeliveries(orders),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // RECENT ORDERS
//   // ============================================================

//   Widget _recentOrders(
//     List<QueryDocumentSnapshot<Map<String, dynamic>>>
//         orders,
//   ) {
//     final sorted =
//         List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
//       orders,
//     );

//     sorted.sort((a, b) {
//       final da =
//           _date(a.data()['createdAt']) ??
//               _date(a.data()['orderDate']) ??
//               DateTime(2000);

//       final dbb =
//           _date(b.data()['createdAt']) ??
//               _date(b.data()['orderDate']) ??
//               DateTime(2000);

//       return dbb.compareTo(da);
//     });

//     return _sectionCard(
//       title: 'Recent Orders',
//       action: '${orders.length} Total',
//       child: sorted.isEmpty
//           ? _emptyState(
//               Icons.shopping_bag_outlined,
//               'No orders yet',
//               'Orders placed by customers will appear here.',
//             )
//           : Column(
//               children: sorted
//                   .take(8)
//                   .map(
//                     (doc) => _orderTile(
//                       doc,
//                       clickable: true,
//                     ),
//                   )
//                   .toList(),
//             ),
//     );
//   }

//   // ============================================================
//   // TODAY DELIVERIES
//   // ============================================================

//   Widget _todayDeliveries(
//     List<QueryDocumentSnapshot<Map<String, dynamic>>>
//         orders,
//   ) {
//     final today = orders.where((doc) {
//       final date =
//           _date(doc.data()['pickupDate']);

//       return date != null && _isToday(date);
//     }).toList();

//     return _sectionCard(
//       title: "Today's Deliveries",
//       action: '${today.length}',
//       child: today.isEmpty
//           ? _emptyState(
//               Icons.local_shipping_outlined,
//               'No deliveries',
//               'No pickup or delivery is scheduled today.',
//             )
//           : Column(
//               children: today
//                   .take(6)
//                   .map(
//                     (doc) => _orderTile(
//                       doc,
//                       clickable: true,
//                     ),
//                   )
//                   .toList(),
//             ),
//     );
//   }

//   // ============================================================
//   // ORDERS PAGE
//   // ============================================================

//   Widget _buildOrdersPage() {
//     return StreamBuilder<
//         QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('orders').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return _errorPage(
//             'Unable to load orders. Please check your Firestore connection.',
//           );
//         }

//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return _loading();
//         }

//         var docs = snapshot.data?.docs ?? [];

//         docs = docs.where((doc) {
//           if (searchText.isEmpty) return true;

//           final data = doc.data();

//           final order =
//               _string(data['orderId'] ??
//                   data['orderNumber']);

//           final customer =
//               _string(data['customerName']);

//           final customerId =
//               _string(data['customerId']);

//           return order
//                   .toLowerCase()
//                   .contains(searchText) ||
//               customer
//                   .toLowerCase()
//                   .contains(searchText) ||
//               customerId
//                   .toLowerCase()
//                   .contains(searchText);
//         }).toList();

//         docs.sort((a, b) {
//           final da =
//               _date(a.data()['createdAt']) ??
//                   _date(a.data()['orderDate']) ??
//                   DateTime(2000);

//           final dbb =
//               _date(b.data()['createdAt']) ??
//                   _date(b.data()['orderDate']) ??
//                   DateTime(2000);

//           return dbb.compareTo(da);
//         });

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     width: 50,
//                     height: 50,
//                     decoration: BoxDecoration(
//                       color: lightOrange,
//                       borderRadius: BorderRadius.circular(13),
//                     ),
//                     child: const Icon(
//                       Icons.shopping_bag_outlined,
//                       color: primary,
//                       size: 28,
//                     ),
//                   ),
//                   const SizedBox(width: 15),
//                   const Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Orders', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: darkText)),
//                         SizedBox(height: 4),
//                         Text('View and manage customer orders.', style: TextStyle(color: grayText, fontSize: 13)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 25),

//               if (docs.isEmpty)
//                 _emptyCard(
//                   Icons.shopping_bag_outlined,
//                   searchText.isEmpty
//                       ? 'No orders found'
//                       : 'No matching orders',
//                   searchText.isEmpty
//                       ? 'Customer orders will appear here automatically.'
//                       : 'Try another customer name, ID or order number.',
//                 )
//               else
//                 ...docs.map(
//                   (doc) => _largeOrderCard(doc),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // LARGE ORDER CARD
//   // ============================================================

//   Widget _largeOrderCard(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data();

//     final orderId =
//         _string(data['orderId'] ??
//             data['orderNumber'],
//             fallback: doc.id);

//     final customer =
//         _string(data['customerName'],
//             fallback: 'Customer');

//     final customerId =
//         _string(data['customerId']);

//     final email =
//         _string(data['customerEmail'] ?? data['email']);

//     final phone = _string(data['customerPhone'] ?? data['phone'], fallback: 'Not available');
//     final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'], fallback: 'Not available');
//     final selectedClothes = _selectedClothesText(data);

//     final service =
//         _string(data['service'],
//             fallback: 'Laundry Service');

//     final quantity = _clothesCount(data);

//     final amount =
//         _number(data['totalAmount']);

//     final status =
//         _string(data['status'],
//             fallback: 'Order Received');

//     final payment =
//         _string(data['paymentStatus'],
//             fallback: 'Pending');

//     final orderDate =
//         _date(data['orderDate']) ??
//             _date(data['createdAt']);

//     final pickupDate =
//         _date(data['pickupDate']);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: lightOrange,
//                   borderRadius:
//                       BorderRadius.circular(13),
//                 ),
//                 child: const Icon(
//                   Icons.shopping_bag_outlined,
//                   color: primary,
//                   size: 28,
//                 ),
//               ),

//               const SizedBox(width: 15),

//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       orderId,
//                       style: const TextStyle(
//                         fontWeight:
//                             FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       customer,
//                       style: const TextStyle(
//                         color: grayText,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               _statusBadge(status),
//             ],
//           ),

//           const Divider(height: 30),

//           LayoutBuilder(
//             builder: (context, constraints) {
//               if (constraints.maxWidth < 650) {
//                 return Column(
//                   children: [
//                     _infoRow(
//                       Icons.badge_outlined,
//                       'Customer ID',
//                       customerId,
//                     ),
//                     _infoRow(
//                       Icons.email_outlined,
//                       'Email',
//                       email,
//                     ),
//                     _infoRow(
//                       Icons.local_laundry_service_outlined,
//                       'Service',
//                       service,
//                     ),
//                     _infoRow(Icons.phone_outlined, 'Phone', phone),
//                     _infoRow(Icons.location_on_outlined, 'Address', address),
//                     _infoRow(Icons.checkroom_outlined, 'Selected Clothes', selectedClothes),
//                     _infoRow(
//                       Icons.checkroom_outlined,
//                       'Clothes',
//                       '$quantity',
//                     ),
//                     _infoRow(
//                       Icons.calendar_today_outlined,
//                       'Order Date',
//                       _formatDate(orderDate),
//                     ),
//                     _infoRow(
//                       Icons.event_outlined,
//                       'Pickup',
//                       _formatDate(pickupDate),
//                     ),
//                     _infoRow(
//                       Icons.currency_rupee,
//                       'Total',
//                       '₹${amount.toStringAsFixed(0)}',
//                     ),
//                     _infoRow(
//                       Icons.payment_outlined,
//                       'Payment',
//                       payment,
//                     ),
//                   ],
//                 );
//               }

//               return Wrap(
//                 spacing: 30,
//                 runSpacing: 18,
//                 children: [
//                   _infoBlock(
//                     'Customer ID',
//                     customerId,
//                   ),
//                   _infoBlock(
//                     'Email',
//                     email,
//                   ),
//                   _infoBlock('Service', service),
//                   _infoBlock('Phone', phone),
//                   _infoBlock('Address', address),
//                   _infoBlock('Clothes', '$quantity'),
//                   _infoBlock('Selected Clothes', selectedClothes),
//                   _infoBlock(
//                     'Order Date',
//                     _formatDate(orderDate),
//                   ),
//                   _infoBlock(
//                     'Pickup',
//                     _formatDate(pickupDate),
//                   ),
//                   _infoBlock(
//                     'Total',
//                     '₹${amount.toStringAsFixed(0)}',
//                   ),
//                   _infoBlock(
//                     'Payment',
//                     payment,
//                   ),
//                 ],
//               );
//             },
//           ),

//           const SizedBox(height: 20),

//           Row(
//             children: [
//               Expanded(
//                 child: OutlinedButton.icon(
//                   onPressed: () => _showOrderDetails(doc),
//                   icon: const Icon(Icons.visibility_outlined),
//                   label: const Text('View Details'),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () => _changeOrderStatus(doc),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: primary,
//                     foregroundColor: Colors.white,
//                   ),
//                   icon: const Icon(Icons.edit_outlined),
//                   label: const Text('Update Status'),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               IconButton(
//                 tooltip: 'Delete order',
//                 icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 onPressed: () => _confirmDeleteOrder(doc),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // CUSTOMERS PAGE
//   // ============================================================

//   Widget _buildCustomersPage() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('users').where('role', isEqualTo: 'customer').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return _errorPage('Unable to load customers. Please check Firestore permissions.');
//         if (snapshot.connectionState == ConnectionState.waiting) return _loading();

//         var customers = snapshot.data?.docs ?? [];
//         customers = customers.where((doc) {
//           if (searchText.isEmpty) return true;
//           final data = doc.data();
//           final name = _string(data['name']).toLowerCase();
//           final id = _string(data['customerId']).toLowerCase();
//           final email = _string(data['email']).toLowerCase();
//           return name.contains(searchText) || id.contains(searchText) || email.contains(searchText);
//         }).toList();
//         customers.sort((a, b) => _string(a.data()['name']).toLowerCase().compareTo(_string(b.data()['name']).toLowerCase()));

//         return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//           stream: db.collection('orders').snapshots(),
//           builder: (context, orderSnapshot) {
//             final orders = orderSnapshot.data?.docs ?? [];
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(30),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Expanded(child: _pageHeader('Customers', 'View and manage registered WashEasy customers.', Icons.people_outline)),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                         decoration: BoxDecoration(color: lightOrange, borderRadius: BorderRadius.circular(12)),
//                         child: Text('Total Customers: ${customers.length}', style: const TextStyle(color: primary, fontWeight: FontWeight.bold)),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 25),
//                   if (customers.isEmpty)
//                     _emptyCard(Icons.people_outline, searchText.isEmpty ? 'No Customers data' : 'No matching customers', searchText.isEmpty ? 'Customer information will appear here after registration.' : 'Try another customer name, ID or email.')
//                   else
//                     ...customers.map((customerDoc) {
//                       final customer = customerDoc.data();
//                       final customerId = _string(customer['customerId']);
//                       final customerEmail = _string(customer['email']).toLowerCase();
//                       final customerName = _string(customer['name']).toLowerCase();
//                       final orderCount = orders.where((order) {
//                         final od = order.data();
//                         return _string(od['customerId']) == customerId ||
//                             _string(od['customerEmail'] ?? od['email']).toLowerCase() == customerEmail ||
//                             _string(od['customerName']).toLowerCase() == customerName;
//                       }).length;
//                       return _customerCard(customerDoc, orderCount);
//                     }),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // ============================================================
//   // CUSTOMER CARD
//   // ============================================================

//   Widget _customerCard(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//     int orderCount,
//   ) {
//     final customer = doc.data();
//     final name = _string(customer['name'], fallback: 'Customer');
//     final id = _string(customer['customerId']);
//     final email = _string(customer['email']);
//     final phone = _string(customer['phone'], fallback: 'Not provided');
//     final created = _date(customer['createdAt']);
//     final status = _string(customer['status'], fallback: 'Active');

//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               CircleAvatar(
//                 radius: 27,
//                 backgroundColor: lightOrange,
//                 child: Text(
//                   name.isNotEmpty ? name[0].toUpperCase() : 'C',
//                   style: const TextStyle(
//                     color: primary,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 19,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Text(
//                   name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//               IconButton(
//                 tooltip: 'Delete customer',
//                 icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 onPressed: () => _confirmDeleteCustomer(doc),
//               ),
//             ],
//           ),
//           const Divider(height: 28),
//           Wrap(
//             spacing: 30,
//             runSpacing: 12,
//             children: [
//               _infoBlock('Customer ID', id),
//               _infoBlock('Email', email),
//               _infoBlock('Phone', phone),
//               _infoBlock('Orders', '$orderCount'),
//               _infoBlock('Registered', _formatDate(created)),
//               _infoBlock('Status', status),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SERVICES & PRICES
//   // ============================================================

//   Widget _buildServicesPage() {
//     return StreamBuilder<
//         QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('prices').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return _errorPage(
//             'Unable to load prices.',
//           );
//         }

//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return _loading();
//         }

//         final docs =
//             snapshot.data?.docs ?? [];

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: _pageHeader(
//                       'Services & Prices',
//                       'Manage laundry services and prices.',
//                       Icons.price_change_outlined,
//                     ),
//                   ),

//                   ElevatedButton.icon(
//                     onPressed: _showAddPriceDialog,
//                     style:
//                         ElevatedButton.styleFrom(
//                       backgroundColor: primary,
//                       foregroundColor:
//                           Colors.white,
//                       padding:
//                           const EdgeInsets.symmetric(
//                         horizontal: 18,
//                         vertical: 14,
//                       ),
//                     ),
//                     icon: const Icon(Icons.add),
//                     label:
//                         const Text('Add Price'),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 25),

//               if (docs.isEmpty)
//                 _emptyCard(
//                   Icons.price_change_outlined,
//                   'No prices found',
//                   'Add prices using the existing Price Management module.',
//                 )
//               else
//                 ...docs.map(
//                   (doc) => _priceCard(doc),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // PRICE CARD
//   // ============================================================

//   Widget _priceCard(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data();

//     final item =
//         _string(data['name'] ??
//             data['itemName'],
//             fallback: doc.id);

//     final service =
//         _string(data['service'],
//             fallback: 'Service');

//     final price =
//         _number(data['price']);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       padding: const EdgeInsets.all(18),
//       decoration: _cardDecoration(),
//       child: Row(
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: lightOrange,
//               borderRadius:
//                   BorderRadius.circular(12),
//             ),
//             child: const Icon(
//               Icons.price_change_outlined,
//               color: primary,
//             ),
//           ),

//           const SizedBox(width: 15),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   item,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Services & Prices • $service',
//                   style: const TextStyle(
//                     color: grayText,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Text(
//             '₹${price.toStringAsFixed(0)}',
//             style: const TextStyle(
//               color: primary,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),

//           const SizedBox(width: 15),

//           IconButton(
//             tooltip: 'Edit price',
//             icon: const Icon(Icons.edit_outlined),
//             onPressed: () => _showEditPriceDialog(doc),
//           ),
//           IconButton(
//             tooltip: 'Delete price',
//             icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//             onPressed: () => _confirmDeletePrice(doc),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // DELIVERIES
//   // ============================================================

//   Widget _buildDeliveriesPage() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('orders').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return _errorPage('Unable to load delivery data.');
//         if (snapshot.connectionState == ConnectionState.waiting) return _loading();

//         final deliveries = (snapshot.data?.docs ?? []).where((doc) {
//           return _date(doc.data()['pickupDate']) != null;
//         }).toList();

//         deliveries.sort((a, b) {
//           final da = _date(a.data()['pickupDate']) ?? DateTime(9999);
//           final dbb = _date(b.data()['pickupDate']) ?? DateTime(9999);
//           return da.compareTo(dbb);
//         });

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _pageHeader('Deliveries', 'Track customer pickups and deliveries.', Icons.local_shipping_outlined),
//               const SizedBox(height: 25),
//               if (deliveries.isEmpty)
//                 _emptyCard(Icons.local_shipping_outlined, 'No deliveries', 'Delivery information will appear here.')
//               else
//                 ...deliveries.map((doc) => _deliveryCard(doc)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // DELIVERY CARD

//   Widget _deliveryCard(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data();
//     final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
//     final customer = _string(data['customerName'], fallback: 'Customer');
//     final customerId = _string(data['customerId']);
//     final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'] ?? data['pickupAddress'], fallback: 'Address not provided');
//     final date = _date(data['pickupDate']);
//     final deliveryStatus = _string(data['deliveryStatus'], fallback: 'Delivery Pending');
//     final payment = _string(data['paymentStatus'], fallback: 'Pending');

//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Row(children: [
//           const Icon(Icons.local_shipping_outlined, color: primary),
//           const SizedBox(width: 12),
//           Expanded(child: Text(order, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
//           PopupMenuButton<String>(
//             tooltip: 'Update delivery status',
//             onSelected: (value) => _updateDeliveryStatus(doc, value),
//             itemBuilder: (context) => const [
//               PopupMenuItem(value: 'Delivery Pending', child: Text('Delivery Pending')),
//               PopupMenuItem(value: 'Delivery Done', child: Text('Delivery Done')),
//             ],
//             child: _statusBadge(deliveryStatus),
//           ),
//         ]),
//         const Divider(height: 25),
//         Wrap(spacing: 30, runSpacing: 15, children: [
//           _infoBlock('Customer', customer),
//           _infoBlock('Customer ID', customerId),
//           _infoBlock('Pickup / Delivery', _formatDate(date)),
//           _infoBlock('Address', address),
//           _infoBlock('Payment', payment),
//         ]),
//       ]),
//     );
//   }

//   // ============================================================
//   // PAYMENTS
//   // ============================================================

//   Widget _buildPaymentsPage() {
//     return StreamBuilder<
//         QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('orders').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return _errorPage(
//             'Unable to load payment information.',
//           );
//         }

//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return _loading();
//         }

//         final docs =
//             snapshot.data?.docs ?? [];

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               _pageHeader(
//                 'Payments',
//                 'View and confirm customer payments.',
//                 Icons.payment_outlined,
//               ),

//               const SizedBox(height: 25),

//               if (docs.isEmpty)
//                 _emptyCard(
//                   Icons.payment_outlined,
//                   'No payment records',
//                   'Payment information will appear with customer orders.',
//                 )
//               else
//                 ...docs.map(
//                   (doc) => _paymentCard(doc),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // PAYMENT CARD
//   // ============================================================

//   Widget _paymentCard(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data();
//     final order = _string(
//       data['orderId'] ?? data['orderNumber'],
//       fallback: doc.id,
//     );
//     final bill = _string(
//       data['billNo'] ?? data['billNumber'],
//       fallback: 'Not available',
//     );
//     final customer = _string(data['customerName'], fallback: 'Customer');
//     final customerId = _string(data['customerId']);
//     final amount = _number(data['totalAmount']);
//     final status = _string(data['paymentStatus'], fallback: 'Pending');
//     final date = _date(data['paymentDate']);
//     final paid = status.toLowerCase() == 'paid';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 15),
//       padding: const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 48,
//                 height: 48,
//                 decoration: BoxDecoration(
//                   color: paid ? Colors.green.withOpacity(.10) : Colors.red.withOpacity(.10),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   paid ? Icons.check_circle_outline : Icons.pending_outlined,
//                   color: paid ? Colors.green : Colors.red,
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(order, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     const SizedBox(height: 4),
//                     Text(customer, style: const TextStyle(color: grayText)),
//                   ],
//                 ),
//               ),
//               _paymentBadge(status),
//               IconButton(
//                 tooltip: 'Delete payment record',
//                 icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
//                 onPressed: () => _confirmDeletePayment(doc),
//               ),
//             ],
//           ),
//           const Divider(height: 28),
//           Wrap(
//             spacing: 30,
//             runSpacing: 15,
//             children: [
//               _infoBlock('Customer ID', customerId),
//               _infoBlock('Bill', bill),
//               _infoBlock('Amount', '₹${amount.toStringAsFixed(0)}'),
//               _infoBlock('Payment Date', _formatDate(date)),
//             ],
//           ),
//           if (!paid) ...[
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () => _confirmPayment(doc),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primary,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                 ),
//                 icon: const Icon(Icons.check_circle_outline),
//                 label: const Text('Confirm Payment'),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // BILLS
//   // ============================================================

//   Widget _buildBillsPage() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('orders').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return _errorPage('Unable to load bills.');
//         if (snapshot.connectionState == ConnectionState.waiting) return _loading();
//         final docs = snapshot.data?.docs ?? [];
//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _pageHeader('Bills', 'View each customer bill from their orders.', Icons.receipt_long_outlined),
//               const SizedBox(height: 25),
//               if (docs.isEmpty)
//                 _emptyCard(Icons.receipt_long_outlined, 'No bills found', 'Customer bills will appear here after orders are placed.')
//               else
//                 ...docs.map((doc) => _billCard(doc)),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _billCard(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data();
//     final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
//     final bill = _string(data['billNo'] ?? data['billNumber'], fallback: 'Bill-${doc.id.substring(0, doc.id.length > 6 ? 6 : doc.id.length)}');
//     final customer = _string(data['customerName'], fallback: 'Customer');
//     final customerId = _string(data['customerId']);
//     final email = _string(data['customerEmail'] ?? data['email'], fallback: 'Not available');
//     final phone = _string(data['customerPhone'] ?? data['phone'], fallback: 'Not available');
//     final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'], fallback: 'Not available');
//     final amount = _number(data['totalAmount']);
//     final payment = _string(data['paymentStatus'], fallback: 'Pending');
//     final quantity = _clothesCount(data);
//     final items = _selectedClothesText(data);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 color: lightOrange,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Icon(
//                 Icons.receipt_long_outlined,
//                 color: primary,
//                 size: 27,
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(bill, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//               const SizedBox(height: 3),
//               Text('$customer • $order', style: const TextStyle(color: grayText)),
//             ])),
//             Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: primary, fontSize: 17)),
//           ]),
//           const Divider(height: 28),
//           Wrap(spacing: 30, runSpacing: 14, children: [
//             _infoBlock('Customer ID', customerId),
//             _infoBlock('Email', email),
//             _infoBlock('Phone', phone),
//             _infoBlock('Address', address),
//             _infoBlock('Clothes', '$quantity'),
//             _infoBlock('Items', items),
//             _infoBlock('Payment', payment),
//           ]),
//           const SizedBox(height: 18),
//           Align(alignment: Alignment.centerRight, child: OutlinedButton.icon(onPressed: () => _showBillDetails(doc), icon: const Icon(Icons.visibility_outlined), label: const Text('View Bill'))),
//         ],
//       ),
//     );
//   }

//   void _showBillDetails(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data();
//     final customer = _string(data['customerName'], fallback: 'Customer');
//     final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
//     final bill = _string(data['billNo'] ?? data['billNumber'], fallback: 'Not available');
//     final amount = _number(data['totalAmount']);
//     final email = _string(data['customerEmail'] ?? data['email'], fallback: 'Not available');
//     final phone = _string(data['customerPhone'] ?? data['phone'], fallback: 'Not available');
//     final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'], fallback: 'Not available');
//     final items = _selectedClothesText(data);
//     showDialog(context: context, builder: (_) => AlertDialog(
//       title: Row(children: [
//         Container(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//             color: lightOrange,
//             borderRadius: BorderRadius.circular(11),
//           ),
//           child: const Icon(Icons.receipt_long_outlined, color: primary, size: 24),
//         ),
//         const SizedBox(width: 10),
//         const Text('Customer Bill'),
//       ]),
//       content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _dialogInfo('Bill No.', bill), _dialogInfo('Order No.', order), _dialogInfo('Customer', customer), _dialogInfo('Email', email), _dialogInfo('Phone', phone), _dialogInfo('Address', address), _dialogInfo('Items', items), _dialogInfo('Total', '₹${amount.toStringAsFixed(0)}'), _dialogInfo('Payment', _string(data['paymentStatus'], fallback: 'Pending')),
//       ])),
//       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
//     ));
//   }

//   // ============================================================
//   // NOTIFICATIONS PAGE
//   // ============================================================

//   Widget _buildNotificationsPage() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('notifications').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) return _notificationFallback();
//         if (snapshot.connectionState == ConnectionState.waiting) return _loading();

//         final docs = snapshot.data?.docs ?? [];
//         final customer = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
//         final orders = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
//         final payments = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
//         final deliveries = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
//         final other = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

//         for (final doc in docs) {
//           switch (_notificationCategory(doc.data())) {
//             case 'customer':
//               customer.add(doc);
//               break;
//             case 'orders':
//               orders.add(doc);
//               break;
//             case 'payments':
//               payments.add(doc);
//               break;
//             case 'deliveries':
//               deliveries.add(doc);
//               break;
//             default:
//               other.add(doc);
//           }
//         }

//         return SingleChildScrollView(
//           padding: const EdgeInsets.all(30),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _pageHeader(
//                 'Notifications Dashboard',
//                 'Notifications are separated into individual sections for easy management.',
//                 Icons.notifications_none,
//               ),
//               const SizedBox(height: 25),
//               LayoutBuilder(
//                 builder: (context, constraints) {
//                   final double cardWidth = constraints.maxWidth >= 850
//                       ? (constraints.maxWidth - 18) / 2
//                       : constraints.maxWidth;

//                   return Wrap(
//                     spacing: 18,
//                     runSpacing: 18,
//                     children: [
//                       SizedBox(
//                         width: cardWidth,
//                         child: _notificationSection(
//                           'Customer Notifications',
//                           Icons.people_outline,
//                           customer,
//                         ),
//                       ),
//                       SizedBox(
//                         width: cardWidth,
//                         child: _notificationSection(
//                           'Order Notifications',
//                           Icons.shopping_bag_outlined,
//                           orders,
//                         ),
//                       ),
//                       SizedBox(
//                         width: cardWidth,
//                         child: _notificationSection(
//                           'Payment Notifications',
//                           Icons.payment_outlined,
//                           payments,
//                         ),
//                       ),
//                       SizedBox(
//                         width: cardWidth,
//                         child: _notificationSection(
//                           'Delivery Notifications',
//                           Icons.local_shipping_outlined,
//                           deliveries,
//                         ),
//                       ),
//                       SizedBox(
//                         width: cardWidth,
//                         child: _notificationSection(
//                           'Other Notifications',
//                           Icons.notifications_none,
//                           other,
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//               if (docs.isEmpty) ...[
//                 const SizedBox(height: 18),
//                 _notificationFallback(),
//               ],
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _notificationSection(
//     String title,
//     IconData icon,
//     List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
//   ) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 46,
//                 height: 46,
//                 decoration: BoxDecoration(
//                   color: lightOrange,
//                   borderRadius: BorderRadius.circular(13),
//                 ),
//                 child: Icon(icon, color: primary, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: darkText,
//                   ),
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 5,
//                 ),
//                 decoration: BoxDecoration(
//                   color: lightOrange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   '${docs.length}',
//                   style: const TextStyle(
//                     color: primary,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           if (docs.isEmpty)
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.symmetric(vertical: 18),
//               decoration: BoxDecoration(
//                 color: background,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: const Text(
//                 'No notifications in this section.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(color: grayText, fontSize: 12),
//               ),
//             )
//           else
//             ...docs.map(_notificationCard),
//         ],
//       ),
//     );
//   }

//   String _notificationCategory(Map<String, dynamic> data) {
//     final type = _string(data['type']).toLowerCase();
//     final title = _string(data['title']).toLowerCase();
//     final message = _string(data['message']).toLowerCase();
//     final combined = '$type $title $message';

//     if (combined.contains('payment') || combined.contains('paid')) return 'payments';
//     if (combined.contains('delivery') || combined.contains('pickup') || combined.contains('collected')) return 'deliveries';
//     if (type.contains('customer_message') || type.contains('owner_message') || combined.contains('customer message') || combined.contains('message from')) return 'customer';
//     if (combined.contains('order') || combined.contains('ironing') || combined.contains('clothes ready') || combined.contains('order received')) return 'orders';
//     return 'other';
//   }

//   Widget _notificationFallback() {
//     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//       stream: db.collection('orders').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) return _loading();
//         final orders = snapshot.data?.docs ?? [];
//         final recent = orders.take(10).toList();
//         if (recent.isEmpty) {
//           return _emptyCard(
//             Icons.notifications_none,
//             'No notifications',
//             'Notifications will appear when customers place orders or payments change.',
//           );
//         }
//         return Column(
//           children: recent.map((doc) {
//             final data = doc.data();
//             final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
//             final customer = _string(data['customerName'], fallback: 'Customer');
//             final status = _string(data['status'], fallback: 'Order Received');
//             return _eventNotification(Icons.shopping_bag_outlined, 'Order $order', '$customer — $status');
//           }).toList(),
//         );
//       },
//     );
//   }

//   Widget _notificationCard(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
//     final data = doc.data();
//     final title = _string(data['title'], fallback: 'WashEasy Notification');
//     final message = _string(data['message']);
//     final customerId = _string(data['customerId']);
//     final customerName = _notificationCustomerName(data, message);
//     final type = _string(data['type']).toLowerCase();
//     final isCustomerMessage = type == 'customer_message' && customerId.isNotEmpty;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: lightOrange,
//         borderRadius: BorderRadius.circular(13),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
//             child: const Icon(Icons.notifications_none, color: primary),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 4),
//                 Text(message, style: const TextStyle(color: grayText, fontSize: 12)),
//                 if (isCustomerMessage) ...[
//                   const SizedBox(height: 10),
//                   Align(
//                     alignment: Alignment.centerLeft,
//                     child: ElevatedButton.icon(
//                       onPressed: () => _openCustomerChat(customerId, customerName),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: primary,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//                       ),
//                       icon: const Icon(Icons.reply, size: 17),
//                       label: const Text('Reply'),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           IconButton(
//             tooltip: 'Delete notification',
//             icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 21),
//             onPressed: () => _confirmDeleteNotification(doc),
//           ),
//         ],
//       ),
//     );
//   }

//   String _notificationCustomerName(Map<String, dynamic> data, String message) {
//     final stored = _string(data['customerName']);
//     if (stored.isNotEmpty) return stored;
//     final colon = message.indexOf(':');
//     if (colon > 0) return message.substring(0, colon).trim();
//     return 'Customer';
//   }

//   Future<void> _openCustomerChat(String customerId, String customerName) async {
//     await showDialog<void>(
//       context: context,
//       builder: (_) => _OwnerChatDialog(
//         db: db,
//         customerId: customerId,
//         customerName: customerName,
//       ),
//     );
//   }

//   // ============================================================
//   // OWNER DETAILS
//   // ============================================================

//   Widget _buildOwnerDetailsPage() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(30),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _pageHeader('Owner Details', 'Add and manage owner, business and profile information.', Icons.person_outline),
//         const SizedBox(height: 25),
//         _ownerProfileEditor(),
//       ]),
//     );
//   }

//   Widget _ownerProfileEditor() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(22),
//       decoration: _cardDecoration(),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         Center(
//           child: Column(children: [
//             CircleAvatar(
//               radius: 48,
//               backgroundColor: lightOrange,
//               backgroundImage: ownerProfileImageBase64 != null && ownerProfileImageBase64!.isNotEmpty ? MemoryImage(base64Decode(ownerProfileImageBase64!)) : null,
//               child: ownerProfileImageBase64 == null || ownerProfileImageBase64!.isEmpty ? const Icon(Icons.person, color: primary, size: 48) : null,
//             ),
//             const SizedBox(height: 10),
//             OutlinedButton.icon(onPressed: _pickOwnerProfilePicture, icon: const Icon(Icons.camera_alt_outlined), label: const Text('Add / Change Profile Picture')),
//           ]),
//         ),
//         const SizedBox(height: 22),
//         _ownerField(ownerNameController, 'Owner Name', Icons.person_outline),
//         _ownerField(ownerAddressController, 'Owner Address', Icons.location_on_outlined),
//         _ownerField(ownerPhoneController, 'Contact Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
//         _ownerField(ownerEmailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
//         _ownerField(businessNameController, 'Business Name', Icons.storefront_outlined),
//         _ownerField(businessAddressController, 'Business Address', Icons.location_city_outlined),
//         _ownerField(businessPhoneController, 'Business Contact Number', Icons.call_outlined, keyboardType: TextInputType.phone),
//         _ownerField(businessEmailController, 'Business Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
//         _ownerField(websiteController, 'Website / Social Link', Icons.language_outlined),
//         _ownerField(workingHoursController, 'Working Hours', Icons.access_time_outlined),
//         const SizedBox(height: 10),
//         SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: ownerDetailsSaving ? null : _saveOwnerDetails, style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)), icon: ownerDetailsSaving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save_outlined), label: Text(ownerDetailsSaving ? 'Saving...' : 'Save Owner Information'))),
//       ]),
//     );
//   }

//   Widget _ownerField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
//     return Padding(padding: const EdgeInsets.only(bottom: 14), child: TextField(controller: controller, keyboardType: keyboardType, decoration: InputDecoration(prefixIcon: Icon(icon, color: primary), labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primary, width: 1.5)))));
//   }

//   Future<void> _loadOwnerDetails() async {
//     setState(() => ownerDetailsLoading = true);
//     try {
//       final snap = await db.collection('ownerDetails').doc('OWNER001').get();
//       final d = snap.data();
//       if (d != null) {
//         ownerNameController.text = _string(d['ownerName'], fallback: 'WashEasy Owner');
//         ownerAddressController.text = _string(d['ownerAddress']);
//         ownerPhoneController.text = _string(d['ownerPhone']);
//         ownerEmailController.text = _string(d['ownerEmail']);
//         businessNameController.text = _string(d['businessName'], fallback: 'WashEasy Laundry');
//         businessAddressController.text = _string(d['businessAddress']);
//         businessPhoneController.text = _string(d['businessPhone']);
//         businessEmailController.text = _string(d['businessEmail']);
//         websiteController.text = _string(d['website']);
//         workingHoursController.text = _string(d['workingHours']);
//         ownerProfileImageBase64 = _string(d['profileImage']);
//       } else {
//         ownerNameController.text = 'WashEasy Owner';
//         businessNameController.text = 'WashEasy Laundry';
//       }
//     } catch (_) {}
//     if (mounted) setState(() => ownerDetailsLoading = false);
//   }

//   Future<void> _pickOwnerProfilePicture() async {
//     try {
//       final file = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 800, maxHeight: 800);
//       if (file == null) return;
//       final bytes = await file.readAsBytes();
//       if (bytes.length > 700 * 1024) {
//         if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose a smaller profile picture.')));
//         return;
//       }
//       setState(() => ownerProfileImageBase64 = base64Encode(bytes));
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to select profile picture: $e')));
//     }
//   }

//   Future<void> _saveOwnerDetails() async {
//     setState(() => ownerDetailsSaving = true);
//     try {
//       await db.collection('ownerDetails').doc('OWNER001').set({
//         'ownerId': 'OWNER001',
//         'ownerName': ownerNameController.text.trim(),
//         'ownerAddress': ownerAddressController.text.trim(),
//         'ownerPhone': ownerPhoneController.text.trim(),
//         'ownerEmail': ownerEmailController.text.trim(),
//         'businessName': businessNameController.text.trim(),
//         'businessAddress': businessAddressController.text.trim(),
//         'businessPhone': businessPhoneController.text.trim(),
//         'businessEmail': businessEmailController.text.trim(),
//         'website': websiteController.text.trim(),
//         'workingHours': workingHoursController.text.trim(),
//         'profileImage': ownerProfileImageBase64 ?? '',
//         'updatedAt': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Owner information saved successfully.')));
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to save owner information: $e'), backgroundColor: Colors.redAccent));
//     } finally {
//       if (mounted) setState(() => ownerDetailsSaving = false);
//     }
//   }

//   // ============================================================
//   // SETTINGS
//   // ============================================================

//   Widget _buildSettingsPage() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(30),
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         children: [
//           _pageHeader(
//             'Settings',
//             'Manage Owner and WashEasy settings.',
//             Icons.settings_outlined,
//           ),

//           const SizedBox(height: 25),

//           _settingsCard(
//             icon: Icons.person_outline,
//             title: 'Owner Information',
//             children: [
//               _settingsRow(
//                 'Owner Name',
//                 'WashEasy Owner',
//               ),
//               _settingsRow(
//                 'Owner ID',
//                 'OWNER001',
//               ),
//               _settingsRow(
//                 'Role',
//                 'Owner',
//               ),
//             ],
//           ),

//           const SizedBox(height: 18),

//           _settingsCard(
//             icon: Icons.storefront_outlined,
//             title: 'Business Information',
//             children: [
//               _settingsRow(
//                 'Business',
//                 'WashEasy Laundry',
//               ),
//               _settingsRow(
//                 'System',
//                 'Laundry & Ironing Management',
//               ),
//             ],
//           ),

//           const SizedBox(height: 18),

//           _settingsCard(
//             icon: Icons.security_outlined,
//             title: 'Account',
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _logout,
//                   style:
//                       ElevatedButton.styleFrom(
//                     backgroundColor:
//                         Colors.redAccent,
//                     foregroundColor:
//                         Colors.white,
//                     padding:
//                         const EdgeInsets.symmetric(
//                       vertical: 14,
//                     ),
//                   ),
//                   icon: const Icon(
//                     Icons.logout,
//                   ),
//                   label:
//                       const Text('Logout'),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // PAGE HEADER
//   // ============================================================

//   Widget _pageHeader(
//     String title,
//     String subtitle,
//     IconData icon,
//   ) {
//     return Row(
//       children: [
//         Container(
//           width: 48,
//           height: 48,
//           decoration: BoxDecoration(
//             color: lightOrange,
//             borderRadius:
//                 BorderRadius.circular(13),
//           ),
//           child: Icon(
//             icon,
//             color: primary,
//           ),
//         ),

//         const SizedBox(width: 15),

//         Expanded(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   color: darkText,
//                 ),
//               ),

//               const SizedBox(height: 5),

//               Text(
//                 subtitle,
//                 style: const TextStyle(
//                   color: grayText,
//                   fontSize: 13,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // SUMMARY CARD
//   // ============================================================

//   Widget _summaryCard(
//     String title,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: _cardDecoration(),
//       child: Row(
//         children: [
//           Container(
//             width: 53,
//             height: 53,
//             decoration: BoxDecoration(
//               color: color.withOpacity(.10),
//               borderRadius:
//                   BorderRadius.circular(13),
//             ),
//             child: Icon(
//               icon,
//               color: color,
//               size: 27,
//             ),
//           ),

//           const SizedBox(width: 15),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               mainAxisAlignment:
//                   MainAxisAlignment.center,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: grayText,
//                     fontSize: 12,
//                   ),
//                 ),

//                 const SizedBox(height: 5),

//                 Text(
//                   value,
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // ORDER TILE
//   // ============================================================

//   Widget _orderTile(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc, {
//     bool clickable = false,
//   }) {
//     final data = doc.data();

//     final orderId =
//         _string(data['orderId'] ??
//             data['orderNumber'],
//             fallback: doc.id);

//     final customer =
//         _string(data['customerName'],
//             fallback: 'Customer');

//     final customerId =
//         _string(data['customerId']);

//     final service =
//         _string(data['service'],
//             fallback: 'Laundry');

//     final amount =
//         _number(data['totalAmount']);

//     final status =
//         _string(data['status'],
//             fallback: 'Order Received');

//     final child = Padding(
//       padding: const EdgeInsets.symmetric(
//         vertical: 13,
//       ),
//       child: Row(
//         children: [
//           Container(
//             width: 45,
//             height: 45,
//             decoration: BoxDecoration(
//               color: lightOrange,
//               borderRadius:
//                   BorderRadius.circular(11),
//             ),
//             child: washEasyLogoBox(size: 45),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   orderId,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),

//                 const SizedBox(height: 3),

//                 Text(
//                   customerId.isEmpty
//                       ? customer
//                       : '$customer ($customerId)',
//                   style: const TextStyle(
//                     color: grayText,
//                     fontSize: 12,
//                   ),
//                 ),

//                 const SizedBox(height: 3),

//                 Text(
//                   service,
//                   style: const TextStyle(
//                     color: Color(0xFF9CA3AF),
//                     fontSize: 11,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.end,
//             children: [
//               Text(
//                 '₹${amount.toStringAsFixed(0)}',
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 5),

//               _statusBadge(status),
//             ],
//           ),
//         ],
//       ),
//     );

//     if (!clickable) {
//       return child;
//     }

//     return InkWell(
//       onTap: () => _showOrderDetails(doc),
//       borderRadius:
//           BorderRadius.circular(10),
//       child: child,
//     );
//   }

//   // ============================================================
//   // STATUS BADGE
//   // ============================================================

//   Widget _statusBadge(String status) {
//     Color color;

//     switch (status.toLowerCase()) {
//       case 'ready':
//       case 'clothes ready':
//         color = Colors.green;
//         break;

//       case 'in progress':
//       case 'ironing started':
//         color = Colors.orange;
//         break;

//       case 'customer collected':
//       case 'completed':
//         color = Colors.blueGrey;
//         break;

//       default:
//         color = primary;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 6,
//       ),
//       decoration: BoxDecoration(
//         color: color.withOpacity(.10),
//         borderRadius:
//             BorderRadius.circular(20),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color: color,
//           fontSize: 10,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // PAYMENT BADGE
//   // ============================================================

//   Widget _paymentBadge(String status) {
//     final paid =
//         status.toLowerCase() == 'paid';

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         horizontal: 10,
//         vertical: 6,
//       ),
//       decoration: BoxDecoration(
//         color: (paid
//                 ? Colors.green
//                 : Colors.orange)
//             .withOpacity(.10),
//         borderRadius:
//             BorderRadius.circular(20),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           color:
//               paid ? Colors.green : Colors.orange,
//           fontWeight: FontWeight.bold,
//           fontSize: 11,
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // SECTION CARD
//   // ============================================================

//   Widget _sectionCard({
//     required String title,
//     required String action,
//     required Widget child,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 17,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),

//               Text(
//                 action,
//                 style: const TextStyle(
//                   color: primary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 10),

//           child,
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // INFO BLOCK
//   // ============================================================

//   Widget _infoBlock(
//     String title,
//     String value,
//   ) {
//     return SizedBox(
//       width: 150,
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: grayText,
//               fontSize: 11,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             value.isEmpty ? 'Not available' : value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 13,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // INFO ROW
//   // ============================================================

//   Widget _infoRow(
//     IconData icon,
//     String title,
//     String value,
//   ) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(bottom: 13),
//       child: Row(
//         children: [
//           Icon(
//             icon,
//             size: 19,
//             color: primary,
//           ),

//           const SizedBox(width: 10),

//           SizedBox(
//             width: 110,
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: grayText,
//                 fontSize: 12,
//               ),
//             ),
//           ),

//           Expanded(
//             child: Text(
//               value.isEmpty
//                   ? 'Not available'
//                   : value,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // EMPTY CARD
//   // ============================================================

//   Widget _emptyCard(
//     IconData icon,
//     String title,
//     String message,
//   ) {
//     return Container(
//       width: double.infinity,
//       padding:
//           const EdgeInsets.symmetric(
//         vertical: 65,
//         horizontal: 25,
//       ),
//       decoration: _cardDecoration(),
//       child: _emptyState(
//         icon,
//         title,
//         message,
//       ),
//     );
//   }

//   // ============================================================
//   // EMPTY STATE
//   // ============================================================

//   Widget _emptyState(
//     IconData icon,
//     String title,
//     String message,
//   ) {
//     return Center(
//       child: Column(
//         children: [
//           Container(
//             width: 68,
//             height: 68,
//             decoration: BoxDecoration(
//               color: background,
//               borderRadius:
//                   BorderRadius.circular(17),
//             ),
//             child: Icon(
//               icon,
//               color: const Color(0xFF94A3B8),
//               size: 31,
//             ),
//           ),

//           const SizedBox(height: 15),

//           Text(
//             title,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//               fontSize: 16,
//             ),
//           ),

//           const SizedBox(height: 7),

//           Text(
//             message,
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               color: grayText,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // ERROR
//   // ============================================================

//   Widget _errorPage(String message) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(30),
//         child: Column(
//           mainAxisSize:
//               MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               color: Colors.redAccent,
//               size: 50,
//             ),

//             const SizedBox(height: 15),

//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.redAccent,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ============================================================
//   // LOADING
//   // ============================================================

//   Widget _loading() {
//     return const Center(
//       child: CircularProgressIndicator(
//         color: primary,
//       ),
//     );
//   }

//   // ============================================================
//   // CARD DECORATION
//   // ============================================================

//   BoxDecoration _cardDecoration() {
//     return BoxDecoration(
//       color: Colors.white,
//       borderRadius:
//           BorderRadius.circular(16),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(.04),
//           blurRadius: 12,
//           offset: const Offset(0, 4),
//         ),
//       ],
//     );
//   }

//   // ============================================================
//   // DELETE CONFIRMATION HELPERS
//   // ============================================================

//   Future<bool> _confirmDelete(String title, String message) async {
//     final result = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(title),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton.icon(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.redAccent,
//               foregroundColor: Colors.white,
//             ),
//             icon: const Icon(Icons.delete_outline),
//             label: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//     return result == true;
//   }

//   Future<void> _confirmDeleteOrder(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     final orderId = _string(
//       doc.data()['orderId'] ?? doc.data()['orderNumber'],
//       fallback: doc.id,
//     );
//     if (!await _confirmDelete(
//       'Delete Order?',
//       'Order $orderId will be permanently deleted from Firestore.',
//     )) return;

//     try {
//       await doc.reference.delete();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Order deleted successfully.')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to delete order: $e'), backgroundColor: Colors.redAccent),
//       );
//     }
//   }

//   Future<void> _confirmDeleteCustomer(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     final name = _string(doc.data()['name'], fallback: 'this customer');
//     final customerId = _string(doc.data()['customerId']);
//     if (!await _confirmDelete(
//       'Delete Customer?',
//       'Delete $name from the WashEasy customer list? This removes the customer document from Firestore.',
//     )) return;

//     try {
//       await doc.reference.delete();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Customer $customerId deleted successfully.')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to delete customer: $e'), backgroundColor: Colors.redAccent),
//       );
//     }
//   }

//   Future<void> _confirmDeletePrice(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     final name = _string(doc.data()['name'] ?? doc.data()['itemName'], fallback: doc.id);
//     if (!await _confirmDelete(
//       'Delete Price?',
//       'Delete the price entry "$name" from Services & Prices?',
//     )) return;

//     try {
//       await doc.reference.delete();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Price deleted successfully.')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to delete price: $e'), backgroundColor: Colors.redAccent),
//       );
//     }
//   }

//   Future<void> _confirmDeleteNotification(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     if (!await _confirmDelete(
//       'Delete Notification?',
//       'This notification will be permanently removed.',
//     )) return;

//     try {
//       await doc.reference.delete();
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Notification deleted successfully.')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to delete notification: $e'), backgroundColor: Colors.redAccent),
//       );
//     }
//   }

//   Future<void> _confirmDeletePayment(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     final orderId = _string(
//       doc.data()['orderId'] ?? doc.data()['orderNumber'],
//       fallback: doc.id,
//     );
//     if (!await _confirmDelete(
//       'Delete Payment Record?',
//       'The payment information for order $orderId will be cleared, but the order itself will remain.',
//     )) return;

//     try {
//       await doc.reference.update({
//         'paymentStatus': 'Pending',
//         'paymentMethod': FieldValue.delete(),
//         'paymentDate': FieldValue.delete(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Payment record deleted successfully.')),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to delete payment record: $e'), backgroundColor: Colors.redAccent),
//       );
//     }
//   }

//   // ============================================================
//   // ORDER DETAILS
//   // ============================================================
// void _showOrderDetails(
//   QueryDocumentSnapshot<Map<String, dynamic>> doc,
// ) {
//   final data = doc.data();

//   final orderId = _string(
//     data['orderId'] ?? data['orderNumber'],
//     fallback: doc.id,
//   );

//   final customer = _string(
//     data['customerName'],
//     fallback: 'Customer',
//   );

//   final customerId = _string(
//     data['customerId'],
//     fallback: 'Not available',
//   );

//   final email = _string(
//     data['customerEmail'] ?? data['email'],
//     fallback: 'Not available',
//   );

//   final phone = _string(
//     data['customerPhone'] ?? data['phone'],
//     fallback: 'Not available',
//   );

//   final address = _string(
//     data['customerAddress'] ??
//         data['address'] ??
//         data['deliveryAddress'] ??
//         data['pickupAddress'],
//     fallback: 'Not available',
//   );

//   final service = _string(
//     data['service'],
//     fallback: 'Not available',
//   );

//   final selectedClothes = _selectedClothesText(data);

//   final status = _string(
//     data['status'],
//     fallback: 'Order Received',
//   );

//   final payment = _string(
//     data['paymentStatus'],
//     fallback: 'Pending',
//   );

//   final amount = _number(
//     data['totalAmount'],
//   );

//   showDialog(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: Text(orderId),

//         content: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment:
//                 CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               _dialogInfo(
//                 'Customer',
//                 customer,
//               ),

//               _dialogInfo(
//                 'Customer ID',
//                 customerId,
//               ),

//               _dialogInfo(
//                 'Email',
//                 email,
//               ),

//               _dialogInfo(
//                 'Phone',
//                 phone,
//               ),

//               _dialogInfo(
//                 'Address',
//                 address,
//               ),

//               _dialogInfo(
//                 'Service',
//                 service,
//               ),

//               _dialogInfo(
//                 'Selected Clothes',
//                 selectedClothes,
//               ),

//               _dialogInfo(
//                 'Amount',
//                 '₹${amount.toStringAsFixed(0)}',
//               ),

//               _dialogInfo(
//                 'Order Status',
//                 status,
//               ),

//               _dialogInfo(
//                 'Payment Status',
//                 payment,
//               ),
//             ],
//           ),
//         ),

//         actions: [
//           TextButton(
//             onPressed: () =>
//                 Navigator.pop(context),
//             child: const Text('Close'),
//           ),

//           ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primary,
//               foregroundColor: Colors.white,
//             ),
//             onPressed: () {
//               Navigator.pop(context);
//               _changeOrderStatus(doc);
//             },
//             child: const Text('Update Status'),
//           ),
//         ],
//       );
//     },
//   );
// }

//   // ============================================================
//   // DIALOG INFO
//   // ============================================================

//   Widget _dialogInfo(
//     String title,
//     String value,
//   ) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(bottom: 12),
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: grayText,
//               fontSize: 12,
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             value.isEmpty
//                 ? 'Not available'
//                 : value,
//             style: const TextStyle(
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // CHANGE ORDER STATUS
//   // ============================================================

//   Future<void> _changeOrderStatus(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     String selectedStatus =
//         _string(
//       doc.data()['status'],
//       fallback: 'Order Received',
//     );

//     final statuses = [
//       'Order Received',
//       'Ironing Started',
//       'Clothes Ready',
//       'Customer Collected',
//     ];

//     final result =
//         await showDialog<String>(
//       context: context,
//       builder: (context) {
//         String value = selectedStatus;

//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return AlertDialog(
//               title:
//                   const Text('Update Order Status'),

//               content:
//                   DropdownButtonFormField<String>(
//                 value: statuses.contains(value)
//                     ? value
//                     : statuses.first,
//                 decoration:
//                     const InputDecoration(
//                   labelText: 'Order Status',
//                   border:
//                       OutlineInputBorder(),
//                 ),
//                 items: statuses
//                     .map(
//                       (status) =>
//                           DropdownMenuItem(
//                         value: status,
//                         child:
//                             Text(status),
//                       ),
//                     )
//                     .toList(),
//                 onChanged: (newValue) {
//                   if (newValue != null) {
//                     setDialogState(() {
//                       value = newValue;
//                     });
//                   }
//                 },
//               ),

//               actions: [
//                 TextButton(
//                   onPressed: () =>
//                       Navigator.pop(context),
//                   child:
//                       const Text('Cancel'),
//                 ),

//                 ElevatedButton(
//                   style:
//                       ElevatedButton.styleFrom(
//                     backgroundColor:
//                         primary,
//                     foregroundColor:
//                         Colors.white,
//                   ),
//                   onPressed: () =>
//                       Navigator.pop(
//                     context,
//                     value,
//                   ),
//                   child:
//                       const Text('Save'),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );

//     if (result == null ||
//         result == selectedStatus) {
//       return;
//     }

//     try {
//       await db
//           .collection('orders')
//           .doc(doc.id)
//           .update({
//         'status': result,
//         'updatedAt':
//             FieldValue.serverTimestamp(),
//       });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         const SnackBar(
//           content:
//               Text('Order status updated.'),
//           backgroundColor: primary,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         SnackBar(
//           content: Text(
//             'Unable to update order: $e',
//           ),
//           backgroundColor:
//               Colors.redAccent,
//         ),
//       );
//     }
//   }

//   // ============================================================
//   // CONFIRM PAYMENT
//   // ============================================================

//   Future<void> _confirmPayment(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) async {
//     try {
//       final data = doc.data();
//       final customerId = _string(data['customerId']);
//       final customerName = _string(data['customerName'], fallback: 'Customer');
//       final orderId = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);

//       await db.collection('orders').doc(doc.id).update({
//         'paymentStatus': 'Paid',
//         'paymentDate': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//       });

//       // Notify the customer immediately that the owner confirmed payment.
//       if (customerId.isNotEmpty) {
//         await db.collection('notifications').add({
//           'targetRole': 'customer',
//           'type': 'payment_confirmed',
//           'title': 'Payment Confirmed',
//           'message': 'Payment for order $orderId has been confirmed.',
//           'customerId': customerId,
//           'orderId': orderId,
//           'createdAt': FieldValue.serverTimestamp(),
//           'read': false,
//         });
//       }

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Payment confirmed for $customerName.'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;

//       ScaffoldMessenger.of(context)
//           .showSnackBar(
//         SnackBar(
//           content: Text(
//             'Unable to confirm payment: $e',
//           ),
//           backgroundColor:
//               Colors.redAccent,
//         ),
//       );
//     }
//   }

//   // ============================================================
//   // PRICE ADD
//   // ============================================================

//   void _showAddPriceDialog() {
//     final itemController =
//         TextEditingController();

//     final serviceController =
//         TextEditingController();

//     final priceController =
//         TextEditingController();

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title:
//               const Text('Add Price'),

//           content: Column(
//             mainAxisSize:
//                 MainAxisSize.min,
//             children: [
//               TextField(
//                 controller:
//                     itemController,
//                 decoration:
//                     const InputDecoration(
//                   labelText: 'Item / Clothing',
//                 ),
//               ),

//               const SizedBox(height: 12),

//               TextField(
//                 controller:
//                     serviceController,
//                 decoration:
//                     const InputDecoration(
//                   labelText: 'Service',
//                 ),
//               ),

//               const SizedBox(height: 12),

//               TextField(
//                 controller:
//                     priceController,
//                 keyboardType:
//                     TextInputType.number,
//                 decoration:
//                     const InputDecoration(
//                   labelText: 'Price',
//                 ),
//               ),
//             ],
//           ),

//           actions: [
//             TextButton(
//               onPressed: () =>
//                   Navigator.pop(context),
//               child:
//                   const Text('Cancel'),
//             ),

//             ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(
//                 backgroundColor: primary,
//                 foregroundColor:
//                     Colors.white,
//               ),
//               onPressed: () async {
//                 final item =
//                     itemController.text.trim();

//                 final service =
//                     serviceController.text.trim();

//                 final price =
//                     double.tryParse(
//                   priceController.text
//                       .trim(),
//                 );

//                 if (item.isEmpty ||
//                     service.isEmpty ||
//                     price == null) {
//                   return;
//                 }

//                 try {
//                   await db
//                       .collection('prices')
//                       .add({
//                     'name': item,
//                     'itemName': item,
//                     'service': service,
//                     'price': price,
//                     'createdAt':
//                         FieldValue
//                             .serverTimestamp(),
//                   });

//                   if (context.mounted) {
//                     Navigator.pop(context);
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(
//                       context,
//                     ).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'Unable to save price: $e',
//                         ),
//                       ),
//                     );
//                   }
//                 }
//               },
//               child:
//                   const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ============================================================
//   // EDIT PRICE
//   // ============================================================

//   void _showEditPriceDialog(
//     QueryDocumentSnapshot<Map<String, dynamic>> doc,
//   ) {
//     final data = doc.data();

//     final controller =
//         TextEditingController(
//       text: _number(data['price'])
//           .toStringAsFixed(0),
//     );

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title:
//               const Text('Edit Price'),

//           content: TextField(
//             controller: controller,
//             keyboardType:
//                 TextInputType.number,
//             decoration:
//                 const InputDecoration(
//               labelText: 'Price',
//               prefixText: '₹ ',
//             ),
//           ),

//           actions: [
//             TextButton(
//               onPressed: () =>
//                   Navigator.pop(context),
//               child:
//                   const Text('Cancel'),
//             ),

//             ElevatedButton(
//               style:
//                   ElevatedButton.styleFrom(
//                 backgroundColor: primary,
//                 foregroundColor:
//                     Colors.white,
//               ),
//               onPressed: () async {
//                 final price =
//                     double.tryParse(
//                   controller.text.trim(),
//                 );

//                 if (price == null) return;

//                 try {
//                   await db
//                       .collection('prices')
//                       .doc(doc.id)
//                       .update({
//                     'price': price,
//                     'updatedAt':
//                         FieldValue
//                             .serverTimestamp(),
//                   });

//                   if (context.mounted) {
//                     Navigator.pop(context);
//                   }
//                 } catch (e) {
//                   if (context.mounted) {
//                     ScaffoldMessenger.of(
//                       context,
//                     ).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'Unable to update price: $e',
//                         ),
//                       ),
//                     );
//                   }
//                 }
//               },
//               child:
//                   const Text('Update'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // ============================================================
//   // OWNER PROFILE
//   // ============================================================

//   void _showOwnerProfile() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
//       builder: (context) {
//         final image = ownerProfileImageBase64;
//         final name = ownerNameController.text.trim().isEmpty ? 'WashEasy Owner' : ownerNameController.text.trim();
//         return SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
//           CircleAvatar(radius: 34, backgroundColor: lightOrange, backgroundImage: image != null && image.isNotEmpty ? MemoryImage(base64Decode(image)) : null, child: image == null || image.isEmpty ? const Icon(Icons.person, color: primary, size: 32) : null),
//           const SizedBox(height: 10),
//           Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//           const SizedBox(height: 15),
//           ListTile(leading: const Icon(Icons.person_outline, color: primary), title: const Text('Owner Details'), onTap: () { Navigator.pop(context); setState(() => selectedIndex = 9); }),
//           ListTile(leading: const Icon(Icons.settings_outlined, color: primary), title: const Text('Settings'), onTap: () { Navigator.pop(context); setState(() => selectedIndex = 8); }),
//           ListTile(
//              leading: const Icon(Icons.logout, color: Colors.redAccent),
//              title: const Text('Logout'),
//              onTap: () {
//                Navigator.pop(context);
//                _logout();
//              },
//            ),
//         ])));
//       },
//     );
//   }

//   // ============================================================
//   // OWNER INFORMATION
//   // ============================================================

//   void showOwnerInformation() {
//     showDialog(context: context, builder: (_) => AlertDialog(
//       title: const Text('Owner Profile'),
//       content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         _dialogInfo('Owner Name', ownerNameController.text),
//         _dialogInfo('Address', ownerAddressController.text),
//         _dialogInfo('Contact Number', ownerPhoneController.text),
//         _dialogInfo('Email', ownerEmailController.text),
//         _dialogInfo('Business', businessNameController.text),
//         _dialogInfo('Business Address', businessAddressController.text),
//         _dialogInfo('Business Contact', businessPhoneController.text),
//         _dialogInfo('Business Email', businessEmailController.text),
//       ])),
//       actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
//     ));
//   }

//   // ============================================================
//   // NOTIFICATIONS POPUP
//   // ============================================================

//   void _showNotifications() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape:
//           const RoundedRectangleBorder(
//         borderRadius:
//             BorderRadius.vertical(
//           top: Radius.circular(22),
//         ),
//       ),
//       builder: (context) {
//         return SizedBox(
//           height:
//               MediaQuery.of(context)
//                       .size
//                       .height *
//                   .65,
//           child: Column(
//             children: [
//               const Padding(
//                 padding:
//                     EdgeInsets.all(20),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.notifications,
//                       color: primary,
//                     ),
//                     SizedBox(width: 10),
//                     Text(
//                       'Notifications',
//                       style: TextStyle(
//                         fontWeight:
//                             FontWeight.bold,
//                         fontSize: 19,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const Divider(height: 1),

//               Expanded(
//                 child:
//                     _notificationStream(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // NOTIFICATION STREAM
//   // ============================================================

//   Widget _notificationStream() {
//     return StreamBuilder<
//         QuerySnapshot<Map<String, dynamic>>>(
//       stream:
//           db.collection('notifications').snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return const Center(
//             child: Text(
//               'Unable to load notifications.',
//             ),
//           );
//         }

//         if (snapshot.connectionState ==
//             ConnectionState.waiting) {
//           return _loading();
//         }

//         final docs =
//             snapshot.data?.docs ?? [];

//         if (docs.isEmpty) {
//           return const Center(
//             child: Padding(
//               padding:
//                   EdgeInsets.all(25),
//               child: Text(
//                 'No notifications yet.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: grayText,
//                 ),
//               ),
//             ),
//           );
//         }

//         return ListView(
//           padding:
//               const EdgeInsets.all(15),
//           children: docs.map((doc) {
//             final data = doc.data();

//             return _eventNotification(
//               Icons.notifications_none,
//               _string(
//                 data['title'],
//                 fallback: 'Notification',
//               ),
//               _string(data['message']),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }

//   // ============================================================
//   // EVENT NOTIFICATION
//   // ============================================================

//   Widget _eventNotification(
//     IconData icon,
//     String title,
//     String message,
//   ) {
//     return Container(
//       margin:
//           const EdgeInsets.only(bottom: 12),
//       padding:
//           const EdgeInsets.all(15),
//       decoration: BoxDecoration(
//         color: lightOrange,
//         borderRadius:
//             BorderRadius.circular(13),
//       ),
//       child: Row(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 42,
//             height: 42,
//             decoration:
//                 const BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               icon,
//               color: primary,
//             ),
//           ),

//           const SizedBox(width: 12),

//           Expanded(
//             child: Column(
//               crossAxisAlignment:
//                   CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight:
//                         FontWeight.bold,
//                   ),
//                 ),

//                 const SizedBox(height: 4),

//                 Text(
//                   message,
//                   style: const TextStyle(
//                     color: grayText,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SETTINGS CARD
//   // ============================================================

//   Widget _settingsCard({
//     required IconData icon,
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding:
//           const EdgeInsets.all(20),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment:
//             CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: lightOrange,
//                   borderRadius:
//                       BorderRadius.circular(11),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: primary,
//                 ),
//               ),

//               const SizedBox(width: 12),

//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 17,
//                   fontWeight:
//                       FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 20),

//           ...children,
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // SETTINGS ROW
//   // ============================================================

//   Widget _settingsRow(
//     String title,
//     String value,
//   ) {
//     return Padding(
//       padding:
//           const EdgeInsets.only(bottom: 15),
//       child: Row(
//         children: [
//           Expanded(
//             child: Text(
//               title,
//               style: const TextStyle(
//                 color: grayText,
//               ),
//             ),
//           ),
//           Text(
//             value,
//             style: const TextStyle(
//               fontWeight:
//                   FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ============================================================
//   // LOGOUT
//   // ============================================================

//   void _logout() {
//     if (widget.onLogout != null) {
//       widget.onLogout!();
//       return;
//     }

//     if (!mounted) return;
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Logout is not connected to the login screen. Please add the onLogout callback in main.dart.'),
//       ),
//     );
//   }

//   // ============================================================
//   // FIRESTORE VALUE HELPERS
//   // ============================================================

//   Widget washEasyLogoBox({double size = 48}) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         width: size,
//         height: size,
//         color: Colors.white,
//         padding: const EdgeInsets.all(4),
//         child: Image.asset('assets/images/washeasy_logo.png', fit: BoxFit.contain),
//       ),
//     );
//   }

//   String _selectedClothesText(Map<String, dynamic> data) {
//     final items = data['items'];
//     if (items is List && items.isNotEmpty) {
//       final parts = <String>[];
//       for (final item in items) {
//         if (item is Map) {
//           final name = _string(item['name'] ?? item['itemName'] ?? item['cloth'] ?? item['clothes'] ?? item['service'], fallback: 'Clothes');
//           final qty = _number(item['quantity'] ?? item['qty'] ?? item['count'] ?? item['clothesQuantity']).toInt();
//           parts.add(qty > 0 ? '$name × $qty' : name);
//         }
//       }
//       if (parts.isNotEmpty) return parts.join(', ');
//     }
//     final service = _string(data['service'], fallback: 'Clothes');
//     final qty = _clothesCount(data);
//     return '$service × $qty';
//   }

//   int _clothesCount(Map<String, dynamic> data) {
//     final direct = data['quantity'] ?? data['clothesQuantity'] ?? data['clothesQty'] ?? data['numberOfClothes'] ?? data['qty'];
//     if (direct != null) return _number(direct).toInt();
//     final items = data['items'];
//     if (items is List) {
//       var total = 0;
//       for (final item in items) {
//         if (item is Map) {
//           total += _number(item['quantity'] ?? item['qty'] ?? item['clothesQuantity'] ?? item['count']).toInt();
//         }
//       }
//       return total;
//     }
//     return 0;
//   }

//   Future<void> _updateDeliveryStatus(QueryDocumentSnapshot<Map<String, dynamic>> doc, String status) async {
//     try {
//       await doc.reference.update({
//         'deliveryStatus': status,
//         'updatedAt': FieldValue.serverTimestamp(),
//       });
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delivery status updated to $status.')));
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to update delivery status: $e'), backgroundColor: Colors.redAccent));
//     }
//   }

//   Widget _pendingPaymentsSection(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
//     return _sectionCard(
//       title: 'Pending Payments',
//       action: '${docs.length} Pending',
//       child: docs.isEmpty
//           ? _emptyState(Icons.check_circle_outline, 'No pending payments', 'All customer payments are paid.')
//           : Column(
//               children: docs.map((doc) {
//                 final data = doc.data();
//                 final name = _string(data['customerName'], fallback: 'Customer');
//                 final id = _string(data['customerId']);
//                 final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
//                 final amount = _number(data['totalAmount']);
//                 return ListTile(
//                   contentPadding: EdgeInsets.zero,
//                   leading: CircleAvatar(backgroundColor: lightOrange, child: const Icon(Icons.person_outline, color: primary)),
//                   title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
//                   subtitle: Text('${id.isEmpty ? '' : '$id • '}$order'),
//                   trailing: Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: primary)),
//                 );
//               }).toList(),
//             ),
//     );
//   }

//   String _string(
//     dynamic value, {
//     String fallback = '',
//   }) {
//     if (value == null) return fallback;

//     final result = value.toString().trim();

//     return result.isEmpty
//         ? fallback
//         : result;
//   }

//   double _number(dynamic value) {
//     if (value is num) {
//       return value.toDouble();
//     }

//     if (value is String) {
//       return double.tryParse(value) ?? 0;
//     }

//     return 0;
//   }

//   DateTime? _date(dynamic value) {
//     if (value == null) return null;

//     if (value is Timestamp) {
//       return value.toDate();
//     }

//     if (value is DateTime) {
//       return value;
//     }

//     if (value is String) {
//       return DateTime.tryParse(value);
//     }

//     return null;
//   }

//   bool _isToday(DateTime date) {
//     final now = DateTime.now();

//     return date.year == now.year &&
//         date.month == now.month &&
//         date.day == now.day;
//   }

//   String _formatDate(DateTime? date) {
//     if (date == null) {
//       return 'Not available';
//     }

//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec',
//     ];

//     return '${date.day} '
//         '${months[date.month - 1]} '
//         '${date.year}';
//   }
// }

// class _OwnerChatDialog extends StatefulWidget {
//   final FirebaseFirestore db;
//   final String customerId;
//   final String customerName;

//   const _OwnerChatDialog({
//     required this.db,
//     required this.customerId,
//     required this.customerName,
//   });

//   @override
//   State<_OwnerChatDialog> createState() => _OwnerChatDialogState();
// }

// class _OwnerChatDialogState extends State<_OwnerChatDialog> {
//   final controller = TextEditingController();
//   bool sending = false;

//   CollectionReference<Map<String, dynamic>> get _messages =>
//       widget.db
//           .collection('chats')
//           .doc(widget.customerId)
//           .collection('messages');

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   DateTime _date(dynamic value) {
//     if (value is Timestamp) return value.toDate();
//     return DateTime.fromMillisecondsSinceEpoch(0);
//   }

//   Future<void> _send() async {
//     final text = controller.text.trim();
//     if (text.isEmpty || sending) return;

//     setState(() => sending = true);
//     try {
//       await _messages.add({
//         'senderId': 'OWNER001',
//         'senderName': 'Owner',
//         'senderRole': 'owner',
//         'message': text,
//         'createdAt': FieldValue.serverTimestamp(),
//         'read': false,
//       });

//       await widget.db.collection('notifications').add({
//         'targetRole': 'customer',
//         'type': 'owner_message',
//         'title': 'Message from Owner',
//         'message': text,
//         'customerId': widget.customerId,
//         'createdAt': FieldValue.serverTimestamp(),
//         'read': false,
//       });

//       controller.clear();
//     } on FirebaseException catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Reply failed: ${e.message ?? e.code}')),
//         );
//       }
//     } finally {
//       if (mounted) setState(() => sending = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Chat with ${widget.customerName}'),
//       content: SizedBox(
//         width: 520,
//         height: 430,
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                 stream: _messages.snapshots(),
//                 builder: (context, snap) {
//                   if (snap.hasError) {
//                     return Center(child: Text('Chat error: ${snap.error}'));
//                   }
//                   if (snap.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final docs = [...?snap.data?.docs];
//                   docs.sort((a, b) =>
//                       _date(a.data()['createdAt']).compareTo(
//                         _date(b.data()['createdAt']),
//                       ));

//                   if (docs.isEmpty) {
//                     return const Center(child: Text('No messages yet.'));
//                   }

//                   return ListView.builder(
//                     itemCount: docs.length,
//                     itemBuilder: (_, i) {
//                       final d = docs[i].data();
//                       final owner = d['senderRole'] == 'owner';
//                       return Align(
//                         alignment: owner
//                             ? Alignment.centerRight
//                             : Alignment.centerLeft,
//                         child: Container(
//                           constraints: const BoxConstraints(maxWidth: 380),
//                           margin: const EdgeInsets.only(bottom: 8),
//                           padding: const EdgeInsets.all(11),
//                           decoration: BoxDecoration(
//                             color: owner ? const Color(0xFFFF6B00) : Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Text(
//                             '${d['message'] ?? ''}',
//                             style: TextStyle(
//                               color: owner ? Colors.white : const Color(0xFF17213D),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     minLines: 1,
//                     maxLines: 3,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a reply...',
//                       border: OutlineInputBorder(),
//                     ),
//                     onSubmitted: (_) => _send(),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   onPressed: sending ? null : _send,
//                   style: IconButton.styleFrom(
//                     backgroundColor: const Color(0xFFFF6B00),
//                     foregroundColor: Colors.white,
//                   ),
//                   icon: sending
//                       ? const SizedBox(
//                           width: 18,
//                           height: 18,
//                           child: CircularProgressIndicator(
//                             strokeWidth: 2,
//                             color: Colors.white,
//                           ),
//                         )
//                       : const Icon(Icons.send),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Close'),
//         ),
//       ],
//     );
//   }
// }












import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class OwnerModule extends StatefulWidget {
  final VoidCallback? onLogout;

  const OwnerModule({super.key, this.onLogout});

  @override
  State<OwnerModule> createState() => _OwnerModuleState();
}

class _OwnerModuleState extends State<OwnerModule> {
  // ============================================================
  // CONSTANTS
  // ============================================================

  static const Color primary = Color(0xFFFF6B00);
  static const Color lightOrange = Color(0xFFFFF3E0);
  static const Color background = Color(0xFFF5F7FB);
  static const Color darkText = Color(0xFF17213D);
  static const Color grayText = Color(0xFF7B8494);

  // Light section/card colors
  static const Color orderCardColor = Color(0xFFFFF8F0);
  static const Color customerCardColor = Color(0xFFF3F8FF);
  static const Color deliveryCardColor = Color(0xFFF1FBF7);
  static const Color paymentCardColor = Color(0xFFFFF4F4);
  static const Color billCardColor = Color(0xFFF8F5FF);
  static const Color customerNotificationColor = Color(0xFFF3F8FF);
  static const Color orderNotificationColor = Color(0xFFFFF8F0);
  static const Color paymentNotificationColor = Color(0xFFFFF4F4);
  static const Color deliveryNotificationColor = Color(0xFFF1FBF7);
  static const Color otherNotificationColor = Color(0xFFF7F7F7);

  final FirebaseFirestore db = FirebaseFirestore.instance;

  int selectedIndex = 0;

  String searchText = '';

  final TextEditingController searchController =
      TextEditingController();

  final List<String> menuItems = [
    'Dashboard',
    'Orders',
    'Customers',
    'Services & Prices',
    'Deliveries',
    'Payments',
    'Bills',
    'Notifications',
    'Settings',
    'Owner Details',
  ];

  final List<IconData> menuIcons = [
    Icons.dashboard_outlined,
    Icons.shopping_bag_outlined,
    Icons.people_outline,
    Icons.price_change_outlined,
    Icons.local_shipping_outlined,
    Icons.payment_outlined,
    Icons.receipt_long_outlined,
    Icons.notifications_none,
    Icons.settings_outlined,
    Icons.person_outline,
  ];

  final ImagePicker _imagePicker = ImagePicker();

  final ownerNameController = TextEditingController();
  final ownerAddressController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final ownerEmailController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessAddressController = TextEditingController();
  final businessPhoneController = TextEditingController();
  final businessEmailController = TextEditingController();
  final websiteController = TextEditingController();
  final workingHoursController = TextEditingController();

  String? ownerProfileImageBase64;
  bool ownerDetailsLoading = false;
  bool ownerDetailsSaving = false;

  @override
  void initState() {
    super.initState();
    _loadOwnerDetails();
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    ownerNameController.dispose();
    ownerAddressController.dispose();
    ownerPhoneController.dispose();
    ownerEmailController.dispose();
    businessNameController.dispose();
    businessAddressController.dispose();
    businessPhoneController.dispose();
    businessEmailController.dispose();
    websiteController.dispose();
    workingHoursController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool mobile = width < 850;

    return Scaffold(
      backgroundColor: background,

      drawer: mobile ? _buildMobileDrawer() : null,

      body: Row(
        children: [
          if (!mobile) _buildSidebar(),

          Expanded(
            child: Column(
              children: [
                _buildTopBar(mobile),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/owner_dashboard_bg.jpeg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      color: Colors.white.withOpacity(.76),
                      child: _buildPage(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SIDEBAR
  // ============================================================

  Widget _buildSidebar() {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 25),

          _buildLogo(),

          const SizedBox(height: 35),

          Expanded(
            child: ListView.builder(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return _buildMenuItem(index);
              },
            ),
          ),

          _buildOwnerBottomProfile(),
        ],
      ),
    );
  }

  // ============================================================
  // MOBILE DRAWER
  // ============================================================

  Widget _buildMobileDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            _buildLogo(),

            const SizedBox(height: 25),

            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (context, index) {
                  return _buildMenuItem(index, closeDrawer: true);
                },
              ),
            ),

            _buildOwnerBottomProfile(),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Image.asset(
              'assets/images/washeasy_logo.png',
              width: 44,
              height: 44,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.local_laundry_service,
                    color: Colors.white,
                    size: 25,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: 10),

          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Wash',
                  style: TextStyle(color: Color(0xFF1565C0)),
                ),
                TextSpan(
                  text: 'Easy',
                  style: TextStyle(color: primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _buildMenuItem(
    int index, {
    bool closeDrawer = false,
  }) {
    final selected = selectedIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      child: ListTile(
        onTap: () {
          setState(() {
            selectedIndex = index;
            searchController.clear();
            searchText = '';
          });

          if (closeDrawer) {
            Navigator.pop(context);
          }
        },

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11),
        ),

        tileColor:
            selected ? primary : Colors.transparent,

        leading: Icon(
          menuIcons[index],
          color: selected
              ? Colors.white
              : const Color(0xFF687385),
        ),

        title: Text(
          menuItems[index],
          style: TextStyle(
            color: selected
                ? Colors.white
                : const Color(0xFF424B57),
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // OWNER BOTTOM PROFILE
  // ============================================================

  Widget _buildOwnerBottomProfile() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _showOwnerProfile,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: lightOrange,
                  shape: BoxShape.circle,
                ),
                child: ownerProfileImageBase64 != null && ownerProfileImageBase64!.isNotEmpty
                    ? ClipOval(child: Image.memory(base64Decode(ownerProfileImageBase64!), fit: BoxFit.cover))
                    : const Icon(Icons.person, color: primary),
              ),

              const SizedBox(width: 10),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Owner',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar(bool mobile) {
    return Container(
      height: 76,
      padding: EdgeInsets.symmetric(
        horizontal: mobile ? 15 : 30,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),
      ),
      child: Row(
        children: [
          if (mobile)
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),

          Expanded(
            child: Text(
              menuItems[selectedIndex],
              style: TextStyle(
                fontSize: mobile ? 19 : 22,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
          ),

          if (!mobile)
            SizedBox(
              width: 280,
              height: 43,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchText = value.trim().toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon:
                      const Icon(Icons.search),
                  filled: true,
                  fillColor: background,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(11),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

          const SizedBox(width: 12),

          // NOTIFICATION
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFE0E0E0),
              ),
              borderRadius: BorderRadius.circular(11),
            ),
            child: IconButton(
              tooltip: 'Notifications',
              icon: const Icon(
                Icons.notifications_none,
              ),
              onPressed: _showNotifications,
            ),
          ),

          const SizedBox(width: 10),

          // OWNER PROFILE
          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: _showOwnerProfile,
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: lightOrange,
                    shape: BoxShape.circle,
                  ),
                  child: ownerProfileImageBase64 != null && ownerProfileImageBase64!.isNotEmpty
                      ? ClipOval(child: Image.memory(base64Decode(ownerProfileImageBase64!), fit: BoxFit.cover))
                      : const Icon(Icons.person_outline, color: primary),
                ),

                if (!mobile) ...[
                  const SizedBox(width: 8),

                  const Text(
                    'Owner',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // MAIN PAGE
  // ============================================================

  Widget _buildPage() {
    switch (selectedIndex) {
      case 0:
        return _buildDashboard();

      case 1:
        return _buildOrdersPage();

      case 2:
        return _buildCustomersPage();

      case 3:
        return _buildServicesPage();

      case 4:
        return _buildDeliveriesPage();

      case 5:
        return _buildPaymentsPage();

      case 6:
        return _buildBillsPage();

      case 7:
        return _buildNotificationsPage();

      case 8:
        return _buildSettingsPage();

      case 9:
        return _buildOwnerDetailsPage();

      default:
        return _buildDashboard();
    }
  }

  // ============================================================
  // DASHBOARD
  // ============================================================

  Widget _buildDashboard() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage(
            'Unable to load dashboard data.',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loading();
        }

        final orders = snapshot.data?.docs ?? [];

        final newOrders = orders.where((doc) {
          final status =
              _string(doc.data()['status']);

          final normalized = status.toLowerCase();
          return normalized == 'new' || normalized == 'order received';
        }).length;

        final inProgress = orders.where((doc) {
          final status =
              _string(doc.data()['status']);

          final normalized = status.toLowerCase();
          return normalized == 'in progress' || normalized == 'ironing started' || normalized == 'processing' || normalized == 'iron started';
        }).length;

        final ready = orders.where((doc) {
          final status =
              _string(doc.data()['status']);

          final normalized = status.toLowerCase();
          return normalized == 'ready' || normalized == 'clothes ready';
        }).length;

        final pendingDeliveries =
            orders.where((doc) {
          final data = doc.data();
          final status =
              _string(data['status']);

          final deliveryStatus = _string(data['deliveryStatus'], fallback: 'Delivery Pending').toLowerCase();
          return deliveryStatus != 'delivery done' && status.toLowerCase() != 'customer collected' && status.toLowerCase() != 'completed';
        }).length;

        final todayDeliveries =
            orders.where((doc) {
          final date =
              _date(doc.data()['pickupDate']);

          return date != null &&
              _isToday(date);
        }).length;

        final pendingPayments = orders.where((doc) {
          return _string(doc.data()['paymentStatus'], fallback: 'Pending').toLowerCase() != 'paid';
        }).toList();

        final pendingPaymentCustomers = pendingPayments.length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _pageHeader(
                'Owner Dashboard',
                'Manage your laundry business from one place.',
                Icons.dashboard_outlined,
              ),

              const SizedBox(height: 25),

              LayoutBuilder(
                builder: (context, constraints) {
                  int columns;

                  if (constraints.maxWidth > 1100) {
                    columns = 3;
                  } else if (constraints.maxWidth > 650) {
                    columns = 2;
                  } else {
                    columns = 1;
                  }

                  return GridView.count(
                    crossAxisCount: columns,
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 2.6,
                    children: [
                      _summaryCard(
                        'New Orders',
                        '$newOrders',
                        Icons.shopping_bag_outlined,
                        primary,
                      ),
                      _summaryCard(
                        'Orders In Progress',
                        '$inProgress',
                        Icons.pending_actions_outlined,
                        Colors.deepOrange,
                      ),
                      _summaryCard(
                        'Ready for Delivery',
                        '$ready',
                        Icons.check_circle_outline,
                        Colors.green,
                      ),
                      _summaryCard(
                        'Pending Deliveries',
                        '$pendingDeliveries',
                        Icons.local_shipping_outlined,
                        Colors.deepPurple,
                      ),
                      _summaryCard(
                        "Today's Deliveries",
                        '$todayDeliveries',
                        Icons.delivery_dining_outlined,
                        Colors.teal,
                      ),
                      _summaryCard(
                        'Pending Payments',
                        '$pendingPaymentCustomers',
                        Icons.account_balance_wallet_outlined,
                        Colors.redAccent,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              _pendingPaymentsSection(pendingPayments),

              const SizedBox(height: 25),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 850) {
                    return Column(
                      children: [
                        _recentOrders(orders),
                        const SizedBox(height: 20),
                        _todayDeliveries(orders),
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _recentOrders(orders),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child:
                            _todayDeliveries(orders),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // RECENT ORDERS
  // ============================================================

  Widget _recentOrders(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        orders,
  ) {
    final sorted =
        List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(
      orders,
    );

    sorted.sort((a, b) {
      final da =
          _date(a.data()['createdAt']) ??
              _date(a.data()['orderDate']) ??
              DateTime(2000);

      final dbb =
          _date(b.data()['createdAt']) ??
              _date(b.data()['orderDate']) ??
              DateTime(2000);

      return dbb.compareTo(da);
    });

    return _sectionCard(
      title: 'Recent Orders',
      action: '${orders.length} Total',
      child: sorted.isEmpty
          ? _emptyState(
              Icons.shopping_bag_outlined,
              'No orders yet',
              'Orders placed by customers will appear here.',
            )
          : Column(
              children: sorted
                  .take(8)
                  .map(
                    (doc) => _orderTile(
                      doc,
                      clickable: true,
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // ============================================================
  // TODAY DELIVERIES
  // ============================================================

  Widget _todayDeliveries(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        orders,
  ) {
    final today = orders.where((doc) {
      final date =
          _date(doc.data()['pickupDate']);

      return date != null && _isToday(date);
    }).toList();

    return _sectionCard(
      title: "Today's Deliveries",
      action: '${today.length}',
      child: today.isEmpty
          ? _emptyState(
              Icons.local_shipping_outlined,
              'No deliveries',
              'No pickup or delivery is scheduled today.',
            )
          : Column(
              children: today
                  .take(6)
                  .map(
                    (doc) => _orderTile(
                      doc,
                      clickable: true,
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // ============================================================
  // ORDERS PAGE
  // ============================================================

  Widget _buildOrdersPage() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage(
            'Unable to load orders. Please check your Firestore connection.',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loading();
        }

        var docs = snapshot.data?.docs ?? [];

        docs = docs.where((doc) {
          if (searchText.isEmpty) return true;

          final data = doc.data();

          final order =
              _string(data['orderId'] ??
                  data['orderNumber']);

          final customer =
              _string(data['customerName']);

          final customerId =
              _string(data['customerId']);

          return order
                  .toLowerCase()
                  .contains(searchText) ||
              customer
                  .toLowerCase()
                  .contains(searchText) ||
              customerId
                  .toLowerCase()
                  .contains(searchText);
        }).toList();

        docs.sort((a, b) {
          final da =
              _date(a.data()['createdAt']) ??
                  _date(a.data()['orderDate']) ??
                  DateTime(2000);

          final dbb =
              _date(b.data()['createdAt']) ??
                  _date(b.data()['orderDate']) ??
                  DateTime(2000);

          return dbb.compareTo(da);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _washEasyLogoBox(size: 50),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orders', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: darkText)),
                        SizedBox(height: 4),
                        Text('View and manage customer orders.', style: TextStyle(color: grayText, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              if (docs.isEmpty)
                _emptyCard(
                  Icons.shopping_bag_outlined,
                  searchText.isEmpty
                      ? 'No orders found'
                      : 'No matching orders',
                  searchText.isEmpty
                      ? 'Customer orders will appear here automatically.'
                      : 'Try another customer name, ID or order number.',
                )
              else
                ...docs.map(
                  (doc) => _largeOrderCard(doc),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // LARGE ORDER CARD
  // ============================================================

  Widget _largeOrderCard(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final orderId =
        _string(data['orderId'] ??
            data['orderNumber'],
            fallback: doc.id);

    final customer =
        _string(data['customerName'],
            fallback: 'Customer');

    final customerId =
        _string(data['customerId']);

    final email =
        _string(data['customerEmail'] ?? data['email']);

    final phone = _string(data['customerPhone'] ?? data['phone'], fallback: 'Not available');
    final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'], fallback: 'Not available');
    final selectedClothes = _selectedClothesText(data);

    final service =
        _string(data['service'],
            fallback: 'Laundry Service');

    final quantity = _clothesCount(data);

    final amount =
        _number(data['totalAmount']);

    final status =
        _string(data['status'],
            fallback: 'Order Received');

    final payment =
        _string(data['paymentStatus'],
            fallback: 'Pending');

    final orderDate =
        _date(data['orderDate']) ??
            _date(data['createdAt']);

    final pickupDate =
        _date(data['pickupDate']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(color: orderCardColor),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius:
                      BorderRadius.circular(13),
                ),
                child: _washEasyLogoBox(size: 50),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderId,
                      style: const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer,
                      style: const TextStyle(
                        color: grayText,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(status),
            ],
          ),

          const Divider(height: 30),

          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 650) {
                return Column(
                  children: [
                    _infoRow(
                      Icons.badge_outlined,
                      'Customer ID',
                      customerId,
                    ),
                    _infoRow(
                      Icons.email_outlined,
                      'Email',
                      email,
                    ),
                    _infoRow(
                      Icons.local_laundry_service_outlined,
                      'Service',
                      service,
                    ),
                    _infoRow(Icons.phone_outlined, 'Phone', phone),
                    _infoRow(Icons.location_on_outlined, 'Address', address),
                    _infoRow(Icons.checkroom_outlined, 'Selected Clothes', selectedClothes),
                    _infoRow(
                      Icons.checkroom_outlined,
                      'Clothes',
                      '$quantity',
                    ),
                    _infoRow(
                      Icons.calendar_today_outlined,
                      'Order Date',
                      _formatDate(orderDate),
                    ),
                    _infoRow(
                      Icons.event_outlined,
                      'Pickup',
                      _formatDate(pickupDate),
                    ),
                    _infoRow(
                      Icons.currency_rupee,
                      'Total',
                      '₹${amount.toStringAsFixed(0)}',
                    ),
                    _infoRow(
                      Icons.payment_outlined,
                      'Payment',
                      payment,
                    ),
                  ],
                );
              }

              return Wrap(
                spacing: 30,
                runSpacing: 18,
                children: [
                  _infoBlock(
                    'Customer ID',
                    customerId,
                  ),
                  _infoBlock(
                    'Email',
                    email,
                  ),
                  _infoBlock('Service', service),
                  _infoBlock('Phone', phone),
                  _infoBlock('Address', address),
                  _infoBlock('Clothes', '$quantity'),
                  _infoBlock('Selected Clothes', selectedClothes),
                  _infoBlock(
                    'Order Date',
                    _formatDate(orderDate),
                  ),
                  _infoBlock(
                    'Pickup',
                    _formatDate(pickupDate),
                  ),
                  _infoBlock(
                    'Total',
                    '₹${amount.toStringAsFixed(0)}',
                  ),
                  _infoBlock(
                    'Payment',
                    payment,
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showOrderDetails(doc),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('View Details'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _changeOrderStatus(doc),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Update Status'),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                tooltip: 'Delete order',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDeleteOrder(doc),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CUSTOMERS PAGE
  // ============================================================

  Widget _buildCustomersPage() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('users').where('role', isEqualTo: 'customer').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _errorPage('Unable to load customers. Please check Firestore permissions.');
        if (snapshot.connectionState == ConnectionState.waiting) return _loading();

        var customers = snapshot.data?.docs ?? [];
        customers = customers.where((doc) {
          if (searchText.isEmpty) return true;
          final data = doc.data();
          final name = _string(data['name']).toLowerCase();
          final id = _string(data['customerId']).toLowerCase();
          final email = _string(data['email']).toLowerCase();
          return name.contains(searchText) || id.contains(searchText) || email.contains(searchText);
        }).toList();
        customers.sort((a, b) => _string(a.data()['name']).toLowerCase().compareTo(_string(b.data()['name']).toLowerCase()));

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: db.collection('orders').snapshots(),
          builder: (context, orderSnapshot) {
            final orders = orderSnapshot.data?.docs ?? [];
            return SingleChildScrollView(
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _pageHeader('Customers', 'View and manage registered WashEasy customers.', Icons.people_outline)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(color: lightOrange, borderRadius: BorderRadius.circular(12)),
                        child: Text('Total Customers: ${customers.length}', style: const TextStyle(color: primary, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  if (customers.isEmpty)
                    _emptyCard(Icons.people_outline, searchText.isEmpty ? 'No Customers data' : 'No matching customers', searchText.isEmpty ? 'Customer information will appear here after registration.' : 'Try another customer name, ID or email.')
                  else
                    ...customers.map((customerDoc) {
                      final customer = customerDoc.data();
                      final customerId = _string(customer['customerId']);
                      final customerEmail = _string(customer['email']).toLowerCase();
                      final customerName = _string(customer['name']).toLowerCase();
                      final orderCount = orders.where((order) {
                        final od = order.data();
                        return _string(od['customerId']) == customerId ||
                            _string(od['customerEmail'] ?? od['email']).toLowerCase() == customerEmail ||
                            _string(od['customerName']).toLowerCase() == customerName;
                      }).length;
                      return _customerCard(customerDoc, orderCount);
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // CUSTOMER CARD
  // ============================================================

  Widget _customerCard(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
    int orderCount,
  ) {
    final customer = doc.data();
    final name = _string(customer['name'], fallback: 'Customer');
    final id = _string(customer['customerId']);
    final email = _string(customer['email']);
    final phone = _string(customer['phone'], fallback: 'Not provided');
    final created = _date(customer['createdAt']);
    final status = _string(customer['status'], fallback: 'Active');

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(color: customerCardColor),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: lightOrange,
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'C',
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Delete customer',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDeleteCustomer(doc),
              ),
            ],
          ),
          const Divider(height: 28),
          Wrap(
            spacing: 30,
            runSpacing: 12,
            children: [
              _infoBlock('Customer ID', id),
              _infoBlock('Email', email),
              _infoBlock('Phone', phone),
              _infoBlock('Orders', '$orderCount'),
              _infoBlock('Registered', _formatDate(created)),
              _infoBlock('Status', status),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SERVICES & PRICES
  // ============================================================

  Widget _buildServicesPage() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('prices').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage(
            'Unable to load prices.',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loading();
        }

        final docs =
            snapshot.data?.docs ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _pageHeader(
                      'Services & Prices',
                      'Manage laundry services and prices.',
                      Icons.price_change_outlined,
                    ),
                  ),

                  ElevatedButton.icon(
                    onPressed: _showAddPriceDialog,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      foregroundColor:
                          Colors.white,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label:
                        const Text('Add Price'),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              if (docs.isEmpty)
                _emptyCard(
                  Icons.price_change_outlined,
                  'No prices found',
                  'Add prices using the existing Price Management module.',
                )
              else
                ...docs.map(
                  (doc) => _priceCard(doc),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PRICE CARD
  // ============================================================

  Widget _priceCard(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final item =
        _string(data['name'] ??
            data['itemName'],
            fallback: doc.id);

    final service =
        _string(data['service'],
            fallback: 'Service');

    final price =
        _number(data['price']);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.price_change_outlined,
              color: primary,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Services & Prices • $service',
                  style: const TextStyle(
                    color: grayText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '₹${price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: primary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 15),

          IconButton(
            tooltip: 'Edit price',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditPriceDialog(doc),
          ),
          IconButton(
            tooltip: 'Delete price',
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDeletePrice(doc),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // DELIVERIES
  // ============================================================

  Widget _buildDeliveriesPage() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _errorPage('Unable to load delivery data.');
        if (snapshot.connectionState == ConnectionState.waiting) return _loading();

        final deliveries = (snapshot.data?.docs ?? []).where((doc) {
          return _date(doc.data()['pickupDate']) != null;
        }).toList();

        deliveries.sort((a, b) {
          final da = _date(a.data()['pickupDate']) ?? DateTime(9999);
          final dbb = _date(b.data()['pickupDate']) ?? DateTime(9999);
          return da.compareTo(dbb);
        });

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pageHeader('Deliveries', 'Track customer pickups and deliveries.', Icons.local_shipping_outlined),
              const SizedBox(height: 25),
              if (deliveries.isEmpty)
                _emptyCard(Icons.local_shipping_outlined, 'No deliveries', 'Delivery information will appear here.')
              else
                ...deliveries.map((doc) => _deliveryCard(doc)),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // DELIVERY CARD

  Widget _deliveryCard(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
    final customer = _string(data['customerName'], fallback: 'Customer');
    final customerId = _string(data['customerId']);
    final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'] ?? data['pickupAddress'], fallback: 'Address not provided');
    final date = _date(data['pickupDate']);
    final deliveryStatus = _string(data['deliveryStatus'], fallback: 'Delivery Pending');
    final payment = _string(data['paymentStatus'], fallback: 'Pending');

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(color: deliveryCardColor),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.local_shipping_outlined, color: primary),
          const SizedBox(width: 12),
          Expanded(child: Text(order, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          PopupMenuButton<String>(
            tooltip: 'Update delivery status',
            onSelected: (value) => _updateDeliveryStatus(doc, value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Delivery Pending', child: Text('Delivery Pending')),
              PopupMenuItem(value: 'Delivery Done', child: Text('Delivery Done')),
            ],
            child: _statusBadge(deliveryStatus),
          ),
        ]),
        const Divider(height: 25),
        Wrap(spacing: 30, runSpacing: 15, children: [
          _infoBlock('Customer', customer),
          _infoBlock('Customer ID', customerId),
          _infoBlock('Pickup / Delivery', _formatDate(date)),
          _infoBlock('Address', address),
          _infoBlock('Payment', payment),
        ]),
      ]),
    );
  }

  // ============================================================
  // PAYMENTS
  // ============================================================

  Widget _buildPaymentsPage() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _errorPage(
            'Unable to load payment information.',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loading();
        }

        final docs =
            snapshot.data?.docs ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _pageHeader(
                'Payments',
                'View and confirm customer payments.',
                Icons.payment_outlined,
              ),

              const SizedBox(height: 25),

              if (docs.isEmpty)
                _emptyCard(
                  Icons.payment_outlined,
                  'No payment records',
                  'Payment information will appear with customer orders.',
                )
              else
                ...docs.map(
                  (doc) => _paymentCard(doc),
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // PAYMENT CARD
  // ============================================================

  Widget _paymentCard(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    final order = _string(
      data['orderId'] ?? data['orderNumber'],
      fallback: doc.id,
    );
    final bill = _string(
      data['billNo'] ?? data['billNumber'],
      fallback: 'Not available',
    );
    final customer = _string(data['customerName'], fallback: 'Customer');
    final customerId = _string(data['customerId']);
    final amount = _number(data['totalAmount']);
    final status = _string(data['paymentStatus'], fallback: 'Pending');
    final date = _date(data['paymentDate']);
    final paid = status.toLowerCase() == 'paid';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(color: paymentCardColor),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: paid ? Colors.green.withOpacity(.10) : Colors.red.withOpacity(.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  paid ? Icons.check_circle_outline : Icons.pending_outlined,
                  color: paid ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(customer, style: const TextStyle(color: grayText)),
                  ],
                ),
              ),
              _paymentBadge(status),
              IconButton(
                tooltip: 'Delete payment record',
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: () => _confirmDeletePayment(doc),
              ),
            ],
          ),
          const Divider(height: 28),
          Wrap(
            spacing: 30,
            runSpacing: 15,
            children: [
              _infoBlock('Customer ID', customerId),
              _infoBlock('Bill', bill),
              _infoBlock('Amount', '₹${amount.toStringAsFixed(0)}'),
              _infoBlock('Payment Date', _formatDate(date)),
            ],
          ),
          if (!paid) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _confirmPayment(doc),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Confirm Payment'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ============================================================
  // BILLS
  // ============================================================

  Widget _buildBillsPage() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _errorPage('Unable to load bills.');
        if (snapshot.connectionState == ConnectionState.waiting) return _loading();
        final docs = snapshot.data?.docs ?? [];
        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pageHeader('Bills', 'View each customer bill from their orders.', Icons.receipt_long_outlined),
              const SizedBox(height: 25),
              if (docs.isEmpty)
                _emptyCard(Icons.receipt_long_outlined, 'No bills found', 'Customer bills will appear here after orders are placed.')
              else
                ...docs.map((doc) => _billCard(doc)),
            ],
          ),
        );
      },
    );
  }

  Widget _billCard(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
    final bill = _string(data['billNo'] ?? data['billNumber'], fallback: 'Bill-${doc.id.substring(0, doc.id.length > 6 ? 6 : doc.id.length)}');
    final customer = _string(data['customerName'], fallback: 'Customer');
    final customerId = _string(data['customerId']);
    final email = _string(data['customerEmail'] ?? data['email'], fallback: 'Not available');
    final phone = _string(data['customerPhone'] ?? data['phone'], fallback: 'Not available');
    final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'], fallback: 'Not available');
    final amount = _number(data['totalAmount']);
    final payment = _string(data['paymentStatus'], fallback: 'Pending');
    final quantity = _clothesCount(data);
    final items = _selectedClothesText(data);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(color: billCardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _washEasyLogoBox(size: 48),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(bill, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 3),
              Text('$customer • $order', style: const TextStyle(color: grayText)),
            ])),
            Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: primary, fontSize: 17)),
          ]),
          const Divider(height: 28),
          Wrap(spacing: 30, runSpacing: 14, children: [
            _infoBlock('Customer ID', customerId),
            _infoBlock('Email', email),
            _infoBlock('Phone', phone),
            _infoBlock('Address', address),
            _infoBlock('Clothes', '$quantity'),
            _infoBlock('Items', items),
            _infoBlock('Payment', payment),
          ]),
          const SizedBox(height: 18),
          Align(alignment: Alignment.centerRight, child: OutlinedButton.icon(onPressed: () => _showBillDetails(doc), icon: const Icon(Icons.visibility_outlined), label: const Text('View Bill'))),
        ],
      ),
    );
  }

  void _showBillDetails(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final customer = _string(data['customerName'], fallback: 'Customer');
    final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
    final bill = _string(data['billNo'] ?? data['billNumber'], fallback: 'Not available');
    final amount = _number(data['totalAmount']);
    final email = _string(data['customerEmail'] ?? data['email'], fallback: 'Not available');
    final phone = _string(data['customerPhone'] ?? data['phone'], fallback: 'Not available');
    final address = _string(data['customerAddress'] ?? data['address'] ?? data['deliveryAddress'], fallback: 'Not available');
    final items = _selectedClothesText(data);
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Row(children: [_washEasyLogoBox(size: 42), const SizedBox(width: 10), const Text('Customer Bill')]),
      content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _dialogInfo('Bill No.', bill), _dialogInfo('Order No.', order), _dialogInfo('Customer', customer), _dialogInfo('Email', email), _dialogInfo('Phone', phone), _dialogInfo('Address', address), _dialogInfo('Items', items), _dialogInfo('Total', '₹${amount.toStringAsFixed(0)}'), _dialogInfo('Payment', _string(data['paymentStatus'], fallback: 'Pending')),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ));
  }

  // ============================================================
  // NOTIFICATIONS PAGE
  // ============================================================

  Widget _buildNotificationsPage() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('notifications').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return _notificationFallback();
        if (snapshot.connectionState == ConnectionState.waiting) return _loading();

        final docs = snapshot.data?.docs ?? [];
        final customer = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final orders = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final payments = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final deliveries = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
        final other = <QueryDocumentSnapshot<Map<String, dynamic>>>[];

        for (final doc in docs) {
          switch (_notificationCategory(doc.data())) {
            case 'customer':
              customer.add(doc);
              break;
            case 'orders':
              orders.add(doc);
              break;
            case 'payments':
              payments.add(doc);
              break;
            case 'deliveries':
              deliveries.add(doc);
              break;
            default:
              other.add(doc);
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _pageHeader(
                'Notifications Dashboard',
                'Notifications are separated into individual sections for easy management.',
                Icons.notifications_none,
              ),
              const SizedBox(height: 25),
              LayoutBuilder(
                builder: (context, constraints) {
                  final double cardWidth = constraints.maxWidth >= 850
                      ? (constraints.maxWidth - 18) / 2
                      : constraints.maxWidth;

                  return Wrap(
                    spacing: 18,
                    runSpacing: 18,
                    children: [
                      SizedBox(
                        width: cardWidth,
                        child: _notificationSection(
                          'Customer Notifications',
                          Icons.people_outline,
                          customer,
                          customerNotificationColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _notificationSection(
                          'Order Notifications',
                          Icons.shopping_bag_outlined,
                          orders,
                          orderNotificationColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _notificationSection(
                          'Payment Notifications',
                          Icons.payment_outlined,
                          payments,
                          paymentNotificationColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _notificationSection(
                          'Delivery Notifications',
                          Icons.local_shipping_outlined,
                          deliveries,
                          deliveryNotificationColor,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth,
                        child: _notificationSection(
                          'Other Notifications',
                          Icons.notifications_none,
                          other,
                          otherNotificationColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (docs.isEmpty) ...[
                const SizedBox(height: 18),
                _notificationFallback(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _notificationSection(
    String title,
    IconData icon,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
    Color sectionColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(color: sectionColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${docs.length}',
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (docs.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 18),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'No notifications in this section.',
                textAlign: TextAlign.center,
                style: TextStyle(color: grayText, fontSize: 12),
              ),
            )
          else
            ...docs.map(_notificationCard),
        ],
      ),
    );
  }

  String _notificationCategory(Map<String, dynamic> data) {
    final type = _string(data['type']).toLowerCase();
    final title = _string(data['title']).toLowerCase();
    final message = _string(data['message']).toLowerCase();
    final combined = '$type $title $message';

    if (combined.contains('payment') || combined.contains('paid')) return 'payments';
    if (combined.contains('delivery') || combined.contains('pickup') || combined.contains('collected')) return 'deliveries';
    if (type.contains('customer_message') || type.contains('owner_message') || combined.contains('customer message') || combined.contains('message from')) return 'customer';
    if (combined.contains('order') || combined.contains('ironing') || combined.contains('clothes ready') || combined.contains('order received')) return 'orders';
    return 'other';
  }

  Widget _notificationFallback() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('orders').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return _loading();
        final orders = snapshot.data?.docs ?? [];
        final recent = orders.take(10).toList();
        if (recent.isEmpty) {
          return _emptyCard(
            Icons.notifications_none,
            'No notifications',
            'Notifications will appear when customers place orders or payments change.',
          );
        }
        return Column(
          children: recent.map((doc) {
            final data = doc.data();
            final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
            final customer = _string(data['customerName'], fallback: 'Customer');
            final status = _string(data['status'], fallback: 'Order Received');
            return _eventNotification(Icons.shopping_bag_outlined, 'Order $order', '$customer — $status');
          }).toList(),
        );
      },
    );
  }

  Widget _notificationCard(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final title = _string(data['title'], fallback: 'WashEasy Notification');
    final message = _string(data['message'], fallback: 'No message available.');
    final customerId = _string(data['customerId']);
    final customerName = _notificationCustomerName(data, message);
    final type = _string(data['type']).toLowerCase();
    final orderId = _string(data['orderId'] ?? data['orderNumber']);
    final isCustomerMessage = type == 'customer_message' && customerId.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: const Color(0xFFE8E8E8)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius: BorderRadius.circular(11),
          ),
          child: const Icon(Icons.notifications_none, color: primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: darkText),
        ),
        subtitle: Text(
          customerName,
          style: const TextStyle(color: grayText, fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Delete notification',
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              onPressed: () => _confirmDeleteNotification(doc),
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              message,
              style: const TextStyle(color: grayText, fontSize: 13),
            ),
          ),
          if (orderId.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Order: $orderId',
                style: const TextStyle(color: darkText, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          if (isCustomerMessage) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: () => _openCustomerChat(customerId, customerName),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                icon: const Icon(Icons.reply, size: 17),
                label: const Text('Reply to Customer'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _notificationCustomerName(Map<String, dynamic> data, String message) {
    final stored = _string(data['customerName']);
    if (stored.isNotEmpty) return stored;
    final colon = message.indexOf(':');
    if (colon > 0) return message.substring(0, colon).trim();
    return 'Customer';
  }

  Future<void> _openCustomerChat(String customerId, String customerName) async {
    await showDialog<void>(
      context: context,
      builder: (_) => _OwnerChatDialog(
        db: db,
        customerId: customerId,
        customerName: customerName,
      ),
    );
  }

  // ============================================================
  // OWNER DETAILS
  // ============================================================

  Widget _buildOwnerDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _pageHeader('Owner Details', 'Add and manage owner, business and profile information.', Icons.person_outline),
        const SizedBox(height: 25),
        _ownerProfileEditor(),
      ]),
    );
  }

  Widget _ownerProfileEditor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: _cardDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Column(children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: lightOrange,
              backgroundImage: ownerProfileImageBase64 != null && ownerProfileImageBase64!.isNotEmpty ? MemoryImage(base64Decode(ownerProfileImageBase64!)) : null,
              child: ownerProfileImageBase64 == null || ownerProfileImageBase64!.isEmpty ? const Icon(Icons.person, color: primary, size: 48) : null,
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(onPressed: _pickOwnerProfilePicture, icon: const Icon(Icons.camera_alt_outlined), label: const Text('Add / Change Profile Picture')),
          ]),
        ),
        const SizedBox(height: 22),
        _ownerField(ownerNameController, 'Owner Name', Icons.person_outline),
        _ownerField(ownerAddressController, 'Owner Address', Icons.location_on_outlined),
        _ownerField(ownerPhoneController, 'Contact Number', Icons.phone_outlined, keyboardType: TextInputType.phone),
        _ownerField(ownerEmailController, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        _ownerField(businessNameController, 'Business Name', Icons.storefront_outlined),
        _ownerField(businessAddressController, 'Business Address', Icons.location_city_outlined),
        _ownerField(businessPhoneController, 'Business Contact Number', Icons.call_outlined, keyboardType: TextInputType.phone),
        _ownerField(businessEmailController, 'Business Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
        _ownerField(websiteController, 'Website / Social Link', Icons.language_outlined),
        _ownerField(workingHoursController, 'Working Hours', Icons.access_time_outlined),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: ownerDetailsSaving ? null : _saveOwnerDetails, style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)), icon: ownerDetailsSaving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.save_outlined), label: Text(ownerDetailsSaving ? 'Saving...' : 'Save Owner Information'))),
      ]),
    );
  }

  Widget _ownerField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(padding: const EdgeInsets.only(bottom: 14), child: TextField(controller: controller, keyboardType: keyboardType, decoration: InputDecoration(prefixIcon: Icon(icon, color: primary), labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: primary, width: 1.5)))));
  }

  Future<void> _loadOwnerDetails() async {
    setState(() => ownerDetailsLoading = true);
    try {
      final snap = await db.collection('ownerDetails').doc('OWNER001').get();
      final d = snap.data();
      if (d != null) {
        ownerNameController.text = _string(d['ownerName'], fallback: 'WashEasy Owner');
        ownerAddressController.text = _string(d['ownerAddress']);
        ownerPhoneController.text = _string(d['ownerPhone']);
        ownerEmailController.text = _string(d['ownerEmail']);
        businessNameController.text = _string(d['businessName'], fallback: 'WashEasy Laundry');
        businessAddressController.text = _string(d['businessAddress']);
        businessPhoneController.text = _string(d['businessPhone']);
        businessEmailController.text = _string(d['businessEmail']);
        websiteController.text = _string(d['website']);
        workingHoursController.text = _string(d['workingHours']);
        ownerProfileImageBase64 = _string(d['profileImage']);
      } else {
        ownerNameController.text = 'WashEasy Owner';
        businessNameController.text = 'WashEasy Laundry';
      }
    } catch (_) {}
    if (mounted) setState(() => ownerDetailsLoading = false);
  }

  Future<void> _pickOwnerProfilePicture() async {
    try {
      final file = await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 70, maxWidth: 800, maxHeight: 800);
      if (file == null) return;
      final bytes = await file.readAsBytes();
      if (bytes.length > 700 * 1024) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please choose a smaller profile picture.')));
        return;
      }
      setState(() => ownerProfileImageBase64 = base64Encode(bytes));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to select profile picture: $e')));
    }
  }

  Future<void> _saveOwnerDetails() async {
    setState(() => ownerDetailsSaving = true);
    try {
      await db.collection('ownerDetails').doc('OWNER001').set({
        'ownerId': 'OWNER001',
        'ownerName': ownerNameController.text.trim(),
        'ownerAddress': ownerAddressController.text.trim(),
        'ownerPhone': ownerPhoneController.text.trim(),
        'ownerEmail': ownerEmailController.text.trim(),
        'businessName': businessNameController.text.trim(),
        'businessAddress': businessAddressController.text.trim(),
        'businessPhone': businessPhoneController.text.trim(),
        'businessEmail': businessEmailController.text.trim(),
        'website': websiteController.text.trim(),
        'workingHours': workingHoursController.text.trim(),
        'profileImage': ownerProfileImageBase64 ?? '',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Owner information saved successfully.')));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to save owner information: $e'), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => ownerDetailsSaving = false);
    }
  }

  // ============================================================
  // SETTINGS
  // ============================================================

  Widget _buildSettingsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _pageHeader(
            'Settings',
            'Manage Owner and WashEasy settings.',
            Icons.settings_outlined,
          ),

          const SizedBox(height: 25),

          _settingsCard(
            icon: Icons.person_outline,
            title: 'Owner Information',
            children: [
              _settingsRow(
                'Owner Name',
                'WashEasy Owner',
              ),
              _settingsRow(
                'Owner ID',
                'OWNER001',
              ),
              _settingsRow(
                'Role',
                'Owner',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _settingsCard(
            icon: Icons.storefront_outlined,
            title: 'Business Information',
            children: [
              _settingsRow(
                'Business',
                'WashEasy Laundry',
              ),
              _settingsRow(
                'System',
                'Laundry & Ironing Management',
              ),
            ],
          ),

          const SizedBox(height: 18),

          _settingsCard(
            icon: Icons.security_outlined,
            title: 'Account',
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.redAccent,
                    foregroundColor:
                        Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                    ),
                  ),
                  icon: const Icon(
                    Icons.logout,
                  ),
                  label:
                      const Text('Logout'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PAGE HEADER
  // ============================================================

  Widget _pageHeader(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: lightOrange,
            borderRadius:
                BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: primary,
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                style: const TextStyle(
                  color: grayText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _summaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              color: color.withOpacity(.10),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: color,
              size: 27,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: grayText,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDER TILE
  // ============================================================

  Widget _orderTile(
    QueryDocumentSnapshot<Map<String, dynamic>> doc, {
    bool clickable = false,
  }) {
    final data = doc.data();

    final orderId =
        _string(data['orderId'] ??
            data['orderNumber'],
            fallback: doc.id);

    final customer =
        _string(data['customerName'],
            fallback: 'Customer');

    final customerId =
        _string(data['customerId']);

    final service =
        _string(data['service'],
            fallback: 'Laundry');

    final amount =
        _number(data['totalAmount']);

    final status =
        _string(data['status'],
            fallback: 'Order Received');

    final child = Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 13,
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: lightOrange,
              borderRadius:
                  BorderRadius.circular(11),
            ),
            child: _washEasyLogoBox(size: 45),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  orderId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  customerId.isEmpty
                      ? customer
                      : '$customer ($customerId)',
                  style: const TextStyle(
                    color: grayText,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  service,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Text(
                '₹${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              _statusBadge(status),
            ],
          ),
        ],
      ),
    );

    if (!clickable) {
      return child;
    }

    return InkWell(
      onTap: () => _showOrderDetails(doc),
      borderRadius:
          BorderRadius.circular(10),
      child: child,
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(String status) {
    Color color;

    switch (status.toLowerCase()) {
      case 'ready':
      case 'clothes ready':
        color = Colors.green;
        break;

      case 'in progress':
      case 'ironing started':
        color = Colors.orange;
        break;

      case 'customer collected':
      case 'completed':
        color = Colors.blueGrey;
        break;

      default:
        color = primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.10),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // PAYMENT BADGE
  // ============================================================

  Widget _paymentBadge(String status) {
    final paid =
        status.toLowerCase() == 'paid';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: (paid
                ? Colors.green
                : Colors.orange)
            .withOpacity(.10),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color:
              paid ? Colors.green : Colors.orange,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required String action,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              Text(
                action,
                style: const TextStyle(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // INFO BLOCK
  // ============================================================

  Widget _infoBlock(
    String title,
    String value,
  ) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: grayText,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? 'Not available' : value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO ROW
  // ============================================================

  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: primary,
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(
                color: grayText,
                fontSize: 12,
              ),
            ),
          ),

          Expanded(
            child: Text(
              value.isEmpty
                  ? 'Not available'
                  : value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY CARD
  // ============================================================

  Widget _emptyCard(
    IconData icon,
    String title,
    String message,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.symmetric(
        vertical: 65,
        horizontal: 25,
      ),
      decoration: _cardDecoration(),
      child: _emptyState(
        icon,
        title,
        message,
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyState(
    IconData icon,
    String title,
    String message,
  ) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: background,
              borderRadius:
                  BorderRadius.circular(17),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF94A3B8),
              size: 31,
            ),
          ),

          const SizedBox(height: 15),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 7),

          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: grayText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _errorPage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 50,
            ),

            const SizedBox(height: 15),

            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LOADING
  // ============================================================

  Widget _loading() {
    return const Center(
      child: CircularProgressIndicator(
        color: primary,
      ),
    );
  }

  // ============================================================
  // CARD DECORATION
  // ============================================================

  BoxDecoration _cardDecoration({Color color = Colors.white}) {
    return BoxDecoration(
      color: color,
      borderRadius:
          BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  // ============================================================
  // DELETE CONFIRMATION HELPERS
  // ============================================================

  Future<bool> _confirmDelete(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
    return result == true;
  }

  Future<void> _confirmDeleteOrder(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final orderId = _string(
      doc.data()['orderId'] ?? doc.data()['orderNumber'],
      fallback: doc.id,
    );
    if (!await _confirmDelete(
      'Delete Order?',
      'Order $orderId will be permanently deleted from Firestore.',
    )) return;

    try {
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Order deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to delete order: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _confirmDeleteCustomer(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final name = _string(doc.data()['name'], fallback: 'this customer');
    final customerId = _string(doc.data()['customerId']);
    if (!await _confirmDelete(
      'Delete Customer?',
      'Delete $name from the WashEasy customer list? This removes the customer document from Firestore.',
    )) return;

    try {
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Customer $customerId deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to delete customer: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _confirmDeletePrice(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final name = _string(doc.data()['name'] ?? doc.data()['itemName'], fallback: doc.id);
    if (!await _confirmDelete(
      'Delete Price?',
      'Delete the price entry "$name" from Services & Prices?',
    )) return;

    try {
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Price deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to delete price: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _confirmDeleteNotification(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    if (!await _confirmDelete(
      'Delete Notification?',
      'This notification will be permanently removed.',
    )) return;

    try {
      await doc.reference.delete();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notification deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to delete notification: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _confirmDeletePayment(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final orderId = _string(
      doc.data()['orderId'] ?? doc.data()['orderNumber'],
      fallback: doc.id,
    );
    if (!await _confirmDelete(
      'Delete Payment Record?',
      'The payment information for order $orderId will be cleared, but the order itself will remain.',
    )) return;

    try {
      await doc.reference.update({
        'paymentStatus': 'Pending',
        'paymentMethod': FieldValue.delete(),
        'paymentDate': FieldValue.delete(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment record deleted successfully.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to delete payment record: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  // ============================================================
  // ORDER DETAILS
  // ============================================================
void _showOrderDetails(
  QueryDocumentSnapshot<Map<String, dynamic>> doc,
) {
  final data = doc.data();

  final orderId = _string(
    data['orderId'] ?? data['orderNumber'],
    fallback: doc.id,
  );

  final customer = _string(
    data['customerName'],
    fallback: 'Customer',
  );

  final customerId = _string(
    data['customerId'],
    fallback: 'Not available',
  );

  final email = _string(
    data['customerEmail'] ?? data['email'],
    fallback: 'Not available',
  );

  final phone = _string(
    data['customerPhone'] ?? data['phone'],
    fallback: 'Not available',
  );

  final address = _string(
    data['customerAddress'] ??
        data['address'] ??
        data['deliveryAddress'] ??
        data['pickupAddress'],
    fallback: 'Not available',
  );

  final service = _string(
    data['service'],
    fallback: 'Not available',
  );

  final selectedClothes = _selectedClothesText(data);

  final status = _string(
    data['status'],
    fallback: 'Order Received',
  );

  final payment = _string(
    data['paymentStatus'],
    fallback: 'Pending',
  );

  final amount = _number(
    data['totalAmount'],
  );

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(orderId),

        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogInfo(
                'Customer',
                customer,
              ),

              _dialogInfo(
                'Customer ID',
                customerId,
              ),

              _dialogInfo(
                'Email',
                email,
              ),

              _dialogInfo(
                'Phone',
                phone,
              ),

              _dialogInfo(
                'Address',
                address,
              ),

              _dialogInfo(
                'Service',
                service,
              ),

              _dialogInfo(
                'Selected Clothes',
                selectedClothes,
              ),

              _dialogInfo(
                'Amount',
                '₹${amount.toStringAsFixed(0)}',
              ),

              _dialogInfo(
                'Order Status',
                status,
              ),

              _dialogInfo(
                'Payment Status',
                payment,
              ),
            ],
          ),
        ),

        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context),
            child: const Text('Close'),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              _changeOrderStatus(doc);
            },
            child: const Text('Update Status'),
          ),
        ],
      );
    },
  );
}

  // ============================================================
  // DIALOG INFO
  // ============================================================

  Widget _dialogInfo(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: grayText,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value.isEmpty
                ? 'Not available'
                : value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHANGE ORDER STATUS
  // ============================================================

  Future<void> _changeOrderStatus(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    String selectedStatus =
        _string(
      doc.data()['status'],
      fallback: 'Order Received',
    );

    final statuses = [
      'Order Received',
      'Ironing Started',
      'Clothes Ready',
      'Customer Collected',
    ];

    final result =
        await showDialog<String>(
      context: context,
      builder: (context) {
        String value = selectedStatus;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text('Update Order Status'),

              content:
                  DropdownButtonFormField<String>(
                value: statuses.contains(value)
                    ? value
                    : statuses.first,
                decoration:
                    const InputDecoration(
                  labelText: 'Order Status',
                  border:
                      OutlineInputBorder(),
                ),
                items: statuses
                    .map(
                      (status) =>
                          DropdownMenuItem(
                        value: status,
                        child:
                            Text(status),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setDialogState(() {
                      value = newValue;
                    });
                  }
                },
              ),

              actions: [
                TextButton(
                  onPressed: () =>
                      Navigator.pop(context),
                  child:
                      const Text('Cancel'),
                ),

                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        primary,
                    foregroundColor:
                        Colors.white,
                  ),
                  onPressed: () =>
                      Navigator.pop(
                    context,
                    value,
                  ),
                  child:
                      const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == null ||
        result == selectedStatus) {
      return;
    }

    try {
      await db
          .collection('orders')
          .doc(doc.id)
          .update({
        'status': result,
        'updatedAt':
            FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Order status updated.'),
          backgroundColor: primary,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to update order: $e',
          ),
          backgroundColor:
              Colors.redAccent,
        ),
      );
    }
  }

  // ============================================================
  // CONFIRM PAYMENT
  // ============================================================

  Future<void> _confirmPayment(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    try {
      final data = doc.data();
      final customerId = _string(data['customerId']);
      final customerName = _string(data['customerName'], fallback: 'Customer');
      final orderId = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);

      await db.collection('orders').doc(doc.id).update({
        'paymentStatus': 'Paid',
        'paymentDate': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Notify the customer immediately that the owner confirmed payment.
      if (customerId.isNotEmpty) {
        await db.collection('notifications').add({
          'targetRole': 'customer',
          'type': 'payment_confirmed',
          'title': 'Payment Confirmed',
          'message': 'Payment for order $orderId has been confirmed.',
          'customerId': customerId,
          'orderId': orderId,
          'createdAt': FieldValue.serverTimestamp(),
          'read': false,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment confirmed for $customerName.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Unable to confirm payment: $e',
          ),
          backgroundColor:
              Colors.redAccent,
        ),
      );
    }
  }

  // ============================================================
  // PRICE ADD
  // ============================================================

  void _showAddPriceDialog() {
    final itemController =
        TextEditingController();

    final serviceController =
        TextEditingController();

    final priceController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Add Price'),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              TextField(
                controller:
                    itemController,
                decoration:
                    const InputDecoration(
                  labelText: 'Item / Clothing',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    serviceController,
                decoration:
                    const InputDecoration(
                  labelText: 'Service',
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller:
                    priceController,
                keyboardType:
                    TextInputType.number,
                decoration:
                    const InputDecoration(
                  labelText: 'Price',
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () async {
                final item =
                    itemController.text.trim();

                final service =
                    serviceController.text.trim();

                final price =
                    double.tryParse(
                  priceController.text
                      .trim(),
                );

                if (item.isEmpty ||
                    service.isEmpty ||
                    price == null) {
                  return;
                }

                try {
                  await db
                      .collection('prices')
                      .add({
                    'name': item,
                    'itemName': item,
                    'service': service,
                    'price': price,
                    'createdAt':
                        FieldValue
                            .serverTimestamp(),
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Unable to save price: $e',
                        ),
                      ),
                    );
                  }
                }
              },
              child:
                  const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // EDIT PRICE
  // ============================================================

  void _showEditPriceDialog(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();

    final controller =
        TextEditingController(
      text: _number(data['price'])
          .toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              const Text('Edit Price'),

          content: TextField(
            controller: controller,
            keyboardType:
                TextInputType.number,
            decoration:
                const InputDecoration(
              labelText: 'Price',
              prefixText: '₹ ',
            ),
          ),

          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () async {
                final price =
                    double.tryParse(
                  controller.text.trim(),
                );

                if (price == null) return;

                try {
                  await db
                      .collection('prices')
                      .doc(doc.id)
                      .update({
                    'price': price,
                    'updatedAt':
                        FieldValue
                            .serverTimestamp(),
                  });

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Unable to update price: $e',
                        ),
                      ),
                    );
                  }
                }
              },
              child:
                  const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // OWNER PROFILE
  // ============================================================

  void _showOwnerProfile() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(22))),
      builder: (context) {
        final image = ownerProfileImageBase64;
        final name = ownerNameController.text.trim().isEmpty ? 'WashEasy Owner' : ownerNameController.text.trim();
        return SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(radius: 34, backgroundColor: lightOrange, backgroundImage: image != null && image.isNotEmpty ? MemoryImage(base64Decode(image)) : null, child: image == null || image.isEmpty ? const Icon(Icons.person, color: primary, size: 32) : null),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 15),
          ListTile(leading: const Icon(Icons.person_outline, color: primary), title: const Text('Owner Details'), onTap: () { Navigator.pop(context); setState(() => selectedIndex = 9); }),
          ListTile(leading: const Icon(Icons.settings_outlined, color: primary), title: const Text('Settings'), onTap: () { Navigator.pop(context); setState(() => selectedIndex = 8); }),
          ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: const Text('Logout'), onTap: () { Navigator.pop(context); _logout(); }),
        ])));
      },
    );
  }

  // ============================================================
  // OWNER INFORMATION
  // ============================================================

  void showOwnerInformation() {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: const Text('Owner Profile'),
      content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _dialogInfo('Owner Name', ownerNameController.text),
        _dialogInfo('Address', ownerAddressController.text),
        _dialogInfo('Contact Number', ownerPhoneController.text),
        _dialogInfo('Email', ownerEmailController.text),
        _dialogInfo('Business', businessNameController.text),
        _dialogInfo('Business Address', businessAddressController.text),
        _dialogInfo('Business Contact', businessPhoneController.text),
        _dialogInfo('Business Email', businessEmailController.text),
      ])),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))],
    ));
  }

  // ============================================================
  // NOTIFICATIONS POPUP
  // ============================================================

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(22),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height:
              MediaQuery.of(context)
                      .size
                      .height *
                  .65,
          child: Column(
            children: [
              const Padding(
                padding:
                    EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications,
                      color: primary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              Expanded(
                child:
                    _notificationStream(),
              ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // NOTIFICATION STREAM
  // ============================================================

  Widget _notificationStream() {
    return StreamBuilder<
        QuerySnapshot<Map<String, dynamic>>>(
      stream:
          db.collection('notifications').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Unable to load notifications.',
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _loading();
        }

        final docs =
            snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return const Center(
            child: Padding(
              padding:
                  EdgeInsets.all(25),
              child: Text(
                'No notifications yet.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: grayText,
                ),
              ),
            ),
          );
        }

        return ListView(
          padding:
              const EdgeInsets.all(15),
          children: docs.map((doc) {
            final data = doc.data();

            return _eventNotification(
              Icons.notifications_none,
              _string(
                data['title'],
                fallback: 'Notification',
              ),
              _string(data['message']),
            );
          }).toList(),
        );
      },
    );
  }

  // ============================================================
  // EVENT NOTIFICATION
  // ============================================================

  Widget _eventNotification(
    IconData icon,
    String title,
    String message,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(bottom: 12),
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: lightOrange,
        borderRadius:
            BorderRadius.circular(13),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
                const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: primary,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  message,
                  style: const TextStyle(
                    color: grayText,
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

  // ============================================================
  // SETTINGS CARD
  // ============================================================

  Widget _settingsCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: lightOrange,
                  borderRadius:
                      BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: primary,
                ),
              ),

              const SizedBox(width: 12),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          ...children,
        ],
      ),
    );
  }

  // ============================================================
  // SETTINGS ROW
  // ============================================================

  Widget _settingsRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: grayText,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _logout() {
    if (widget.onLogout != null) {
      widget.onLogout!();
      return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout is not connected to the login screen. Please pass the onLogout callback from main.dart.'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  // ============================================================
  // FIRESTORE VALUE HELPERS
  // ============================================================

  Widget _washEasyLogoBox({double size = 48}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: Colors.white,
        padding: const EdgeInsets.all(4),
        child: Image.asset('assets/images/washeasy_logo.png', fit: BoxFit.contain),
      ),
    );
  }

  String _selectedClothesText(Map<String, dynamic> data) {
    final items = data['items'];
    if (items is List && items.isNotEmpty) {
      final parts = <String>[];
      for (final item in items) {
        if (item is Map) {
          final name = _string(item['name'] ?? item['itemName'] ?? item['cloth'] ?? item['clothes'] ?? item['service'], fallback: 'Clothes');
          final qty = _number(item['quantity'] ?? item['qty'] ?? item['count'] ?? item['clothesQuantity']).toInt();
          parts.add(qty > 0 ? '$name × $qty' : name);
        }
      }
      if (parts.isNotEmpty) return parts.join(', ');
    }
    final service = _string(data['service'], fallback: 'Clothes');
    final qty = _clothesCount(data);
    return '$service × $qty';
  }

  int _clothesCount(Map<String, dynamic> data) {
    final direct = data['quantity'] ?? data['clothesQuantity'] ?? data['clothesQty'] ?? data['numberOfClothes'] ?? data['qty'];
    if (direct != null) return _number(direct).toInt();
    final items = data['items'];
    if (items is List) {
      var total = 0;
      for (final item in items) {
        if (item is Map) {
          total += _number(item['quantity'] ?? item['qty'] ?? item['clothesQuantity'] ?? item['count']).toInt();
        }
      }
      return total;
    }
    return 0;
  }

  Future<void> _updateDeliveryStatus(QueryDocumentSnapshot<Map<String, dynamic>> doc, String status) async {
    try {
      await doc.reference.update({
        'deliveryStatus': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delivery status updated to $status.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Unable to update delivery status: $e'), backgroundColor: Colors.redAccent));
    }
  }

  Widget _pendingPaymentsSection(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    return _sectionCard(
      title: 'Pending Payments',
      action: '${docs.length} Pending',
      child: docs.isEmpty
          ? _emptyState(Icons.check_circle_outline, 'No pending payments', 'All customer payments are paid.')
          : Column(
              children: docs.map((doc) {
                final data = doc.data();
                final name = _string(data['customerName'], fallback: 'Customer');
                final id = _string(data['customerId']);
                final order = _string(data['orderId'] ?? data['orderNumber'], fallback: doc.id);
                final amount = _number(data['totalAmount']);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(backgroundColor: lightOrange, child: const Icon(Icons.person_outline, color: primary)),
                  title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('${id.isEmpty ? '' : '$id • '}$order'),
                  trailing: Text('₹${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: primary)),
                );
              }).toList(),
            ),
    );
  }

  String _string(
    dynamic value, {
    String fallback = '',
  }) {
    if (value == null) return fallback;

    final result = value.toString().trim();

    return result.isEmpty
        ? fallback
        : result;
  }

  double _number(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value) ?? 0;
    }

    return 0;
  }

  DateTime? _date(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return 'Not available';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}

class _OwnerChatDialog extends StatefulWidget {
  final FirebaseFirestore db;
  final String customerId;
  final String customerName;

  const _OwnerChatDialog({
    required this.db,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<_OwnerChatDialog> createState() => _OwnerChatDialogState();
}

class _OwnerChatDialogState extends State<_OwnerChatDialog> {
  final controller = TextEditingController();
  bool sending = false;

  CollectionReference<Map<String, dynamic>> get _messages =>
      widget.db
          .collection('chats')
          .doc(widget.customerId)
          .collection('messages');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  DateTime _date(dynamic value) {
    if (value is Timestamp) return value.toDate();
    return DateTime.fromMillisecondsSinceEpoch(0);
  }

  Future<void> _send() async {
    final text = controller.text.trim();
    if (text.isEmpty || sending) return;

    setState(() => sending = true);
    try {
      await _messages.add({
        'senderId': 'OWNER001',
        'senderName': 'Owner',
        'senderRole': 'owner',
        'message': text,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });

      await widget.db.collection('notifications').add({
        'targetRole': 'customer',
        'type': 'owner_message',
        'title': 'Message from Owner',
        'message': text,
        'customerId': widget.customerId,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });

      controller.clear();
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reply failed: ${e.message ?? e.code}')),
        );
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Chat with ${widget.customerName}'),
      content: SizedBox(
        width: 520,
        height: 430,
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: _messages.snapshots(),
                builder: (context, snap) {
                  if (snap.hasError) {
                    return Center(child: Text('Chat error: ${snap.error}'));
                  }
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = [...?snap.data?.docs];
                  docs.sort((a, b) =>
                      _date(a.data()['createdAt']).compareTo(
                        _date(b.data()['createdAt']),
                      ));

                  if (docs.isEmpty) {
                    return const Center(child: Text('No messages yet.'));
                  }

                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (_, i) {
                      final d = docs[i].data();
                      final owner = d['senderRole'] == 'owner';
                      return Align(
                        alignment: owner
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 380),
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(11),
                          decoration: BoxDecoration(
                            color: owner ? const Color(0xFFFF6B00) : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${d['message'] ?? ''}',
                            style: TextStyle(
                              color: owner ? Colors.white : const Color(0xFF17213D),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    minLines: 1,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Type a reply...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: sending ? null : _send,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B00),
                    foregroundColor: Colors.white,
                  ),
                  icon: sending
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
