import 'package:flutter/material.dart';

import '../../../machines/presentation/pages/machines_home_page.dart';
import '../../../inventory/presentation/pages/inventory_home_page.dart';
import '../../../maintenance/presentation/pages/maintenance_home_page.dart';
import '../../../hr/presentation/pages/hr_home_page.dart';
import '../../../accounting/presentation/pages/accounting_home_page.dart';
import '../../../sales/presentation/pages/sales_home_page.dart';
import '../../../conflict_governance/presentation/pages/conflict_governance_home_page.dart';
import '../../../shared/presentation/widgets/watermark_signature.dart';

class SystemModulesScreen extends StatelessWidget {
  const SystemModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = <({String title, Widget page})>[
      (title: 'المعدات والتشخيص', page: const MachinesHomePage()),
      (title: 'المخزون الذكي', page: const InventoryHomePage()),
      (title: 'الأعطال والصيانة', page: const MaintenanceHomePage()),
      (title: 'الموارد البشرية', page: const HrHomePage()),
      (title: 'الحسابات', page: const AccountingHomePage()),
      (title: 'المبيعات', page: const SalesHomePage()),
      (title: 'الحوكمة والمزامنة', page: const ConflictGovernanceHomePage()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('UMG Factory OS')),
      body: Stack(
        children: [
          GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];
              return Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => module.page),
                  ),
                  child: Center(
                    child: Text(
                      module.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            },
          ),
          const WatermarkSignature(),
        ],
      ),
    );
  }
}
