import 'package:flutter/material.dart';

import '../../../accounting/presentation/pages/accounting_page.dart';
import '../../../conflict_governance/presentation/pages/conflict_governance_page.dart';
import '../../../hr/presentation/pages/hr_page.dart';
import '../../../inventory/presentation/pages/inventory_page.dart';
import '../../../machines/presentation/pages/machine_engineering_page.dart';
import '../../../maintenance/presentation/pages/maintenance_page.dart';
import '../../../production/presentation/pages/production_page.dart';
import '../../../sales/presentation/pages/sales_page.dart';

class SystemModulesPage extends StatelessWidget {
  const SystemModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <({String title, String subtitle, IconData icon, Widget page})>[
      (title: 'Production', subtitle: 'الإنتاج والأوامر والتتبع', icon: Icons.factory_outlined, page: const ProductionPage()),
      (title: 'Machine Engineering & Smart Diagnosis', subtitle: 'هندسة المعدات والتشخيص الذكي', icon: Icons.precision_manufacturing_outlined, page: const MachineEngineeringPage()),
      (title: 'Smart Inventory', subtitle: 'الخامات والمستلزمات والمنتج وقطع الغيار', icon: Icons.inventory_2_outlined, page: const InventoryPage()),
      (title: 'HR', subtitle: 'الموارد البشرية والرواتب والحضور', icon: Icons.people_alt_outlined, page: const HrPage()),
      (title: 'Accounting', subtitle: 'الخزنة والعملاء والموردون والقيود', icon: Icons.account_balance_wallet_outlined, page: const AccountingPage()),
      (title: 'Sales', subtitle: 'أوامر البيع والفواتير والتحصيل', icon: Icons.sell_outlined, page: const SalesPage()),
      (title: 'Conflict Governance', subtitle: 'التعارضات والدمج والحوكمة', icon: Icons.gavel_outlined, page: const ConflictGovernancePage()),
      (title: 'Maintenance', subtitle: 'الأعطال والصيانة الوقائية والتنبؤية', icon: Icons.build_circle_outlined, page: const MaintenancePage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('UMG Factory OS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _KpiStrip(),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              final module = modules[index];
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => module.page),
                  );
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(module.icon, size: 28),
                        const Spacer(),
                        Text(module.title, style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 6),
                        Text(module.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _KpiStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = const [
      ('Production Rate', '87%'),
      ('Machine Health', '91%'),
      ('Maintenance Due', '04'),
      ('Critical Stock', '03'),
      ('Open Conflicts', '02'),
      ('Cash Snapshot', 'Ready'),
    ];

    return SizedBox(
      height: 115,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return SizedBox(
            width: 170,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$1),
                    const Spacer(),
                    Text(item.$2, style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
