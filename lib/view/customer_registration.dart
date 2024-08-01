import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modal/customer_modal.dart';
import '../view_modal/form_validation.dart';
import '../view_modal/postcode_details_vm.dart';
import '../view_modal/validatepan_vm.dart';
import 'common_widgets/custom_textstyle.dart';
import 'common_widgets/custom_widgets.dart';
import 'customer_details_view.dart';

class CustomerRegistration extends StatefulWidget {
   int? index;
   bool? isUpdate;
  CustomerRegistration({super.key, this.index,this.isUpdate});
  @override
  State<CustomerRegistration> createState() => _CustomerRegistrationState();
}

class _CustomerRegistrationState extends State<CustomerRegistration> {
  ///TextEditing Controllers for the TextFormField
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNoController = TextEditingController();
  final TextEditingController _addressLine1 = TextEditingController();
  final TextEditingController _addressLine2 = TextEditingController();
  final TextEditingController _postCode = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _city = TextEditingController();

  ///Global Form key for form validation
  final _formKey = GlobalKey<FormState>();

  ///PAN AutoValidation through API
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  void _validateAndSubmitPan() {
    String panNumber = _panController.text;
    if (validatePanNumber(panNumber) == null && panNumber.length == 10 ) {
      Provider.of<ValidatePanVm>(context,listen: false).verifyPAN(context, _panController.text,
          (fullName){
           _nameController.text = fullName;
          });

    }
  }

  ///get Post Code Details through API
   void _postDetails()async{
    String postCode = _postCode.text;
    if(validatePostCode(postCode) == null && postCode.length == 6 ){
      Provider.of<PostcodeDetailsVm>(context,listen: false).getPostDetails(context, int.parse(postCode),
          (city,state){
          _city.text = city ;
          _state.text = state;
          }
      );

    }
  }

  ///List to Store Customer Details
  List<CustomerModal> customers = [];

  ///Save customer in local Storage
  Future<void> _saveCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final String customersString = jsonEncode(customers.map((customer) => customer.toJson()).toList());
    await prefs.setString('customers', customersString);
  }


  ///Validate Form ,Adding customer to the list and update customer
  void addCustomer() {
    if (_formKey.currentState!.validate()) {
      final newCustomer = CustomerModal(
        pan: _panController.text,
        name: _nameController.text,
        email: _emailController.text,
        mobile: _mobileNoController.text,
        addressLine1: _addressLine1.text,
        addressLine2: _addressLine2.text,
        postCode: _postCode.text,
        state: _state.text,
        city: _city.text,
      );

      if (widget.isUpdate == true) {
        if (widget.index != null && widget.index! >= 0 && widget.index! < customers.length) {
          customers[widget.index!] = newCustomer; // Update existing customer
        }
      } else {
        customers.add(newCustomer); // Add new customer
      }

      _saveCustomers();
      setState(() {});
      clearTextFields();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const CustomerDetailsView(),
        ),
            (Route<dynamic> route) => false,
      ).then((_) => _loadCustomers());
    }
  }
  ///Loading existing customer from list
  Future<void> _loadCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? customersString = prefs.getString('customers');
    if (customersString != null) {
      final List<dynamic> customersJson = jsonDecode(customersString);
      customers = customersJson.map((json) => CustomerModal.fromJson(json)).toList();
      setState(() {});
    }
  }

  ///Update data
  void _loadCustomerData(int index) {
    if (index >= 0 && index < customers.length) {
      final customer = customers[index];
      _panController.text = customer.pan!;
      _nameController.text = customer.name!;
      _emailController.text = customer.email!;
      _mobileNoController.text = customer.mobile!;
      _addressLine1.text = customer.addressLine1!;
      _addressLine2.text = customer.addressLine2!;
      _postCode.text = customer.postCode!;
      _state.text = customer.state!;
      _city.text = customer.city!;
    }
  }

///Clear TextFields
  void clearTextFields() {
    _panController.clear();
    _nameController.clear();
    _emailController.clear();
    _mobileNoController.clear();
    _addressLine1.clear();
    _addressLine2.clear();
    _postCode.clear();
    _state.clear();
    _city.clear();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    ///Listener For PAN AutoValidation and PostCode
    _panController.addListener(_validateAndSubmitPan);
    _postCode.addListener(_postDetails);
    ///to load existing customer details
    _loadCustomers().then((_) {
      if (widget.index != null) {
        _loadCustomerData(widget.index!);
      }
    });

  }

  @override
  void dispose(){
    super.dispose();
    _panController.removeListener(_validateAndSubmitPan);
    _panController.removeListener(_postDetails);

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final panVerifyProvider = Provider.of<ValidatePanVm>(context);
    final postDetailsProvider = Provider.of<PostcodeDetailsVm>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar:AppBar(

        title: Text(widget.isUpdate == true? "Update Details" :'Registration',style: const TextStyle(color: Colors.white),),
        leading: widget.isUpdate == true?  IconButton(onPressed: (){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>  const CustomerDetailsView(),
            ),
                (Route<dynamic> route) => false,
          );
        },
          icon: const Icon(Icons.arrow_back_outlined,color: Colors.white,),
        ):const SizedBox.shrink(),
        actions: [
          widget.isUpdate == true?const SizedBox.shrink():MaterialButton(
              child: const Text("View Details",style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerDetailsView(),
                  ),
                ).then((_) => _loadCustomers());
              })
        ],
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
            height: MediaQuery.of(context).size.height/4,
            decoration:  const BoxDecoration(
                gradient:  LinearGradient(
                    colors: [Color(0xFF3820F0), Color(0xFF5A4FCF), Color(0xFF8981DD),Color(0xFFB8B3EA)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25) )),

          ),
          Padding(
              padding:  EdgeInsets.only(
               top: height/50,
               left: width/30,
               right: width/30,
              bottom: height/80),
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
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();  // Dismisses the keyboard
                },
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width /25),
                    child: ListView(
                      children: [
                        SizedBox(height: height/120,),
                        commonLabel(context, " PAN Number"),
                        SizedBox(height: height/120,),
                        ///PAN TextField
                        TextFormField(
                          controller: _panController,
                          keyboardType: TextInputType.text,
                          validator: validatePanNumber,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                            LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (value){
                            if(value.length == 10){
                              setState(() {
                                _autoValidateMode = AutovalidateMode.always;
                              });
                            }
                            _nameController.text ="";
                          },
                          autovalidateMode: _autoValidateMode,
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: MediaQuery.of(context).size.width / 70),
                            filled: true,
                            fillColor: const Color(0xFFF2F2F2),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon:panVerifyProvider.isLoading ? Container(
                              padding: const EdgeInsets.all(12.0),
                              width: 24,
                              height: 24,
                              child: const CircularProgressIndicator(strokeWidth: 2.0),
                            ):null ,
                            hintText: "Enter PAN Number",
                            hintStyle: CustomTextStyle.hintTextStyle(context)
                          ),

                        ),
                        SizedBox(height: height/90,),
                        commonLabel(context, " Full Name "),
                        SizedBox(height: height/120,),
                        ///Full Name TextField
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.text,
                          validator: validateFullName,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z ]')),
                            LengthLimitingTextInputFormatter(140),
                          ],
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: width / 70),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Full Name",
                              hintStyle: CustomTextStyle.hintTextStyle(context)),
                          textCapitalization: TextCapitalization.words,
                        ),
                        SizedBox(height: height/80,),
                        commonLabel(context, " Email Address "),
                        SizedBox(height: height/120,),
                        ///Email Address TextField
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.text,
                          validator: validateEmail,
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width / 70),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Email Address",
                              hintStyle: CustomTextStyle.hintTextStyle(context)),
                        ),
                        SizedBox(height: height/80,),
                        commonLabel(context, " Mobile Number "),
                        SizedBox(height: height/120,),
                        ///Mobile No TextField
                        TextFormField(
                          controller: _mobileNoController,
                          keyboardType: TextInputType.number,
                          validator: validateMobileNumber,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 1,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width / 70),
                              prefixIcon: SizedBox(
                                height: height/30,
                                width: width/50,
                                child: Center(
                                  child: Text(
                                    "+91",
                                    style: CustomTextStyle.textFieldTextStyle(context),
                                  ),
                                ),
                              ),

                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Mobile No.",
                              hintStyle: CustomTextStyle.hintTextStyle(context)),
                        ),
                        SizedBox(height: height/80,),
                        commonLabel(context, " Address Line 1 "),
                        SizedBox(height: height/120,),
                        TextFormField(
                          controller: _addressLine1,
                          keyboardType: TextInputType.text,
                          validator: validateAddress,
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 2,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: height/70,
                                  horizontal: width /40),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Address",
                              hintStyle: CustomTextStyle.hintTextStyle(context)),
                        ),
                        SizedBox(height: height/80,),
                        RichText(
                            text: TextSpan(
                                text: " Address Line 2 ",
                                style: CustomTextStyle.labelTextStyle(context),
                                children: const <TextSpan>[
                                  TextSpan(text: "(optional)", style: TextStyle(color: Colors.redAccent,fontSize:13))
                                ])),
                        SizedBox(height: height/120,),
                        TextFormField(
                          controller: _addressLine2,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 2,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: height/70,
                                  horizontal: width /40),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter Address",
                              hintStyle: CustomTextStyle.hintTextStyle(context)),
                        ),
                        SizedBox(height: height/80,),
                        commonLabel(context, " Post Code "),
                        SizedBox(height: height/120,),
                        TextFormField(
                          controller: _postCode,
                          keyboardType: TextInputType.number,
                          validator: validatePostCode,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          cursorColor: Colors.grey,
                          style: CustomTextStyle.textFieldTextStyle(context),
                          maxLines: 1,
                          onChanged: (value){
                            _city.text = "";
                            _state.text = "";
                          },
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: MediaQuery.of(context).size.width / 70),
                              filled: true,
                              fillColor: const Color(0xFFF2F2F2),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            suffixIcon:postDetailsProvider.isLoading ? Container(
                              padding: const EdgeInsets.all(12.0),
                              width: 24,
                              height: 24,
                              child: const CircularProgressIndicator(strokeWidth: 2.0),
                            ):null,
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              hintText: "Enter post code",
                              hintStyle: CustomTextStyle.hintTextStyle(context)),
                        ),
                        SizedBox(height: height/40,),
                        SizedBox(
                          height: height/20,
                          width: width,
                          child: Row(
                            children: [
                              Expanded(
                                flex:2,
                                child: TextFormField(
                                  controller: _state,
                                  cursorColor: Colors.grey,
                                  style: CustomTextStyle.textFieldTextStyle(context),
                                  maxLines: 1,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context).size.width / 70),
                                      filled: true,
                                      fillColor: const Color(0xFFF2F2F2),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    labelText: "    State ",
                                      floatingLabelBehavior: FloatingLabelBehavior.always
                                      )),
                                ),
                              SizedBox(width: width/70,),
                              Expanded(
                                flex:2,
                                child: TextFormField(
                                    controller: _city,
                                    cursorColor: Colors.grey,
                                    style: CustomTextStyle.textFieldTextStyle(context),
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context).size.width / 70),
                                        filled: true,
                                        fillColor: const Color(0xFFF2F2F2),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        labelText: "    City ",
                                        floatingLabelBehavior: FloatingLabelBehavior.always
                                    )),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: height/40,),
                        GestureDetector(
                          onTap: (){
                            addCustomer();
                          },
                            child: Center(child: commonButton(context, widget.isUpdate == true ? "Update":"Add Customer"))),
                        SizedBox(height: height/40,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
