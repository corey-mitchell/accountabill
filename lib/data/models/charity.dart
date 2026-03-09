import 'package:uuid/uuid.dart';

/// Data model for charity information
///
/// This currently uses a hardcoded list of charity information,
/// which was pulled from the U.S. IRS Exempt Organizations Data
/// https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf
///
/// In the future, this will be updated to pull from an API.
class Charity {
  static const Uuid _uuid = Uuid();

  final String? id;
  final String name;
  final double? amountDonated;
  final String? sortName;

  Charity({String? id, required this.name, this.amountDonated, this.sortName})
    : id = id ?? _uuid.v4();
}

class CharityAPIResponse {
  final String EIN;
  final String NAME;
  final String? STREET;
  final String? CITY;
  final String? STATE;
  final String? ZIP;
  final dynamic SORT_NAME;

  const CharityAPIResponse({
    required this.EIN,
    required this.NAME,
    this.STREET,
    this.CITY,
    this.STATE,
    this.ZIP,
    this.SORT_NAME,
  });
}
