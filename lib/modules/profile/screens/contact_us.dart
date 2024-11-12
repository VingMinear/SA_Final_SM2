import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:homework3/widgets/custom_appbar.dart';

import '../../../utils/Utilty.dart';
import '../../../widgets/CardContact.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: customAppBar(
        title: 'Contact Us',
        showNotification: false,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 250,
              child: Image.asset(
                'assets/icons/contactus.jpg',
                width: 250,
              ),
            ),
            Text(
              '''If you have any questions, concerns, or feedback, we're here to help. Feel free to get in touch with us through the following methods:''',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '''1. Phone: Our friendly customer support team is available to assist you over the phone.''',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '''2. Telegram: For non-urgent inquiries, you can reach out to us via telegram account.''',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                cardContact(
                  onTap: () {
                    callLaunchUrl(
                      url: 'tel:010 880 612',
                    );
                  },
                  title: 'Telephone',
                  icon: 'assets/icons/ic_ph.svg',
                ),
                const SizedBox(width: 16),
                cardContact(
                  onTap: () {
                    callLaunchUrl(
                      url: 'https://t.me/SAMOEUN_CHHAY',
                    );
                  },
                  title: 'Telegram',
                  icon: 'assets/icons/ic_telegram.svg',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
