import 'package:flutter/material.dart';
import 'package:relax_doc/theme/app_theme.dart';

enum UserRole { vendor, customer, admin }

class RoleSelector extends StatelessWidget {
  final UserRole value;
  final ValueChanged<UserRole> onChanged;
  const RoleSelector({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final items = const [UserRole.vendor, UserRole.customer, UserRole.admin];
    final labels = const ['Vendor', 'Customer', 'Admin'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(items.length, (i) {
        final selected = value == items[i];
        return Padding(
          padding: EdgeInsets.only(right: i < items.length - 1 ? 12 : 0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(items[i]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
              child: Text(
                labels[i],
                style: TextStyle(
                  color:
                      selected ? AppColors.primary : AppColors.textMuted,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
