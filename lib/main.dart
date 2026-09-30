import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_options.dart';

import 'features/notificationmodule/notification_module.dart';
import 'features/communicationmodule/communication_module.dart';
import 'features/Ordertrackingmodule/order_tracking_module.dart';
import 'features/owner/owner_module.dart';
import 'features/customer/customer_module.dart';
import 'features/billing/billing_module.dart';
import 'features/payment/payment_module.dart';
import 'features/pricemanagement/pricemanagement_module.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const WashEasyApp());
}

// ============================================================
// APP
// ============================================================

class WashEasyApp extends StatelessWidget {
  const WashEasyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WashEasy',

      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
        fontFamily: 'Arial',

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.darkText,
          elevation: 0,
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: Color(0xFFE0E0E0),
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
            borderSide: BorderSide(
              color: Colors.orange,
              width: 2,
            ),
          ),
        ),
      ),

      home: const LoginSelectionScreen(),

      routes: {
        '/owner': (context) => const OwnerModule(),
        '/customer': (context) => const CustomerModule(),
        '/billing': (context) => const BillingModule(),
        '/payment': (context) => const PaymentModule(),
        '/price-management': (context) => const PriceManagement(),
        '/order-tracking': (context) =>
            const OrderTrackingModule(),
        '/communication': (context) =>
            const CommunicationModule(),
        '/notification': (context) =>
            const NotificationModule(),
      },
    );
  }
}

// ============================================================
// COLORS
// ============================================================

class AppColors {
  static const Color primary = Color(0xFFFF6B00);
  static const Color darkText = Color(0xFF17213D);
  static const Color grayText = Color(0xFF8A8A96);
  static const Color lightOrange = Color(0xFFFFF3E0);
  static const Color circleOrange = Color(0xFFFFE0B2);
}

// ============================================================
// FIRESTORE SERVICE
// ============================================================

class FirebaseService {
  static final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

  // ----------------------------------------------------------
  // CHECK CUSTOMER ID
  // ----------------------------------------------------------

  static Future<bool> customerIdExists(
    String customerId,
  ) async {
    final result = await firestore
        .collection('users')
        .where(
          'customerId',
          isEqualTo: customerId,
        )
        .limit(1)
        .get();

    return result.docs.isNotEmpty;
  }

  // ----------------------------------------------------------
  // GENERATE CUSTOMER ID
  // ----------------------------------------------------------

  static Future<String> generateCustomerId() async {
    int number = 1;

    while (true) {
      final id =
          'CUST${number.toString().padLeft(3, '0')}';

      final exists = await customerIdExists(id);

      if (!exists) {
        return id;
      }

      number++;
    }
  }

  // ----------------------------------------------------------
  // GENERATE CUSTOMER PASSWORD
  // PASSWORD = FLAT NUMBER + LAST 4 PHONE DIGITS
  // ----------------------------------------------------------

  static String? generateCustomerPassword({
    required String address,
    required String phone,
  }) {
    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 4) return null;

    final flatMatch = RegExp(
      r'(?:flat|flat\s*no|apartment|apt|unit|room)\s*[-:#]?\s*(\d+[A-Za-z]?)',
      caseSensitive: false,
    ).firstMatch(address);

    final flatNumber = flatMatch?.group(1) ??
        RegExp(r'\d+[A-Za-z]?').firstMatch(address)?.group(0);

    if (flatNumber == null || flatNumber.isEmpty) return null;

    return '$flatNumber${phoneDigits.substring(phoneDigits.length - 4)}';
  }

  // ----------------------------------------------------------
  // FIND CUSTOMER BY NAME
  // ----------------------------------------------------------

  static Future<DocumentSnapshot?>
      findCustomerByName(String customerName) async {
    final normalizedName = customerName.trim().toLowerCase();

    final result = await firestore
        .collection('users')
        .where(
          'nameLower',
          isEqualTo: normalizedName,
        )
        .where(
          'role',
          isEqualTo: 'customer',
        )
        .limit(1)
        .get();

    if (result.docs.isEmpty) return null;
    return result.docs.first;
  }
}

// ============================================================
// LOGIN SELECTION
// ============================================================

class LoginSelectionScreen extends StatelessWidget {
  const LoginSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleLoginScreen(
      title: 'Customer Login',
      subtitle: 'Login using your Customer Name',
      icon: Icons.person_outline,
      isOwner: false,
    );
  }
}

// ============================================================
// OWNER / CUSTOMER LOGIN
// ============================================================

class OwnerLoginScreen extends StatelessWidget {
  const OwnerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleLoginScreen(
      title: 'Owner Login',
      subtitle: 'Login using your Owner ID',
      icon: Icons.storefront_outlined,
      isOwner: true,
    );
  }
}

class CustomerLoginScreen extends StatelessWidget {
  const CustomerLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleLoginScreen(
      title: 'Customer Login',
      subtitle: 'Login using your Customer Name',
      icon: Icons.person_outline,
      isOwner: false,
    );
  }
}

// ============================================================
// MODERN LOGIN SCREEN
// ============================================================

class SimpleLoginScreen extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isOwner;

  const SimpleLoginScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isOwner,
  });

  @override
  State<SimpleLoginScreen> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  final idController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;
  late bool selectedOwner;

  @override
  void initState() {
    super.initState();
    selectedOwner = widget.isOwner;
  }

  @override
  void dispose() {
    idController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final id = idController.text.trim();
    final password = passwordController.text.trim();

    if (id.isEmpty || password.isEmpty) {
      showMessage(
        'Please enter your customer name and password.',
        error: true,
      );
      return;
    }

    // ========================================================
    // OWNER LOGIN
    // ========================================================

    if (selectedOwner) {
      const ownerId = 'OWNER001';
      const ownerPassword = 'WashEasy@123';

      if (id == ownerId && password == ownerPassword) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const OwnerModule(),
          ),
        );
      } else {
        showMessage(
          'Invalid Owner ID or password.',
          error: true,
        );
      }

      return;
    }

    // ========================================================
    // CUSTOMER LOGIN
    // FIREBASE AUTHENTICATION IS NOT USED
    // ========================================================

    setState(() {
      isLoading = true;
    });

    try {
      final user = await FirebaseService.findCustomerByName(id);

      if (user == null) {
        showMessage(
          'Customer name not found.',
          error: true,
        );
        return;
      }

      final data = user.data() as Map<String, dynamic>;

      final storedPassword =
          (data['password'] ?? '').toString();

      if (storedPassword != password) {
        showMessage(
          'Incorrect customer name or password.',
          error: true,
        );
        return;
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CustomerModule(
            customerId: (data['customerId'] ?? '').toString(),
            customerName: (data['name'] ?? '').toString(),
            customerEmail: (data['email'] ?? '').toString(),
            customerAddress: (data['address'] ?? '').toString(),
            customerPhone: (data['phone'] ?? '').toString(),
            onLogout: () async {
              // Do not depend on the LoginScreen State being mounted.
              // It is replaced when CustomerModule opens.
              final navigator = Navigator.of(context, rootNavigator: true);
              navigator.pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginSelectionScreen(),
                ),
                (route) => false,
              );
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('CUSTOMER LOGIN ERROR: $e');

      showMessage(
        'Unable to login. Check Firestore connection.',
        error: true,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void showMessage(
    String message, {
    bool error = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            error ? Colors.red : AppColors.primary,
      ),
    );
  }


  void showForgotPasswordMessage() {
    showMessage(
      selectedOwner
          ? 'Please contact the WashEasy administrator for Owner login details.'
          : 'Use your registered full name and your flat number + last 4 phone digits.',
      error: false,
    );
  }

  Widget buildLogoHeader(double width) {
    final logoSize = width < 420 ? 145.0 : 170.0;

    return Column(
      children: [
        Image.asset(
          'assets/images/washeasy_logo.png',
          width: logoSize,
          height: logoSize,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
            children: [
              TextSpan(
                text: 'Wash',
                style: TextStyle(
                  color: Color(0xFF1565C0),
                ),
              ),
              TextSpan(
                text: 'Easy',
                style: TextStyle(
                  color: Color(0xFFFF6B00),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Clean Clothes  •  Happy You',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.darkText,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget buildRoleSwitch() {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFFD6E0EA),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (selectedOwner) {
                  setState(() {
                    selectedOwner = false;
                    idController.clear();
                    passwordController.clear();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: !selectedOwner
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person,
                      size: 27,
                      color: !selectedOwner
                          ? Colors.white
                          : AppColors.darkText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Customer',
                      style: TextStyle(
                        color: !selectedOwner
                            ? Colors.white
                            : AppColors.darkText,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (!selectedOwner) {
                  setState(() {
                    selectedOwner = true;
                    idController.clear();
                    passwordController.clear();
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selectedOwner
                      ? AppColors.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(27),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.engineering_outlined,
                      size: 27,
                      color: selectedOwner
                          ? Colors.white
                          : AppColors.darkText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Owner',
                      style: TextStyle(
                        color: selectedOwner
                            ? Colors.white
                            : AppColors.darkText,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool password = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: password && hidePassword,
      style: const TextStyle(
        color: AppColors.darkText,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF8291A8),
          fontSize: 16,
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF536B87),
          size: 28,
        ),
        suffixIcon: password
            ? IconButton(
                icon: Icon(
                  hidePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF536B87),
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 19,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFD3DFEA),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final cardWidth =
        screenWidth > 820 ? 790.0 : screenWidth - 36;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FCFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: cardWidth,
              ),
              child: Column(
                children: [
                  buildLogoHeader(screenWidth),

                  const SizedBox(height: 28),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(
                      screenWidth < 420 ? 18 : 42,
                      42,
                      screenWidth < 420 ? 18 : 42,
                      28,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.12),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        buildRoleSwitch(),

                        const SizedBox(height: 28),

                        buildInput(
                          controller: idController,
                          hint: selectedOwner
                              ? 'Owner ID'
                              : 'Customer Name',
                          icon: Icons.email_outlined,
                        ),

                        const SizedBox(height: 16),

                        buildInput(
                          controller: passwordController,
                          hint: 'Password',
                          icon: Icons.lock_outline,
                          password: true,
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 58,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColors.primary,
                              foregroundColor: Colors.white,
                              elevation: 3,
                              shadowColor:
                                  AppColors.primary.withOpacity(0.30),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(16),
                              ),
                            ),
                            onPressed:
                                isLoading ? null : login,
                            child: isLoading
                                ? const SizedBox(
                                    width: 25,
                                    height: 25,
                                    child:
                                        CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight:
                                              FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 27,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        if (!selectedOwner) ...[
                          const SizedBox(height: 34),

                          Row(
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFD7E1EB),
                                  thickness: 1.2,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Text(
                                  'New Customer?',
                                  style: TextStyle(
                                    color: AppColors.darkText,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Color(0xFFD7E1EB),
                                  thickness: 1.2,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 18),

                          SizedBox(
                            width: 280,
                            height: 54,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    AppColors.primary,
                                side: const BorderSide(
                                  color: AppColors.primary,
                                  width: 1.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(28),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegistrationScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.person_add_alt_1,
                                size: 25,
                              ),
                              label: const Text(
                                'Register Now',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 22),

                        TextButton.icon(
                          onPressed: showForgotPasswordMessage,
                          icon: const Icon(
                            Icons.lock_outline,
                            size: 18,
                            color: Color(0xFF657B96),
                          ),
                          label: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF657B96),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Laundry & Ironing\nMade Easy!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: 145,
                    height: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState
    extends State<RegistrationScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final addressController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ==========================================================
  // REGISTER CUSTOMER
  // ==========================================================

  String? _extractFlatNumber(String address) {
    final labeled = RegExp(
      r'(?:flat|flat\s*no|apartment|apt|unit|room)\s*[-:#]?\s*(\d+[A-Za-z]?)',
      caseSensitive: false,
    ).firstMatch(address);
    return labeled?.group(1) ??
        RegExp(r'\d+[A-Za-z]?').firstMatch(address)?.group(0);
  }

  Future<bool> _customerNameExists(String name) async {
    final snap = await FirebaseService.firestore
        .collection('users')
        .where('nameLower', isEqualTo: name.trim().toLowerCase())
        .where('role', isEqualTo: 'customer')
        .limit(1)
        .get();
    return snap.docs.isNotEmpty;
  }

  Future<void> registerCustomer() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final address = addressController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || email.isEmpty || address.isEmpty || phone.isEmpty) {
      showError(
        'Please enter your full name, email, address and phone number.',
      );
      return;
    }

    if (!RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(email)) {
      showError(
        'Please enter a valid email address.',
      );
      return;
    }

    final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
    if (phoneDigits.length < 4) {
      showError('Please enter a valid phone number.');
      return;
    }

    final password = FirebaseService.generateCustomerPassword(
      address: address,
      phone: phone,
    );

    if (password == null) {
      showError(
        'Please include your flat number in the address, for example: Flat 689, A Wing...',
      );
      return;
    }

    if (await _customerNameExists(name)) {
      showError(
        'This customer name is already registered. Please use a unique full name.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // ------------------------------------------------------
      // AUTOMATIC CUSTOMER ID
      // ------------------------------------------------------

      final customerId =
          await FirebaseService.generateCustomerId();

      // ------------------------------------------------------
      // SAVE DIRECTLY TO FIRESTORE
      // ------------------------------------------------------

      await FirebaseService.firestore
          .collection('users')
          .doc(customerId)
          .set({
        'customerId': customerId,
        'name': name,
        'nameLower': name.toLowerCase(),
        'email': email,
        'address': address,
        'phone': phone,
        'flatNumber': _extractFlatNumber(address),
        'password': password,
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      showSuccessDialog(
        name,
        password,
      );
    } on FirebaseException catch (e) {
      debugPrint(
        'FIRESTORE REGISTRATION ERROR: ${e.code}',
      );

      debugPrint(
        'MESSAGE: ${e.message}',
      );

      if (e.code == 'permission-denied') {
        showError(
          'Firestore permission denied. '
          'Check your Firestore Rules.',
        );
      } else {
        showError(
          'Firebase error: ${e.code}',
        );
      }
    } catch (e) {
      debugPrint(
        'REGISTRATION ERROR: $e',
      );

      showError(
        'Could not create customer account.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ==========================================================
  // SUCCESS DIALOG
  // ==========================================================

  void showSuccessDialog(
    String customerName,
    String password,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          title: const Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green,
              ),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Account Created',
                ),
              ),
            ],
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              const Text(
                'Your WashEasy customer account has been created successfully.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  color: AppColors.lightOrange,
                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: Column(
                  children: [
                    const Text(
                      'LOGIN NAME',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            AppColors.grayText,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      customerName,
                      style: const TextStyle(
                        fontSize: 24,
                        color:
                            AppColors.primary,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'PASSWORD',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            AppColors.grayText,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      password,
                      style: const TextStyle(
                        fontSize: 20,
                        color:
                            AppColors.darkText,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Login name: your full name\nPassword: flat number + last 4 digits of your phone number.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),

          actions: [
            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor:
                      Colors.white,
                ),

                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },

                child: const Text(
                  'Continue to Login',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // ERROR
  // ==========================================================

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text('Register'),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                'Create your WashEasy account',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.darkText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Register with your full name, email, address and phone number. Your login password will be your flat number followed by the last 4 digits of your phone number.',
                textAlign: TextAlign.center,

                style: TextStyle(
                  color: AppColors.grayText,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 30),

              TextField(
                controller: nameController,

                decoration:
                    const InputDecoration(
                  labelText: 'Full Name',

                  prefixIcon: Icon(
                    Icons.person_outline,
                    color:
                        AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: emailController,

                keyboardType:
                    TextInputType.emailAddress,

                decoration:
                    const InputDecoration(
                  labelText: 'Email',

                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color:
                        AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: addressController,

                maxLines: 3,

                decoration:
                    const InputDecoration(
                  labelText: 'Full Address',
                  hintText: 'Include your flat number, e.g. Flat 689, A Wing...',
                  prefixIcon: Icon(
                    Icons.location_on_outlined,
                    color:
                        AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                decoration:
                    const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    color:
                        AppColors.primary,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 54,

                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary,
                    foregroundColor:
                        Colors.white,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),

                  onPressed: isLoading
                      ? null
                      : registerCustomer,

                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,

                          child:
                              CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Customer Account',

                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color:
                      AppColors.lightOrange,

                  borderRadius:
                      BorderRadius.circular(12),
                ),

                child: const Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Icon(
                      Icons.security,
                      color:
                          AppColors.primary,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        'Your customer details are saved in Firestore. Login with your full name and password: flat number + last 4 phone digits.',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              AppColors.darkText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}