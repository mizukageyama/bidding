class Validator {
  Validator();

  String? email(String? value) {
    const pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Please enter a valid email address';
    } else {
      return null;
    }
  }

  String? password(String? value) {
    const pattern = r'^.{6,}$';
    final regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Password must be at least 6 characters';
    } else {
      return null;
    }
  }

  String? number(String? value) {
    if (value == null) {
      return 'This is a required field';
    }
    bool isNum = double.tryParse(value) != null;
    if (!isNum) {
      return 'Enter a number';
    }
    return null;
  }

  String? bid(String? value, double askingPrice, bool hasApprovedBid) {
    if (value == null) {
      return 'This is a required field';
    }
    bool isNum = double.tryParse(value) != null;
    if (!isNum) {
      return 'Enter a number';
    }
    if (hasApprovedBid && double.parse(value) < askingPrice) {
      return 'Bid higher than $askingPrice';
    }
    if (double.parse(value) < askingPrice) {
      return 'Start bidding at $askingPrice';
    }
    return null;
  }

  String? notEmpty(String? value) {
    if (value == '') {
      return 'This is a required field';
    } else {
      return null;
    }
  }
}
