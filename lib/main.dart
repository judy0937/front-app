import 'package:flutter/material.dart';
import 'package:test2/purches/add_purches_screen.dart';

import 'ChooseRoleScreen/ChooseRoleScreen.dart';
import 'bills/invoice_screen.dart';
import 'inventory/inventory_screen.dart';
import 'medicine/drug_suggestions_screen.dart';
import 'medicine/addnewmedicineScreen.dart';
import 'add_supplier/addsuplierScreen.dart';
import 'companies/comany_screen.dart';
import 'homepage/homepage.dart';
import 'login/loginScreen.dart';
import 'medicine/new_medicine_order.dart';
import 'medicine/selling_medicine.dart';
import 'medicine/viewmedicine.dart';
import 'onBoarding/introPage.dart';
import 'onBoarding/on_boarding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',

      home: PharmacyDashboard(),
      /*SellMedicineScreen(medicineName: "Paracetamol",
        unitPrice: 3.5,
        stock: 120, onSellComplete: (int soldQuantity) {  },),*/
    );
  }
}

