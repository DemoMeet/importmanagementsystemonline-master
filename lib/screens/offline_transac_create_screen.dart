import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../flutter_dropdown_search.dart';
import '../model/coal.dart';
import '../model/company.dart';
import 'coal_sale_screen.dart';
import 'dashboard.dart';
import 'offline_transac_screen.dart';

class OfflineTransacCreateScreen extends StatefulWidget {
  const OfflineTransacCreateScreen({Key? key}) : super(key: key);

  @override
  _OfflineTransacCreateScreenState createState() =>
      _OfflineTransacCreateScreenState();
}

class _OfflineTransacCreateScreenState
    extends State<OfflineTransacCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final bdtEditingController = TextEditingController();
  final rateEditingController = TextEditingController();
  final purposeEditingController = TextEditingController();
  final thirdpartyEditingController = TextEditingController();
  final contactController = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  DateTime? _date;
  final _paymentTypes = ['Cash', 'Bank'];
  final _productTypes = ['Stone', 'Coal'];
  String? _chosenPayment, _chosenProduct;
  bool? _process;
  int? _count;

  List<String> _companyNameList = [];
  String? _chosenCompanyName;
  List<String> _companyContactList = [];

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
        if (doc["invoice"] == "1") {
          setState(() {
            _companyNameList.add(doc["name"]);
            _companyContactList.add(doc["contact"]);
          });
        }
      }
      print(_companyNameList);
    });
  }

  void _setvaluess(var newValue) {
    FirebaseFirestore.instance
        .collection('companies')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        if (doc["invoice"] == "1" && doc["name"] == newValue) {
          setState(() {
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


          SizedBox(
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

    final bdtField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
            autofocus: false,
            controller: bdtEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value!.isEmpty) {
                return ("BDT cannot be empty!!");
              }
              return null;
            },
            onSaved: (value) {
              bdtEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'BDT',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final rateField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
            ],
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
              contentPadding: const EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Rate (INR to BDT)',
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
        padding: const EdgeInsets.fromLTRB(
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
              ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red, content: Text("Wait Please!!")))
              : AddData();
        },
        child: (_process!)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
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
                'Add New Entry',
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

    final paymentDropdown = Container(
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
            items: _paymentTypes.map(buildMenuItem).toList(),
            hint: Text(
              'Select Payment',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenPayment,
            onChanged: (newValue) {
              setState(() {
                _chosenPayment = newValue;
              });
            }));



    DropdownMenuItem<String> buildproductItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(color: Colors.blue),
        ));

    final productDropdown = Container(
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
            items: _productTypes.map(buildproductItem).toList(),
            hint: Text(
              'Select Product',
              style: TextStyle(color: Colors.blue),
            ),
            value: _chosenProduct,
            onChanged: (newValue) {
              setState(() {
                _chosenProduct = newValue;
              });
            }));


    final thirdpartyField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: thirdpartyEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              thirdpartyEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Third party',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));

    final contactField = Container(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: contactController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              contactController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Contact',
              labelStyle: const TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            )));
    final purposeField = SizedBox(
        width: MediaQuery.of(context).size.width / 4,
        child: TextFormField(
            cursorColor: Colors.blue,
            autofocus: false,
            controller: purposeEditingController,
            keyboardType: TextInputType.name,
            validator: (value) {
              return null;
            },
            onSaved: (value) {
              purposeEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(
                20,
                15,
                20,
                15,
              ),
              labelText: 'Purpose',
              labelStyle: TextStyle(color: Colors.blue),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.blue),
              ),
            )));
    final nameDropdown = Container(
      width: MediaQuery.of(context).size.width / 4,
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add New Offline Transaction'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dashboard()));
              },
              child: Text(
                "Dashboard",
                style: TextStyle(color: Colors.white),
              ))
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
                    const Text(
                      'This offline transaction is no where connected with any other feature of this website!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const Text(
                      'Either Third Party or Clients will be save.. Client is Prioritized',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        pickDate,
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [bdtField, rateField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [paymentDropdown, purposeField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [productDropdown, thirdpartyField],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [nameDropdown, contactField],
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
    if (_formKey.currentState!.validate() &&
        _chosenPayment != null && _chosenProduct != null && _date != null && bdtEditingController.text.isNotEmpty && rateEditingController.text.isNotEmpty
       ) {
      if( _chosenCompanyName != null){

        final ref = FirebaseFirestore.instance.collection("offline_transaction");
        final _inr = (double.parse(bdtEditingController.text) *
            double.parse(rateEditingController.text)).floor()
            .toString();
        ref.add({"Payment": _chosenPayment, "Product":_chosenProduct, "date": _date, "BDT" : bdtEditingController.text, "Rate": rateEditingController.text, "INR": _inr, "Company Name":_chosenCompanyName, "Company Contact": contactController.text});
        setState(() {
          _process = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text("Entry Added!!")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OfflineTransacScreen()));

      }else if( thirdpartyEditingController.text.isNotEmpty){

        final ref = FirebaseFirestore.instance.collection("offline_transaction");
        final _inr = (double.parse(bdtEditingController.text) *
            double.parse(rateEditingController.text)).floor()
            .toString();
        ref.add({"Payment": _chosenPayment, "Product":_chosenProduct, "date": _date, "BDT" : bdtEditingController.text, "Rate": rateEditingController.text, "INR": _inr, "Company Name":thirdpartyEditingController.text, "Company Contact":  contactController.text});
        setState(() {
          _process = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green, content: Text("Entry Added!!")));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => OfflineTransacScreen()));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red, content: Text("Something Wrong!!")));
        setState(() {
          _process = false;
          _count = 1;
        });
      }

    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red, content: Text("Something Wrong!!")));
      setState(() {
        _process = false;
        _count = 1;
      });
    }
  }
}
