import 'package:dio/dio.dart';

class SendGrid {
  final _apiKey = 'SG.key';

  //only good for mobile
  Future<void> sendEmail(String sendTo, Map<String, dynamic> data) async {
    //try {
    await Dio().post('https://api.sendgrid.com/v3/mail/send',
        options: Options(contentType: 'application/json', headers: {
          "content-type": "application/json",
          "authorization": "Bearer $_apiKey",
        }),
        data: {
          "from": {"email": "bidonline22@gmail.com"},
          "personalizations": [
            {
              "to": [
                {"email": sendTo}
              ],
              "dynamic_template_data": data
            }
          ],
          "template_id": "d-08007f94fa93405b938a6dbb55af0825"
        });
    //}
    // on DioError catch (e) {
    //   print('Error: $e');
    // }
  }
}
