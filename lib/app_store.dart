class MarketplaceUser {
  MarketplaceUser({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    this.ratingTotal = 0,
    this.ratingCount = 0,
  });

  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final double ratingTotal;
  final int ratingCount;

  double get averageRating => ratingCount == 0 ? 0 : ratingTotal / ratingCount;

  MarketplaceUser copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? role,
    double? ratingTotal,
    int? ratingCount,
  }) {
    return MarketplaceUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      role: role ?? this.role,
      ratingTotal: ratingTotal ?? this.ratingTotal,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }
}

class JobListing {
  JobListing({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.description,
    required this.employerId,
    required this.price,
    required this.when,
    List<String>? applicants,
    this.isEscrowProtected = true,
  }) : applicants = applicants ?? <String>[];

  final String id;
  final String title;
  final String category;
  final String location;
  final String description;
  final String employerId;
  final String price;
  final String when;
  final List<String> applicants;
  final bool isEscrowProtected;
}

class ChatMessage {
  ChatMessage({required this.senderId, required this.text, required this.timestamp});

  final String senderId;
  final String text;
  final DateTime timestamp;
}

class ChatThread {
  ChatThread({
    required this.id,
    required this.jobId,
    required this.participantA,
    required this.participantB,
    required this.title,
    List<ChatMessage>? messages,
  }) : messages = messages ?? <ChatMessage>[];

  final String id;
  final String jobId;
  final String participantA;
  final String participantB;
  final String title;
  final List<ChatMessage> messages;
}

class MarketplaceStore {
  MarketplaceStore._();

  static final MarketplaceStore instance = MarketplaceStore._();

  final List<MarketplaceUser> users = [
    MarketplaceUser(
      id: 'user-customer',
      name: 'Wanjiru Njeri',
      email: 'wanjiru@demo.com',
      password: '123456',
      role: 'customer',
      ratingTotal: 47,
      ratingCount: 10,
    ),
    MarketplaceUser(
      id: 'user-worker-1',
      name: 'James Mwangi',
      email: 'james@demo.com',
      password: '123456',
      role: 'worker',
      ratingTotal: 47,
      ratingCount: 9,
    ),
    MarketplaceUser(
      id: 'user-worker-2',
      name: 'Grace Achieng',
      email: 'grace@demo.com',
      password: '123456',
      role: 'worker',
      ratingTotal: 42,
      ratingCount: 8,
    ),
  ];

  final List<JobListing> jobs = [
    JobListing(
      id: 'job-plumbing',
      title: 'Fix leaking kitchen sink',
      category: 'Plumbing',
      location: 'Kilimani · 1.2 km',
      description: 'Water is leaking under the sink and needs a fast repair today.',
      employerId: 'user-customer',
      price: 'KSh 3,500',
      when: 'Today, 4 PM',
    ),
    JobListing(
      id: 'job-cleaning',
      title: 'Deep clean 2-bedroom apartment',
      category: 'Cleaning',
      location: 'Westlands · 3.4 km',
      description: 'Need a careful clean before move-in and the home needs thorough sanitizing.',
      employerId: 'user-customer',
      price: 'KSh 4,000',
      when: 'Tomorrow, 9 AM',
    ),
    JobListing(
      id: 'job-repairs',
      title: 'Replace broken door lock',
      category: 'Repairs',
      location: 'Lavington · 4.1 km',
      description: 'The front door lock is jammed and the replacement needs installation today.',
      employerId: 'user-customer',
      price: 'KSh 1,800',
      when: 'Today, 6 PM',
      isEscrowProtected: false,
    ),
  ];

  final List<ChatThread> threads = [
    ChatThread(
      id: 'thread-job-plumbing',
      jobId: 'job-plumbing',
      participantA: 'user-customer',
      participantB: 'user-worker-1',
      title: 'Fix leaking kitchen sink',
      messages: [
        ChatMessage(
          senderId: 'user-worker-1',
          text: "Hi Wanjiru, I've seen your job. I can come by 4 PM today.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        ),
        ChatMessage(
          senderId: 'user-customer',
          text: 'Great, 4 PM works. Is KSh 3,500 okay?',
          timestamp: DateTime.now().subtract(const Duration(minutes: 38)),
        ),
        ChatMessage(
          senderId: 'user-worker-1',
          text: "Yes, that works. I'll bring the replacement pipe fittings.",
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        ),
      ],
    ),
  ];

  MarketplaceUser? currentUser;

  MarketplaceUser? getUserByEmail(String email) {
    for (final user in users) {
      if (user.email.trim().toLowerCase() == email.trim().toLowerCase()) {
        return user;
      }
    }
    return null;
  }

  bool signIn(String email, String password) {
    final user = getUserByEmail(email);
    if (user == null || user.password != password) {
      return false;
    }
    currentUser = user;
    return true;
  }

  bool signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) {
    if (getUserByEmail(email) != null) {
      return false;
    }

    final newUser = MarketplaceUser(
      id: 'user-${users.length + 1}',
      name: name,
      email: email,
      password: password,
      role: role,
    );
    users.add(newUser);
    currentUser = newUser;
    return true;
  }

  void signOut() => currentUser = null;

  void applyToJob(String jobId) {
    if (currentUser == null || currentUser!.role != 'worker') {
      return;
    }

    final job = jobs.firstWhere((element) => element.id == jobId, orElse: () => jobs.first);
    if (!job.applicants.contains(currentUser!.id)) {
      job.applicants.add(currentUser!.id);
    }

    final employerId = job.employerId;
    final threadId = 'thread-$jobId';
    if (threads.every((thread) => thread.id != threadId)) {
      threads.add(
        ChatThread(
          id: threadId,
          jobId: jobId,
          participantA: employerId,
          participantB: currentUser!.id,
          title: job.title,
          messages: [
            ChatMessage(
              senderId: employerId,
              text: 'We have your application. Please send a quick message about your availability.',
              timestamp: DateTime.now(),
            ),
          ],
        ),
      );
    }
  }

  void sendMessage(String threadId, String text) {
    if (currentUser == null || text.trim().isEmpty) {
      return;
    }
    final thread = threads.firstWhere((element) => element.id == threadId, orElse: () => threads.first);
    thread.messages.add(
      ChatMessage(
        senderId: currentUser!.id,
        text: text.trim(),
        timestamp: DateTime.now(),
      ),
    );
  }

  ChatThread? threadForJobId(String jobId) {
    return threads.firstWhereOrNull((thread) => thread.jobId == jobId);
  }

  void rateUser(String userId, double score, String review) {
    final target = users.firstWhere((user) => user.id == userId, orElse: () => users.first);
    final updatedTotal = target.ratingTotal + score;
    final updatedCount = target.ratingCount + 1;
    final index = users.indexWhere((user) => user.id == userId);
    if (index == -1) {
      return;
    }
    users[index] = target.copyWith(
      ratingTotal: updatedTotal,
      ratingCount: updatedCount,
    );
    if (review.trim().isNotEmpty) {
      // no-op: the app keeps a lightweight, in-memory rating log in the UI only
    }
  }

  String userName(String userId) {
    return users.firstWhere((user) => user.id == userId, orElse: () => MarketplaceUser(
      id: 'guest',
      name: 'Unknown user',
      email: 'guest@example.com',
      password: '',
      role: 'customer',
    )).name;
  }
}

extension _FirstWhereOrNullExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
