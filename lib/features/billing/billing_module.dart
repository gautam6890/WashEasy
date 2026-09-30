import 'package:flutter/material.dart';

class BillingModule extends StatefulWidget {
  const BillingModule({super.key});

  @override
  State<BillingModule> createState() => _BillingModuleState();
}

class _BillingModuleState extends State<BillingModule> {
  final Color primaryColor = const Color(0xFFFF6B4A);
  final Color darkBackground = const Color(0xFFF6F7F9);
  final Color cardColor = Colors.white;
  final Color textColor = const Color(0xFF202124);
  final Color secondaryText = const Color(0xFF777777);

  final TextEditingController billNoController = TextEditingController();
  final TextEditingController orderNoController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController customerNameController =
      TextEditingController();
  final TextEditingController customerIdController =
      TextEditingController();
  final TextEditingController returnDateController =
      TextEditingController();

  String paymentStatus = '';

  final List<BillItem> items = [];

  @override
  void dispose() {
    billNoController.dispose();
    orderNoController.dispose();
    dateController.dispose();
    customerNameController.dispose();
    customerIdController.dispose();
    returnDateController.dispose();

    super.dispose();
  }

  double get totalAmount {
    double total = 0;

    for (final item in items) {
      total += item.quantity * item.price;
    }

    return total;
  }

  String formatPrice(double price) {
    return '₹${price.toStringAsFixed(0)}';
  }

  // ----------------------------------------------------------
  // TOP HEADER
  // ----------------------------------------------------------

  Widget buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor,
            const Color(0xFFFF876D),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.20),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.local_laundry_service,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 15),

          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'WASH EASY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Laundry & Care Services',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // SECTION TITLE
  // ----------------------------------------------------------

  Widget sectionTitle(
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 24,
        bottom: 12,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: primaryColor,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // EMPTY FIELD
  // ----------------------------------------------------------

  Widget detailField(
    String label,
    String value,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: secondaryText,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value.isEmpty ? '—' : value,
          style: TextStyle(
            color: value.isEmpty ? Colors.grey : textColor,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // BILL DETAILS CARD
  // ----------------------------------------------------------

  Widget buildBillDetails() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: detailField(
                  'Bill Number',
                  billNoController.text,
                ),
              ),
              Expanded(
                child: detailField(
                  'Order Number',
                  orderNoController.text,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Align(
            alignment: Alignment.centerLeft,
            child: detailField(
              'Date',
              dateController.text,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // CUSTOMER CARD
  // ----------------------------------------------------------

  Widget buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.person_outline,
              color: primaryColor,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customerNameController.text.isEmpty
                      ? 'Customer Name'
                      : customerNameController.text,
                  style: TextStyle(
                    color: customerNameController.text.isEmpty
                        ? secondaryText
                        : textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  customerIdController.text.isEmpty
                      ? 'Customer ID'
                      : 'ID: ${customerIdController.text}',
                  style: TextStyle(
                    color: secondaryText,
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

  // ----------------------------------------------------------
  // SERVICE TABLE
  // ----------------------------------------------------------

  Widget buildServicesCard() {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table heading
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            child: const Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    'SERVICE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'CLOTHES',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'PRICE',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Empty state
          if (items.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32,
                horizontal: 20,
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 38,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'No services added',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Services will appear here automatically',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

          // Items
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      item.service,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      item.quantity.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      formatPrice(
                        item.quantity * item.price,
                      ),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PAYMENT STATUS
  // ----------------------------------------------------------

  Widget buildPaymentStatus() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.payment_outlined,
            color: primaryColor,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Payment Status',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: paymentStatus.isEmpty
                  ? Colors.grey.shade100
                  : primaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              paymentStatus.isEmpty ? 'Not Set' : paymentStatus,
              style: TextStyle(
                color: paymentStatus.isEmpty
                    ? Colors.grey
                    : primaryColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // RETURN DATE
  // ----------------------------------------------------------

  Widget buildReturnDate() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            color: primaryColor,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'Return Date',
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            returnDateController.text.isEmpty
                ? '—'
                : returnDateController.text,
            style: TextStyle(
              color: returnDateController.text.isEmpty
                  ? Colors.grey
                  : textColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // TOTAL CARD
  // ----------------------------------------------------------

  Widget buildTotalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF6B4A),
            const Color(0xFFFF876D),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL AMOUNT',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Final Bill Amount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            formatPrice(totalAmount),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ACTION BUTTONS
  // ----------------------------------------------------------

  Widget buildButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Save Bill will be added later.'),
                ),
              );
            },
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Bill'),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(
                color: primaryColor,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Print Bill will be added later.'),
                ),
              );
            },
            icon: const Icon(Icons.print_outlined),
            label: const Text('Print Bill'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // MAIN BUILD
  // ----------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,

      appBar: AppBar(
        backgroundColor: darkBackground,
        elevation: 0,
        foregroundColor: textColor,
        title: const Text(
          'Billing',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildHeader(),

              sectionTitle(
                'Bill Information',
                Icons.receipt_long_outlined,
              ),

              buildBillDetails(),

              sectionTitle(
                'Customer',
                Icons.person_outline,
              ),

              buildCustomerCard(),

              sectionTitle(
                'Services & Items',
                Icons.local_laundry_service_outlined,
              ),

              buildServicesCard(),

              sectionTitle(
                'Payment',
                Icons.account_balance_wallet_outlined,
              ),

              buildPaymentStatus(),

              const SizedBox(height: 12),

              buildReturnDate(),

              const SizedBox(height: 20),

              buildTotalCard(),

              const SizedBox(height: 20),

              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------
// BILL ITEM MODEL
// --------------------------------------------------------------

class BillItem {
  final String service;
  final int quantity;
  final double price;

  BillItem({
    required this.service,
    required this.quantity,
    required this.price,
  });
}