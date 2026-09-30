import 'package:flutter/material.dart';

class PaymentModule extends StatefulWidget {
  const PaymentModule({super.key});

  @override
  State<PaymentModule> createState() => _PaymentModuleState();
}

class _PaymentModuleState extends State<PaymentModule> {
  // ============================================================
  // COLORS
  // ============================================================

  static const Color primaryColor = Color.fromARGB(255, 199, 129, 16);
  static const Color lightBlue = Color.fromARGB(255, 166, 94, 22);

  static const Color paidColor = Color(0xFF2E7D32);
  static const Color paidLight = Color(0xFFE8F5E9);

  static const Color pendingColor = Color(0xFFEF6C00);
  static const Color pendingLight = Color(0xFFFFF3E0);

  static const Color backgroundColor = Color.fromARGB(255, 213, 128, 16);

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchController =
      TextEditingController();

  // ============================================================
  // FILTER
  // ============================================================

  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Pending',
    'Paid',
  ];

  // ============================================================
  // PAYMENT DATA
  //
  // IMPORTANT:
  // This list is intentionally EMPTY.
  // Payment records will later come from the Billing Module.
  // ============================================================

  final List<PaymentData> payments = [];

  // ============================================================
  // FILTERED PAYMENTS
  // ============================================================

  List<PaymentData> get filteredPayments {
    final query = searchController.text.trim().toLowerCase();

    return payments.where((payment) {
      final matchesSearch =
          payment.customerName.toLowerCase().contains(query) ||
          payment.orderId.toLowerCase().contains(query) ||
          payment.billNumber.toLowerCase().contains(query) ||
          payment.paymentId.toLowerCase().contains(query);

      final matchesFilter =
          selectedFilter == 'All' ||
          payment.paymentStatus == selectedFilter;

      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ============================================================
  // SUMMARY
  // ============================================================

  int get totalPayments => payments.length;

  int get paidOrders => payments
      .where((payment) => payment.paymentStatus == 'Paid')
      .length;

  int get pendingOrders => payments
      .where((payment) => payment.paymentStatus == 'Pending')
      .length;

  double get paidAmount => payments
      .where((payment) => payment.paymentStatus == 'Paid')
      .fold(0, (sum, payment) => sum + payment.amount);

  double get pendingAmount => payments
      .where((payment) => payment.paymentStatus == 'Pending')
      .fold(0, (sum, payment) => sum + payment.amount);

  double get totalAmount =>
      payments.fold(0, (sum, payment) => sum + payment.amount);

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: const Text(
          'Payment Management',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              const SizedBox(height: 18),

              _buildSummary(),

              const SizedBox(height: 22),

              _buildSearchBar(),

              const SizedBox(height: 14),

              _buildFilterButtons(),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Text(
                    'Payment Records',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const Spacer(),

                  Text(
                    '${filteredPayments.length} records',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (filteredPayments.isEmpty)
                _buildEmptyState()
              else
                ...filteredPayments.map(
                  (payment) => _buildPaymentCard(payment),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            primaryColor,
            Color(0xFF1976D2),
          ],
        ),

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.20),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 55,
            width: 55,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.payments_outlined,
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
                  'Payment Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Track and confirm customer payments',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
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
  // SUMMARY
  // ============================================================

  Widget _buildSummary() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Total Payments',
                value: '$totalPayments',
                icon: Icons.receipt_long_outlined,
                color: primaryColor,
                background: lightBlue,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSummaryCard(
                title: 'Paid Orders',
                value: '$paidOrders',
                icon: Icons.check_circle_outline,
                color: paidColor,
                background: paidLight,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Paid Amount',
                value: _formatCurrency(paidAmount),
                icon: Icons.account_balance_wallet_outlined,
                color: paidColor,
                background: paidLight,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSummaryCard(
                title: 'Pending Amount',
                value: _formatCurrency(pendingAmount),
                icon: Icons.pending_actions_outlined,
                color: pendingColor,
                background: pendingLight,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'Pending Orders',
                value: '$pendingOrders',
                icon: Icons.access_time_outlined,
                color: pendingColor,
                background: pendingLight,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: _buildSummaryCard(
                title: 'Total Amount',
                value: _formatCurrency(totalAmount),
                icon: Icons.currency_rupee,
                color: primaryColor,
                background: lightBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // SUMMARY CARD
  // ============================================================

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required Color background,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,

            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(11),
            ),

            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
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
  // SEARCH BAR
  // ============================================================

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,

      onChanged: (_) {
        setState(() {});
      },

      decoration: InputDecoration(
        hintText: 'Search payments...',

        prefixIcon: const Icon(
          Icons.search,
        ),

        suffixIcon: searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();

                  setState(() {});
                },
              )
            : null,

        filled: true,
        fillColor: Colors.white,

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
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FILTER BUTTONS
  // ============================================================

  Widget _buildFilterButtons() {
    return SizedBox(
      height: 44,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,

        itemCount: filters.length,

        separatorBuilder: (_, __) {
          return const SizedBox(width: 8);
        },

        itemBuilder: (context, index) {
          final filter = filters[index];

          final bool isSelected =
              selectedFilter == filter;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFilter = filter;
              });
            },

            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),

              decoration: BoxDecoration(
                color: isSelected
                    ? primaryColor
                    : Colors.white,

                borderRadius:
                    BorderRadius.circular(25),

                border: Border.all(
                  color: isSelected
                      ? primaryColor
                      : Colors.grey.shade300,
                ),
              ),

              child: Center(
                child: Row(
                  children: [
                    if (filter == 'Pending')
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : pendingColor,
                      ),

                    if (filter == 'Paid')
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: isSelected
                            ? Colors.white
                            : paidColor,
                      ),

                    if (filter != 'All')
                      const SizedBox(width: 5),

                    Text(
                      filter,

                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade700,

                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // PAYMENT CARD
  // ============================================================

  Widget _buildPaymentCard(
    PaymentData payment,
  ) {
    final bool isPaid =
        payment.paymentStatus == 'Paid';

    final Color statusColor =
        isPaid ? paidColor : pendingColor;

    final Color statusBackground =
        isPaid ? paidLight : pendingLight;

    return GestureDetector(
      onTap: () {
        _showPaymentDetails(payment);
      },

      child: Container(
        width: double.infinity,

        margin: const EdgeInsets.only(
          bottom: 14,
        ),

        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: isPaid
                ? Colors.green.shade100
                : Colors.orange.shade100,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 44,
                  width: 44,

                  decoration: BoxDecoration(
                    color: statusBackground,
                    borderRadius:
                        BorderRadius.circular(12),
                  ),

                  child: Icon(
                    isPaid
                        ? Icons.check_circle_outline
                        : Icons.pending_outlined,

                    color: statusColor,
                    size: 23,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        payment.orderId,

                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        payment.paymentId,

                        style: TextStyle(
                          fontSize: 11,
                          color:
                              Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                _buildStatusBadge(
                  payment.paymentStatus,
                ),
              ],
            ),

            const SizedBox(height: 15),

            const Divider(),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 18,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    payment.customerName,

                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                Text(
                  payment.billNumber,

                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    icon: Icons.currency_rupee,
                    label: 'Amount',
                    value:
                        _formatCurrency(
                      payment.amount,
                    ),
                    valueColor: primaryColor,
                  ),
                ),

                Expanded(
                  child: _buildInfoItem(
                    icon:
                        Icons.payment_outlined,
                    label: 'Method',
                    value:
                        payment.paymentMethod,
                    valueColor:
                        Colors.grey.shade800,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            if (!isPaid)
              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: () {
                    _confirmPayment(payment);
                  },

                  icon: const Icon(
                    Icons.check_circle_outline,
                    size: 19,
                  ),

                  label: const Text(
                    'Confirm Payment',
                  ),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        paidColor,

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 12,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              )
            else
              const Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.check_circle,
                    color: paidColor,
                    size: 18,
                  ),

                  SizedBox(width: 6),

                  Text(
                    'Payment Completed',
                    style: TextStyle(
                      color: paidColor,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _buildStatusBadge(
    String status,
  ) {
    final bool isPaid =
        status == 'Paid';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color:
            isPaid ? paidLight : pendingLight,

        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          Icon(
            isPaid
                ? Icons.check_circle
                : Icons.access_time,

            size: 14,

            color:
                isPaid ? paidColor : pendingColor,
          ),

          const SizedBox(width: 4),

          Text(
            status.toUpperCase(),

            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color:
                  isPaid ? paidColor : pendingColor,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // INFO ITEM
  // ============================================================

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 17,
          color: Colors.grey.shade600,
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                label,

                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,

                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // PAYMENT DETAILS
  // ============================================================

  void _showPaymentDetails(
    PaymentData payment,
  ) {
    final bool isPaid =
        payment.paymentStatus == 'Paid';

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor: Colors.transparent,

      builder: (context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            25,
          ),

          decoration: const BoxDecoration(
            color: Colors.white,

            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),

          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Container(
                  height: 4,
                  width: 45,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,

                      decoration: BoxDecoration(
                        color: isPaid
                            ? paidLight
                            : pendingLight,

                        borderRadius:
                            BorderRadius.circular(12),
                      ),

                      child: Icon(
                        isPaid
                            ? Icons.check_circle_outline
                            : Icons.pending_outlined,

                        color: isPaid
                            ? paidColor
                            : pendingColor,
                      ),
                    ),

                    const SizedBox(width: 12),

                    const Expanded(
                      child: Text(
                        'Payment Details',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      icon: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                _buildDetailRow(
                  'Payment ID',
                  payment.paymentId,
                ),

                _buildDetailRow(
                  'Order Number',
                  payment.orderId,
                ),

                _buildDetailRow(
                  'Bill Number',
                  payment.billNumber,
                ),

                _buildDetailRow(
                  'Customer Name',
                  payment.customerName,
                ),

                _buildDetailRow(
                  'Amount',
                  _formatCurrency(
                    payment.amount,
                  ),
                  valueColor: primaryColor,
                ),

                _buildDetailRow(
                  'Payment Method',
                  payment.paymentMethod,
                ),

                _buildDetailRow(
                  'Payment Status',
                  payment.paymentStatus,
                  valueColor: isPaid
                      ? paidColor
                      : pendingColor,
                ),

                _buildDetailRow(
                  'Payment Date',
                  payment.paymentDate == null
                      ? 'Not Paid Yet'
                      : _formatDate(
                          payment.paymentDate!,
                        ),
                ),

                const SizedBox(height: 15),

                if (!isPaid)
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);

                        _confirmPayment(
                          payment,
                        );
                      },

                      icon: const Icon(
                        Icons.check_circle_outline,
                      ),

                      label: const Text(
                        'Confirm Payment',
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            paidColor,

                        foregroundColor:
                            Colors.white,

                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            13,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,

                    padding:
                        const EdgeInsets.all(14),

                    decoration:
                        BoxDecoration(
                      color: paidLight,

                      borderRadius:
                          BorderRadius.circular(
                        13,
                      ),
                    ),

                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [
                        Icon(
                          Icons.check_circle,
                          color: paidColor,
                        ),

                        SizedBox(width: 8),

                        Text(
                          'Payment Completed',
                          style: TextStyle(
                            color: paidColor,
                            fontWeight:
                                FontWeight.bold,
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

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _buildDetailRow(
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
      ),

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
          ),
        ),
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Expanded(
            child: Text(
              label,

              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          const SizedBox(width: 15),

          Flexible(
            child: Text(
              value,

              textAlign: TextAlign.right,

              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: valueColor ??
                    Colors.grey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONFIRM PAYMENT
  // ============================================================

  void _confirmPayment(
    PaymentData payment,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          icon: Container(
            height: 55,
            width: 55,

            decoration: BoxDecoration(
              color: paidLight,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.payments_outlined,
              color: paidColor,
              size: 28,
            ),
          ),

          title: const Text(
            'Confirm Payment?',
            textAlign: TextAlign.center,

            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: Text(
            'Are you sure you want to mark this payment as Paid?\n\n'
            'Order: ${payment.orderId}\n'
            'Amount: ${_formatCurrency(payment.amount)}',

            textAlign: TextAlign.center,

            style: TextStyle(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),

          actionsAlignment:
              MainAxisAlignment.center,

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child: const Text(
                'Cancel',
              ),
            ),

            const SizedBox(width: 8),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  payment.paymentStatus =
                      'Paid';

                  payment.paymentDate =
                      DateTime.now();
                });

                Navigator.pop(
                  dialogContext,
                );

                _showSuccessMessage();
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    paidColor,

                foregroundColor:
                    Colors.white,

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 11,
                ),

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10),
                ),
              ),

              child: const Text(
                'Confirm Payment',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // SUCCESS MESSAGE
  // ============================================================

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        backgroundColor: paidColor,

        behavior:
            SnackBarBehavior.floating,

        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12),
        ),

        content: const Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.white,
            ),

            SizedBox(width: 10),

            Expanded(
              child: Text(
                'Payment confirmed successfully.',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          Container(
            height: 75,
            width: 75,

            decoration: BoxDecoration(
              color: lightBlue,
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.receipt_long_outlined,
              size: 38,
              color: primaryColor,
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'No Payment Records',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Payment records will appear here\n'
            'when orders are connected to the billing module.',

            textAlign: TextAlign.center,

            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FORMAT CURRENCY
  // ============================================================

  String _formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(0)}';
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    final year =
        date.year.toString();

    return '$day/$month/$year';
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// ==================================================================
// PAYMENT DATA MODEL
// ==================================================================

class PaymentData {
  final String paymentId;
  final String orderId;
  final String billNumber;
  final String customerName;

  double amount;

  String paymentStatus;
  String paymentMethod;

  DateTime? paymentDate;

  PaymentData({
    required this.paymentId,
    required this.orderId,
    required this.billNumber,
    required this.customerName,
    required this.amount,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.paymentDate,
  });
}