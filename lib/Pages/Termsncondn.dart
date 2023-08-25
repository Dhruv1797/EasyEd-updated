import 'package:flutter/material.dart';

class Termsncondn extends StatelessWidget {
  const Termsncondn({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height;

    double devicewidth = MediaQuery.of(context).size.width;
    FontWeight fontweightsize = FontWeight.w600;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Container(
                height: deviceheight * 0.87,
                width: devicewidth * 0.95,
                // color: Colors.red,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          '''Welcome to EasyEd! These Terms and Conditions govern your access and use of our social media application ("EasyEd"), including all content, features, and services provided through the App. By accessing or using the App, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use the App.
                            '''),
                      Text(
                        ''' 
1. Acceptable Use 
  ''',
                        style: TextStyle(fontWeight: fontweightsize),
                      ),
                      Text(
                          ''' 1.1 You must be at least 5 years old to use the App. By using the App, you confirm that you meet the minimum age requirement. 
  '''),
                      Text(
                          ''' 1.2 You agree to use the App responsibly and comply with all applicable laws and regulations. '''),
                      Text(
                          ''' 1.3 You are responsible for maintaining the confidentiality of your account credentials and are liable for all activities that occur under your account. '''),
                      Text(
                          ''' 1.4 You may not use the App to post, share, or engage in any content that is unlawful, harmful, defamatory, abusive, or violates the rights of others. 
   '''),
                      Text(''' 
2. User Content 
  ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                          ''' 2.1 The App allows you to post and share content, including photos, videos, and text ("User Content"). By posting User Content, you grant us a non-exclusive, worldwide, royalty-free license to use, reproduce, modify, and distribute your User Content for the purpose of operating and improving the App. 
 '''),
                      Text(
                          ''' 2.2 You are solely responsible for your User Content. We do not endorse or guarantee the accuracy, quality, or reliability of User Content, and we reserve the right to remove any User Content that violates these Terms or is otherwise inappropriate.   '''),
                      Text(
                          ''' 2.3 You represent and warrant that you have all necessary rights to post User Content and that it does not infringe upon the rights of any third party. 
  '''),
                      Text('''3. Intellectual Property 
 ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text('''  
 3.1 The App and its content, including but not limited to logos, trademarks, and software, are the property of “EasyEd” or its licensors and are protected by intellectual property laws. 
 '''),
                      Text(
                          ''' 3.2 You may not copy, modify, distribute, or reproduce any part of the App without prior written permission from us. 
 '''),
                      Text('''4. Privacy 
 ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                          ''' 4.1 Our Privacy Policy governs the collection, use, and disclosure of your personal information when you use the App. By using the App, you consent to the practices outlined in our Privacy Policy. 
   '''),
                      Text(
                          ''' 4.2 We may collect certain information automatically when you use the App, such as device information, IP address, and usage data. This data helps us improve the App and deliver a better user experience. 
  '''),
                      Text(
                          ''' 4.3 We may use cookies or similar technologies to enhance your user experience and provide personalized content and advertisements.   
                          '''),
                      Text('''
5. Termination 
  ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                          ''' 5.1 We reserve the right to suspend or terminate your access to the App at any time without notice for violating these Terms or engaging in any behavior that we deem harmful to the App or its users. 
 '''),
                      Text('''6. Disclaimer of Warranties  
                      ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                          ''' 6.1 The App is provided "as is" and without warranties of any kind, whether express or implied.   '''),
                      Text(
                          ''' 6.2 We do not guarantee that the App will be error-free, uninterrupted, or free of viruses or harmful components. 
 '''),
                      Text('''7. Limitation of Liability 
  ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                        ''' 
 7.1 To the maximum extent permitted by law, we shall not be liable for any direct, indirect, incidental, consequential, or punitive damages arising from your use of the App. 
  ''',
                      ),
                      Text('''8. Modifications to the Terms  
                      ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                          ''' 8.1 We may update these Terms from time to time without prior notice. By continuing to use the App after the updated Terms have been posted, you agree to be bound by the revised Terms. 
  '''),
                      Text('''  
9. Governing Law 
 ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text('''
 9.1 These Terms shall be governed by and construed in accordance with the laws of [Jurisdiction], without regard to its conflict of laws principles.   
 '''),
                      Text('''10. Contact Us 
  ''', style: TextStyle(fontWeight: fontweightsize)),
                      Text(
                          ''' 10.1 If you have any questions or concerns about these Terms or the App, please contact us at info@easyeduverse.com 
  '''),
                      Text('''  
By using the App, you acknowledge that you have read, understood, and agreed to these Terms and our Privacy Policy. ''',
                          style: TextStyle(fontWeight: fontweightsize)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
