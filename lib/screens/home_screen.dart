import 'package:flutter/material.dart';
import '../database_helper.dart';
import 'products_screen.dart';
import 'sales_screen.dart';
import 'customers_screen.dart';
import 'invoices_screen.dart';
import 'expenses_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selected = 0;
  Map<String, dynamic> stats = {};

  final pages = const [
    _DashboardBody(),
    ProductsScreen(),
    SalesScreen(),
    CustomersScreen(),
    InvoicesScreen(),
    ExpensesScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  final labels = const [
    'الرئيسية', 'المنتجات', 'المبيعات', 'العملاء',
    'الفواتير', 'المصروفات', 'التقارير', 'الإعدادات'
  ];

  final icons = const [
    Icons.dashboard_outlined, Icons.inventory_2_outlined,
    Icons.point_of_sale_outlined, Icons.people_outline,
    Icons.receipt_long_outlined, Icons.payments_outlined,
    Icons.bar_chart_outlined, Icons.settings_outlined
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final x = await DatabaseHelper.instance.dashboardStats();
    if (mounted) setState(() => stats = x);
  }

  void _select(int i) {
    setState(() => selected = i);
    if (i == 0) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(builder: (context, box) {
        final desktop = box.maxWidth >= 850;
        if (desktop) {
          return Scaffold(
            body: Row(
              children: [
                _Sidebar(
                  selected: selected,
                  labels: labels,
                  icons: icons,
                  onSelect: _select,
                ),
                Expanded(
                  child: Column(
                    children: [
                      _TopBar(onRefresh: _load),
                      Expanded(child: pages[selected]),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(labels[selected]),
            actions: [
              IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
            ],
          ),
          body: pages[selected],
          bottomNavigationBar: NavigationBar(
            selectedIndex: selected > 4 ? 0 : selected,
            onDestinationSelected: (i) => _select(i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'الرئيسية'),
              NavigationDestination(icon: Icon(Icons.inventory_2_outlined), label: 'المنتجات'),
              NavigationDestination(icon: Icon(Icons.point_of_sale_outlined), label: 'المبيعات'),
              NavigationDestination(icon: Icon(Icons.people_outline), label: 'العملاء'),
              NavigationDestination(icon: Icon(Icons.receipt_long_outlined), label: 'الفواتير'),
            ],
          ),
        );
      }),
    );
  }
}

class _Sidebar extends StatelessWidget {
  final int selected;
  final List<String> labels;
  final List<IconData> icons;
  final ValueChanged<int> onSelect;

  const _Sidebar({
    required this.selected,
    required this.labels,
    required this.icons,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff063c91), Color(0xff06245c)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 20, 18, 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('▦ بكسل Pixel',
                      style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w800)),
                    SizedBox(height: 5),
                    Text('لأنظمة الحماية و الشبكات',
                      style: TextStyle(color: Colors.white70, fontSize: 11)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                itemCount: labels.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ListTile(
                    selected: selected == i,
                    selectedTileColor: const Color(0xff2374d8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onTap: () => onSelect(i),
                    leading: Icon(icons[i], color: Colors.white),
                    title: Text(labels[i],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(14),
              child: Text('Pixel • 0915 763 524\n© 2026',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.7)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final VoidCallback onRefresh;
  const _TopBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 25),
          const SizedBox(width: 22),
          Expanded(
            child: SizedBox(
              height: 42,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'بحث سريع...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: const Color(0xfff6f8fb),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          IconButton(onPressed: onRefresh, icon: const Icon(Icons.refresh)),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundColor: Color(0xff173c77),
            child: Text('م', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 10),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('مدير النظام', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('المدير', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: DatabaseHelper.instance.dashboardStats(),
      builder: (context, snap) {
        final s = snap.data ?? {};
        final products = s['products'] ?? 0;
        final customers = s['customers'] ?? 0;
        final sales = ((s['sales'] ?? 0) as num).toDouble();
        final expenses = ((s['expenses'] ?? 0) as num).toDouble();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('لوحة التحكم',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('نظرة سريعة على منظومة PixelSales',
                style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 20),
              LayoutBuilder(builder: (context, c) {
                final n = c.maxWidth > 1200 ? 4 : c.maxWidth > 700 ? 2 : 1;
                return GridView.count(
                  crossAxisCount: n,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2.25,
                  children: [
                    _StatCard('العملاء', '$customers', Icons.people_outline, const Color(0xff13a85a)),
                    _StatCard('إجمالي المبيعات', '${sales.toStringAsFixed(2)} د.ل', Icons.point_of_sale_outlined, const Color(0xff2874e8)),
                    _StatCard('صافي المبيعات', '${(sales-expenses).toStringAsFixed(2)} د.ل', Icons.trending_up, const Color(0xff8054df)),
                    _StatCard('إجمالي المنتجات', '$products', Icons.inventory_2_outlined, const Color(0xffff941b)),
                  ],
                );
              }),
              const SizedBox(height: 18),
              LayoutBuilder(builder: (context, c) {
                final wide = c.maxWidth > 850;
                final left = _RecentInvoices();
                final right = _QuickActions();
                return wide
                    ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(flex: 5, child: left),
                        const SizedBox(width: 18),
                        Expanded(flex: 4, child: right),
                      ])
                    : Column(children: [left, const SizedBox(height: 18), right]);
              }),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard(this.title, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800)),
              ],
            )),
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(color: color.withOpacity(.12), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentInvoices extends StatelessWidget {
  const _RecentInvoices();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Padding(
            padding: EdgeInsets.all(14),
            child: Text('المبيعات الأخيرة',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.getInvoices(),
            builder: (_, snap) {
              final data = (snap.data ?? []).take(5).toList();
              if (data.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(22),
                  child: Center(child: Text('لا توجد مبيعات بعد')),
                );
              }
              return Column(children: data.map((x) => ListTile(
                dense: true,
                leading: const CircleAvatar(
                  backgroundColor: Color(0xffe7f0ff),
                  child: Icon(Icons.receipt_long, color: Color(0xff2874e8), size: 19),
                ),
                title: Text('فاتورة #${x['id']}'),
                subtitle: Text((x['customer_name'] ?? 'عميل نقدي').toString()),
                trailing: Text('${(x['total'] as num).toStringAsFixed(2)} د.ل',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              )).toList());
            },
          ),
        ]),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('اختصارات سريعة',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          _Action('إضافة منتج', Icons.add_box_outlined, const ProductsScreen()),
          _Action('بيع جديد', Icons.point_of_sale_outlined, const SalesScreen()),
          _Action('إضافة عميل', Icons.person_add_outlined, const CustomersScreen()),
          _Action('التقارير', Icons.bar_chart_outlined, const ReportsScreen()),
        ]),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;
  const _Action(this.title, this.icon, this.page);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
          icon: Icon(icon),
          label: Text(title),
        ),
      ),
    );
  }
}
