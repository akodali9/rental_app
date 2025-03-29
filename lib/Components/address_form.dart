import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/update/user_address_list_update.dart';

class AddressForm extends StatefulWidget {
  final AddressModel? initialAddress;
  final bool isEditing;

  const AddressForm({
    super.key,
    this.initialAddress,
    this.isEditing = false,
  });

  @override
  AddressFormState createState() => AddressFormState();
}

class AddressFormState extends State<AddressForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final contactNoController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  String selectedState = '';
  List<String> states = [
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  @override
  void initState() {
    super.initState();

    // Set initial values for controllers if editing
    if (widget.isEditing && widget.initialAddress != null) {
      nameController.text = widget.initialAddress!.name;
      contactNoController.text = widget.initialAddress!.contactNo;
      streetController.text = widget.initialAddress!.street;
      cityController.text = widget.initialAddress!.city;
      stateController.text = widget.initialAddress!.state;
      postalCodeController.text = widget.initialAddress!.postalCode;
      selectedState = widget.initialAddress!.state;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: contactNoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Contact Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your contact number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: streetController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Street'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your street';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: cityController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your city';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField<String>(
                onChanged: (value) {
                  setState(() {
                    selectedState = value!;
                  });
                },
                items: states.map((state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'State'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your state';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: postalCodeController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Postal Code'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 20,
                child: ElevatedButton(
                  style: const ButtonStyle(
                      fixedSize: WidgetStatePropertyAll(Size(20, 50)),
                      elevation: WidgetStatePropertyAll(10),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))))),
                  onPressed: () async {
                    final address = AddressModel(
                      name: nameController.text,
                      contactNo: contactNoController.text,
                      street: streetController.text,
                      city: cityController.text,
                      state: selectedState,
                      postalCode: postalCodeController.text,
                      country: 'India',
                    );

                    UserCubit userCubit = context.read<UserCubit>();
                    if (userCubit.state is UserLoadedState) {
                      UserModel user =
                          (userCubit.state as UserLoadedState).user;

                      if (widget.isEditing) {
                        if (widget.initialAddress != null) {
                          int index = user.addressList
                              .indexWhere((a) => a == widget.initialAddress);
                          if (index != -1) {
                            user.addressList[index] = address;
                          }
                        }
                      } else {
                        user.addAddress(address);
                      }
                      String token = (context.read<UserTokenCubit>().state
                              as UserTokenLoadedState)
                          .token;
                      bool status =
                          await AddressListUpdate.updateAddressListOnServer(
                              context, user.userId, user.addressList, token);

                      if (status) {
                        if (context.mounted) Navigator.of(context).pop();
                      }
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
