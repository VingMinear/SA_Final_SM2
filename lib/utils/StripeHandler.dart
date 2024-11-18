import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homework3/utils/Utilty.dart';
import 'package:http/http.dart' as http;

class StripePaymentHandle {
  Map<String, dynamic>? paymentIntent;

  Future<bool> stripeMakePayment({required String amount}) async {
    var isSuccess = false;
    try {
      paymentIntent = await createPaymentIntent(amount, 'USD');
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret:
                  paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'SS5',
            ),
          )
          .then((value) {});

      //STEP 3: Display Payment sheet
      isSuccess = await displayPaymentSheet();
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
    return isSuccess;
  }

  Future<bool> displayPaymentSheet() async {
    var isSccess = false;
    try {
      // Display the payment sheet
      await Stripe.instance.presentPaymentSheet();
      isSccess = true;
      // Notify the user of successful payment
      Fluttertoast.showToast(msg: 'Payment completed successfully.');
    } on Exception catch (e) {
      if (e is StripeException) {
        // Handle specific Stripe errors
        if (e.error.code == FailureCode.Failed) {
          alertDialog(desc: 'Payment failed. Please try again later.');
        } else if (e.error.code == FailureCode.Canceled) {
          Fluttertoast.showToast(msg: 'Payment was canceled by the user.');
        } else {
          Fluttertoast.showToast(msg: '${e.error.localizedMessage}');
        }
      } else {
        // Handle unforeseen errors
        Fluttertoast.showToast(
            msg: 'An unexpected error occurred. Please try again.');
      }
    }
    return isSccess;
  }

//create Payment
  createPaymentIntent(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51PVAzHLRxnMedF0lzFqfkqqqfeXJsMsGiqueXf4v0iFN5u7jiYBhAYlxmdCKerdxwqlrJNkgiDJh7lfAIHNcu24E00Gw9bRSEB',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    // Convert the amount to a double, multiply by 100 to convert dollars to cents,
    // and then round it to avoid fractional cents issues.
    final calculatedAmount = (double.parse(amount) * 100).round();
    return calculatedAmount
        .toString(); // Return as string to match Stripe's expected format
  }
}
