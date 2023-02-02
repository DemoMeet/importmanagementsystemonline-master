
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dashboard.dart';
import 'offline_transac_create_screen.dart';

class OfflineTransacScreen extends StatefulWidget {
  const OfflineTransacScreen({Key? key}) : super(key: key);

  @override
  _OfflineTransacScreenState createState() => _OfflineTransacScreenState();
}

class _OfflineTransacScreenState extends State<OfflineTransacScreen> {

  DateTime? _date;
  bool? _process;
  int? _count;

  final TextEditingController searchController = TextEditingController();
  bool search = false;
  final TextEditingController yearSearchController = TextEditingController();
  bool yearSearch = false;

  @override
  void initState() {

    super.initState();
    _process = false;
    _count = 1;
  }

  Widget _getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22),
      backgroundColor: Colors.blue,
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.blue,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OfflineTransacCreateScreen()));
            },
            label: 'Add Data',
            labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: Colors.blue),
        // FAB 2
        // SpeedDialChild(
        //     child: Icon(
        //       Icons.picture_as_pdf_outlined,
        //       color: Colors.white,
        //     ),
        //     backgroundColor: Colors.blue,
        //     onTap: () {
        //       setState(() {
        //         generatePdf();
        //       });
        //     },
        //     label: 'Generated PDF',
        //     labelStyle: TextStyle(
        //         fontWeight: FontWeight.w500,
        //         color: Colors.white,
        //         fontSize: 16.0),
        //     labelBackgroundColor: Colors.blue)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Offline Transaction List'),
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
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Available Stock : $_totalStock Ton",
          //         style: TextStyle(color: Colors.red, fontSize: 18),
          //       ),
          //
          //       nameSearchField,
          //       yearSearchField,
          //       Text(
          //         "Total Sale : $_totalAmount TK",
          //         style: TextStyle(color: Colors.red, fontSize: 18),
          //       ),
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(20.0),
          //   child: Row(
          //     children: [
          //       pickDate,
          //       SizedBox(
          //         width: 20,
          //       ),
          //       addButton,
          //     ],
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Divider(),
          // ),
          const SizedBox(height: 20,),
          Expanded(child: (search) ? _searchBuilder() : (yearSearch)? _yearSearchBuilder() : _buildListView()),
        ],
      ),
      floatingActionButton: _getFAB(),
    );
  }


  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection("offline_transaction");

  Widget _yearSearchBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.orderBy("date", descending: true).snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) =>element["lc"].toString().toLowerCase() == "sale" &&
                    element["year"].contains(yearSearchController.text))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget _searchBuilder() {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.orderBy("date", descending: true).snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .where((QueryDocumentSnapshot<Object?> element) => element["lc"].toString().toLowerCase() == "sale" &&
                    element["supplierName"].toString().toLowerCase().contains(searchController.text))
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget _buildListView() {
    return StreamBuilder<QuerySnapshot>(
        stream: _collectionReference.orderBy("date", descending: true).snapshots().asBroadcastStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              children: [
                ...snapshot.data!.docs
                    .map((QueryDocumentSnapshot<Object?> data) {
                  return buildSingleItem(data);
                })
              ],
            );
          }
        });
  }

  Widget buildSingleItem( coal) => Container(
    padding: const EdgeInsets.all(15),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                SizedBox(
                  width: 70,
                ),
                Text(
                  "Date",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["date"].toDate().toString().substring(0,9),
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Product",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["Product"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "BDT",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["BDT"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                const Text(
                  "INR",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["INR"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              width: 70,
            ),
            Column(
              children: [
                const Text(
                  "RATE",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["Rate"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              width: 70,
            ),
            Column(
              children: [
                const Text(
                  "Payment",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["Payment"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Company Name",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["Company Name"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            Column(
              children: [
                Text(
                  "Company Contact",
                  style: TextStyle(color: Colors.blue, fontSize: 20),
                ),
                Text(
                  coal["Company Contact"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ],
            ),
            SizedBox(
              width: 70,
            ),
            // IconButton(
            //   onPressed: () {
            //     FirebaseFirestore.instance
            //         .collection('coals')
            //         .get()
            //         .then((QuerySnapshot querySnapshot) {
            //       for (var doc in querySnapshot.docs) {
            //         if(doc["invoice"] == coal["invoice"] && doc["lc"] == "sale"){
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => CoalSaleUpdateScreen(
            //                     coalModel: coal,
            //                   )));
            //         }
            //       }
            //     });
            //   },
            //   icon: Icon(
            //     Icons.edit,
            //     color: Colors.red,
            //   ),
            // ),
            IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('offline_transaction').doc(coal.id).delete()
                    .then((val){
                  setState(() {});
                });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    ),
  );

}
