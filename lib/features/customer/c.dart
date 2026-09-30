// ============================================================
// WASH EASY CUSTOMER MODULE
// Firestore-backed customer dashboard, orders, bills, chat,
// notifications and profile management.
// ============================================================

import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const List<String> laundryServices = [
  'Ironing',
  'Dry Cleaning',
  'Raffu',
  'Dying',
];

class ClothItem {
  final String name;
  final Map<String, double> rates;
  const ClothItem(this.name, this.rates);
}

final List<ClothItem> clothCatalog = [
  const ClothItem('Shirt', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Formal Pant', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Jeans', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('T-Shirt', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Hoodie', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Kurti', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Pajama', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Suit', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Saree', {'Ironing': 30, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Blouse', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Saree & Blouse', {'Ironing': 40, 'Dry Cleaning': 120, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Kurta', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Dupatta', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Trousers', {'Ironing': 20, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('School Uniform', {'Ironing': 20, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Bedsheets', {'Ironing': 30, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Pillow Cover', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Dhoti', {'Ironing': 30, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Shorts', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Table Cloth', {'Ironing': 9, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Blazer', {'Ironing': 35, 'Dry Cleaning': 60, 'Raffu': 180, 'Dying': 200}),
  const ClothItem('Coat Pant Set', {'Ironing': 35, 'Dry Cleaning': 150, 'Raffu': 180, 'Dying': 200}),
];

class OrderLineItem {
  final String name;
  final int quantity;
  final double lineTotal;

  const OrderLineItem({
    required this.name,
    required this.quantity,
    required this.lineTotal,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'quantity': quantity,
        'lineTotal': lineTotal,
      };

  factory OrderLineItem.fromMap(Map<String, dynamic> map) {
    return OrderLineItem(
      name: '${map['name'] ?? 'Item'}',
      quantity: _toInt(map['quantity']),
      lineTotal: _toDouble(map['lineTotal']),
    );
  }
}

class LaundryOrder {
  final String billNo;
  final String orderId;
  final DateTime orderDate;
  final String customerName;
  final String customerId;
  final String service;
  final List<OrderLineItem> items;
  final double totalAmount;
  final DateTime pickupDate;
  final DateTime returnDate;
  final String paymentStatus;
  final String status;
  final String notes;

  const LaundryOrder({
    required this.billNo,
    required this.orderId,
    required this.orderDate,
    required this.customerName,
    required this.customerId,
    required this.service,
    required this.items,
    required this.totalAmount,
    required this.pickupDate,
    required this.returnDate,
    required this.paymentStatus,
    required this.status,
    this.notes = '',
  });

  int get totalPieces => items.fold(0, (sum, item) => sum + item.quantity);

  factory LaundryOrder.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final rawItems = d['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map((e) => OrderLineItem.fromMap(Map<String, dynamic>.from(e)))
            .toList()
        : <OrderLineItem>[];

    return LaundryOrder(
      billNo: '${d['billNo'] ?? 'INV-${doc.id}'}',
      orderId: '${d['orderId'] ?? doc.id}',
      orderDate: _toDate(d['orderDate']) ?? _toDate(d['createdAt']) ?? DateTime.now(),
      customerName: '${d['customerName'] ?? ''}',
      customerId: '${d['customerId'] ?? ''}',
      service: '${d['service'] ?? ''}',
      items: items,
      totalAmount: _toDouble(d['totalAmount']),
      pickupDate: _toDate(d['pickupDate']) ?? DateTime.now(),
      returnDate: _toDate(d['returnDate']) ?? DateTime.now().add(const Duration(days: 2)),
      paymentStatus: '${d['paymentStatus'] ?? 'Pending'}',
      status: '${d['status'] ?? 'New'}',
      notes: '${d['notes'] ?? ''}',
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse('$value') ?? 0;
}

int _toInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.tryParse('$value') ?? 0;
}

DateTime? _toDate(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  if (value is String) return DateTime.tryParse(value);
  return null;
}

class CustomerModule extends StatefulWidget {
  final String? customerId;
  final String? customerName;
  final String? customerEmail;
  final String? customerAddress;
  final String? customerPhone;
  final FutureOr<void> Function()? onLogout;

  const CustomerModule({
    super.key,
    this.customerId,
    this.customerName,
    this.customerEmail,
    this.customerAddress,
    this.customerPhone,
    this.onLogout,
  });

  @override
  State<CustomerModule> createState() => _CustomerModuleState();
}

class _CustomerModuleState extends State<CustomerModule> {
  final _firestore = FirebaseFirestore.instance;
  final _orderFormKey = GlobalKey();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  final _chatController = TextEditingController();

  final Map<String, int> quantities = {
    for (final item in clothCatalog) item.name: 0,
  };

  int bottomIndex = 0;
  String? selectedService;
  ClothItem? pickerItem;
  int pickerQuantity = 1;
  DateTime? pickupDate;
  bool saving = false;
  String? photoUrl;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _customerSub;
  String? _userDocId;

  String get customerId => _idController.text.trim();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.customerName ?? '';
    _idController.text = widget.customerId ?? '';
    _emailController.text = widget.customerEmail ?? '';
    _addressController.text = widget.customerAddress ?? '';
    _phoneController.text = widget.customerPhone ?? '';
    if (customerId.isNotEmpty) {
      _listenToCustomer();
    }
  }

  void _listenToCustomer() {
    final id = widget.customerId?.trim();
    if (id == null || id.isEmpty) return;

    _customerSub = _firestore
        .collection('users')
        .where('customerId', isEqualTo: id)
        .limit(1)
        .snapshots()
        .listen((snap) {
      if (!mounted || snap.docs.isEmpty) return;
      final doc = snap.docs.first;
      final d = doc.data();

      setState(() {
        _userDocId = doc.id;
        _nameController.text =
            '${d['name'] ?? _nameController.text}';
        _emailController.text =
            '${d['email'] ?? _emailController.text}';
        _addressController.text =
            '${d['address'] ?? _addressController.text}';
        _phoneController.text =
            '${d['phone'] ?? _phoneController.text}';
        photoUrl = d['photoUrl'] as String?;
      });
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> _customerDocRef() async {
    if (_userDocId != null && _userDocId!.isNotEmpty) {
      return _firestore.collection('users').doc(_userDocId);
    }

    final snap = await _firestore
        .collection('users')
        .where('customerId', isEqualTo: customerId)
        .limit(1)
        .get();

    if (snap.docs.isNotEmpty) {
      _userDocId = snap.docs.first.id;
      return snap.docs.first.reference;
    }

    return _firestore.collection('users').doc(customerId);
  }

  @override
  void dispose() {
    _customerSub?.cancel();
    _nameController.dispose();
    _idController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  List<ClothItem> get chosenItems =>
      clothCatalog.where((e) => (quantities[e.name] ?? 0) > 0).toList();

  int get totalPieces =>
      quantities.values.fold(0, (sum, value) => sum + value);

  double get estimatedTotal {
    if (selectedService == null) return 0;
    return chosenItems.fold(
      0,
      (sum, item) =>
          sum + (quantities[item.name] ?? 0) * (item.rates[selectedService!] ?? 0),
    );
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: CustomerColors.darkText,
      ),
    );
  }

  void _goToNewOrder() {
    setState(() => bottomIndex = 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _orderFormKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _selectService(String service) {
    setState(() => selectedService = selectedService == service ? null : service);
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: today.add(const Duration(days: 1)),
      firstDate: today,
      lastDate: today.add(const Duration(days: 60)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: CustomerColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: CustomerColors.darkText,
          ),
        ),
        child: child!,
      ),
    );
    if (selected != null) setState(() => pickupDate = selected);
  }

  Future<void> _placeOrder() async {
    if (customerId.isEmpty || _nameController.text.trim().isEmpty) {
      _message('Customer information is missing. Please login again.');
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      _message('Please add your address before placing an order.');
      await _editAddress();
      return;
    }
    if (selectedService == null) {
      _message('Please select a service.');
      return;
    }
    if (chosenItems.isEmpty) {
      _message('Please add at least one clothing item.');
      return;
    }
    if (pickupDate == null) {
      _message('Please select a pickup date.');
      return;
    }

    setState(() => saving = true);
    final now = DateTime.now();
    final id = 'OR-VEB${now.millisecondsSinceEpoch}';
    final bill = 'INV${now.millisecondsSinceEpoch}';
    final returnDate = pickupDate!.add(const Duration(days: 2));

    final items = chosenItems.map((item) {
      final qty = quantities[item.name] ?? 0;
      final rate = item.rates[selectedService!] ?? 0;
      return OrderLineItem(
        name: item.name,
        quantity: qty,
        lineTotal: qty * rate,
      );
    }).toList();

    final data = {
      'orderId': id,
      'billNo': bill,
      'orderDate': Timestamp.fromDate(now),
      'createdAt': FieldValue.serverTimestamp(),
      'customerName': _nameController.text.trim(),
      'customerId': customerId,
      'customerEmail': _emailController.text.trim(),
      'customerPhone': _phoneController.text.trim(),
      'customerAddress': _addressController.text.trim(),
      'service': selectedService,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': estimatedTotal,
      'pickupDate': Timestamp.fromDate(pickupDate!),
      'returnDate': Timestamp.fromDate(returnDate),
      'paymentStatus': 'Pending',
      'status': 'New',
      'notes': _notesController.text.trim(),
    };

    try {
      await _firestore.collection('orders').doc(id).set(data);

      final customerRef = await _customerDocRef();
      await customerRef.set({
        'customerId': customerId,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'role': 'customer',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firestore.collection('notifications').add({
        'targetRole': 'owner',
        'type': 'new_order',
        'title': 'New Order',
        'message': '${_nameController.text.trim()} placed order $id',
        'orderId': id,
        'customerId': customerId,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });

      final savedTotal = estimatedTotal;
      final savedName = _nameController.text.trim();
      final savedNotes = _notesController.text.trim();
      final savedService = selectedService!;
      final savedPickup = pickupDate!;

      if (!mounted) return;
      setState(() {
        saving = false;
        selectedService = null;
        pickupDate = null;
        _notesController.clear();
        for (final key in quantities.keys) {
          quantities[key] = 0;
        }
      });
      _message('Order placed successfully.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerBillPage(
            order: LaundryOrder(
              billNo: bill,
              orderId: id,
              orderDate: now,
              customerName: savedName,
              customerId: customerId,
              service: savedService,
              items: items,
              totalAmount: savedTotal,
              pickupDate: savedPickup,
              returnDate: returnDate,
              paymentStatus: 'Pending',
              status: 'New',
              notes: savedNotes,
            ),
          ),
        ),
      );
    } on FirebaseException catch (e) {
      if (mounted) setState(() => saving = false);
      _message('Order could not be saved: ${e.message ?? e.code}');
    } catch (_) {
      if (mounted) setState(() => saving = false);
      _message('Order could not be saved. Please try again.');
    }
  }

  Future<void> _editAddress() async {
    final controller = TextEditingController(text: _addressController.text);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Address'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Customer Address',
            hintText: 'Enter complete address',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();

    if (result == null || result.isEmpty || customerId.isEmpty) return;

    try {
      final customerRef = await _customerDocRef();
      await customerRef.set({
        'address': result,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      final orderSnap = await _firestore
          .collection('orders')
          .where('customerId', isEqualTo: customerId)
          .get();
      for (final doc in orderSnap.docs) {
        await doc.reference.update({'customerAddress': result});
      }
      if (mounted) setState(() => _addressController.text = result);
      _message('Address updated successfully.');
    } catch (e) {
      _message('Could not update address.');
    }
  }

  Future<void> _pickProfilePhoto() async {
    if (customerId.isEmpty) {
      _message('Customer ID is missing.');
      return;
    }
    try {
      final picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 900,
      );
      if (file == null) return;

      final Uint8List bytes = await file.readAsBytes();
      final ref = FirebaseStorage.instance
          .ref()
          .child('customer_profiles')
          .child('$customerId.jpg');

      await ref.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();

      final customerRef = await _customerDocRef();
      await customerRef.set({
        'photoUrl': url,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) setState(() => photoUrl = url);
      _message('Profile photo updated.');
    } on FirebaseException catch (e) {
      _message('Photo upload failed: ${e.message ?? e.code}');
    } catch (_) {
      _message('Photo upload failed.');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _ordersStream() {
    if (customerId.isEmpty) {
      return const Stream.empty();
    }
    return _firestore
        .collection('orders')
        .where('customerId', isEqualTo: customerId)
        .snapshots();
  }

  List<LaundryOrder> _readOrders(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
    if (!snapshot.hasData) return [];
    final list = snapshot.data!.docs.map(LaundryOrder.fromDoc).toList();
    list.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _ordersStream(),
      builder: (context, snapshot) {
        final orders = _readOrders(snapshot);
        return Scaffold(
          backgroundColor: CustomerColors.background,
          body: SafeArea(
            child: CustomerDashboardBackground(
              child: IndexedStack(
                index: bottomIndex,
              children: [
                _homePage(orders),
                CustomerOrdersPage(orders: orders),
                CustomerBillsPage(orders: orders),
                CustomerChatPage(
                  customerId: customerId,
                  customerName: _nameController.text.trim(),
                ),
                CustomerProfilePage(
                  name: _nameController.text.trim(),
                  customerId: customerId,
                  email: _emailController.text.trim(),
                  phone: _phoneController.text.trim(),
                  address: _addressController.text.trim(),
                  photoUrl: photoUrl,
                  onChangeAddress: _editAddress,
                  onPickPhoto: _pickProfilePhoto,
                  onLogout: _logoutCustomer,
                ),
              ],
              ),
            ),
          ),
          bottomNavigationBar: _bottomBar(),
        );
      },
    );
  }

  Future<void> _logoutCustomer() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomerColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // Always navigate from the root navigator so logout works even when
    // CustomerModule was opened with pushReplacement().
    Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
      '/',
      (route) => false,
    );
  }

  Widget _homePage(List<LaundryOrder> orders) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 100),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _header(),
              const SizedBox(height: 18),
              _welcomeBanner(),
              const SizedBox(height: 24),
              _customerInfoCard(),
              const SizedBox(height: 24),
              _sectionTitle('Our Services', 'Choose a service for your clothes'),
              const SizedBox(height: 12),
              _services(),
              const SizedBox(height: 26),
              _sectionTitle('Create New Order', 'Select clothes, quantity and pickup date'),
              const SizedBox(height: 12),
              Container(key: _orderFormKey, child: _orderForm()),
              const SizedBox(height: 26),
              Row(
                children: [
                  Expanded(child: _sectionTitle('All Orders', 'View every order and its current status')),
                  TextButton(
                    onPressed: () => setState(() => bottomIndex = 1),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (orders.isEmpty)
                _emptyCard('No orders yet', 'Your orders will appear here.')
              else
                ...orders.take(3).map((o) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _homeOrderCard(o),
                    )),
              const SizedBox(height: 16),
              _chatBanner(),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: [
        _washEasyLogo(size: 46),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(text: 'Wash', style: TextStyle(color: CustomerColors.brandBlue)),
                    TextSpan(text: 'Easy', style: TextStyle(color: CustomerColors.primary)),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'Customer Dashboard',
                style: TextStyle(color: CustomerColors.grayText, fontSize: 11),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CustomerNotificationsPage(customerId: customerId),
            ),
          ),
          icon: const Icon(Icons.notifications_none_rounded,
              color: CustomerColors.darkText),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => setState(() => bottomIndex = 4),
          child: _avatar(photoUrl, radius: 20),
        ),
      ],
    );
  }

  Widget _welcomeBanner() {
    final name = _nameController.text.trim().isEmpty
        ? 'Customer'
        : _nameController.text.trim();
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [CustomerColors.primary, Color(0xFFFF9A4D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: CustomerColors.primary.withOpacity(.18),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello, $name! 👋',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 7),
                const Text('What would you like to do today?',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 14),
                ElevatedButton.icon(
                  onPressed: _goToNewOrder,
                  icon: const Icon(Icons.add, size: 17),
                  label: const Text('New Order'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: CustomerColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _washEasyLogo(size: 72),
        ],
      ),
    );
  }

  Widget _customerInfoCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: CustomerColors.border),
      ),
      child: Row(
        children: [
          _avatar(photoUrl, radius: 27),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _nameController.text.trim().isEmpty
                      ? 'Customer'
                      : _nameController.text.trim(),
                  style: const TextStyle(
                      color: CustomerColors.darkText,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text('ID: $customerId',
                    style: const TextStyle(color: CustomerColors.grayText, fontSize: 11)),
                const SizedBox(height: 4),
                Text(
                  _addressController.text.trim().isEmpty
                      ? 'Address not added'
                      : _addressController.text.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: CustomerColors.grayText, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Change address',
            onPressed: _editAddress,
            icon: const Icon(Icons.edit_location_alt_outlined,
                color: CustomerColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                color: CustomerColors.darkText,
                fontSize: 19,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 3),
        Text(subtitle,
            style: const TextStyle(color: CustomerColors.grayText, fontSize: 11)),
      ],
    );
  }

  Widget _services() {
    const subtitles = {
      'Ironing': 'Give clothes for ironing',
      'Dry Cleaning': 'Professional dry cleaning',
      'Raffu': 'Repair & stitching work',
      'Dying': 'Give clothes for dying',
    };

    const images = {
      'Ironing': 'assets/images/services/ironing_logo.png',
      'Dry Cleaning': 'assets/images/services/dry_cleaning_logo.png',
      'Raffu': 'assets/images/services/raffu_logo.png',
      'Dying': 'assets/images/services/dying_logo.png',
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: laundryServices.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 175,
      ),
      itemBuilder: (_, i) {
        final s = laundryServices[i];
        final selected = selectedService == s;
        return InkWell(
          onTap: () => _selectService(s),
          borderRadius: BorderRadius.circular(17),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                color: selected ? CustomerColors.primary : CustomerColors.border,
                width: selected ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: CustomerColors.darkText.withOpacity(.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          images[s]!,
                          fit: BoxFit.cover,
                        ),
                        if (selected)
                          Container(
                            color: CustomerColors.primary.withOpacity(.14),
                          ),
                        if (selected)
                          const Positioned(
                            right: 9,
                            top: 9,
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.check_circle,
                                color: CustomerColors.primary,
                                size: 22,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s,
                        style: const TextStyle(
                          color: CustomerColors.darkText,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitles[s]!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CustomerColors.grayText,
                          fontSize: 10.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _orderForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CustomerColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _customerMiniDetails(),
          const SizedBox(height: 18),
          const Text('Order Summary',
              style: TextStyle(
                  color: CustomerColors.darkText,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 9),
          if (chosenItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: CustomerColors.lightOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Select a service and add clothes below.',
                style: TextStyle(color: CustomerColors.grayText, fontSize: 12),
              ),
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: CustomerColors.lightOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ...chosenItems.map((item) => Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.name} × ${quantities[item.name]}',
                              style: const TextStyle(
                                  color: CustomerColors.darkText,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Text(
                            '₹${((quantities[item.name] ?? 0) * (item.rates[selectedService!] ?? 0)).toStringAsFixed(0)}',
                            style: const TextStyle(
                                color: CustomerColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            onPressed: () =>
                                setState(() => quantities[item.name] = 0),
                            icon: const Icon(Icons.close, size: 16),
                            color: CustomerColors.grayText,
                          ),
                        ],
                      )),
                  const Divider(),
                  Row(
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomerColors.darkText)),
                      const Spacer(),
                      Text('₹${estimatedTotal.toStringAsFixed(0)}',
                          style: const TextStyle(
                              color: CustomerColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          const Text('Clothes & Rates',
              style: TextStyle(
                  color: CustomerColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: CustomerColors.lightOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ClothItem>(
                value: pickerItem,
                isExpanded: true,
                hint: Text(selectedService == null
                    ? 'Select a service first'
                    : 'Choose a clothing item'),
                items: selectedService == null
                    ? null
                    : clothCatalog.map((item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(
                            '${item.name} — ₹${item.rates[selectedService!]!.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                onChanged: selectedService == null
                    ? null
                    : (v) => setState(() {
                          pickerItem = v;
                          pickerQuantity = 1;
                        }),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text('Quantity',
                  style: TextStyle(
                      color: CustomerColors.darkText,
                      fontWeight: FontWeight.w600,
                      fontSize: 12)),
              const SizedBox(width: 10),
              _stepper(Icons.remove,
                  pickerItem != null && pickerQuantity > 1
                      ? () => setState(() => pickerQuantity--)
                      : null),
              SizedBox(
                width: 30,
                child: Text('$pickerQuantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              _stepper(Icons.add,
                  pickerItem != null ? () => setState(() => pickerQuantity++) : null),
              const Spacer(),
              ElevatedButton(
                onPressed: pickerItem == null
                    ? null
                    : () {
                        setState(() {
                          quantities[pickerItem!.name] =
                              (quantities[pickerItem!.name] ?? 0) + pickerQuantity;
                          pickerItem = null;
                          pickerQuantity = 1;
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomerColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 17),
          const Text('Expected Pickup Date',
              style: TextStyle(
                  color: CustomerColors.darkText,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: CustomerColors.lightOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined,
                      color: CustomerColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      pickupDate == null
                          ? 'Select pickup date'
                          : _date(pickupDate!),
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      color: CustomerColors.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Special instructions...',
              filled: true,
              fillColor: CustomerColors.lightOrange,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: CustomerColors.lightOrange,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Row(
              children: [
                const Icon(Icons.receipt_long_outlined,
                    color: CustomerColors.primary),
                const SizedBox(width: 10),
                const Expanded(
                    child: Text('Estimated Bill',
                        style: TextStyle(fontWeight: FontWeight.w600))),
                Text('₹${estimatedTotal.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: CustomerColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: saving ? null : _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomerColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13)),
              ),
              child: saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Place Order',
                      style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerMiniDetails() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CustomerColors.lightOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.person_outline, color: CustomerColors.primary),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_nameController.text.trim().isEmpty
                    ? 'Customer'
                    : _nameController.text.trim(),
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(
                  _addressController.text.trim().isEmpty
                      ? 'Address not added'
                      : _addressController.text.trim(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: CustomerColors.grayText, fontSize: 11),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _editAddress,
            icon: const Icon(Icons.edit_outlined,
                color: CustomerColors.primary, size: 19),
          ),
        ],
      ),
    );
  }

  Widget _stepper(IconData icon, VoidCallback? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon,
            size: 15,
            color: onTap == null
                ? CustomerColors.grayText.withOpacity(.35)
                : CustomerColors.primary),
      ),
    );
  }

  Widget _homeOrderCard(LaundryOrder order) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerOrderDetailsPage(order: order),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CustomerColors.border),
        ),
        child: Row(
          children: [
            _washEasyLogo(size: 45),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.orderId,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomerColors.darkText)),
                  const SizedBox(height: 4),
                  Text('${order.service} • ${order.totalPieces} clothes',
                      style: const TextStyle(
                          color: CustomerColors.grayText, fontSize: 11)),
                  const SizedBox(height: 5),
                  _statusChip(order.status),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('₹${order.totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomerColors.darkText)),
                const SizedBox(height: 6),
                const Icon(Icons.chevron_right,
                    color: CustomerColors.grayText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomerColors.lightOrange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _prettyStatus(status),
        style: const TextStyle(
            color: CustomerColors.primary,
            fontSize: 9,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _emptyCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CustomerColors.border),
      ),
      child: Column(
        children: [
          const Icon(Icons.inventory_2_outlined,
              size: 36, color: CustomerColors.grayText),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: CustomerColors.darkText)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(
                  color: CustomerColors.grayText, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _chatBanner() {
    return InkWell(
      onTap: () => setState(() => bottomIndex = 3),
      borderRadius: BorderRadius.circular(17),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CustomerColors.lightOrange,
          borderRadius: BorderRadius.circular(17),
        ),
        child: const Row(
          children: [
            Icon(Icons.chat_bubble_outline,
                color: CustomerColors.primary, size: 28),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Need help?',
                      style: TextStyle(
                          color: CustomerColors.darkText,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 3),
                  Text('Chat with the WashEasy owner / administrator',
                      style: TextStyle(
                          color: CustomerColors.grayText, fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: CustomerColors.primary, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar() {
    const labels = ['Home', 'Orders', 'Bills', 'Chat', 'Profile'];
    const inactive = [
      Icons.home_outlined,
      Icons.inventory_2_outlined,
      Icons.receipt_long_outlined,
      Icons.chat_bubble_outline,
      Icons.person_outline,
    ];
    const active = [
      Icons.home,
      Icons.inventory_2,
      Icons.receipt_long,
      Icons.chat_bubble,
      Icons.person,
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(.08),
              blurRadius: 18,
              offset: const Offset(0, -4))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(5, (i) {
            final selected = bottomIndex == i;
            return InkWell(
              onTap: () => setState(() => bottomIndex = i),
              borderRadius: BorderRadius.circular(13),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? CustomerColors.lightOrange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(selected ? active[i] : inactive[i],
                        color: selected
                            ? CustomerColors.primary
                            : CustomerColors.grayText,
                        size: 21),
                    const SizedBox(height: 3),
                    Text(labels[i],
                        style: TextStyle(
                            color: selected
                                ? CustomerColors.primary
                                : CustomerColors.grayText,
                            fontSize: 9,
                            fontWeight:
                                selected ? FontWeight.bold : FontWeight.w500)),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CustomerOrdersPage extends StatefulWidget {
  final List<LaundryOrder> orders;
  const CustomerOrdersPage({super.key, required this.orders});

  @override
  State<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends State<CustomerOrdersPage> {
  int tab = 0;
  final tabs = const ['All', 'New', 'In Progress', 'Ready', 'Completed'];

  List<LaundryOrder> get filtered {
    if (tab == 0) return widget.orders;
    return widget.orders.where((o) {
      final s = o.status.toLowerCase();
      if (tab == 1) return s == 'new' || s == 'order received';
      if (tab == 2) return s == 'in progress' || s == 'ironing started';
      if (tab == 3) return s == 'ready' || s == 'clothes ready';
      return s == 'completed' || s == 'customer collected';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return CustomerDashboardBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('All Orders',
              style: TextStyle(
                  color: CustomerColors.darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Track all your laundry orders',
              style: TextStyle(color: CustomerColors.grayText, fontSize: 13)),
          const SizedBox(height: 18),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(tabs.length, (i) {
                final selected = tab == i;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(tabs[i]),
                    selected: selected,
                    selectedColor: CustomerColors.primary,
                    labelStyle: TextStyle(
                        color: selected ? Colors.white : CustomerColors.darkText,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                    onSelected: (_) => setState(() => tab = i),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            _empty()
          else
            ...filtered.map((order) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CustomerOrderDetailsPage(order: order),
                      ),
                    ),
                    borderRadius: BorderRadius.circular(17),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(17),
                        border: Border.all(color: CustomerColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: CustomerColors.lightOrange,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: CustomerColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(order.orderId,
                                    style: const TextStyle(
                                        color: CustomerColors.darkText,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Text(order.service,
                                    style: const TextStyle(
                                        color: CustomerColors.grayText,
                                        fontSize: 11)),
                                const SizedBox(height: 6),
                                _status(order.status),
                                const SizedBox(height: 5),
                                Text('${order.totalPieces} clothes • Return by ${_date(order.returnDate)}',
                                    style: const TextStyle(
                                        color: CustomerColors.grayText,
                                        fontSize: 10)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${order.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: CustomerColors.darkText,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              const Icon(Icons.chevron_right,
                                  color: CustomerColors.grayText),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _status(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: CustomerColors.lightOrange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(_prettyStatus(status),
          style: const TextStyle(
              color: CustomerColors.primary,
              fontSize: 9,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _empty() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 80),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 42, color: CustomerColors.grayText),
              SizedBox(height: 12),
              Text('No orders found',
                  style: TextStyle(
                      color: CustomerColors.darkText,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      );
}

class CustomerOrderDetailsPage extends StatelessWidget {
  final LaundryOrder order;
  const CustomerOrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .doc(order.orderId)
          .snapshots(),
      builder: (context, snapshot) {
        final liveOrder = snapshot.hasData && snapshot.data!.exists
            ? LaundryOrder.fromDoc(snapshot.data!)
            : order;
        return _buildDetails(context, liveOrder);
      },
    );
  }

  Widget _buildDetails(BuildContext context, LaundryOrder order) {
    final steps = [
      'Order Received',
      'Ironing Started',
      'Clothes Ready',
      'Customer Collected'
    ];
    final current = _statusIndex(order.status);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: CustomerColors.darkText,
        elevation: 0,
        title: const Text('Order Details'),
      ),
      body: CustomerDashboardBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 80, 18, 30),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [CustomerColors.primary, Color(0xFFFF9A4D)],
                ),
                borderRadius: BorderRadius.circular(17),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(order.orderId,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                  ),
                  _whiteChip(_prettyStatus(order.status)),
                ],
              ),
            ),
            const SizedBox(height: 18),
            _detailCard([
              _row('Order Date', _date(order.orderDate)),
              _row('Pickup Date', _date(order.pickupDate)),
              _row('Return By', _date(order.returnDate)),
              _row('Service', order.service),
              _row('Payment', order.paymentStatus),
              _row('Total', '₹${order.totalAmount.toStringAsFixed(0)}'),
            ]),
            const SizedBox(height: 18),
            const Text('Items',
                style: TextStyle(
                    color: CustomerColors.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 9),
            ...order.items.map((item) => _itemRow(item)),
            const SizedBox(height: 18),
            const Text('Order Tracking',
                style: TextStyle(
                    color: CustomerColors.darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...List.generate(steps.length, (i) {
              final done = i <= current;
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 15,
                  backgroundColor:
                      done ? CustomerColors.primary : CustomerColors.border,
                  child: Icon(done ? Icons.check : Icons.circle_outlined,
                      size: 16, color: done ? Colors.white : CustomerColors.grayText),
                ),
                title: Text(steps[i],
                    style: TextStyle(
                        color: done
                            ? CustomerColors.darkText
                            : CustomerColors.grayText,
                        fontSize: 13,
                        fontWeight:
                            done ? FontWeight.bold : FontWeight.normal)),
              );
            }),
            if (order.notes.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Text('Notes',
                  style: TextStyle(
                      color: CustomerColors.darkText,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(order.notes,
                  style: const TextStyle(
                      color: CustomerColors.grayText, fontSize: 12)),
            ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CustomerBillPage(order: order)),
                ),
                icon: const Icon(Icons.receipt_long_outlined),
                label: const Text('View Bill'),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }

  Widget _detailCard(List<Widget> children) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CustomerColors.border),
        ),
        child: Column(children: children),
      );

  Widget _row(String a, String b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Text(a,
                style: const TextStyle(
                    color: CustomerColors.grayText, fontSize: 12)),
            const Spacer(),
            Flexible(
              child: Text(b,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: CustomerColors.darkText,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

  Widget _itemRow(OrderLineItem item) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CustomerColors.border),
        ),
        child: Row(
          children: [
            Expanded(child: Text(item.name)),
            Text('Qty: ${item.quantity}',
                style: const TextStyle(
                    color: CustomerColors.grayText, fontSize: 11)),
            const SizedBox(width: 12),
            Text('₹${item.lineTotal.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: CustomerColors.darkText,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _whiteChip(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(20)),
        child: Text(text,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold)),
      );
}

class CustomerBillsPage extends StatelessWidget {
  final List<LaundryOrder> orders;
  const CustomerBillsPage({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final total = orders.fold<double>(0, (sum, o) => sum + o.totalAmount);
    return CustomerDashboardBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Bills & Payments',
              style: TextStyle(
                  color: CustomerColors.darkText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('View your bills and payment status',
              style: TextStyle(color: CustomerColors.grayText, fontSize: 13)),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [CustomerColors.primary, Color(0xFFFF9A4D)],
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Billed',
                    style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 6),
                Text('₹${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('${orders.length} order${orders.length == 1 ? '' : 's'}',
                    style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Center(
                child: Text('No bills yet',
                    style: TextStyle(color: CustomerColors.grayText)),
              ),
            )
          else
            ...orders.map((o) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CustomerBillPage(order: o)),
                    ),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: CustomerColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              color: CustomerColors.lightOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.receipt_long_outlined,
                                color: CustomerColors.primary),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(o.billNo,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 3),
                                Text(o.service,
                                    style: const TextStyle(
                                        color: CustomerColors.grayText,
                                        fontSize: 11)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${o.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 3),
                              Text(o.paymentStatus,
                                  style: TextStyle(
                                      color: o.paymentStatus.toLowerCase() == 'paid'
                                          ? Colors.green
                                          : CustomerColors.primary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 3),
                              OutlinedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomerBillPage(order: o),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: CustomerColors.primary,
                                  side: const BorderSide(
                                    color: CustomerColors.primary,
                                  ),
                                  minimumSize: const Size(0, 32),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'View Bill',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class CustomerBillPage extends StatefulWidget {
  final LaundryOrder order;

  const CustomerBillPage({super.key, required this.order});

  @override
  State<CustomerBillPage> createState() => _CustomerBillPageState();
}

class _CustomerBillPageState extends State<CustomerBillPage> {
  DocumentSnapshot<Map<String, dynamic>>? _ownerSnapshot;

  @override
  void initState() {
    super.initState();
    _loadOwnerDetails();
  }

  Future<void> _loadOwnerDetails() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('ownerDetails')
          .doc('OWNER001')
          .get();
      if (mounted) {
        setState(() => _ownerSnapshot = snapshot);
      }
    } catch (_) {
      // The bill will still open if owner details are unavailable.
    }
  }

  String _ownerValue(String key, [String fallback = 'Not added']) {
    final data = _ownerSnapshot?.data();
    final value = data?[key]?.toString().trim() ?? '';
    return value.isEmpty ? fallback : value;
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final ownerName = _ownerValue('name', 'WashEasy Owner');
    final businessName = _ownerValue('businessName', 'WashEasy Laundry');
    final businessAddress = _ownerValue('businessAddress');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: CustomerColors.darkText,
        elevation: 0,
        title: const Text('Bill Details'),
      ),
      body: CustomerDashboardBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 82, 14, 30),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.96),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: CustomerColors.primary, width: 1.3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: IgnorePointer(
                    child: Center(
                      child: Opacity(
                        opacity: 0.075,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _washEasyLogo(size: 150),
                            const SizedBox(height: 8),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Wash',
                                    style: TextStyle(color: CustomerColors.brandBlue),
                                  ),
                                  TextSpan(
                                    text: 'Easy',
                                    style: TextStyle(color: CustomerColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: _washEasyLogo(size: 70)),
                const Center(
                  child: Text(
                    'LAUNDRY & IRONING SERVICE',
                    style: TextStyle(fontSize: 9, color: Colors.black54),
                  ),
                ),
                const SizedBox(height: 15),
                const Divider(),
                _line('Bill No.', order.billNo),
                _line('Order No.', order.orderId),
                _line('Date', _date(order.orderDate)),
                const SizedBox(height: 8),
                const Text(
                  'CUSTOMER DETAILS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 5),
                _line('Customer', order.customerName),
                _line('Customer ID', order.customerId),
                const SizedBox(height: 10),
                const Text(
                  'OWNER / BUSINESS DETAILS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 5),
                _line('Owner', ownerName),
                _line('Business', businessName),
                _line('Business Address', businessAddress),
                const SizedBox(height: 10),
                const Text(
                  'ITEMS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 7),
                const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Item',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      child: Text(
                        'Qty',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 65,
                      child: Text(
                        'Amount',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ...order.items.map(
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            i.name,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          width: 45,
                          child: Text(
                            '${i.quantity}',
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                        SizedBox(
                          width: 65,
                          child: Text(
                            '₹${i.lineTotal.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                _line('Service', order.service),
                _line('Total Pieces', '${order.totalPieces}'),
                _line('Payment Status', order.paymentStatus),
                _line('Return Date', _date(order.returnDate)),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: CustomerColors.lightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'TOTAL: ₹${order.totalAmount.toStringAsFixed(0)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CustomerColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'Thank you for choosing WashEasy!',
                    style: TextStyle(
                      color: CustomerColors.grayText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ],
        ),
      );
}

class CustomerChatPage extends StatefulWidget {
  final String customerId;
  final String customerName;

  const CustomerChatPage({
    super.key,
    required this.customerId,
    required this.customerName,
  });

  @override
  State<CustomerChatPage> createState() => _CustomerChatPageState();
}

class _CustomerChatPageState extends State<CustomerChatPage> {
  final controller = TextEditingController();
  bool sending = false;

  CollectionReference<Map<String, dynamic>> get _messages =>
      FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.customerId)
          .collection('messages');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = controller.text.trim();
    if (text.isEmpty || widget.customerId.isEmpty || sending) return;

    setState(() => sending = true);
    try {
      await _messages.add({
        'senderId': widget.customerId,
        'senderName': widget.customerName,
        'senderRole': 'customer',
        'message': text,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });

      await FirebaseFirestore.instance.collection('notifications').add({
        'targetRole': 'owner',
        'type': 'customer_message',
        'title': 'New Customer Message',
        'message': '${widget.customerName}: $text',
        'customerId': widget.customerId,
        'createdAt': FieldValue.serverTimestamp(),
        'read': false,
      });

      controller.clear();
    } on FirebaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message failed: ${e.message ?? e.code}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Message failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  DateTime _messageDate(dynamic value) =>
      _toDate(value) ?? DateTime.fromMillisecondsSinceEpoch(0);

  Widget _messageBubble(Map<String, dynamic> data) {
    final sent = data['senderRole'] == 'customer';
    return Align(
      alignment: sent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: sent ? CustomerColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(sent ? 16 : 4),
            bottomRight: Radius.circular(sent ? 4 : 16),
          ),
          border: Border.all(
            color: sent ? CustomerColors.primary : CustomerColors.border,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          '${data['message'] ?? ''}',
          style: TextStyle(
            color: sent ? Colors.white : CustomerColors.darkText,
            fontSize: 13,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = CustomerDashboardBackground(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  _washEasyLogo(size: 50),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chat with Owner',
                          style: TextStyle(
                            color: CustomerColors.darkText,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'We are here to help you',
                          style: TextStyle(
                            color: CustomerColors.grayText,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CustomerColors.lightOrange,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.support_agent_rounded,
                      color: CustomerColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: widget.customerId.isEmpty
                  ? const Center(
                      child: Text(
                        'Login again to use Help & Support.',
                        style: TextStyle(color: CustomerColors.grayText),
                      ),
                    )
                  : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: _messages.snapshots(),
                      builder: (context, snap) {
                        if (snap.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Unable to load chat.\n${snap.error}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    color: CustomerColors.grayText),
                              ),
                            ),
                          );
                        }
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: CustomerColors.primary,
                            ),
                          );
                        }

                        final docs = [...?snap.data?.docs];
                        docs.sort((a, b) => _messageDate(
                                a.data()['createdAt'])
                            .compareTo(_messageDate(b.data()['createdAt'])));

                        if (docs.isEmpty) {
                          return Center(
                            child: Container(
                              margin: const EdgeInsets.all(24),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.92),
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(color: CustomerColors.border),
                              ),
                              child: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.support_agent_rounded,
                                      color: CustomerColors.primary, size: 38),
                                  SizedBox(height: 10),
                                  Text(
                                    'Hi, welcome!',
                                    style: TextStyle(
                                      color: CustomerColors.darkText,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Send a message and the WashEasy owner / administrator will help you.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: CustomerColors.grayText,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                          itemCount: docs.length,
                          itemBuilder: (_, i) =>
                              _messageBubble(docs[i].data()),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 9, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.96),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: CustomerColors.lightOrange,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: CustomerColors.primary,
                            width: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  InkWell(
                    onTap: sending ? null : _send,
                    borderRadius: BorderRadius.circular(28),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: CustomerColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: sending
                          ? const Padding(
                              padding: EdgeInsets.all(14),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                              size: 23,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    // CustomerChatPage can be opened directly from Profile. Keeping a
    // Scaffold here guarantees a Material ancestor for TextField/InkWell.
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: content,
    );
  }
}

class CustomerProfilePage extends StatelessWidget {
  final String name;
  final String customerId;
  final String email;
  final String phone;
  final String address;
  final String? photoUrl;
  final VoidCallback onChangeAddress;
  final VoidCallback onPickPhoto;
  final FutureOr<void> Function() onLogout;

  const CustomerProfilePage({
    super.key,
    required this.name,
    required this.customerId,
    required this.email,
    required this.phone,
    required this.address,
    required this.photoUrl,
    required this.onChangeAddress,
    required this.onPickPhoto,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return CustomerDashboardBackground(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 24, 18, 100),
        child: Column(
        children: [
          InkWell(
            onTap: onPickPhoto,
            borderRadius: BorderRadius.circular(55),
            child: Stack(
              children: [
                _avatar(photoUrl, radius: 48),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 31,
                    height: 31,
                    decoration: const BoxDecoration(
                        color: CustomerColors.primary, shape: BoxShape.circle),
                    child: const Icon(Icons.camera_alt,
                        color: Colors.white, size: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(name.isEmpty ? 'Customer' : name,
              style: const TextStyle(
                  color: CustomerColors.darkText,
                  fontSize: 21,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(email.isEmpty ? 'Email not added' : email,
              style: const TextStyle(
                  color: CustomerColors.grayText, fontSize: 12)),
          const SizedBox(height: 25),
          _infoCard([
            _infoRow(Icons.badge_outlined, 'Customer ID', customerId),
            _infoRow(Icons.email_outlined, 'Email', email),
            _infoRow(Icons.phone_outlined, 'Phone', phone),
            _infoRow(Icons.location_on_outlined, 'Address',
                address.isEmpty ? 'Not added' : address),
          ]),
          const SizedBox(height: 12),
          _action('Address', 'Change your delivery/pickup address',
              Icons.location_on_outlined, onChangeAddress),
          _action('Profile Photo', 'Upload or change your photo',
              Icons.camera_alt_outlined, onPickPhoto),
          _action('Notifications', 'View updates from WashEasy',
              Icons.notifications_none_outlined, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      CustomerNotificationsPage(customerId: customerId)),
            );
          }),
          _action('Help & Support', 'Chat with the WashEasy owner / administrator',
              Icons.help_outline, () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerChatPage(
                  customerId: customerId,
                  customerName: name,
                ),
              ),
            );
          }),
          _action('Logout', 'Return to the login screen', Icons.logout, () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomerColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(dialogContext, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              await onLogout();
            }
          }),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(List<Widget> children) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CustomerColors.border),
        ),
        child: Column(children: children),
      );

  Widget _infoRow(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: CustomerColors.primary, size: 19),
            const SizedBox(width: 11),
            Text(label,
                style: const TextStyle(
                    color: CustomerColors.grayText, fontSize: 11)),
            const Spacer(),
            Flexible(
              child: Text(value.isEmpty ? 'Not added' : value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      color: CustomerColors.darkText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );

  Widget _action(
      String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: CustomerColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: CustomerColors.primary),
        title: Text(title,
            style: const TextStyle(
                color: CustomerColors.darkText,
                fontSize: 13,
                fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle,
            style: const TextStyle(
                color: CustomerColors.grayText, fontSize: 10)),
        trailing: const Icon(Icons.chevron_right,
            color: CustomerColors.grayText),
      ),
    );
  }
}

class CustomerNotificationsPage extends StatelessWidget {
  final String customerId;
  const CustomerNotificationsPage({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('notifications')
        .where('customerId', isEqualTo: customerId)
        .snapshots();

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.transparent,
        foregroundColor: CustomerColors.darkText,
        elevation: 0,
      ),
      body: CustomerDashboardBackground(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: stream,
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final docs = [...?snap.data?.docs];
          docs.sort((a, b) {
            final at = _toDate(a.data()['createdAt']) ??
                DateTime.fromMillisecondsSinceEpoch(0);
            final bt = _toDate(b.data()['createdAt']) ??
                DateTime.fromMillisecondsSinceEpoch(0);
            return bt.compareTo(at);
          });
          if (docs.isEmpty) {
            return const Center(
                child: Text('No notifications yet.',
                    style: TextStyle(color: CustomerColors.grayText)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final d = docs[i].data();
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: CustomerColors.border),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.notifications_active_outlined,
                        color: CustomerColors.primary),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${d['title'] ?? 'WashEasy'}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomerColors.darkText)),
                          const SizedBox(height: 4),
                          Text('${d['message'] ?? ''}',
                              style: const TextStyle(
                                  color: CustomerColors.grayText, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
          },
        ),
      ),
    );
  }
}

String _prettyStatus(String status) {
  switch (status.toLowerCase()) {
    case 'new':
      return 'New';
    case 'order received':
      return 'Order Received';
    case 'ironing started':
    case 'in progress':
      return 'In Progress';
    case 'clothes ready':
    case 'ready':
      return 'Ready';
    case 'customer collected':
    case 'completed':
      return 'Completed';
    default:
      return status;
  }
}

int _statusIndex(String status) {
  switch (status.toLowerCase()) {
    case 'new':
    case 'order received':
      return 0;
    case 'ironing started':
    case 'in progress':
      return 1;
    case 'clothes ready':
    case 'ready':
      return 2;
    case 'customer collected':
    case 'completed':
      return 3;
    default:
      return 0;
  }
}

Widget _avatar(String? url, {double radius = 24}) {
  if (url != null && url.isNotEmpty) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
      backgroundColor: CustomerColors.lightOrange,
    );
  }
  return CircleAvatar(
    radius: radius,
    backgroundColor: CustomerColors.lightOrange,
    child: Icon(Icons.person_outline,
        color: CustomerColors.primary, size: radius),
  );
}

String _date(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

class CustomerDashboardBackground extends StatelessWidget {
  final Widget child;

  const CustomerDashboardBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/customer_dashboard_bg.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

Widget _washEasyLogo({double size = 48}) {
  final radius = size * .22;
  return Container(
    width: size,
    height: size,
    padding: EdgeInsets.all(size * .08),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: CustomerColors.border),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius * .72),
      child: Image.asset(
        'assets/images/washeasy_logo.png',
        fit: BoxFit.contain,
      ),
    ),
  );
}

class CustomerColors {
  static const Color primary = Color(0xFFF47B20);
  static const Color brandBlue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFFEAF3FF);
  static const Color darkText = Color(0xFF17213D);
  static const Color grayText = Color(0xFF8A8A96);
  static const Color lightOrange = Color(0xFFFFF1E6);
  static const Color background = Color(0xFFFAF9FE);
  static const Color border = Color(0xFFE9E3DB);
}
