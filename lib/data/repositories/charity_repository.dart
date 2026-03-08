import 'package:accountabill/data/models/charity.dart';
import 'package:firebase_database/firebase_database.dart';

/// Data object for charities
///
/// Keeps track of user selected charity(ies), loads charities into data object on page
/// initialization and handles selecting and removing charities
class CharityRepository {
  /// Method for handling initial loading of charities
  ///
  /// Will return the first 100 entries, the rest will be grabbed through search.
  ///
  /// @returns Map<String, Charity>
  Future<Map<String, Charity>> loadCharities() async {
    // Get universal charity data
    FirebaseDatabase database = FirebaseDatabase.instance;
    DatabaseReference ref = database.ref('/');

    // Query the first 10000 items by key
    final snapshot = await ref.orderByKey().limitToFirst(100).get();

    if (snapshot.exists) {
      final List<dynamic> data = snapshot.value as List<dynamic>;
      Map<String, Charity> charityMap = {};
      for (var i = 0; i < data.length; i++) {
        final value = data[i] as Map;
        final id = value['EIN'].toString();
        final name = value['NAME'];
        final sortName = value['SORT_NAME'];

        charityMap[id] = Charity(id: id, name: name, sortName: sortName);
      }
      return charityMap;
    } else {
      throw Error();
    }
  }

  /// Method for handling charity search
  ///
  /// So much time put into getting all of this charity data into place and Firebase
  /// doesn't even offer an option for querying it..............
  /// Totally not mad about that wasted 4+ hours...................................
  // Future<Map<String, Charity>> searchCharities(String searchValue) async {
  //   try {} catch (e) {
  //     print(e);
  //   }
  // }
}
