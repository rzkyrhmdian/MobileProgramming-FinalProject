import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileprogramming_finalproject/utils/colors.dart';
import 'package:mobileprogramming_finalproject/domain/model/notification_info.dart';
import 'package:mobileprogramming_finalproject/data/repository/notification_repository_impl.dart';
import 'package:mobileprogramming_finalproject/ui/notifikasi/notifikasi_viewmodel.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Stream<List<NotificationInfo>> _notifStream;

  @override
  void initState() {
    super.initState();
    _notifStream = NotificationRepositoryImpl().getUserNotificationsStream();
  }

  @override
  Widget build(BuildContext context) {
    final notifVm = Provider.of<NotifikasiViewModel>(context, listen: false);
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
          title: const Text(
            'Notifikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SizedBox.expand(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundGeneral.png'),
                fit: BoxFit.cover,
              ),
            ),
            padding: const EdgeInsets.only(top: kToolbarHeight + 20),
            child: StreamBuilder<List<NotificationInfo>>(
              stream: _notifStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Terjadi kesalahan: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                final notifs = snapshot.data ?? [];

                return _buildList(
                  notifs,
                  'Belum ada notifikasi saat ini.',
                  notifVm,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    List<NotificationInfo> items,
    String emptyMessage,
    NotifikasiViewModel viewModel_,
  ) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final notif = items[index];
        final type = viewModel_.getNotificationType(notif.title);

        IconData icon;
        Color iconColor;
        Color iconBgColor;

        switch (type) {
          case NotificationType.selesai:
            icon = Icons.check_circle_outline_rounded;
            iconColor = const Color(0xFF2E7D32);
            iconBgColor = const Color(0xFFE8F5E9);
            break;
          case NotificationType.tolak:
            icon = Icons.cancel_outlined;
            iconColor = const Color(0xFFC62828);
            iconBgColor = const Color(0xFFFFEBEE);
            break;
          case NotificationType.terima:
            icon = Icons.hourglass_bottom_rounded;
            iconColor = const Color(0xFFEF6C00);
            iconBgColor = const Color(0xFFFFF3E0);
            break;
          case NotificationType.info:
            icon = Icons.info_outline;
            iconColor = AppColors.primary;
            iconBgColor = AppColors.primary.withValues(alpha: 0.1);
            break;
        }

        return _buildNotificationCard(
          notif: notif,
          icon: icon,
          iconColor: iconColor,
          iconBgColor: iconBgColor,
          viewModel: viewModel_,
        );
      },
    );
  }

  Widget _buildNotificationCard({
    required NotificationInfo notif,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required NotifikasiViewModel viewModel,
  }) {
    return GestureDetector(
      onTap: () {
        if (!notif.isRead) {
          NotificationRepositoryImpl().markAsRead(notif.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: !notif.isRead
              ? AppColors.primary.withValues(alpha: 0.04)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: !notif.isRead
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!notif.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.getTimeAgo(notif.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
