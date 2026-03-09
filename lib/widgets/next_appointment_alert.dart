import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../screens/timeline/timeline_screen.dart';
import '../screens/midwives/midwives_screen.dart';
import '../screens/hospitals/hospitals_screens.dart';

class Appointment {
  final String title;
  final DateTime time;
  final IconData icon;
  final bool isVaccine;
  final bool completed;

  Appointment({
    required this.title,
    required this.time,
    required this.icon,
    this.isVaccine = false,
    this.completed = false,
  });

  Appointment copyWith({
    String? title,
    DateTime? time,
    IconData? icon,
    bool? isVaccine,
    bool? completed,
  }) {
    return Appointment(
      title: title ?? this.title,
      time: time ?? this.time,
      icon: icon ?? this.icon,
      isVaccine: isVaccine ?? this.isVaccine,
      completed: completed ?? this.completed,
    );
  }
}

final ValueNotifier<List<Appointment>> appointmentAlertsNotifier =
    ValueNotifier<List<Appointment>>([
  Appointment(
    title: "Blood Test",
    time: DateTime(2026, 3, 10, 9, 30),
    icon: Icons.bloodtype,
  ),
  Appointment(
    title: "Doctor Consultation",
    time: DateTime(2026, 3, 10, 11, 0),
    icon: Icons.medical_services,
  ),
  Appointment(
    title: "MRI Scan",
    time: DateTime(2026, 3, 10, 14, 30),
    icon: Icons.science,
  ),
  Appointment(
    title: "Pharmacy Pickup",
    time: DateTime(2026, 3, 10, 16, 0),
    icon: Icons.local_pharmacy,
  ),
]);

DateTime buildDefaultAlertTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 9).add(const Duration(days: 1));
}

void setAppointmentAlert(Appointment alert) {
  final updated = List<Appointment>.from(appointmentAlertsNotifier.value);
  final existingIndex = updated.indexWhere(
    (a) => a.title == alert.title && a.isVaccine == alert.isVaccine,
  );

  if (existingIndex >= 0) {
    updated[existingIndex] = alert.copyWith(completed: false);
  } else {
    updated.add(alert);
  }

  updated.sort((a, b) => a.time.compareTo(b.time));
  appointmentAlertsNotifier.value = updated;
}

void markAlertAsCompleted(String title, {bool vaccineOnly = false}) {
  final updated = appointmentAlertsNotifier.value
      .where((a) {
        if (a.title != title) return true;
        if (vaccineOnly && !a.isVaccine) return true;
        return false; // Remove this item
      })
      .toList(growable: false);
  appointmentAlertsNotifier.value = updated;
}

bool hasPendingAlert(String title, {bool vaccineOnly = false}) {
  return appointmentAlertsNotifier.value.any(
    (a) =>
        a.title == title &&
        !a.completed &&
        (!vaccineOnly || (vaccineOnly && a.isVaccine)),
  );
}

Appointment? getNextUpcomingAppointment() {
  final now = DateTime.now();
  final upcoming = appointmentAlertsNotifier.value
      .where((a) => !a.completed && a.time.isAfter(now))
      .toList(growable: false)
    ..sort((a, b) {
      // Prioritize vaccines/tests over appointments
      if (a.isVaccine != b.isVaccine) {
        return a.isVaccine ? -1 : 1;
      }
      // Then sort by time
      return a.time.compareTo(b.time);
    });
  return upcoming.isEmpty ? null : upcoming.first;
}

class NextAppointmentAlert extends StatelessWidget {
  const NextAppointmentAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Appointment>>(
      valueListenable: appointmentAlertsNotifier,
      builder: (context, _, __) {
        final nextAppointment = getNextUpcomingAppointment();

        if (nextAppointment == null) {
          return const SizedBox.shrink();
        }

        final now = DateTime.now();
        final duration = nextAppointment.time.difference(now);
        final String etaLabel = duration.inDays > 0
            ? '${duration.inDays} d'
            : '${duration.inHours.clamp(1, 23)} h';

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TimelineScreen(
                  scrollToEntryTitle: nextAppointment.title,
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    nextAppointment.icon,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nextAppointment.isVaccine
                            ? 'Upcoming Vaccine'
                            : 'Upcoming Appointment',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        nextAppointment.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (nextAppointment.isVaccine)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () => _showBookingDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Book',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          markAlertAsCompleted(nextAppointment.title,
                              vaccineOnly: true);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Vaccine marked as already gotten.'),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Already gotten',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      etaLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
void _showBookingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Book Vaccine/Test',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
          fontSize: 18,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Where would you like to book?',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HospitalsScreen(),
                ),
              );
            },
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.local_hospital, color: AppColors.primary),
            ),
            title: const Text(
              'Hospital',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            subtitle: const Text(
              'Book at a nearby hospital',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MidwivesScreen(),
                ),
              );
            },
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.people, color: Color(0xFF10B981)),
            ),
            title: const Text(
              'Midwife',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
            subtitle: const Text(
              'Book with a certified midwife',
              style: TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}