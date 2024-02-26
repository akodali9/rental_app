import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/alertdialog_customactions.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/screens/address/address_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: BlocBuilder<UserCubit, UserState>(builder: (context, state) {
        if (state is UserLoadedState) {
          final user = state.user;
          if (user.userId == 'guestUserId') {
            return Center(
              child: TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Text(
                    'Login/Signup to continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/auth');
                },
              ),
            );
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: SvgPicture.asset(
                          'assets/images/profile-circle.svg',
                          fit: BoxFit.fill),
                    ),
                    Text(
                      'Hello, ${user.name} 😊',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'User type: ${user.isAdmin ? 'Admin' : 'Customer'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.zero,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const AddressPage(),
                          ));
                        },
                        child: const ListTile(
                          leading: Icon(Icons.location_city),
                          title: Text('Saved Address'),
                          trailing: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: const ButtonStyle(
                          shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          )),
                          padding: MaterialStatePropertyAll(
                            EdgeInsets.zero,
                          ),
                        ),
                        child: const ListTile(
                          leading: Icon(Icons.shopping_bag),
                          title: Text('Orders'),
                          trailing: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.red[100]),
                      ),
                      onPressed: () {
                        showAlertDialog(context, "Do you want to Logout?", [
                          "Yes",
                          "No"
                        ], [
                          () {
                            context.read<UserCubit>().removeUser();
                            Navigator.of(context).pop();
                            showToast(context,
                                "You have been Successfully logged out");
                          },
                          () {
                            Navigator.of(context).pop();
                          }
                        ]);
                      },
                      icon: const Text(
                        '  Logout  ',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            );
          }
        } else if (state is UserInitialState) {
          const Center(
            child: CircularProgressIndicator(),
          );
        }

        return const Center(
          child: Text("Internal error"),
        );
      }),
    );
  }
}
