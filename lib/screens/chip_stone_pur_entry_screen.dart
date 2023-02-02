import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:intl/intl.dart';

import '../flutter_dropdown_search.dart';
import '../model/company.dart';
import '../model/csale.dart';
import 'chip_stone_pur_screen.dart';
import 'crusher_sale_s_screen.dart';
import 'crusher_sale_t_screen.dart';
import 'dashboard.dart';

class ChipStonePurEntryScreen extends StatefulWidget {
  const ChipStonePurEntryScreen({Key? key}) : super(key: key);

  @override
  _ChipStonePurEntryScreen createState() => _ChipStonePurEntryScreen();
}

class _ChipStonePurEntryScreen extends State<ChipStonePurEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  double cft_value = 0.0;
  final truckCountEditingController = new TextEditingController();
  final cftEditingController = new TextEditingController();
  final rateEditingController = new TextEditingController();
  final threeToFourEditingController = new TextEditingController();
  final oneToSixEditingController = new TextEditingController();
  final halfEditingController = new TextEditingController();
  final fiveToTenEditingController = new TextEditingController();
  final remarksEditingController = new TextEditingController();
  final truckNumberEditingController = new TextEditingController();
  TextEditingController _controller = TextEditingController();
  DateTime? _date;
  bool? _process;
  int? _count;
  int _invoice = 1;
  final _portTypes = ['Shutarkandi', 'Tamabil','Bholaganj'];
  String? _chosenPort;

  List<String> _companyNameList = [];
  String? _chosenCompanyName;
  List<String> _companyContactList = [];
  String? _chosenCompanyContact;

  @override
  void initState() {
    super.initState();
    _process = false;
    _count = 1;

    FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if(doc["invoice"] == "1"){
          setState(() {
            _companyNameList.add(doc["name"]);
            _companyContactList.add(doc["contact"]);
          });
        }
      }
    });
  }
  void _setvaluess(var newValue){
    FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["invoice"] == "1" && doc["name"] == newValue) {
          setState(() {
            _chosenCompanyContact = doc["contact"];
            _chosenCompanyName = doc["name"];
          });
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    final pickDate = Container(
      child: Row(
        children: [
          const SizedBox(
            width: 50,
          ),
          Text(
            'Date   :',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(
            width: 25,
          ),
          Material(
            elevation: 5,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
            child: MaterialButton(
              padding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              minWidth: MediaQuery.of(context).size.width / 6,
              onPressed: () {
                showDatePicker(
                  context: context,
                  firstDate: DateTime(1990, 01),
                  lastDate: DateTime(2101),
                  initialDate: _date ?? DateTime.now(),
                ).then((value) {
                  setState(() {
                    _date = value;
                  });
                });
              },
              child: Text(
                (_date == null)
                    ? 'Pick Date'
                    : DateFormat('yyyy-MM-dd').format(_date!),
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );

    final truckNumberField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckNumberEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Truck Plate Number cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckNumberEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Truck Plate Number',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final truckCountField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            cursorColor: Colors.blue,
            autofocus: false,
            controller: truckCountEditingController,
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) {
                return ("No Of Truck cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              truckCountEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'No of Trucks',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final cftField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: Row(
          children: [
            Container(margin: EdgeInsets.only(right: 20),
              width: MediaQuery.of(context).size.width / 5,
              child: TextFormField(
                  cursorColor: Colors.blue,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
                  autofocus: false,
                  controller: cftEditingController,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("CFT cannot be empty!!");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    cftEditingController.text = value!;
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(
                      20,
                      15,
                      20,
                      15,
                    ),
                    labelText: 'CFT',
                    labelStyle: TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  )),
            ),
            Container(
              width: 25,
              child: IconButton(onPressed: (){
                setState(() {
                  cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
                      .toString()) +  double.parse(halfEditingController.text
                      .toString()) +  double.parse(fiveToTenEditingController.text.toString());

                  cftEditingController.text = cft_value.toString();
                });
              }, icon: Icon(Icons.add_circle_outline_sharp, color: Colors.blue,),),
            ),
          ],
        ));

    final rateField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: rateEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Rate cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              rateEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Rate',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final threeToFourField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: threeToFourEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              threeToFourEditingController.text = value!;

            },

            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '3/4',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final oneToSixField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: oneToSixEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              oneToSixEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '16 mm',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final halfField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: halfEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              halfEditingController.text = value!;
            },

            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '1/2',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final fiveToTenField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))],
            autofocus: false,
            controller: fiveToTenEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("Field cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              fiveToTenEditingController.text = value!;
            },

            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: '5/10',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final remarksField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            maxLines: 3,
            cursorColor: Colors.blue,
            autofocus: false,
            controller: remarksEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              remarksEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Remarks',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final addButton = Material(
      elevation: (_process!) ? 0 : 5,
      color: (_process!) ? Colors.blue.shade800 : Colors.blue,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(
          150,
          35,
          150,
          35,
        ),
        minWidth: 20,
        onPressed: () {
          setState(() {
            _process = true;
            _count = (_count! - 1);
          });
          (_count! < 0)
              ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red, content: Text("Wait Please!!")))
              : AddData();
        },
        child: (_process!)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Processing',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Center(
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ))),
                ],
              )
            : Text(
                'Add Chip Stone Purchase',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
      ),
    );

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final portDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _portTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select Port',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenPort,
            onChanged: (newValue) {
              setState(() {
                _chosenPort = newValue;
              });
            }));

    DropdownMenuItem<String> buildMenuName(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final nameDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        // child: DropdownButtonFormField<String>(
        //     decoration: InputDecoration(
        //       contentPadding: EdgeInsets.fromLTRB(
        //         20,
        //         15,
        //         20,
        //         15,
        //       ),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //       ),
        //       focusedBorder: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10),
        //         borderSide: BorderSide(color: Colors.blue),
        //       ),
        //     ),
        //     items: _companyNameList.map(buildMenuName).toList(),
        //     hint: Text(
        //       'Select Client/Supplier',
        //       style: TextStyle(color: Colors.blue),
        //     ),
        //     value: _chosenCompanyName,
        //     onChanged: (newValue) {
        //       setState(() {
        //         _chosenCompanyName = newValue;
        //
        //         FirebaseFirestore.instance
        //             .collection('companies')
        //             .get()
        //             .then((QuerySnapshot querySnapshot) {
        //           for (var doc in querySnapshot.docs) {
        //             if(doc["invoice"] == "1" && doc["name"] == newValue ){
        //               setState(() {
        //                 _chosenCompanyContact = doc["contact"];
        //               });
        //             }
        //           }
        //         });
        //
        //       });
        //     }),

      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.blue,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FlutterDropdownSearch(
          textController: _controller,
          items: _companyNameList,
          dropdownHeight: 300,
          setvaluess: _setvaluess,
        ),
      ),
    );

    DropdownMenuItem<String> buildMenuContact(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final contactDropdown = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            ),
            items: _companyContactList.map(buildMenuContact).toList(),
            hint: Text(
              'Select Client/Supplier',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenCompanyContact,
            onChanged: (newValue) {
              setState(() {
                _chosenCompanyContact = newValue;

                FirebaseFirestore.instance
                    .collection('companies')
                    .get()
                    .then((QuerySnapshot querySnapshot) {
                  for (var doc in querySnapshot.docs) {
                    if(doc["invoice"] == "1" && doc["contact"] == newValue ){
                     setState(() {
                       _chosenCompanyName = doc["name"];
                     });
                    }
                  }
                });
              });
            }));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Chip Stone Purchase'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Text(
                "Dashboard",
                style: TextStyle(
                    color: Colors.white
                ),
              )
          )
        ],
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    pickDate,
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        truckCountField,
                        truckNumberField,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [cftField, rateField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [threeToFourField, oneToSixField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [halfField, fiveToTenField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [nameDropdown, contactDropdown],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    portDropdown,
                    SizedBox(
                      height: 20,
                    ),
                    remarksField,
                    SizedBox(
                      height: 20,
                    ),
                    addButton,
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void AddData() async {
    if (_formKey.currentState!.validate() && _date != null) {
      final ref = FirebaseFirestore.instance.collection("cPurchase").doc();
      final _price = (double.parse(cftEditingController.text) *
          double.parse(rateEditingController.text)).floor()
          .toString();

      if (_chosenPort == "Shutarkandi") {

        FirebaseFirestore.instance
            .collection('cPurchase')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (_invoice <= int.parse(doc["invoice"])) {
              _invoice = int.parse(doc["invoice"]) + 1;
            }
          }
          cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
              .toString()) +  double.parse(halfEditingController.text
              .toString()) +  double.parse(fiveToTenEditingController.text.toString());

          CSale cSaleModel = CSale();
          cSaleModel.invoice = _invoice.toString();
          cSaleModel.date = DateFormat('yyyy-MM-dd').format(_date!);
          cSaleModel.truckCount = truckCountEditingController.text;
          cSaleModel.cft = cft_value.toString();
          cSaleModel.rate = rateEditingController.text;
          cSaleModel.price = _price;
          cSaleModel.threeToFour = threeToFourEditingController.text;
          cSaleModel.oneToSix = oneToSixEditingController.text;
          cSaleModel.half = halfEditingController.text;
          cSaleModel.fiveToTen = fiveToTenEditingController.text;
          cSaleModel.remarks = remarksEditingController.text;
          cSaleModel.port = _chosenPort!;
          cSaleModel.buyerName = _chosenCompanyName!;
          cSaleModel.buyerContact = _chosenCompanyContact!;
          cSaleModel.year = DateFormat('MMM-yyyy').format(_date!);
          cSaleModel.truckNumber = truckNumberEditingController.text;
          cSaleModel.docID = ref.id;
          ref.set(cSaleModel.toMap());
          int _invoiceC = 1;
          FirebaseFirestore.instance
              .collection('companies')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (_invoiceC <= int.parse(doc["invoice"])) {
                _invoiceC = int.parse(doc["invoice"]) + 1;
              }
            }
            final ref2 = FirebaseFirestore.instance.collection("companies").doc();
            Company companyModel = Company();
            companyModel.id = "chipstonepurchaseshutarkandi" + _invoice.toString();
            companyModel.name = _chosenCompanyName!;
            companyModel.contact = _chosenCompanyContact!;
            companyModel.address = "0";
            companyModel.credit = "0";
            companyModel.debit = _price;
            companyModel.remarks = "Chip Stone Purchase Shutarkandi";
            companyModel.invoice = _invoiceC.toString();
            companyModel.paymentTypes = "0";
            companyModel.paymentInfo = "0";
            companyModel.date = DateFormat('yyyy-MM-dd').format(_date!);
            companyModel.year = DateFormat('MMM-yyyy').format(_date!);
            companyModel.docID = ref2.id;
            companyModel.rate = rateEditingController.text;
            cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
                .toString()) +  double.parse(halfEditingController.text
                .toString()) +  double.parse(fiveToTenEditingController.text.toString());

            companyModel.quantity =  cft_value.toString();
            ref2.set(companyModel.toMap());
            setState(() {
              _process = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                backgroundColor: Colors.green, content: Text("Entry Added!!")));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChipStonePurScreen()));
          });
        });




      } else  if(_chosenPort == "Tamabil") {

        FirebaseFirestore.instance
            .collection('cPurchase')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (_invoice <= int.parse(doc["invoice"])) {
              _invoice = int.parse(doc["invoice"]) + 1;
            }
          }
          cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
              .toString()) +  double.parse(halfEditingController.text
              .toString()) +  double.parse(fiveToTenEditingController.text.toString());

          CSale cSaleModel = CSale();
          cSaleModel.invoice = _invoice.toString();
          cSaleModel.date = DateFormat('yyyy-MM-dd').format(_date!);
          cSaleModel.truckCount = truckCountEditingController.text;
          cSaleModel.cft = cft_value.toString();
          cSaleModel.rate = rateEditingController.text;
          cSaleModel.price = _price;
          cSaleModel.threeToFour = threeToFourEditingController.text;
          cSaleModel.oneToSix = oneToSixEditingController.text;
          cSaleModel.half = halfEditingController.text;
          cSaleModel.fiveToTen = fiveToTenEditingController.text;
          cSaleModel.remarks = remarksEditingController.text;
          cSaleModel.port = _chosenPort!;
          cSaleModel.buyerName = _chosenCompanyName!;
          cSaleModel.buyerContact = _chosenCompanyContact!;
          cSaleModel.year = DateFormat('MMM-yyyy').format(_date!);
          cSaleModel.truckNumber = truckNumberEditingController.text;
          cSaleModel.docID = ref.id;
          ref.set(cSaleModel.toMap());
          int _invoiceC = 1;
          FirebaseFirestore.instance
              .collection('companies')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (doc["name"] == _chosenCompanyName) {
                if (_invoiceC <= int.parse(doc["invoice"])) {
                  _invoiceC = int.parse(doc["invoice"]) + 1;
                }
              }
            }        cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
                .toString()) +  double.parse(halfEditingController.text
                .toString()) +  double.parse(fiveToTenEditingController.text.toString());

            final ref2 = FirebaseFirestore.instance.collection("companies").doc();
            Company companyModel = Company();
            companyModel.id = "chipstonepurchasetamabil" + _invoice.toString();
            companyModel.name = _chosenCompanyName!;
            companyModel.contact = _chosenCompanyContact!;
            companyModel.address = "0";
            companyModel.credit = "0";
            companyModel.debit = _price;
            companyModel.remarks = "Chip Stone Purchase Tamabil : " +  cft_value.toString() + " CFT";
            companyModel.invoice = _invoiceC.toString();
            companyModel.paymentTypes = "0";
            companyModel.paymentInfo = "0";
            companyModel.date = DateFormat('yyyy-MM-dd').format(_date!);
            companyModel.year = DateFormat('MMM-yyyy').format(_date!);
            companyModel.docID = ref2.id;
            companyModel.rate = rateEditingController.text;

            companyModel.quantity =  cft_value.toString();
            ref2.set(companyModel.toMap());
            setState(() {
              _process = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green, content: Text("Entry Added!!")));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChipStonePurScreen()));
          });
        });

      } else  if(_chosenPort == "Bholaganj") {

        FirebaseFirestore.instance
            .collection('cPurchase')
            .get()
            .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (_invoice <= int.parse(doc["invoice"])) {
              _invoice = int.parse(doc["invoice"]) + 1;
            }
          }
          cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
              .toString()) +  double.parse(halfEditingController.text
              .toString()) +  double.parse(fiveToTenEditingController.text.toString());

          CSale cSaleModel = CSale();
          cSaleModel.invoice = _invoice.toString();
          cSaleModel.date = DateFormat('yyyy-MM-dd').format(_date!);
          cSaleModel.truckCount = truckCountEditingController.text;
          cSaleModel.cft = cft_value.toString();
          cSaleModel.rate = rateEditingController.text;
          cSaleModel.price = _price;
          cSaleModel.threeToFour = threeToFourEditingController.text;
          cSaleModel.oneToSix = oneToSixEditingController.text;
          cSaleModel.half = halfEditingController.text;
          cSaleModel.fiveToTen = fiveToTenEditingController.text;
          cSaleModel.remarks = remarksEditingController.text;
          cSaleModel.port = _chosenPort!;
          cSaleModel.buyerName = _chosenCompanyName!;
          cSaleModel.buyerContact = _chosenCompanyContact!;
          cSaleModel.year = DateFormat('MMM-yyyy').format(_date!);
          cSaleModel.truckNumber = truckNumberEditingController.text;
          cSaleModel.docID = ref.id;
          ref.set(cSaleModel.toMap());
          int _invoiceC = 1;
          FirebaseFirestore.instance
              .collection('companies')
              .get()
              .then((QuerySnapshot querySnapshot) {
            for (var doc in querySnapshot.docs) {
              if (doc["name"] == _chosenCompanyName) {
                if (_invoiceC <= int.parse(doc["invoice"])) {
                  _invoiceC = int.parse(doc["invoice"]) + 1;
                }
              }
            }        cft_value = double.parse(threeToFourEditingController.text.toString()) +  double.parse(oneToSixEditingController.text
                .toString()) +  double.parse(halfEditingController.text
                .toString()) +  double.parse(fiveToTenEditingController.text.toString());

            final ref2 = FirebaseFirestore.instance.collection("companies").doc();
            Company companyModel = Company();
            companyModel.id = "chipstonepurchasebholaganj" + _invoice.toString();
            companyModel.name = _chosenCompanyName!;
            companyModel.contact = _chosenCompanyContact!;
            companyModel.address = "0";
            companyModel.credit = "0";
            companyModel.debit = _price;
            companyModel.remarks = "Chip Stone Purchase Bholaganj : " +  cft_value.toString() + " CFT";
            companyModel.invoice = _invoiceC.toString();
            companyModel.paymentTypes = "0";
            companyModel.paymentInfo = "0";
            companyModel.date = DateFormat('yyyy-MM-dd').format(_date!);
            companyModel.year = DateFormat('MMM-yyyy').format(_date!);
            companyModel.docID = ref2.id;
            companyModel.rate = rateEditingController.text;

            companyModel.quantity =  cft_value.toString();
            ref2.set(companyModel.toMap());
            setState(() {
              _process = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.green, content: Text("Entry Added!!")));
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => ChipStonePurScreen()));
          });
        });

      }
    }else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
