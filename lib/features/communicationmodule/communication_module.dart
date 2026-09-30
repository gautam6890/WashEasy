import 'package:flutter/material.dart';

class CommunicationModule extends StatefulWidget {
  const CommunicationModule({super.key});

  @override
  State<CommunicationModule> createState() => _CommunicationModuleState();
}

class _CommunicationModuleState extends State<CommunicationModule> {
  // ============================================================
  // WASH EASY COLORS
  // ============================================================

  static const Color primaryOrange = Color(0xFFFF8C00);
  //static const Color darkOrange  = Color(0xFFE66F00);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkText = Color(0xFF222222);

  // ============================================================
  // CURRENT USER
  //
  // Change this to "Owner" if you want to test the Owner screen.
  // ============================================================

  String currentUserType = 'Customer';

  // ============================================================
  // SEARCH
  // ============================================================

  final TextEditingController searchController = TextEditingController();

  String searchText = '';

  // ============================================================
  // SAMPLE CONVERSATIONS
  // ============================================================

  final List<ConversationData> conversations = [
    ConversationData(
      customerId: 'C001',
      customerName: 'Rahul',
      orderId: 'ORD001',
      service: 'Ironing',
      unreadCount: 2,
      messages: [
        ChatMessage(
          messageId: 'M001',
          senderId: 'OWNER',
          senderName: 'WashEasy Owner',
          senderType: 'Owner',
          message: 'Hello! How can I help you?',
          timestamp: '10:20 AM',
        ),
        ChatMessage(
          messageId: 'M002',
          senderId: 'C001',
          senderName: 'Rahul',
          senderType: 'Customer',
          message: 'When will my clothes be ready?',
          timestamp: '10:25 AM',
        ),
        ChatMessage(
          messageId: 'M003',
          senderId: 'OWNER',
          senderName: 'WashEasy Owner',
          senderType: 'Owner',
          message: 'Tomorrow after 5 PM.',
          timestamp: '10:30 AM',
        ),
      ],
    ),
    ConversationData(
      customerId: 'C002',
      customerName: 'John',
      orderId: 'ORD002',
      service: 'Washing',
      unreadCount: 1,
      messages: [
        ChatMessage(
          messageId: 'M004',
          senderId: 'C002',
          senderName: 'John',
          senderType: 'Customer',
          message: 'Is my order ready?',
          timestamp: '11:15 AM',
        ),
        ChatMessage(
          messageId: 'M005',
          senderId: 'OWNER',
          senderName: 'WashEasy Owner',
          senderType: 'Owner',
          message: 'Your clothes are almost ready.',
          timestamp: '11:20 AM',
        ),
      ],
    ),
    ConversationData(
      customerId: 'C003',
      customerName: 'Priya',
      orderId: 'ORD003',
      service: 'Dry Cleaning',
      unreadCount: 0,
      messages: [
        ChatMessage(
          messageId: 'M006',
          senderId: 'OWNER',
          senderName: 'WashEasy Owner',
          senderType: 'Owner',
          message: 'Your order has been received.',
          timestamp: '12:00 PM',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.chat_bubble_outline),
            SizedBox(width: 10),
            Text(
              'Communication',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                currentUserType = value;
              });
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'Customer',
                child: Text('Customer View'),
              ),
              PopupMenuItem(
                value: 'Owner',
                child: Text('Owner View'),
              ),
            ],
            icon: const Icon(Icons.swap_horiz),
          ),
        ],
      ),
      body: currentUserType == 'Customer'
          ? buildCustomerView()
          : buildOwnerView(),
    );
  }

  // ============================================================
  // CUSTOMER VIEW
  // ============================================================

  Widget buildCustomerView() {
    final conversation = conversations.first;

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: primaryOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chat with Owner',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Ask questions about your laundry order',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Owner card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: buildOwnerCard(),
        ),

        const SizedBox(height: 10),

        // Order information
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: buildOrderInfo(conversation),
        ),

        const SizedBox(height: 10),

        // Chat preview
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: buildChatArea(conversation),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // OWNER VIEW
  // ============================================================

  Widget buildOwnerView() {
    final filteredConversations = conversations.where((conversation) {
      final query = searchText.toLowerCase();

      return conversation.customerName.toLowerCase().contains(query) ||
          conversation.customerId.toLowerCase().contains(query) ||
          conversation.orderId.toLowerCase().contains(query);
    }).toList();

    return Column(
      children: [
        // Owner header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: primaryOrange,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Communicate with your customers',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search customers...',
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
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Conversation list
        Expanded(
          child: filteredConversations.isEmpty
              ? buildNoMessages()
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  itemCount: filteredConversations.length,
                  itemBuilder: (context, index) {
                    return buildConversationCard(
                      filteredConversations[index],
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ============================================================
  // OWNER CARD
  // ============================================================

  Widget buildOwnerCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.storefront,
              color: primaryOrange,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'WashEasy Owner',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 9,
                      color: Colors.green,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Online',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ORDER INFORMATION
  // ============================================================

  Widget buildOrderInfo(ConversationData conversation) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: primaryOrange.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.receipt_long,
            color: primaryOrange,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order ${conversation.orderId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  conversation.service,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Text(
            'Active',
            style: TextStyle(
              color: primaryOrange,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CHAT AREA
  // ============================================================

  Widget buildChatArea(ConversationData conversation) {
    return ChatScreen(
      conversation: conversation,
      currentUserType: currentUserType,
    );
  }

  // ============================================================
  // OWNER CONVERSATION CARD
  // ============================================================

  Widget buildConversationCard(ConversationData conversation) {
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last
        : null;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversation: conversation,
              currentUserType: 'Owner',
            ),
          ),
        ).then((_) {
          setState(() {});
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: primaryOrange,
                size: 27,
              ),
            ),

            const SizedBox(width: 13),

            // Message information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.customerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: darkText,
                          ),
                        ),
                      ),
                      if (conversation.unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: const BoxDecoration(
                            color: primaryOrange,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${conversation.unreadCount}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${conversation.orderId} • ${conversation.service}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    lastMessage?.message ?? 'No messages',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 5),

            const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NO MESSAGES
  // ============================================================

  Widget buildNoMessages() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 65,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 15),
          const Text(
            'No conversations found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Try another customer name or order number.',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// CHAT SCREEN
// ============================================================================

class ChatScreen extends StatefulWidget {
  final ConversationData conversation;
  final String currentUserType;

  const ChatScreen({
    super.key,
    required this.conversation,
    required this.currentUserType,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final ScrollController scrollController = ScrollController();

  static const Color primaryOrange = Color(0xFFFF8C00);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND MESSAGE
  // ============================================================

  void sendMessage() {
    final text = messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    final bool isCustomer = widget.currentUserType == 'Customer';

    setState(() {
      widget.conversation.messages.add(
        ChatMessage(
          messageId:
              'M${widget.conversation.messages.length + 1}',
          senderId: isCustomer
              ? widget.conversation.customerId
              : 'OWNER',
          senderName: isCustomer
              ? widget.conversation.customerName
              : 'WashEasy Owner',
          senderType: widget.currentUserType,
          message: text,
          timestamp: getCurrentTime(),
        ),
      );

      messageController.clear();
    });

    scrollToBottom();
  }

  // ============================================================
  // CURRENT TIME
  // ============================================================

  String getCurrentTime() {
    final now = TimeOfDay.now();

    final hour = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;

    final minute = now.minute.toString().padLeft(2, '0');

    final period = now.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  // ============================================================
  // SCROLL TO BOTTOM
  // ============================================================

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,

        title: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.currentUserType == 'Customer'
                    ? Icons.storefront
                    : Icons.person,
                color: primaryOrange,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currentUserType == 'Customer'
                        ? 'WashEasy Owner'
                        : widget.conversation.customerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    widget.conversation.orderId,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Order information
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(15, 15, 15, 5),
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.receipt_long,
                  color: primaryOrange,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order ${widget.conversation.orderId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.conversation.service,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(
                15,
                10,
                15,
                10,
              ),
              itemCount: widget.conversation.messages.length,
              itemBuilder: (context, index) {
                final message =
                    widget.conversation.messages[index];

                final bool isMe =
                    message.senderType ==
                        widget.currentUserType;

                return buildMessageBubble(
                  message,
                  isMe,
                );
              },
            ),
          ),

          // Input
          buildMessageInput(),
        ],
      ),
    );
  }

  // ============================================================
  // MESSAGE BUBBLE
  // ============================================================

  Widget buildMessageBubble(
    ChatMessage message,
    bool isMe,
  ) {
    return Align(
      alignment:
          isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 11,
        ),
        decoration: BoxDecoration(
          color: isMe ? primaryOrange : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isMe)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: primaryOrange,
                  ),
                ),
              ),

            Text(
              message.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              message.timestamp,
              style: TextStyle(
                color: isMe
                    ? Colors.white70
                    : Colors.grey.shade500,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // MESSAGE INPUT
  // ============================================================

  Widget buildMessageInput() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
          8,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  sendMessage();
                },
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF3F3F3),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: sendMessage,
              child: Container(
                height: 48,
                width: 48,
                decoration: const BoxDecoration(
                  color: primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 21,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// CHAT MESSAGE MODEL
// ============================================================================

class ChatMessage {
  final String messageId;
  final String senderId;
  final String senderName;
  final String senderType;
  final String message;
  final String timestamp;

  ChatMessage({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.message,
    required this.timestamp,
  });
}

// ============================================================================
// CONVERSATION MODEL
// ============================================================================

class ConversationData {
  final String customerId;
  final String customerName;
  final String orderId;
  final String service;

  int unreadCount;

  final List<ChatMessage> messages;

  ConversationData({
    required this.customerId,
    required this.customerName,
    required this.orderId,
    required this.service,
    required this.unreadCount,
    required this.messages,
  });
}