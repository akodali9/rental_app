import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:rental_app/Auth/provider/user_cubit.dart';
import 'package:rental_app/functions/show_toast.dart';
import 'package:rental_app/global_variables.dart';
import 'package:rental_app/models/user_model.dart';

class AddressListUpdate {
  static Future<bool> updateAddressListOnServer(
    BuildContext context,
    String userId,
    List<AddressModel> newAddressList,
    String token,
  ) async {
    final List<Map<String, dynamic>> addressMaps =
        newAddressList.map((address) => address.toMap()).toList();
    final response = await http.post(
      Uri.parse('$uri/user/$userId/addresses'),
      headers: {
        'Content-Type': 'application/json',
        // 'authorization': token,
      },
      body: jsonEncode({'newAddressList': addressMaps}),
    );

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      if (context.mounted) {
        showToast(context, jsonBody['message']);
        final List<AddressModel> addressList =
            (jsonBody['newAddressList'] as List<dynamic>).map((addressMap) {
          return AddressModel.fromMap(addressMap);
        }).toList();

        final userCubit = context.read<UserCubit>();
        userCubit.updateAddressListForUser(addressList);
      }
      return true;
    } else {
      return false;
    }
  }
}
