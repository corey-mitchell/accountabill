import 'package:accountabill/data/models/card_account.dart';
import 'package:accountabill/data/models/charity.dart';
import 'package:accountabill/pages/charity_search.dart';
import 'package:accountabill/widgets/page_container.dart';
import 'package:flutter/material.dart';

/// User settings page
///
/// 🚧 Currently under construction 🚧
///
/// This is where the user will be able to see and
/// edit their selected charity, payment instrument and
/// any additional settings.
class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final Map<String, CardAccount> accounts = {
    '0': CardAccount(isDefault: true),
    '1': CardAccount(),
    '2': CardAccount(isExpired: true),
  }; // TODO: Get real accounts list
  Charity? charity = Charity(
    name: "American Cancer Society",
    amountDonated: 25,
  ); // TODO: Have empty state to remove default starting value

  /// Handle charity selection
  void _handleCharitySelection(BuildContext context) async {
    final charitySelection = await Navigator.push<Charity>(
      context,
      MaterialPageRoute(builder: (_) => CharitySearchPage(charity: charity)),
    );

    // Validate user input
    if (charitySelection == null || charitySelection.name == charity?.name)
      return;

    try {
      setState(() {
        charity = charitySelection;
      });
      // Show success snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text("Charity successfully set")));
    } catch (e) {
      print(e);
      // Show error snackbar
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: const Text("Failed to set charity")));
    }
  }

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
    return PageContainer(
      child: Column(
        spacing: 16,
        children: [_charitiesList(context), _accountsList()],
      ),
    );
  }

  /// Charities list
  Widget _charitiesList(BuildContext context) {
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
          onTap: () => _handleCharitySelection(context),
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
                          charity?.name ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Total donated:", style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(
                    "\$${charity?.amountDonated?.toStringAsFixed(2) ?? '0.00'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
