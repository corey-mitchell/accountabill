import 'package:accountabill/data/models/card_account.dart';
import 'package:accountabill/data/models/charity.dart';
import 'package:flutter/material.dart';

/// User settings page
///
/// 🚧 Currently under construction 🚧
///
/// This is where the user will be able to see and
/// edit their selected charity, payment instrument and
/// any additional settings.
class SettingsPage extends StatelessWidget {
  final Map<String, CardAccount> accounts = {
    '0': CardAccount(isDefault: true),
    '1': CardAccount(),
    '2': CardAccount(isExpired: true),
  }; // TODO: Get real accounts list
  final Charity charity = Charity();

  SettingsPage({super.key});

  /// Page scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _buildUI(context));
  }

  /// Page app bar widget
  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text("Settings"),
      centerTitle: true,
    );
  }

  /// Page UI main widget
  Widget _buildUI(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(spacing: 16, children: [_charitiesList(), _accountsList()]),
    );
  }

  /// Charities list
  Widget _charitiesList() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Charity",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        GestureDetector(
          onTap: () {
            print("Select charity");
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 4, bottom: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(),
            ),
            child: Container(
              margin: EdgeInsets.only(left: 16),
              padding: EdgeInsets.only(right: 8),
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "American Cancer Society",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ), // TODO: Replace with true value
                        Text("Total donated:", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    "\$430.00",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ), // TODO: Replace with true value
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Accounts list
  Widget _accountsList() {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 16),
          child: Text(
            "Accounts",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(),
          ),
          child: Column(
            children: [
              ...accounts.entries.map((entry) {
                final CardAccount account = entry.value;
                final isDefault =
                    account.isDefault != null && account.isDefault!;
                final isExpired =
                    account.isExpired != null && account.isExpired!;
                final isLastElement = entry.key == accounts.entries.last.key;
                return GestureDetector(
                  onTap: () {
                    print("Account ${entry.key} pressed");
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 16),
                    padding: EdgeInsets.only(right: 8),
                    height: 60,
                    decoration: !isLastElement
                        ? BoxDecoration(border: Border(bottom: BorderSide()))
                        : null,
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Visa(**** 1234)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ), // TODO: Replace with true value
                        ),
                        if (isDefault || isExpired)
                          Text(
                            isDefault ? "Default" : "Expired",
                            style: isDefault
                                ? TextStyle(fontWeight: FontWeight.bold)
                                : TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.red,
                                  ),
                          ), // TODO: Replace with true value
                        Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        // SizedBox(
        //   width: double.infinity,
        //   height: 36,
        //   child: ElevatedButton(
        //     onPressed: () => print("Add new charity"),
        //     child: Text("Add charity")
        //   )
        // )
      ],
    );
  }
}
