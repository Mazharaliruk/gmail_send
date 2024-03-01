// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendOTP(
    String email,
    BuildContext context,
    String upliftDate,
    deliverdate,
    regNumberController,
    upliftFromController,
    deliverToController,
    commentsControlkler) async {
  String username = 'shahlili1645@gmail.com';
  String password = 'lfzhdzgojlhsgubh';
  final smtpServer = gmail(username, password);
  final message = Message()
    ..from = Address(username, 'Shah Lili')
    ..recipients.add(email)
    ..subject = 'Email Verification test :: ${DateTime.now()}'
    ..text =
        'uplift date : $upliftDate \n /n deliver date : $deliverdate \n /n  regNumber : $regNumberController \n /n upliftFrom : $upliftFromController \n /n deliverTo: $deliverToController /n \n comments : $commentsControlkler'
    ..html =
        "<h1>Test</h1>\n<p>uplift date : $upliftDate \n /n deliver date : $deliverdate \n /n  regNumber : $regNumberController \n /n upliftFrom : $upliftFromController \n /n deliverTo: $deliverToController /n \n comments : $commentsControlkler </p>";
  try {
    await send(message, smtpServer);
    showmessageofalert(context, "6 digits otp send to your email $email");
  } on MailerException catch (e) {
    showmessageofalert(context, "OTP not sent. $e");
    for (var p in e.problems) {
      showmessageofalert(context, "Problem: ${p.code}: ${p.msg}");
    }
  }
}

showmessageofalert(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

void openGmail(
    List<String> recipients,
    String upliftDate,
    deliverdate,
    regNumberController,
    upliftFromController,
    deliverToController,
    commentsControlkler) async {
  recipients.add('info@cartransportni.com');
  String recipientList = recipients.join(",");

  String subject = "Delivery Instructions for johnstons for";

  String body = _buildDataTableText(
      upliftDate,
      deliverdate,
      regNumberController,
      upliftFromController,
      deliverToController,
      commentsControlkler);

  // Encode the body
  String encodedBody = Uri.encodeComponent(body);
  String decodedBody = Uri.decodeComponent(encodedBody);

  String htmlBody = _buildDataTableHtml(
      upliftDate,
      deliverdate,
      regNumberController,
      upliftFromController,
      deliverToController,
      commentsControlkler);

  // Encode the HTML body
  String encodedBodyhtml = Uri.encodeComponent(htmlBody);
  String decodedBodyhtml = Uri.decodeComponent(encodedBodyhtml);

  String uri = "mailto:$recipientList?subject=$subject&body=$decodedBody";

  var emailLaunchUri = Uri.encodeFull(uri);

  if (await canLaunch(emailLaunchUri)) {
    await launch(emailLaunchUri);
    recipients.clear();
  } else {
    throw 'Could not launch $emailLaunchUri';
  }
}

String _buildDataTableText(String upliftDate, String deliverDate,
    String regNumber, String upliftFrom, String deliverTo, String comments) {
  // Concatenate the data values with appropriate delimiters
  String tableText = "Uplift Date: $upliftDate\n"
      '\n'
      "Deliver Date: $deliverDate\n"
      '\n'
      "Reg Number: $regNumber\n"
      '\n'
      "Uplift From: $upliftFrom\n"
      '\n'
      "Deliver To: $deliverTo\n"
      '\n'
      "Comments: $comments\n";

  return tableText;
}

String _buildDataTableHtml(String upliftDate, String deliverDate,
    String regNumber, String upliftFrom, String deliverTo, String comments) {
  // Construct the HTML structure with the table
  String html = '''
    <!DOCTYPE html>
    <html>
    <head>
    <style>
    table {
      font-family: Arial, sans-serif;
      border-collapse: collapse;
      width: 100%;
    }
    th, td {
      border: 1px solid black;
      padding: 8px;
      text-align: left;
    }
    th {
      background-color: #f2f2f2;
    }
    </style>
    </head>
    <body>
    <h1>Data Table</h1>
    <table>
      <tr><th>Field</th><th>Value</th></tr>
      <tr><td>Uplift Date</td><td>$upliftDate</td></tr>
      <tr><td>Deliver Date</td><td>$deliverDate</td></tr>
      <tr><td>Reg Number</td><td>$regNumber</td></tr>
      <tr><td>Uplift From</td><td>$upliftFrom</td></tr>
      <tr><td>Deliver To</td><td>$deliverTo</td></tr>
      <tr><td>Comments</td><td>$comments</td></tr>
    </table>
    </body>
    </html>
    ''';

  return html;
}
