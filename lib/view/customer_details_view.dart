import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pixel6_assignment/modal/customer_modal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'common_widgets/custom_widgets.dart';
import 'customer_registration.dart';

class CustomerDetailsView extends StatefulWidget {
  const CustomerDetailsView({super.key});

  @override
  State<CustomerDetailsView> createState() => _CustomerDetailsViewState();
}

class _CustomerDetailsViewState extends State<CustomerDetailsView> {
  ///for Storing customer details
  List<CustomerModal> customers = [];

  ///Loading existing customer from list
  Future<void> _loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customersString = prefs.getString('customers');
    if (customersString != null) {
      final List<dynamic> customersJson = jsonDecode(customersString);
      customers =
          customersJson.map((json) => CustomerModal.fromJson(json)).toList();
      setState(() {});
    }
  }

  ///AFTER editing or deleting customer update customer List
  Future<void> _updateCustomerList() async {
    final prefs = await SharedPreferences.getInstance();
    final String customersString =
        jsonEncode(customers.map((e) => e.toJson()).toList());
    await prefs.setString('customers', customersString);
  }

  ///Delete Customer
  void _deleteCustomer(int index) {
    setState(() {
      customers.removeAt(index);
      _updateCustomerList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async{
        return false;
      },
      child: Scaffold(
          backgroundColor: const Color(0xFFF5F6F9),
          appBar: AppBar(
            title: const Text(
              'Customer Details',
              style: TextStyle(color: Colors.white),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            leading: IconButton(onPressed: (){
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>  CustomerRegistration(isUpdate: false,),
                ),
                    (Route<dynamic> route) => false,
              );
            },
              icon: const Icon(Icons.arrow_back_outlined),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3820F0),
                    Color(0xFF5A4FCF),
                    Color(0xFF8981DD),
                    Color(0xFFB8B3EA)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF3820F0),
                      Color(0xFF5A4FCF),
                      Color(0xFF8981DD),
                      Color(0xFFB8B3EA)
                    ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
              ),
              customers.isEmpty
                  ? const Center(child: Text("No customers available"))
                  : Padding(
                      padding: EdgeInsets.only(
                        top: height / 20,
                        left: width / 15,
                        right: width / 15,
                      ),
                      child: ListView.builder(
                        itemCount: customers.length,
                        itemBuilder: (context, index) {
                          final customer = customers[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: height / 50),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade100,
                                      offset: const Offset(0, 0),
                                      blurRadius: 3,
                                      blurStyle: BlurStyle.outer,
                                    )
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: height / 50,
                                    left: width / 30,
                                    right: width / 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonDetailText(
                                        context, "PAN : ", "${customer.pan}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(
                                        context, "Name : ", "${customer.name}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(
                                        context, "Email : ", "${customer.email}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(context, "Mobile No. : ",
                                        "${customer.mobile}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(context, "Address Line 1 : ",
                                        "${customer.addressLine1}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(context, "Address Line 2 : ",
                                        "${customer.addressLine2}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(context, "Post Code : ",
                                        "${customer.postCode}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(
                                        context, "State : ", "${customer.state}"),
                                    SizedBox(height: height / 200),
                                    commonDetailText(
                                        context, "City : ", "${customer.city}"),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit,
                                              color: Colors.blue),
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerRegistration(
                                                        index: index,
                                                        isUpdate: true,
                                                      )),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () => _deleteCustomer(index),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height / 200),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          )),
    );
  }
}
