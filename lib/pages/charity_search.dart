import 'package:accountabill/data/models/charity.dart';
import 'package:accountabill/data/repositories/charity_repository.dart';
import 'package:accountabill/widgets/main_cta.dart';
import 'package:accountabill/widgets/page_container.dart';
import 'package:flutter/material.dart';

/// User charity selection page
///
/// This is where the user will be able to search and
/// select their desired charity.
///
/// In the future, this will show the users more information
/// about the selected charity and allow them to add multiple.
class CharitySearchPage extends StatefulWidget {
  final Charity? charity;

  const CharitySearchPage({super.key, this.charity});

  @override
  State<CharitySearchPage> createState() => _CharitySearchPageState();
}

class _CharitySearchPageState extends State<CharitySearchPage> {
  Map<String, Charity> _filteredCharities = {};
  Charity? selectedCharity;
  bool _focused = false;
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final CharityRepository _repository = CharityRepository();

  @override
  void initState() {
    super.initState();
    _initializeCharities();
    // Monitor focus node for showing/hiding dropdown
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _focused = true;
        });
      } else {
        setState(() {
          _focused = false;
        });
      }
    });
  }

  // Read events from local DB into state
  void _initializeCharities() async {
    try {
      final loadedCharities = await _repository.loadCharities();
      if (loadedCharities.isNotEmpty) {
        setState(() {
          _filteredCharities = loadedCharities;
          selectedCharity = widget.charity;
        });
      } else {
        throw Error();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text("Failed to fetch charities")),
      );
    }
  }

  /// Handle teardown method
  @override
  void dispose() {
    // Dispose of the FocusNode to prevent memory leaks
    _focusNode.dispose();
    super.dispose();
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
      title: Text("Select Charity"),
      centerTitle: true,
    );
  }

  /// Page UI main widget
  Widget _buildUI(BuildContext context) {
    final TextEditingController searchController = TextEditingController(
      text: selectedCharity != null ? selectedCharity?.name : "",
    );
    return PageContainer(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  TextFormField(
                    controller: searchController,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Search',
                    ),
                    validator: (String? value) {
                      return (value == null || value.trim().isEmpty)
                          ? 'Value cannot be empty'
                          : null;
                    },
                  ),
                  if (_focused) _searchResults(),
                ],
              ),
            ),
            MainCTA(
              child: Text("Save"),
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return; // Stop if invalid
                }
                // TODO: Update this to return selected value
                // (Will need to first check if user has history with selected charity)
                Navigator.pop(context, selectedCharity);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Search results
  ///
  /// TODOs:
  ///   Implement loading indicator
  ///   Implement external search
  Widget _searchResults() {
    return Positioned(
      top: 60,
      left: 0,
      right: 0,
      child: Material(
        elevation: 4,
        child: SizedBox(
          height: 200,
          child: ListView(
            shrinkWrap: true,
            children: [
              ..._filteredCharities.entries.map((charity) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCharity = charity.value;
                      _focused = false;
                    });
                  },
                  child: ListTile(title: Text(charity.value.name)),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
