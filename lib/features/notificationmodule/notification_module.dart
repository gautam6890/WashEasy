import 'package:flutter/material.dart';

class NotificationModule extends StatefulWidget {
  const NotificationModule({super.key});

  @override
  State<NotificationModule> createState() => _NotificationModuleState();
}

class _NotificationModuleState extends State<NotificationModule> {
  // ============================================================
  // WASH EASY COLORS
  // ============================================================

  static const Color primaryOrange = Color(0xFFFF8C00);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkText = Color(0xFF222222);

  // ============================================================
  // DATA
  // ============================================================

  final List<NotificationData> notifications = [
    NotificationData(
      id: 'N001',
      title: 'Your clothes are ready',
      message:
          'Your clothes for Order ORD001 are ready for collection.',
      type: 'Clothes Ready',
      orderId: 'ORD001',
      dateTime: DateTime(2026, 8, 24, 10, 30),
      isRead: false,
    ),
    NotificationData(
      id: 'N002',
      title: 'Payment pending',
      message:
          'Payment of ₹240 is pending for Order ORD001.',
      type: 'Payment',
      orderId: 'ORD001',
      dateTime: DateTime(2026, 8, 24, 9, 45),
      isRead: false,
    ),
    NotificationData(
      id: 'N003',
      title: 'Pickup tomorrow',
      message:
          'Your clothes for Order ORD001 are scheduled for pickup tomorrow.',
      type: 'Pickup Reminder',
      orderId: 'ORD001',
      dateTime: DateTime(2026, 8, 24, 8, 30),
      isRead: true,
    ),
    NotificationData(
      id: 'N004',
      title: 'Bill generated',
      message:
          'Your bill B001 for Order ORD001 has been generated. Total Amount: ₹240.',
      type: 'Bill',
      orderId: 'ORD001',
      dateTime: DateTime(2026, 8, 23, 17, 20),
      isRead: true,
    ),
    NotificationData(
      id: 'N005',
      title: 'Order received',
      message:
          'Your Order ORD002 has been successfully received.',
      type: 'Order Update',
      orderId: 'ORD002',
      dateTime: DateTime(2026, 8, 23, 14, 15),
      isRead: true,
    ),
    NotificationData(
      id: 'N006',
      title: 'Payment successful',
      message:
          'Payment for Order ORD002 has been successfully confirmed.',
      type: 'Payment',
      orderId: 'ORD002',
      dateTime: DateTime(2026, 8, 23, 12, 10),
      isRead: true,
    ),
  ];

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';

  // ============================================================
  // FILTER
  // ============================================================

  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Unread',
    'Order',
    'Payment',
    'Bill',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // UNREAD COUNT
  // ============================================================

  int get unreadCount {
    return notifications.where((notification) {
      return !notification.isRead;
    }).length;
  }

  // ============================================================
  // FILTERED NOTIFICATIONS
  // ============================================================

  List<NotificationData> get filteredNotifications {
    List<NotificationData> result = notifications;

    // Filter
    if (selectedFilter == 'Unread') {
      result = result.where((notification) {
        return !notification.isRead;
      }).toList();
    } else if (selectedFilter == 'Order') {
      result = result.where((notification) {
        return notification.type == 'Order Update' ||
            notification.type == 'Clothes Ready' ||
            notification.type == 'Pickup Reminder';
      }).toList();
    } else if (selectedFilter == 'Payment') {
      result = result.where((notification) {
        return notification.type == 'Payment';
      }).toList();
    } else if (selectedFilter == 'Bill') {
      result = result.where((notification) {
        return notification.type == 'Bill';
      }).toList();
    }

    // Search
    if (searchText.isNotEmpty) {
      final query = searchText.toLowerCase();

      result = result.where((notification) {
        return notification.title
                .toLowerCase()
                .contains(query) ||
            notification.message
                .toLowerCase()
                .contains(query) ||
            notification.orderId
                .toLowerCase()
                .contains(query) ||
            notification.type
                .toLowerCase()
                .contains(query);
      }).toList();
    }

    return result;
  }

  // ============================================================
  // MARK ALL AS READ
  // ============================================================

  void markAllAsRead() {
    setState(() {
      for (final notification in notifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // ============================================================
  // MARK SINGLE NOTIFICATION AS READ
  // ============================================================

  void openNotification(NotificationData notification) {
    setState(() {
      notification.isRead = true;
    });

    showNotificationDetails(notification);
  }

  // ============================================================
  // NOTIFICATION DETAILS
  // ============================================================

  void showNotificationDetails(
    NotificationData notification,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color:
                              getNotificationColor(
                            notification.type,
                          ).withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          getNotificationIcon(
                            notification.type,
                          ),
                          color:
                              getNotificationColor(
                            notification.type,
                          ),
                          size: 27,
                        ),
                      ),
                      const SizedBox(width: 13),
                      const Expanded(
                        child: Text(
                          'Notification Details',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // Title
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryOrange,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Message
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Details
                  buildDetailRow(
                    Icons.receipt_long,
                    'Order ID',
                    notification.orderId,
                  ),

                  buildDetailRow(
                    Icons.category_outlined,
                    'Type',
                    notification.type,
                  ),

                  buildDetailRow(
                    Icons.calendar_today_outlined,
                    'Date',
                    formatDate(notification.dateTime),
                  ),

                  buildDetailRow(
                    Icons.access_time,
                    'Time',
                    formatTime(notification.dateTime),
                  ),

                  const SizedBox(height: 15),

                  // Status
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Notification read',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        foregroundColor: Colors.white,
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget buildDetailRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Row(
        children: [
          Icon(
            icon,
            color: primaryOrange,
            size: 19,
          ),
          const SizedBox(width: 10),
          Text(
            '$title:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ICON
  // ============================================================

  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'Clothes Ready':
        return Icons.check_circle;

      case 'Payment':
        return Icons.payment;

      case 'Pickup Reminder':
        return Icons.event;

      case 'Bill':
        return Icons.receipt_long;

      case 'Order Update':
        return Icons.local_laundry_service;

      default:
        return Icons.notifications;
    }
  }

  // ============================================================
  // COLOR
  // ============================================================

  Color getNotificationColor(String type) {
    switch (type) {
      case 'Clothes Ready':
        return Colors.green;

      case 'Payment':
        return Colors.red;

      case 'Pickup Reminder':
        return Colors.orange;

      case 'Bill':
        return Colors.blue;

      case 'Order Update':
        return primaryOrange;

      default:
        return Colors.grey;
    }
  }

  // ============================================================
  // DATE
  // ============================================================

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // TIME
  // ============================================================

  String formatTime(DateTime date) {
    final hour = date.hour % 12 == 0
        ? 12
        : date.hour % 12;

    final minute =
        date.minute.toString().padLeft(2, '0');

    final period = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final displayedNotifications =
        filteredNotifications;

    return Scaffold(
      backgroundColor: backgroundColor,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            Icon(Icons.notifications_outlined),
            SizedBox(width: 10),
            Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Mark all read',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: Column(
        children: [
          // Header section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(
              18,
              20,
              18,
              20,
            ),
            decoration: const BoxDecoration(
              color: primaryOrange,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stay updated',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  unreadCount == 0
                      ? 'You have no unread notifications'
                      : 'You have $unreadCount unread '
                          'notification${unreadCount == 1 ? '' : 's'}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Search
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search notifications...',
                prefixIcon: const Icon(
                  Icons.search,
                  color: primaryOrange,
                ),
                suffixIcon: searchText.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          searchController.clear();

                          setState(() {
                            searchText = '';
                          });
                        },
                        icon: const Icon(Icons.clear),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Filter chips
          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filters.length,
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected =
                    selectedFilter == filter;

                return Padding(
                  padding:
                      const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    selectedColor: primaryOrange,
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Notification count
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                const Text(
                  'Recent Notifications',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                const Spacer(),
                Text(
                  '${displayedNotifications.length} items',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Notification list
          Expanded(
            child: displayedNotifications.isEmpty
                ? buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      5,
                      16,
                      20,
                    ),
                    itemCount:
                        displayedNotifications.length,
                    itemBuilder: (context, index) {
                      return buildNotificationCard(
                        displayedNotifications[index],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget buildNotificationCard(
    NotificationData notification,
  ) {
    final notificationColor =
        getNotificationColor(notification.type);

    return GestureDetector(
      onTap: () {
        openNotification(notification);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: notification.isRead
              ? Colors.white
              : const Color(0xFFFFF4E5),
          borderRadius: BorderRadius.circular(18),
          border: notification.isRead
              ? null
              : Border.all(
                  color: primaryOrange.withOpacity(0.25),
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color:
                    notificationColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                getNotificationIcon(
                  notification.type,
                ),
                color: notificationColor,
                size: 27,
              ),
            ),

            const SizedBox(width: 13),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight:
                                notification.isRead
                                    ? FontWeight.w600
                                    : FontWeight.bold,
                            color: darkText,
                          ),
                        ),
                      ),

                      if (!notification.isRead)
                        Container(
                          height: 9,
                          width: 9,
                          margin:
                              const EdgeInsets.only(
                            top: 5,
                            left: 8,
                          ),
                          decoration:
                              const BoxDecoration(
                            color: primaryOrange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification.message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),

                  const SizedBox(height: 9),

                  Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: notificationColor
                              .withOpacity(0.10),
                          borderRadius:
                              BorderRadius.circular(7),
                        ),
                        child: Text(
                          notification.type,
                          style: TextStyle(
                            color: notificationColor,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 8),

                      Text(
                        notification.orderId,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                          fontWeight:
                              FontWeight.w500,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        formatTime(
                          notification.dateTime,
                        ),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 3),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none,
                color: primaryOrange,
                size: 45,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'No notifications found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 7),

            Text(
              'There are no notifications matching your selection.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// NOTIFICATION MODEL
// ============================================================================

class NotificationData {
  final String id;
  final String title;
  final String message;
  final String type;
  final String orderId;
  final DateTime dateTime;

  bool isRead;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.orderId,
    required this.dateTime,
    required this.isRead,
  });
}