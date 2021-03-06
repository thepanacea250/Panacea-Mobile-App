import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:panacea/pages/addDependent.dart';
import 'package:panacea/pages/search_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependentScreen extends StatefulWidget {
  const DependentScreen({Key? key}) : super(key: key);

  @override
  State<DependentScreen> createState() => _DependentScreenState();
}

class _DependentScreenState extends State<DependentScreen> {
  bool isLoading = true;
  String? uid;
  String? phonep;
  getData() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid").toString();
      phonep = prefs.getString("phone").toString();
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    String collection = 'dependant';
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xffE4E3F0),
        centerTitle: true,
        title: Text(
          'ADD DEPENDENT',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.notifications_rounded,
                color: Colors.black,
              ),
            ),
          ),
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Image.asset('images/parson.png'),
            ),
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: screenHeight,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  HexColor("#E8EAEF"),
                  HexColor("#E8E7EE"),
                  HexColor("#E8EAEF"),
                ],
              )),
              child: ListView(
                children: [
                  Container(
                    height: 60.0,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: screenHeight * .065,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  border: Border.all(
                                      color: HexColor("#9D0208").withOpacity(0),
                                      width: 1.0),
                                  color: Colors.white),
                              child: Center(
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        Icons.search,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        print("your menu action here");
                                      },
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return SearchPage();
                                              }));
                                              print("ddd");
                                            },
                                            child: Text(
                                              "Search hospitals, pharmacy..",
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            style: ButtonStyle(
                                              alignment: Alignment.centerLeft,
                                              shape: MaterialStateProperty.all(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0))),
                                            )
                                            // decoration: InputDecoration(
                                            //   hintText: "Search",
                                            //   border: OutlineInputBorder(
                                            //       borderRadius: BorderRadius.all(
                                            //           Radius.circular(50))),
                                            // ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(6),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("My Dependants",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Container(
                                child: DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.0),
                                  color: Color.fromARGB(255, 195, 193, 215)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return AddDependant();
                                    }));
                                  },
                                  child: Text(
                                    "Add dependent",
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 12),
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                        Container(
                          height: screenHeight / 1.5,
                          // width: 120,
                          child: StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection(collection)
                                  .where('usersId', isEqualTo: uid)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text("errror");
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (snapshot.data!.size == 0) {
                                  return Center(child: Text("Empty"));
                                }
                                return GridView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: Column(
                                        children: [
                                          Image.asset("images/lydia.jpg"),
                                          Text(snapshot.data!.docs[index]
                                              ['names'])
                                        ],
                                      ),
                                    );
                                  },
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10,
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
