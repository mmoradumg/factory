import 'package:flutter/material.dart';

class MachineEngineeringPage extends StatelessWidget {
  const MachineEngineeringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final machines = const [
      ('GR للتنقيط', 'خط إنتاج خرطوم ري بالتنقيط'),
      ('PVC', 'وحدة إنتاج ومعالجة PVC'),
      ('الخرازة', 'تشغيل وتشكيل ميكانيكي'),
      ('الكسارة', 'التكسير والنقل والمعالجة الأولية'),
      ('حقن الفلاتر', 'ماكينة حقن لصناعة أجزاء الفلاتر'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('هندسة المعدات والتشخيص الذكي')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Card(
            child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('مركز المعرفة الصناعية', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('قاعدة بيانات المعدات + شجرة التجميع + الأجزاء + الأعطال الذكية + المعرفة الفنية.'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...machines.map(
            (m) => Card(
              child: ListTile(
                leading: const Icon(Icons.memory_outlined),
                title: Text(m.$1),
                subtitle: Text(m.$2),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
