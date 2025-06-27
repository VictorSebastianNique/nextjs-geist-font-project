import 'package:twilio_flutter/twilio_flutter.dart';

class SmsService {
  final TwilioFlutter twilioFlutter;

  SmsService({
    required String accountSid,
    required String authToken,
    required String twilioNumber,
  }) : twilioFlutter = TwilioFlutter(
          accountSid: accountSid,
          authToken: authToken,
          twilioNumber: twilioNumber,
        );

  Future<void> sendSms(String toNumber, String message) async {
    try {
      await twilioFlutter.sendSMS(toNumber: toNumber, messageBody: message);
    } catch (e) {
      throw Exception('Error enviando SMS: $e');
    }
  }
}
