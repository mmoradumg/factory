import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../audit/presentation/pages/audit_log_host_screen.dart';
import '../../../hr/presentation/pages/hr_host_screen.dart';
import '../../../inventory/presentation/pages/inventory_host_screen.dart';

class SystemModulesScreen extends StatelessWidget {
  const SystemModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('أنظمة المصنع')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ModuleTile(
            title: 'الرقابة والتدقيق',
            subtitle: 'Audit Dashboard + Live Feed',
            icon: Icons.shield_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => sl<AuditLogHostScreen>())),
          ),
          const SizedBox(height: 10),
          _ModuleTile(
            title: 'الموارد البشرية',
            subtitle: 'Employees + Leaves + Salary Advances',
            icon: Icons.groups_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => sl<HrHostScreen>())),
          ),
          const SizedBox(height: 10),
          _ModuleTile(
            title: 'المخازن',
            subtitle: 'Items + Stock Movements + Low Stock',
            icon: Icons.inventory_2_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => sl<InventoryHostScreen>())),
          ),
        ],
      ),
    );
  }
}

class _ModuleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _ModuleTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(icon)),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
