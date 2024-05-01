import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motomate/screens/CreditCard/Components/input_formatters.dart';
import 'package:motomate/screens/dashboard.dart';
import 'package:motomate/utils/database.dart';
import 'package:motomate/utils/notification.dart';

import '../../utils/flutter_toast.dart';
import 'Components/card_type.dart';
import 'Components/card_utils.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  TextEditingController cardNumberController = TextEditingController();
  CardType cardType = CardType.Invalid;

  void getCardTypeFrmNum() {
    //with in 6 digits we can identify the type of card
    if (cardNumberController.text.length <= 6) {
      String cardNum = CardUtils.getCleanedNumber(cardNumberController.text);
      CardType type = CardUtils.getCardTypeFrmNumber(cardNum);
      if (type != cardType) {
        setState(() {
          cardType = type;
        });
      }
    }
  }

  @override
  void initState() {
    cardNumberController.addListener(() {
      getCardTypeFrmNum();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => DashBoard()),
                  (route) => false);
        }, icon:Icon(Icons.arrow_back)),
        actions: [
          IconButton(
              onPressed: () async => await UserModel().signOut(context),
              icon: const Icon(Icons.logout))
        ],
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text("Card Details",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 100),
        child: Column(
          children: [
            Form(
              child: Column(
                children: [
                  //card number
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TextFormField(
                      controller: cardNumberController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(19),
                        CardNumberInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        hintText: "Card Number",
                        //show card type logo
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CardUtils.getCardIcon(cardType),
                        ),
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: SvgPicture.asset("assets/icons/card.svg"),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: "Full Name",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: SvgPicture.asset("assets/icons/user.svg"),
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          //limit input
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          decoration: InputDecoration(
                              hintText: "CVV",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: SvgPicture.asset("assets/icons/Cvv.svg"),
                              )),
                        )),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          //limit input
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(5),
                            CardMonthInputFormatter(),
                          ],
                          decoration: InputDecoration(
                              hintText: "MM/YY",
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child:
                                    SvgPicture.asset("assets/icons/calender.svg"),
                              )),
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  onPressed: () async {
                    await UserModel().updateUser(
                        userID: _firebaseAuth.currentUser!.uid,
                        key: 'proaccount',
                        data: "true");
                    await UserModel().updateUser(
                        userID: _firebaseAuth.currentUser!.uid,
                        key: 'creditcardno',
                        data: cardNumberController.text);
                    NotificationService().pushNotification(
                        'Credit Card Details Added Successfully.');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashBoard()),
                            (route) => false);
                    displayToastMessage("Successfull!", context);
                  },
                  child: Text("Add Card",style: TextStyle(color: Colors.white,),),),
            ),
          ],
        ),
      ),
    );
  }
}
