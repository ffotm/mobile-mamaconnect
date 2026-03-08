import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../constants/app_constants.dart';

class _Client {
  final String id;
  final String name;
  final int weekPregnant;
  final String lastSeen;
  final double lastBpm;
  final double lastTemp;
  final int kicksToday;
  final bool hasAlert;
  final List<_Log> logs;
  final List<_Message> messages;

  const _Client({
    required this.id,
    required this.name,
    required this.weekPregnant,
    required this.lastSeen,
    required this.lastBpm,
    required this.lastTemp,
    required this.kicksToday,
    required this.hasAlert,
    required this.logs,
    required this.messages,
  });
}

class _Log {
  final String time;
  final String metric;
  final String value;
  final bool isAlert;
  const _Log(
      {required this.time,
      required this.metric,
      required this.value,
      this.isAlert = false});
}

class _Message {
  final String sender;
  final String text;
  final String time;
  const _Message(
      {required this.sender, required this.text, required this.time});
}

class _Request {
  final String id;
  final String name;
  final int weekPregnant;
  final String message;
  final String time;
  bool isPending;
  _Request({
    required this.id,
    required this.name,
    required this.weekPregnant,
    required this.message,
    required this.time,
    this.isPending = true,
  });
}

final _mockClients = [
  const _Client(
    id: '1',
    name: 'Yasmine Bensalem',
    weekPregnant: 28,
    lastSeen: '10 min ago',
    lastBpm: 143,
    lastTemp: 36.6,
    kicksToday: 12,
    hasAlert: false,
    logs: [
      _Log(time: '08:00', metric: 'Heart Rate', value: '143 BPM'),
      _Log(time: '10:00', metric: 'Temperature', value: '36.6 °C'),
      _Log(time: '12:00', metric: 'Kicks', value: '12 today'),
      _Log(time: '14:00', metric: 'SpO₂', value: '98.4 %'),
    ],
    messages: [
      _Message(
          sender: 'client',
          text: 'I felt some sharp pain this morning.',
          time: '09:15'),
      _Message(
          sender: 'midwife',
          text:
              'That can be round ligament pain, very normal at 28 weeks. If it persists more than 1 hour call me.',
          time: '09:22'),
      _Message(
          sender: 'client',
          text: 'Thank you, it passed already!',
          time: '09:45'),
    ],
  ),
  const _Client(
    id: '2',
    name: 'Rania Cherif',
    weekPregnant: 34,
    lastSeen: '1 hour ago',
    lastBpm: 158,
    lastTemp: 37.4,
    kicksToday: 6,
    hasAlert: true,
    logs: [
      _Log(
          time: '07:30', metric: 'Heart Rate', value: '158 BPM', isAlert: true),
      _Log(
          time: '09:00',
          metric: 'Temperature',
          value: '37.4 °C',
          isAlert: true),
      _Log(time: '11:00', metric: 'Kicks', value: '6 (low)', isAlert: true),
      _Log(time: '13:00', metric: 'SpO₂', value: '96.1 %'),
    ],
    messages: [
      _Message(
          sender: 'client',
          text: 'Baby seems less active today.',
          time: '11:00'),
    ],
  ),
  const _Client(
    id: '3',
    name: 'Amira Hadj',
    weekPregnant: 16,
    lastSeen: '3 hours ago',
    lastBpm: 138,
    lastTemp: 36.5,
    kicksToday: 4,
    hasAlert: false,
    logs: [
      _Log(time: '09:00', metric: 'Heart Rate', value: '138 BPM'),
      _Log(time: '11:00', metric: 'Temperature', value: '36.5 °C'),
    ],
    messages: [],
  ),
];

final _mockRequests = [
  _Request(
      id: 'r1',
      name: 'Lina Boukhalfa',
      weekPregnant: 12,
      message:
          'Hi, I am 12 weeks and looking for a midwife to follow my pregnancy.',
      time: '2 hours ago'),
  _Request(
      id: 'r2',
      name: 'Sara Mansouri',
      weekPregnant: 22,
      message:
          'My previous midwife moved. I need someone to take over my care urgently.',
      time: 'Yesterday'),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class MidwifeDashboardScreen extends StatefulWidget {
  const MidwifeDashboardScreen({super.key});

  @override
  State<MidwifeDashboardScreen> createState() => _MidwifeDashboardScreenState();
}

class _MidwifeDashboardScreenState extends State<MidwifeDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final requests = List<_Request>.from(_mockRequests);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _pendingCount => requests.where((r) => r.isPending).length;
  int get _alertCount => _mockClients.where((c) => c.hasAlert).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Midwife Dashboard', style: AppTextStyles.heading3),
            Text('Dr. Sarah Benali',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textLight)),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textDark),
                onPressed: () {},
              ),
              if (_alertCount > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Center(
                      child: Text('$_alertCount',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            const Tab(text: 'Clients'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Requests'),
                  if (_pendingCount > 0) ...[
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('$_pendingCount',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 10)),
                    ),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Overview'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ClientsTab(clients: _mockClients),
          _RequestsTab(
            requests: requests,
            onAccept: (r) => setState(() => r.isPending = false),
            onDecline: (r) => setState(() => requests.remove(r)),
          ),
          _OverviewTab(clients: _mockClients),
        ],
      ),
    );
  }
}

// ── Tab 1: Clients ────────────────────────────────────────────────────────────

class _ClientsTab extends StatelessWidget {
  final List<_Client> clients;
  const _ClientsTab({required this.clients});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: clients.length,
      itemBuilder: (_, i) => _ClientCard(
        client: clients[i],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => _ClientDetailScreen(client: clients[i])),
        ),
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final _Client client;
  final VoidCallback onTap;
  const _ClientCard({required this.client, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: client.hasAlert
                ? Colors.red.withValues(alpha: 0.4)
                : AppColors.divider,
            width: client.hasAlert ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      AppColors.primaryLight.withValues(alpha: 0.4),
                  child: Text(client.name[0],
                      style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(client.name,
                          style: AppTextStyles.bodyLarge
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text('Week ${client.weekPregnant} • ${client.lastSeen}',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textLight)),
                    ],
                  ),
                ),
                if (client.hasAlert)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Text('Alert',
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            // Metric chips
            Row(
              children: [
                _MetricChip(
                  icon: Icons.favorite,
                  color: AppColors.primary,
                  label: '${client.lastBpm.toStringAsFixed(0)} BPM',
                  alert: client.lastBpm > 160,
                ),
                const SizedBox(width: AppSpacing.sm),
                _MetricChip(
                  icon: Icons.thermostat,
                  color: Colors.orange,
                  label: '${client.lastTemp} °C',
                  alert: client.lastTemp > 37.5,
                ),
                const SizedBox(width: AppSpacing.sm),
                _MetricChip(
                  icon: Icons.child_care,
                  color: Colors.purple,
                  label: '${client.kicksToday} kicks',
                  alert: client.kicksToday < 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final bool alert;
  const _MetricChip(
      {required this.icon,
      required this.color,
      required this.label,
      this.alert = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (alert ? Colors.red : color).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: alert ? Colors.red : color, size: 12),
          const SizedBox(width: 4),
          Text(label,
              style: AppTextStyles.bodySmall.copyWith(
                  color: alert ? Colors.red : AppColors.textDark,
                  fontSize: 11)),
        ],
      ),
    );
  }
}

// ── Tab 2: Requests ───────────────────────────────────────────────────────────

class _RequestsTab extends StatelessWidget {
  final List<_Request> requests;
  final void Function(_Request) onAccept;
  final void Function(_Request) onDecline;

  const _RequestsTab(
      {required this.requests,
      required this.onAccept,
      required this.onDecline});

  @override
  Widget build(BuildContext context) {
    final pending = requests.where((r) => r.isPending).toList();
    final accepted = requests.where((r) => !r.isPending).toList();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (pending.isNotEmpty) ...[
          Text('New Requests',
              style: AppTextStyles.bodyLarge
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          ...pending.map((r) => _RequestCard(
              request: r,
              onAccept: () => onAccept(r),
              onDecline: () => onDecline(r))),
          const SizedBox(height: AppSpacing.lg),
        ],
        if (accepted.isNotEmpty) ...[
          Text('Accepted',
              style: AppTextStyles.bodyLarge
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          ...accepted.map(
              (r) => _RequestCard(request: r, onAccept: null, onDecline: null)),
        ],
        if (pending.isEmpty && accepted.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Column(
                children: [
                  const Icon(Icons.inbox_outlined,
                      size: 48, color: AppColors.textLight),
                  const SizedBox(height: AppSpacing.md),
                  Text('No requests', style: AppTextStyles.bodyMedium),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RequestCard extends StatelessWidget {
  final _Request request;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;

  const _RequestCard({required this.request, this.onAccept, this.onDecline});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.4),
                child: Text(request.name[0],
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name,
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.w600)),
                    Text('Week ${request.weekPregnant} • ${request.time}',
                        style: AppTextStyles.bodySmall
                            .copyWith(color: AppColors.textLight)),
                  ],
                ),
              ),
              if (!request.isPending)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const Text('Accepted',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 11,
                          fontWeight: FontWeight.w600)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(request.message,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textMedium, height: 1.4)),
          ),
          if (request.isPending) ...[
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onDecline,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textMedium,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.full)),
                    ),
                    child: const Text('Accept',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Tab 3: Overview ───────────────────────────────────────────────────────────

class _OverviewTab extends StatelessWidget {
  final List<_Client> clients;
  const _OverviewTab({required this.clients});

  @override
  Widget build(BuildContext context) {
    final alerts = clients.where((c) => c.hasAlert).length;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats row
          Row(
            children: [
              _StatCard(
                  value: '${clients.length}',
                  label: 'Total Clients',
                  color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              _StatCard(value: '$alerts', label: 'Alerts', color: Colors.red),
              const SizedBox(width: AppSpacing.sm),
              _StatCard(
                  value: '${clients.where((c) => !c.hasAlert).length}',
                  label: 'Healthy',
                  color: Colors.green),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Recent Activity',
              style: AppTextStyles.bodyLarge
                  .copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.sm),
          ...clients.expand((c) => c.logs
              .take(2)
              .map((l) => _ActivityRow(clientName: c.name, log: l))),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  const _StatCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.heading2.copyWith(color: color)),
            Text(label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textMedium),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final String clientName;
  final _Log log;
  const _ActivityRow({required this.clientName, required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: log.isAlert
              ? Colors.red.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Icon(log.isAlert ? Icons.warning_amber : Icons.check_circle_outline,
              color: log.isAlert ? Colors.red : Colors.green, size: 16),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodySmall,
                children: [
                  TextSpan(
                      text: clientName,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D2D2D))),
                  TextSpan(
                      text: ' — ${log.metric}: ${log.value}',
                      style: const TextStyle(color: Color(0xFF6B6B6B))),
                ],
              ),
            ),
          ),
          Text(log.time,
              style:
                  AppTextStyles.bodySmall.copyWith(color: AppColors.textLight)),
        ],
      ),
    );
  }
}

// ── Client Detail Screen ──────────────────────────────────────────────────────

class _ClientDetailScreen extends StatefulWidget {
  final _Client client;
  const _ClientDetailScreen({super.key, required this.client});

  @override
  State<_ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<_ClientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;
  final _msgController = TextEditingController();
  late List<_Message> _messages;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _messages = List.from(widget.client.messages);
  }

  @override
  void dispose() {
    _tab.dispose();
    _msgController.dispose();
    super.dispose();
  }

  void _sendAdvice() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(
          sender: 'midwife',
          text: text,
          time:
              '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}'));
      _msgController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.client.name, style: AppTextStyles.heading3),
            Text('Week ${widget.client.weekPregnant}',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.textLight)),
          ],
        ),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textLight,
          indicatorColor: AppColors.primary,
          tabs: const [Tab(text: 'Data Logs'), Tab(text: 'Advice Chat')],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          // ── Logs ────────────────────────────────────────────────────────
          ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              // Current readings
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Readings',
                        style: AppTextStyles.bodyLarge
                            .copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                            child: _ReadingTile(
                                icon: Icons.favorite,
                                color: AppColors.primary,
                                label: 'Heart Rate',
                                value:
                                    '${widget.client.lastBpm.toStringAsFixed(0)} BPM',
                                isAlert: widget.client.lastBpm > 160)),
                        Expanded(
                            child: _ReadingTile(
                                icon: Icons.thermostat,
                                color: Colors.orange,
                                label: 'Temp',
                                value: '${widget.client.lastTemp} °C',
                                isAlert: widget.client.lastTemp > 37.5)),
                        Expanded(
                            child: _ReadingTile(
                                icon: Icons.child_care,
                                color: Colors.purple,
                                label: 'Kicks',
                                value: '${widget.client.kicksToday}',
                                isAlert: widget.client.kicksToday < 10)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Today\'s Log',
                  style: AppTextStyles.bodyLarge
                      .copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: AppSpacing.sm),
              ...widget.client.logs.map((log) => _LogRow(log: log)),
            ],
          ),

          // ── Advice Chat ──────────────────────────────────────────────────
          Column(
            children: [
              Expanded(
                child: _messages.isEmpty
                    ? Center(
                        child: Text('No messages yet',
                            style: AppTextStyles.bodyMedium
                                .copyWith(color: AppColors.textLight)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) => _ChatBubble(msg: _messages[i]),
                      ),
              ),
              // Input
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _msgController,
                        decoration: InputDecoration(
                          hintText: 'Write advice or reply...',
                          hintStyle: AppTextStyles.hintText,
                          filled: true,
                          fillColor: AppColors.background,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    GestureDetector(
                      onTap: _sendAdvice,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: AppColors.primary),
                        child: const Icon(Icons.send,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReadingTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final bool isAlert;
  const _ReadingTile(
      {required this.icon,
      required this.color,
      required this.label,
      required this.value,
      required this.isAlert});

  @override
  Widget build(BuildContext context) {
    final c = isAlert ? Colors.red : color;
    return Column(
      children: [
        Icon(icon, color: c, size: 20),
        const SizedBox(height: 4),
        Text(value,
            style: AppTextStyles.bodyMedium
                .copyWith(color: c, fontWeight: FontWeight.w600)),
        Text(label,
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textLight, fontSize: 10)),
      ],
    );
  }
}

class _LogRow extends StatelessWidget {
  final _Log log;
  const _LogRow({required this.log});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: log.isAlert ? Colors.red.withValues(alpha: 0.04) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: log.isAlert
              ? Colors.red.withValues(alpha: 0.3)
              : AppColors.divider,
        ),
      ),
      child: Row(
        children: [
          Text(log.time,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textLight, fontSize: 11)),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(log.metric, style: AppTextStyles.bodyMedium)),
          Text(log.value,
              style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: log.isAlert ? Colors.red : AppColors.textDark)),
          if (log.isAlert) ...[
            const SizedBox(width: 6),
            const Icon(Icons.warning_amber_rounded,
                color: Colors.red, size: 14),
          ],
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _Message msg;
  const _ChatBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    final isMidwife = msg.sender == 'midwife';
    return Align(
      alignment: isMidwife ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
        decoration: BoxDecoration(
          color: isMidwife ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMidwife ? 16 : 4),
            bottomRight: Radius.circular(isMidwife ? 4 : 16),
          ),
          border: isMidwife ? null : Border.all(color: AppColors.divider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(msg.text,
                style: AppTextStyles.bodySmall.copyWith(
                    color: isMidwife ? Colors.white : AppColors.textDark,
                    height: 1.4)),
            const SizedBox(height: 4),
            Text(msg.time,
                style: TextStyle(
                    fontSize: 10,
                    color: isMidwife
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.textLight)),
          ],
        ),
      ),
    );
  }
}
