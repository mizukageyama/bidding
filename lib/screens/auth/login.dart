import 'package:bidding/layout/styles.dart';
import 'package:bidding/widgets/form_input_field_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 500,
        width: 400,
        padding: const EdgeInsets.all(10.00),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
            color: whiteColor,
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
               const SizedBox(
                  height: 5,
                ),
              const  ListTile(
                  title: Text(
                    'Welcome to Bidding Online!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                  ), 
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const <Widget>[
                      FormInputFieldWithIcon(
                        iconPrefix: Icons.email,
                        labelText: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        ),
                      SizedBox(height: 10,),

                      FormInputFieldWithIcon(
                        iconPrefix: Icons.key,
                        labelText: 'Password',
                      ),
                  ])
              ),
                  
              ButtonBar(
                alignment: MainAxisAlignment.center,
                buttonPadding:const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10),
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('Login'),
                    onPressed: (){}),

                    ElevatedButton(
                    child: const Text('SignUp'),
                    onPressed: (){}),
                   ],
                 )
              ],
            ),
        ),
      ),
    );
  }
}