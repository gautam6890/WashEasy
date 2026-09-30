import 'package:flutter/material.dart';

// ============================================================
// WASH EASY - ORDER TRACKING MODULE
// ============================================================

// ============================================================
// ORDER DATA MODEL
// ============================================================

class OrderData {
  String orderId;
  String customerId;
  String customerName;
  String service;
  int quantity;
  DateTime orderDate;
  DateTime returnDate;
  String status;
  String paymentStatus;

  DateTime? receivedTime;
  DateTime? processingTime;
  DateTime? readyTime;
  DateTime? collectedTime;

  OrderData({
    required this.orderId,
    required this.customerId,
    required this.customerName,
    required this.service,
    required this.quantity,
    required this.orderDate,
    required this.returnDate,
    required this.status,
    required this.paymentStatus,
    this.receivedTime,
    this.processingTime,
    this.readyTime,
    this.collectedTime,
  });

  // Processing status according to selected service
  String get processingStatus {
    switch (service) {
      case 'Washing':
        return 'Washing Started';

      case 'Dry Cleaning':
        return 'Dry Cleaning Started';

      case 'Dyeing':
        return 'Dyeing Started';

      case 'Ironing':
      default:
        return 'Ironing Started';
    }
  }
}

// ============================================================
// MAIN ORDER TRACKING MODULE
// ============================================================

class OrderTrackingModule extends StatefulWidget {
  const OrderTrackingModule({super.key});

  @override
  State<OrderTrackingModule> createState() =>
      _OrderTrackingModuleState();
}

class _OrderTrackingModuleState
    extends State<OrderTrackingModule> {
  // ----------------------------------------------------------
  // SAMPLE ORDERS
  // ----------------------------------------------------------

  final List<OrderData> orders = [
    OrderData(
      orderId: 'ORD001',
      customerId: 'C001',
      customerName: 'Rahul',
      service: 'Ironing',
      quantity: 8,
      orderDate: DateTime(2026, 8, 24, 10, 30),
      returnDate: DateTime(2026, 8, 26),
      status: 'Processing',
      paymentStatus: 'Pending',
      receivedTime:
          DateTime(2026, 8, 24, 10, 30),
      processingTime:
          DateTime(2026, 8, 24, 12, 15),
    ),

    OrderData(
      orderId: 'ORD002',
      customerId: 'C002',
      customerName: 'John',
      service: 'Washing',
      quantity: 5,
      orderDate: DateTime(2026, 8, 23, 9, 30),
      returnDate: DateTime(2026, 8, 25),
      status: 'Ready',
      paymentStatus: 'Paid',
      receivedTime:
          DateTime(2026, 8, 23, 9, 30),
      processingTime:
          DateTime(2026, 8, 23, 11, 00),
      readyTime:
          DateTime(2026, 8, 24, 15, 30),
    ),

    OrderData(
      orderId: 'ORD003',
      customerId: 'C003',
      customerName: 'Priya',
      service: 'Dry Cleaning',
      quantity: 3,
      orderDate: DateTime(2026, 8, 24, 11, 00),
      returnDate: DateTime(2026, 8, 27),
      status: 'Received',
      paymentStatus: 'Pending',
      receivedTime:
          DateTime(2026, 8, 24, 11, 00),
    ),

    OrderData(
      orderId: 'ORD004',
      customerId: 'C004',
      customerName: 'Anjali',
      service: 'Dyeing',
      quantity: 4,
      orderDate: DateTime(2026, 8, 21, 10, 00),
      returnDate: DateTime(2026, 8, 23),
      status: 'Collected',
      paymentStatus: 'Paid',
      receivedTime:
          DateTime(2026, 8, 21, 10, 00),
      processingTime:
          DateTime(2026, 8, 21, 13, 00),
      readyTime:
          DateTime(2026, 8, 22, 16, 00),
      collectedTime:
          DateTime(2026, 8, 23, 12, 00),
    ),
  ];

  int selectedTab = 0;

  String searchText = '';

  String selectedFilter = 'All';

  // ==========================================================
  // COLORS
  // ==========================================================

  static const Color orange =
      Color(0xFFFF6B00);

  static const Color lightOrange =
      Color(0xFFFFF3E8);

  static const Color darkText =
      Color(0xFF17213D);

  static const Color greyText =
      Color(0xFF777777);

  // ==========================================================
  // GET FILTERED ORDERS
  // ==========================================================

  List<OrderData> get filteredOrders {
    List<OrderData> result =
        List.from(orders);

    // Search
    if (searchText.trim().isNotEmpty) {
      final search =
          searchText.toLowerCase();

      result = result.where((order) {
        return order.orderId
                .toLowerCase()
                .contains(search) ||
            order.customerName
                .toLowerCase()
                .contains(search) ||
            order.customerId
                .toLowerCase()
                .contains(search);
      }).toList();
    }

    // Filter
    if (selectedFilter != 'All') {
      result = result.where((order) {
        return order.status == selectedFilter;
      }).toList();
    }

    return result;
  }

  // ==========================================================
  // CREATE ORDER
  // ==========================================================

  void addNewOrder({
    required String customerName,
    required String service,
    required int quantity,
    required DateTime returnDate,
  }) {
    final orderNumber =
        orders.length + 1;

    final order = OrderData(
      orderId:
          'ORD${orderNumber.toString().padLeft(3, '0')}',
      customerId:
          'C${orderNumber.toString().padLeft(3, '0')}',
      customerName:
          customerName,
      service:
          service,
      quantity:
          quantity,
      orderDate:
          DateTime.now(),
      returnDate:
          returnDate,
      status:
          'Received',
      paymentStatus:
          'Pending',
      receivedTime:
          DateTime.now(),
    );

    setState(() {
      orders.insert(0, order);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Order placed successfully!',
        ),
        backgroundColor:
            Colors.green,
      ),
    );
  }

  // ==========================================================
  // UPDATE STATUS
  // ==========================================================

  void updateOrderStatus(
    OrderData order,
    String newStatus,
  ) {
    setState(() {
      order.status = newStatus;

      if (newStatus == 'Received') {
        order.receivedTime =
            DateTime.now();
      }

      if (newStatus == 'Processing') {
        order.processingTime =
            DateTime.now();
      }

      if (newStatus == 'Ready') {
        order.readyTime =
            DateTime.now();
      }

      if (newStatus == 'Collected') {
        order.collectedTime =
            DateTime.now();
      }
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Order status updated successfully.',
        ),
        backgroundColor:
            Colors.green,
      ),
    );
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor:
            Colors.white,

        foregroundColor:
            darkText,

        elevation: 0,

        title: const Text(
          'Order Tracking',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        actions: [
          IconButton(
            tooltip:
                'Place New Order',
            icon: const Icon(
              Icons.add_circle_outline,
              color: orange,
            ),
            onPressed: () {
              _showPlaceOrderScreen();
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // ====================================================
          // TAB SELECTION
          // ====================================================

          Container(
            color: Colors.white,

            padding:
                const EdgeInsets.all(12),

            child: Row(
              children: [
                Expanded(
                  child: _topTab(
                    title:
                        'My Orders',
                    icon:
                        Icons.person_outline,
                    index: 0,
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                Expanded(
                  child: _topTab(
                    title:
                        'Owner Orders',
                    icon:
                        Icons.storefront_outlined,
                    index: 1,
                  ),
                ),
              ],
            ),
          ),

          // ====================================================
          // CONTENT
          // ====================================================

          Expanded(
            child: selectedTab == 0
                ? _customerView()
                : _ownerView(),
          ),
        ],
      ),

      // ========================================================
      // FLOATING ACTION BUTTON
      // ========================================================

      floatingActionButton:
          selectedTab == 0
              ? FloatingActionButton.extended(
                  backgroundColor:
                      orange,

                  foregroundColor:
                      Colors.white,

                  icon:
                      const Icon(Icons.add),

                  label:
                      const Text(
                    'New Order',
                  ),

                  onPressed: () {
                    _showPlaceOrderScreen();
                  },
                )
              : null,
    );
  }

  // ==========================================================
  // TOP TAB
  // ==========================================================

  Widget _topTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final selected =
        selectedTab == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),

        padding:
            const EdgeInsets.symmetric(
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: selected
              ? orange
              : const Color(0xFFF5F5F5),

          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),

        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              icon,

              size: 20,

              color: selected
                  ? Colors.white
                  : darkText,
            ),

            const SizedBox(
              width: 8,
            ),

            Text(
              title,

              style: TextStyle(
                color: selected
                    ? Colors.white
                    : darkText,

                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // CUSTOMER VIEW
  // ==========================================================

  Widget _customerView() {
    final customerOrders =
        orders;

    return SingleChildScrollView(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        100,
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'My Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              color: darkText,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            'Track your laundry orders',
            style: TextStyle(
              color:
                  Colors.grey.shade600,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          // Summary
          _customerSummary(),

          const SizedBox(
            height: 20,
          ),

          if (customerOrders.isEmpty)
            _emptyOrders()

          else
            ...customerOrders.map(
              (order) =>
                  _customerOrderCard(order),
            ),
        ],
      ),
    );
  }

  // ==========================================================
  // CUSTOMER SUMMARY
  // ==========================================================

  Widget _customerSummary() {
    final active =
        orders.where(
      (order) =>
          order.status != 'Collected',
    ).length;

    final ready =
        orders.where(
      (order) =>
          order.status == 'Ready',
    ).length;

    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            title:
                'Total Orders',
            value:
                orders.length.toString(),
            icon:
                Icons.receipt_long,
            color:
                orange,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: _summaryCard(
            title:
                'Active',
            value:
                active.toString(),
            icon:
                Icons.local_laundry_service,
            color:
                Colors.blue,
          ),
        ),

        const SizedBox(
          width: 10,
        ),

        Expanded(
          child: _summaryCard(
            title:
                'Ready',
            value:
                ready.toString(),
            icon:
                Icons.check_circle_outline,
            color:
                Colors.green,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SUMMARY CARD
  // ==========================================================

  Widget _summaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding:
          const EdgeInsets.all(14),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            value,

            style:
                const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
              color: darkText,
            ),
          ),

          Text(
            title,

            style: TextStyle(
              fontSize: 11,
              color:
                  Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // CUSTOMER ORDER CARD
  // ==========================================================

  Widget _customerOrderCard(
    OrderData order,
  ) {
    final completed =
        order.status == 'Collected';

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),
            blurRadius: 10,
            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(18),

        child: Column(
          children: [

            Row(
              children: [

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        order.orderId,

                        style:
                            const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.bold,
                          color: darkText,
                        ),
                      ),

                      const SizedBox(
                        height: 5,
                      ),

                      Text(
                        order.customerName,

                        style:
                            TextStyle(
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                _statusBadge(
                  order.status,
                ),
              ],
            ),

            const Divider(
              height: 25,
            ),

            Row(
              children: [

                Expanded(
                  child: _orderInfo(
                    Icons.local_laundry_service,
                    order.service,
                  ),
                ),

                Expanded(
                  child: _orderInfo(
                    Icons.checkroom,
                    '${order.quantity} Clothes',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 12,
            ),

            Row(
              children: [

                Expanded(
                  child: _orderInfo(
                    Icons.calendar_today_outlined,
                    'Return: ${_formatDate(order.returnDate)}',
                  ),
                ),

                _paymentBadge(
                  order.paymentStatus,
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            SizedBox(
              width:
                  double.infinity,

              child:
                  OutlinedButton.icon(
                icon: Icon(
                  completed
                      ? Icons.receipt_long
                      : Icons.timeline,
                  color: orange,
                ),

                label: Text(
                  completed
                      ? 'View Order'
                      : 'Track Order',
                ),

                style:
                    OutlinedButton.styleFrom(
                  foregroundColor:
                      orange,

                  side:
                      const BorderSide(
                    color: orange,
                  ),

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 12,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      10,
                    ),
                  ),
                ),

                onPressed: () {
                  _showTrackingScreen(
                    order,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // OWNER VIEW
  // ==========================================================

  Widget _ownerView() {
    return Column(
      children: [

        // Search
        Padding(
          padding:
              const EdgeInsets.fromLTRB(
            16,
            16,
            16,
            10,
          ),

          child: TextField(
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },

            decoration:
                InputDecoration(
              hintText:
                  'Search orders...',

              prefixIcon:
                  const Icon(
                Icons.search,
                color: orange,
              ),

              suffixIcon:
                  searchText.isNotEmpty
                      ? IconButton(
                          icon:
                              const Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            setState(() {
                              searchText =
                                  '';
                            });
                          },
                        )
                      : null,

              filled: true,

              fillColor:
                  Colors.white,

              border:
                  OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),

                borderSide:
                    BorderSide.none,
              ),
            ),
          ),
        ),

        // Filters
        _filterButtons(),

        const SizedBox(
          height: 8,
        ),

        Expanded(
          child:
              filteredOrders.isEmpty
                  ? _emptyOrders()
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(
                        16,
                        5,
                        16,
                        20,
                      ),

                      itemCount:
                          filteredOrders.length,

                      itemBuilder:
                          (context, index) {
                        return _ownerOrderCard(
                          filteredOrders[
                              index],
                        );
                      },
                    ),
        ),
      ],
    );
  }

  // ==========================================================
  // FILTER BUTTONS
  // ==========================================================

  Widget _filterButtons() {
    final filters = [
      'All',
      'Received',
      'Processing',
      'Ready',
      'Collected',
    ];

    return SingleChildScrollView(
      scrollDirection:
          Axis.horizontal,

      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      child: Row(
        children: filters.map(
          (filter) {
            final selected =
                selectedFilter ==
                    filter;

            return Padding(
              padding:
                  const EdgeInsets.only(
                right: 8,
              ),

              child:
                  ChoiceChip(
                label:
                    Text(filter),

                selected:
                    selected,

                selectedColor:
                    orange,

                backgroundColor:
                    Colors.white,

                labelStyle:
                    TextStyle(
                  color: selected
                      ? Colors.white
                      : darkText,

                  fontWeight:
                      FontWeight.w500,
                ),

                onSelected:
                    (_) {
                  setState(() {
                    selectedFilter =
                        filter;
                  });
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ==========================================================
  // OWNER ORDER CARD
  // ==========================================================

  Widget _ownerOrderCard(
    OrderData order,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.05,
            ),

            blurRadius: 10,

            offset:
                const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                padding:
                    const EdgeInsets.all(
                  11,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      lightOrange,

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: const Icon(
                  Icons.receipt_long,
                  color: orange,
                ),
              ),

              const SizedBox(
                width: 12,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      order.orderId,

                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.bold,
                        color: darkText,
                      ),
                    ),

                    const SizedBox(
                      height: 3,
                    ),

                    Text(
                      order.customerName,

                      style:
                          TextStyle(
                        color:
                            Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              _statusBadge(
                order.status,
              ),
            ],
          ),

          const Divider(
            height: 25,
          ),

          _ownerInfoRow(
            'Customer ID',
            order.customerId,
          ),

          _ownerInfoRow(
            'Service',
            order.service,
          ),

          _ownerInfoRow(
            'Clothes',
            order.quantity.toString(),
          ),

          _ownerInfoRow(
            'Expected Return',
            _formatDate(
              order.returnDate,
            ),
          ),

          _ownerInfoRow(
            'Payment',
            order.paymentStatus,
          ),

          const SizedBox(
            height: 14,
          ),

          Row(
            children: [

              Expanded(
                child:
                    OutlinedButton(
                  onPressed: () {
                    _showTrackingScreen(
                      order,
                    );
                  },

                  style:
                      OutlinedButton.styleFrom(
                    foregroundColor:
                        orange,

                    side:
                        const BorderSide(
                      color: orange,
                    ),

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  child:
                      const Text(
                    'Track',
                  ),
                ),
              ),

              const SizedBox(
                width: 10,
              ),

              Expanded(
                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    _showUpdateStatusDialog(
                      order,
                    );
                  },

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        orange,

                    foregroundColor:
                        Colors.white,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ),

                  icon:
                      const Icon(
                    Icons.edit,
                    size: 18,
                  ),

                  label:
                      const Text(
                    'Update Status',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // ORDER INFORMATION
  // ==========================================================

  Widget _orderInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [

        Icon(
          icon,
          size: 18,
          color: orange,
        ),

        const SizedBox(
          width: 7,
        ),

        Expanded(
          child: Text(
            text,

            style:
                const TextStyle(
              fontSize: 12,
              color: darkText,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // OWNER INFO ROW
  // ==========================================================

  Widget _ownerInfoRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 9,
      ),

      child: Row(
        children: [

          SizedBox(
            width: 120,

            child: Text(
              title,

              style:
                  TextStyle(
                color:
                    Colors.grey.shade600,

                fontSize: 13,
              ),
            ),
          ),

          const Text(
            ':',
            style:
                TextStyle(
              color: greyText,
            ),
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child: Text(
              value,

              style:
                  const TextStyle(
                color: darkText,
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // STATUS BADGE
  // ==========================================================

  Widget _statusBadge(
    String status,
  ) {
    Color background;
    Color foreground;
    IconData icon;

    switch (status) {
      case 'Collected':
        background =
            Colors.green.shade50;
        foreground =
            Colors.green.shade700;
        icon =
            Icons.check_circle;

        break;

      case 'Ready':
        background =
            Colors.blue.shade50;
        foreground =
            Colors.blue.shade700;
        icon =
            Icons.inventory_2_outlined;

        break;

      case 'Processing':
        background =
            Colors.orange.shade50;
        foreground =
            orange;
        icon =
            Icons.local_laundry_service;

        break;

      default:
        background =
            Colors.grey.shade100;
        foreground =
            Colors.grey.shade700;
        icon =
            Icons.schedule;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),

      decoration:
          BoxDecoration(
        color: background,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
            MainAxisSize.min,

        children: [

          Icon(
            icon,
            size: 14,
            color: foreground,
          ),

          const SizedBox(
            width: 5,
          ),

          Text(
            status.toUpperCase(),

            style:
                TextStyle(
              color: foreground,
              fontSize: 10,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PAYMENT BADGE
  // ==========================================================

  Widget _paymentBadge(
    String status,
  ) {
    final paid =
        status == 'Paid';

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),

      decoration:
          BoxDecoration(
        color: paid
            ? Colors.green.shade50
            : Colors.orange.shade50,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status,

        style:
            TextStyle(
          color: paid
              ? Colors.green.shade700
              : orange,

          fontWeight:
              FontWeight.w600,

          fontSize: 11,
        ),
      ),
    );
  }

  // ==========================================================
  // EMPTY ORDERS
  // ==========================================================

  Widget _emptyOrders() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(40),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(
              width: 80,
              height: 80,

              decoration:
                  const BoxDecoration(
                color: lightOrange,
                shape: BoxShape.circle,
              ),

              child:
                  const Icon(
                Icons.local_laundry_service,
                color: orange,
                size: 40,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            const Text(
              'No orders found',

              style:
                  TextStyle(
                fontSize: 18,
                fontWeight:
                    FontWeight.bold,
                color: darkText,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Your orders will appear here.',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                color:
                    Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // PLACE NEW ORDER
  // ==========================================================

  void _showPlaceOrderScreen() {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            PlaceOrderScreen(
          onOrderPlaced:
              addNewOrder,
        ),
      ),
    );
  }

  // ==========================================================
  // TRACKING SCREEN
  // ==========================================================

  void _showTrackingScreen(
    OrderData order,
  ) {
    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) =>
            OrderProgressScreen(
          order: order,
        ),
      ),
    );
  }

  // ==========================================================
  // UPDATE STATUS DIALOG
  // ==========================================================

  void _showUpdateStatusDialog(
    OrderData order,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        String selectedStatus =
            order.status;

        return StatefulBuilder(
          builder:
              (context, setDialogState) {
            return AlertDialog(
              title:
                  const Text(
                'Update Order Status',
                style:
                    TextStyle(
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              content:
                  SingleChildScrollView(
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    RadioListTile<String>(
                      value:
                          'Received',

                      groupValue:
                          selectedStatus,

                      activeColor:
                          orange,

                      title:
                          const Text(
                        'Order Received',
                      ),

                      onChanged:
                          (value) {
                        setDialogState(() {
                          selectedStatus =
                              value!;
                        });
                      },
                    ),

                    RadioListTile<String>(
                      value:
                          'Processing',

                      groupValue:
                          selectedStatus,

                      activeColor:
                          orange,

                      title:
                          Text(
                        order.processingStatus,
                      ),

                      onChanged:
                          (value) {
                        setDialogState(() {
                          selectedStatus =
                              value!;
                        });
                      },
                    ),

                    RadioListTile<String>(
                      value:
                          'Ready',

                      groupValue:
                          selectedStatus,

                      activeColor:
                          orange,

                      title:
                          const Text(
                        'Clothes Are Ready',
                      ),

                      onChanged:
                          (value) {
                        setDialogState(() {
                          selectedStatus =
                              value!;
                        });
                      },
                    ),

                    RadioListTile<String>(
                      value:
                          'Collected',

                      groupValue:
                          selectedStatus,

                      activeColor:
                          orange,

                      title:
                          const Text(
                        'Customer Collected',
                      ),

                      onChanged:
                          (value) {
                        setDialogState(() {
                          selectedStatus =
                              value!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },

                  child:
                      const Text(
                    'Cancel',
                    style:
                        TextStyle(
                      color: greyText,
                    ),
                  ),
                ),

                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        orange,

                    foregroundColor:
                        Colors.white,
                  ),

                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );

                    updateOrderStatus(
                      order,
                      selectedStatus,
                    );
                  },

                  child:
                      const Text(
                    'Update',
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // DATE FORMAT
  // ==========================================================

  String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ============================================================
// PLACE ORDER SCREEN
// ============================================================

class PlaceOrderScreen
    extends StatefulWidget {
  final Function({
    required String customerName,
    required String service,
    required int quantity,
    required DateTime returnDate,
  }) onOrderPlaced;

  const PlaceOrderScreen({
    super.key,
    required this.onOrderPlaced,
  });

  @override
  State<PlaceOrderScreen> createState() =>
      _PlaceOrderScreenState();
}

class _PlaceOrderScreenState
    extends State<PlaceOrderScreen> {

  final TextEditingController
      nameController =
          TextEditingController();

  String selectedService =
      'Ironing';

  int quantity = 1;

  DateTime returnDate =
      DateTime.now().add(
    const Duration(
      days: 2,
    ),
  );

  final orange =
      const Color(0xFFFF6B00);

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  // ==========================================================
  // SELECT DATE
  // ==========================================================

  Future<void> selectDate() async {
    final date =
        await showDatePicker(
      context: context,

      initialDate:
          returnDate,

      firstDate:
          DateTime.now(),

      lastDate:
          DateTime.now().add(
        const Duration(
          days: 30,
        ),
      ),

      builder:
          (context, child) {
        return Theme(
          data:
              Theme.of(context).copyWith(
            colorScheme:
                const ColorScheme.light(
              primary:
                  Color(0xFFFF6B00),
            ),
          ),

          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        returnDate = date;
      });
    }
  }

  // ==========================================================
  // PLACE ORDER
  // ==========================================================

  void placeOrder() {
    final name =
        nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter customer name.',
          ),
        ),
      );

      return;
    }

    widget.onOrderPlaced(
      customerName: name,
      service: selectedService,
      quantity: quantity,
      returnDate: returnDate,
    );

    Navigator.pop(context);
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        title:
            const Text(
          'Place New Order',
          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        backgroundColor:
            Colors.white,

        foregroundColor:
            const Color(0xFF17213D),

        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // --------------------------------------------------
            // HEADER
            // --------------------------------------------------

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration:
                  BoxDecoration(
                color: orange,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.local_laundry_service,
                    color:
                        Colors.white,
                    size: 35,
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  Text(
                    'Place Your Laundry Order',

                    style:
                        TextStyle(
                      color:
                          Colors.white,
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(
                    height: 5,
                  ),

                  Text(
                    'Enter your order details below.',

                    style:
                        TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 22,
            ),

            // --------------------------------------------------
            // CUSTOMER NAME
            // --------------------------------------------------

            _sectionTitle(
              'Customer Name',
            ),

            const SizedBox(
              height: 8,
            ),

            TextField(
              controller:
                  nameController,

              decoration:
                  InputDecoration(
                hintText:
                    'Enter customer name',

                prefixIcon:
                    const Icon(
                  Icons.person_outline,
                  color:
                      Color(0xFFFF6B00),
                ),

                filled: true,

                fillColor:
                    Colors.white,

                border:
                    OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),

                  borderSide:
                      BorderSide.none,
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // --------------------------------------------------
            // SERVICE
            // --------------------------------------------------

            _sectionTitle(
              'Select Service',
            ),

            const SizedBox(
              height: 8,
            ),

            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 15,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child:
                  DropdownButtonHideUnderline(
                child:
                    DropdownButton<String>(
                  value:
                      selectedService,

                  isExpanded:
                      true,

                  icon:
                      const Icon(
                    Icons.keyboard_arrow_down,
                    color:
                        Color(0xFFFF6B00),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value:
                          'Ironing',
                      child:
                          Text('Ironing'),
                    ),

                    DropdownMenuItem(
                      value:
                          'Washing',
                      child:
                          Text('Washing'),
                    ),

                    DropdownMenuItem(
                      value:
                          'Dry Cleaning',
                      child:
                          Text('Dry Cleaning'),
                    ),

                    DropdownMenuItem(
                      value:
                          'Dyeing',
                      child:
                          Text('Dyeing'),
                    ),
                  ],

                  onChanged:
                      (value) {
                    setState(() {
                      selectedService =
                          value!;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // --------------------------------------------------
            // QUANTITY
            // --------------------------------------------------

            _sectionTitle(
              'Number of Clothes',
            ),

            const SizedBox(
              height: 8,
            ),

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                15,
              ),

              decoration:
                  BoxDecoration(
                color: Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),

              child: Row(
                children: [

                  const Icon(
                    Icons.checkroom_outlined,
                    color:
                        Color(0xFFFF6B00),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  const Expanded(
                    child:
                        Text(
                      'Clothes Quantity',
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ),

                  _quantityButton(
                    icon:
                        Icons.remove,
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                  ),

                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 16,
                    ),

                    child:
                        Text(
                      '$quantity',

                      style:
                          const TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  _quantityButton(
                    icon:
                        Icons.add,
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // --------------------------------------------------
            // RETURN DATE
            // --------------------------------------------------

            _sectionTitle(
              'Expected Return Date',
            ),

            const SizedBox(
              height: 8,
            ),

            GestureDetector(
              onTap:
                  selectDate,

              child: Container(
                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(
                  16,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      Colors.white,

                  borderRadius:
                      BorderRadius.circular(
                    12,
                  ),
                ),

                child: Row(
                  children: [

                    const Icon(
                      Icons.calendar_month,
                      color:
                          Color(0xFFFF6B00),
                    ),

                    const SizedBox(
                      width: 12,
                    ),

                    Expanded(
                      child:
                          Text(
                        _formatDate(
                          returnDate,
                        ),

                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),

                    const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                      color:
                          Colors.grey,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 28,
            ),

            // --------------------------------------------------
            // PLACE ORDER BUTTON
            // --------------------------------------------------

            SizedBox(
              width:
                  double.infinity,

              height: 55,

              child:
                  ElevatedButton.icon(
                onPressed:
                    placeOrder,

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      orange,

                  foregroundColor:
                      Colors.white,

                  elevation: 2,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),

                icon:
                    const Icon(
                  Icons.shopping_bag_outlined,
                ),

                label:
                    const Text(
                  'Place Order',
                  style:
                      TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SECTION TITLE
  // ==========================================================

  Widget _sectionTitle(
    String title,
  ) {
    return Text(
      title,

      style:
          const TextStyle(
        color:
            Color(0xFF17213D),

        fontSize: 15,

        fontWeight:
            FontWeight.bold,
      ),
    );
  }

  // ==========================================================
  // QUANTITY BUTTON
  // ==========================================================

  Widget _quantityButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 35,
        height: 35,

        decoration:
            BoxDecoration(
          color:
              const Color(0xFFFFF3E8),

          borderRadius:
              BorderRadius.circular(
            9,
          ),
        ),

        child: Icon(
          icon,

          size: 18,

          color:
              const Color(0xFFFF6B00),
        ),
      ),
    );
  }

  // ==========================================================
  // DATE FORMAT
  // ==========================================================

  String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

// ============================================================
// ORDER PROGRESS SCREEN
// ============================================================

class OrderProgressScreen
    extends StatefulWidget {

  final OrderData order;

  const OrderProgressScreen({
    super.key,
    required this.order,
  });

  @override
  State<OrderProgressScreen> createState() =>
      _OrderProgressScreenState();
}

class _OrderProgressScreenState
    extends State<OrderProgressScreen> {

  static const Color orange =
      Color(0xFFFF6B00);

  static const Color darkText =
      Color(0xFF17213D);

  // ==========================================================
  // STATUS NUMBER
  // ==========================================================

  int get statusIndex {
    switch (widget.order.status) {
      case 'Processing':
        return 1;

      case 'Ready':
        return 2;

      case 'Collected':
        return 3;

      case 'Received':
      default:
        return 0;
    }
  }

  // ==========================================================
  // PROGRESS
  // ==========================================================

  double get progress {
    return statusIndex / 3;
  }

  // ==========================================================
  // STATUS LIST
  // ==========================================================

  List<Map<String, dynamic>>
      get trackingSteps {

    return [
      {
        'title':
            'Order Received',

        'description':
            'Your order has been received.',

        'icon':
            Icons.inbox_outlined,

        'date':
            widget.order.receivedTime,
      },

      {
        'title':
            widget.order.processingStatus,

        'description':
            'Your clothes are being processed.',

        'icon':
            Icons.local_laundry_service,

        'date':
            widget.order.processingTime,
      },

      {
        'title':
            'Clothes Are Ready',

        'description':
            'Your clothes are ready for collection.',

        'icon':
            Icons.checkroom_outlined,

        'date':
            widget.order.readyTime,
      },

      {
        'title':
            'Customer Collected',

        'description':
            'The clothes have been collected.',

        'icon':
            Icons.check_circle_outline,

        'date':
            widget.order.collectedTime,
      },
    ];
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        title:
            const Text(
          'Track Order',
          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        backgroundColor:
            Colors.white,

        foregroundColor:
            darkText,

        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            // ==================================================
            // ORDER HEADER
            // ==================================================

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                20,
              ),

              decoration:
                  BoxDecoration(
                color: orange,

                borderRadius:
                    BorderRadius.circular(
                  20,
                ),

                boxShadow: [
                  BoxShadow(
                    color:
                        orange.withOpacity(
                      0.25,
                    ),

                    blurRadius: 15,

                    offset:
                        const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      Container(
                        width: 48,
                        height: 48,

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white.withOpacity(
                            0.2,
                          ),

                          borderRadius:
                              BorderRadius.circular(
                            13,
                          ),
                        ),

                        child:
                            const Icon(
                          Icons.receipt_long,
                          color:
                              Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 13,
                      ),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,

                          children: [

                            const Text(
                              'Order Tracking',

                              style:
                                  TextStyle(
                                color:
                                    Colors.white70,
                                fontSize: 13,
                              ),
                            ),

                            const SizedBox(
                              height: 3,
                            ),

                            Text(
                              widget.order.orderId,

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  Text(
                    widget.order.customerName,

                    style:
                        const TextStyle(
                      color:
                          Colors.white,
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 5,
                  ),

                  Text(
                    '${widget.order.service} • '
                    '${widget.order.quantity} Clothes',

                    style:
                        const TextStyle(
                      color:
                          Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // PROGRESS CARD
            // ==================================================

            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Row(
                    children: [

                      const Expanded(
                        child:
                            Text(
                          'Order Progress',
                          style:
                              TextStyle(
                            fontSize: 17,
                            fontWeight:
                                FontWeight.bold,
                            color:
                                darkText,
                          ),
                        ),
                      ),

                      Text(
                        '${(progress * 100).round()}%',

                        style:
                            const TextStyle(
                          color:
                              orange,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),

                    child:
                        LinearProgressIndicator(
                      value:
                          progress,

                      minHeight: 9,

                      backgroundColor:
                          Colors.grey.shade200,

                      valueColor:
                          const AlwaysStoppedAnimation<
                              Color>(
                        orange,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // ORDER DETAILS
            // ==================================================

            _detailsCard(),

            const SizedBox(
              height: 20,
            ),

            // ==================================================
            // TIMELINE
            // ==================================================

            const Text(
              'Order Timeline',

              style:
                  TextStyle(
                fontSize: 19,
                fontWeight:
                    FontWeight.bold,
                color:
                    darkText,
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            Container(
              padding:
                  const EdgeInsets.all(
                18,
              ),

              decoration:
                  BoxDecoration(
                color:
                    Colors.white,

                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),

              child:
                  _timeline(),
            ),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DETAILS CARD
  // ==========================================================

  Widget _detailsCard() {
    return Container(
      padding:
          const EdgeInsets.all(18),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),
      ),

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          const Text(
            'Order Details',

            style:
                TextStyle(
              fontSize: 17,
              fontWeight:
                  FontWeight.bold,
              color:
                  darkText,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          _detailRow(
            'Customer ID',
            widget.order.customerId,
          ),

          _detailRow(
            'Service',
            widget.order.service,
          ),

          _detailRow(
            'Number of Clothes',
            widget.order.quantity
                .toString(),
          ),

          _detailRow(
            'Order Date',
            _formatDate(
              widget.order.orderDate,
            ),
          ),

          _detailRow(
            'Return Date',
            _formatDate(
              widget.order.returnDate,
            ),
          ),

          _detailRow(
            'Payment Status',
            widget.order.paymentStatus,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // DETAIL ROW
  // ==========================================================

  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.only(
        bottom: 11,
      ),

      child: Row(
        children: [

          Expanded(
            child: Text(
              title,

              style:
                  TextStyle(
                color:
                    Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ),

          Text(
            value,

            style:
                const TextStyle(
              color: darkText,
              fontSize: 13,
              fontWeight:
                  FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TIMELINE
  // ==========================================================

  Widget _timeline() {
    return Column(
      children: List.generate(
        trackingSteps.length,
        (index) {

          final step =
              trackingSteps[index];

          final completed =
              index <= statusIndex;

          final current =
              index == statusIndex;

          final isLast =
              index ==
                  trackingSteps.length - 1;

          return _timelineItem(
            title:
                step['title'],

            description:
                step['description'],

            icon:
                step['icon'],

            date:
                step['date'],

            completed:
                completed,

            current:
                current,

            isLast:
                isLast,
          );
        },
      ),
    );
  }

  // ==========================================================
  // TIMELINE ITEM
  // ==========================================================

  Widget _timelineItem({
    required String title,
    required String description,
    required IconData icon,
    required DateTime? date,
    required bool completed,
    required bool current,
    required bool isLast,
  }) {
    final color =
        completed
            ? orange
            : Colors.grey.shade300;

    final textColor =
        completed
            ? darkText
            : Colors.grey.shade500;

    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        // ======================================================
        // CIRCLE + LINE
        // ======================================================

        SizedBox(
          width: 45,

          child: Column(
            children: [

              AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 250,
                ),

                width:
                    current ? 44 : 38,

                height:
                    current ? 44 : 38,

                decoration:
                    BoxDecoration(
                  color: completed
                      ? color
                      : Colors.white,

                  shape:
                      BoxShape.circle,

                  border:
                      Border.all(
                    color: color,
                    width:
                        current ? 3 : 2,
                  ),

                  boxShadow:
                      current
                          ? [
                              BoxShadow(
                                color:
                                    orange.withOpacity(
                                  0.25,
                                ),

                                blurRadius:
                                    10,
                              ),
                            ]
                          : null,
                ),

                child:
                    Icon(
                  completed
                      ? Icons.check
                      : icon,

                  size:
                      current ? 22 : 19,

                  color: completed
                      ? Colors.white
                      : Colors.grey.shade400,
                ),
              ),

              if (!isLast)
                Container(
                  width: 3,
                  height: 65,

                  margin:
                      const EdgeInsets.symmetric(
                    vertical: 3,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        indexLineColor(
                      completed,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      5,
                    ),
                  ),
                ),
            ],
          ),
        ),

        const SizedBox(
          width: 12,
        ),

        // ======================================================
        // CONTENT
        // ======================================================

        Expanded(
          child: Container(
            margin:
                const EdgeInsets.only(
              bottom: 15,
            ),

            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration:
                BoxDecoration(
              color: current
                  ? const Color(
                      0xFFFFF3E8,
                    )
                  : Colors.grey.shade50,

              borderRadius:
                  BorderRadius.circular(
                14,
              ),

              border: current
                  ? Border.all(
                      color:
                          Colors.orange.shade200,
                    )
                  : null,
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child:
                          Text(
                        title,

                        style:
                            TextStyle(
                          color:
                              textColor,

                          fontSize:
                              15,

                          fontWeight:
                              current ||
                                      completed
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                        ),
                      ),
                    ),

                    if (current)
                      Container(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),

                        decoration:
                            BoxDecoration(
                          color:
                              orange,

                          borderRadius:
                              BorderRadius.circular(
                            10,
                          ),
                        ),

                        child:
                            const Text(
                          'CURRENT',

                          style:
                              TextStyle(
                            color:
                                Colors.white,
                            fontSize:
                                8,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(
                  height: 5,
                ),

                Text(
                  description,

                  style:
                      TextStyle(
                    color:
                        completed
                            ? Colors.grey.shade600
                            : Colors.grey.shade400,

                    fontSize: 12,
                  ),
                ),

                if (date != null) ...[
                  const SizedBox(
                    height: 8,
                  ),

                  Row(
                    children: [

                      Icon(
                        Icons
                            .access_time,
                        size: 13,
                        color:
                            Colors.grey.shade500,
                      ),

                      const SizedBox(
                        width: 5,
                      ),

                      Text(
                        _formatDateTime(
                          date,
                        ),

                        style:
                            TextStyle(
                          color:
                              Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // LINE COLOR
  // ==========================================================

  Color indexLineColor(
    bool completed,
  ) {
    return completed
        ? orange
        : Colors.grey.shade300;
  }

  // ==========================================================
  // DATE
  // ==========================================================

  String _formatDate(
    DateTime date,
  ) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ==========================================================
  // DATE + TIME
  // ==========================================================

  String _formatDateTime(
    DateTime date,
  ) {
    final hour =
        date.hour == 0
            ? 12
            : date.hour > 12
                ? date.hour - 12
                : date.hour;

    final minute =
        date.minute.toString().padLeft(
              2,
              '0',
            );

    final period =
        date.hour >= 12
            ? 'PM'
            : 'AM';

    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} • '
        '$hour:$minute $period';
  }
}