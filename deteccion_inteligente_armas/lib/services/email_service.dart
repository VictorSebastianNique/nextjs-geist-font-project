import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailService {
  Future<void> sendEmail({
    required String toEmail,
    required String subject,
    required String body,
    List<String>? attachmentPaths,
  }) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [toEmail],
      attachmentPaths: attachmentPaths,
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (e) {
      throw Exception('Error enviando correo: $e');
    }
  }
}
