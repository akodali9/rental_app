import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_app/Auth/provider/token_cubit.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/Components/address_form.dart';
import 'package:rental_app/models/user_model.dart';
import 'package:rental_app/update/user_address_list_update.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Page"),
        centerTitle: true,
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserInitialState) {
            return const LinearProgressIndicator();
          } else if (state is UserLoadedState) {
            UserModel user = state.user;
            return user.addressList.isNotEmpty
                ? CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          AddressModel address = user.addressList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                'Name: ${address.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Contact No: ${address.contactNo}'),
                                  Text('Street: ${address.street}'),
                                  Text('City: ${address.city}'),
                                  Text('State: ${address.state}'),
                                  Text('Postal Code: ${address.postalCode}'),
                                  Text('Country: ${address.country}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      showModalBottomSheet(
                                        showDragHandle: true,
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) => AddressForm(
                                          initialAddress: address,
                                          isEditing: true,
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () async {
                                      user.removeAddress(address);
                                      String token = (context
                                              .read<UserTokenCubit>()
                                              .state as UserTokenLoadedState)
                                          .token;
                                      await AddressListUpdate
                                          .updateAddressListOnServer(
                                              context,
                                              user.userId,
                                              user.addressList,
                                              token);
                                    },
                                  ),
                                ],
                              ),
                              // Add more details or customize the ListTile as needed
                            ),
                          );
                        }, childCount: user.addressList.length),
                      ),
                    ],
                  )
                : const Center(
                    child: Text(
                      'You can add your address by clicking on the button below ;)',
                      textAlign: TextAlign.center,
                    ),
                  );
          } else {
            return const Center(
              child: Text('Unknown state'),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: const ButtonStyle(
              fixedSize: MaterialStatePropertyAll(
                Size(20, 50),
              ),
              elevation: MaterialStatePropertyAll(10),
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ),
            child: const Text(
              "Add new address",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () {
              showModalBottomSheet(
                showDragHandle: true,
                isScrollControlled: true,
                context: context,
                builder: (context) => const AddressForm(),
              );
            },
          ),
        ),
      ),
    );
  }
}
