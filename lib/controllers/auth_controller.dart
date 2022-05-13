import 'package:bidding/screens/seller/home.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/material.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/screens/auth/_auth_screens.dart';

class AuthController extends GetxController {
  final log = getLogger('Auth Controller');

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  Rxn<UserModel> userModel = Rxn<UserModel>();

  Rxn<User> firebaseUser = Rxn<User>();

  String? userRole = 'Test';
  RxBool isDisabled = false.obs;

  RxString userMode = 'Seller'.obs;

  RxBool? isObscureText = true.obs;
  RxBool? isObscureText2 = true.obs;
  RxBool? isObscureCurrentPW = true.obs;
  RxBool? isObscureNewPW = true.obs;
  RxBool isCheckboxChecked = false.obs;

  @override
  void onInit() {
    log.i('onInit | Auth Controller is ready');
    //delay to give splash screen 3 sec
    Future.delayed(const Duration(seconds: 3), () {
      ever(firebaseUser, _setInitialScreen);
      firebaseUser.bindStream(user);
    });
    super.onInit();
  }

  Stream<User?> get user => auth.authStateChanges();

  Future<void> _setInitialScreen(_firebaseUser) async {
    if (_firebaseUser == null) {
      log.i('_setInitialScreen | User is null. Proceed Signin Screen');
      await Get.offAll(() => LoginScreen());
    } else {
      log.i('_setInitialScreen | User found. Data: ${_firebaseUser.email}');
      await _initializeUser();
      await Get.offAll(() => const SellerHome());
    }
  }

  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      showLoading();
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      await clearControllers();
      dismissDialog();
    } catch (e) {
      log.i(e);
      dismissDialog();
      Get.snackbar(
        'Error logging in',
        'Please check your email and password',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> registerPatient(BuildContext context) async {
    FocusScope.of(context).unfocus();
    showLoading();
    final app = await Firebase.initializeApp(
        name: 'tempApp', options: Firebase.app().options);
    await FirebaseAuth.instanceFor(app: app)
        .createUserWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((result) async {
      await _createPatientUser(result.user!.uid, context);
    }).onError((error, stackTrace) async {
      dismissDialog();
      Get.snackbar(
        'Error creating account',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    });
    await app.delete();
  }

  Future<void> sendPasswordResetEmail(BuildContext context) async {
    FocusScope.of(context).unfocus();
    try {
      await auth.sendPasswordResetEmail(email: emailController.text);
      log.i('Password link sent to: ${emailController.text}');
      dismissDialog();
      showSimpleDialog(
        title: 'Password Reset Email Sent',
        description: 'Check your email for a password reset link.',
        onTapFunc: () => dismissDialog(),
      );
    } on FirebaseAuthException catch (error) {
      dismissDialog();
      log.i('Forgot pw function: $error');
      showSimpleDialog(
        title: 'Password Reset Email Failed',
        description: 'An error ocurred. The email you'
            ' entered might not exist in our server.',
        onTapFunc: () => dismissDialog(),
      );
    }
  }

  Future<void> changePassword(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPasswordController.text);
    showLoading();
    await user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPasswordController.text).then((_) {
        dismissDialog();
        _changePasswordSuccess();
        Get.back();
        Get.snackbar('Password Changed Successfully',
            'You may now use your new password.',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
            colorText: Get.theme.snackBarTheme.actionTextColor);
      });
    }).catchError((err) {
      dismissDialog();
      Get.snackbar('Password Change Failed',
          'Your current password you have entered is not correct',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
          colorText: Get.theme.snackBarTheme.actionTextColor);
    });
  }

  Future<void> _createPatientUser(String _userID, BuildContext context) async {
    await firestore
        .collection('users')
        .doc(_userID)
        .set(<String, dynamic>{'userType': 'patient', 'disabled': false});
    await firestore.collection('patients').doc(_userID).set(<String, dynamic>{
      'userID': _userID,
      'email': emailController.text.trim(),
      'firstName': firstNameController.text.trim(),
      'lastName': lastNameController.text.trim(),
      'profileImage': '',
      'validID': '',
      'validSelfie': '',
    }).then((value) async {
      dismissDialog();
      signInWithEmailAndPassword(context);
    });
  }

  Future<void> signOut() async {
    showLoading();
    try {
      await auth.signOut();
      dismissDialog();
      log.i('signOut | User signs out successfully');
    } catch (e) {
      dismissDialog();
      Get.snackbar(
        'Error signing out',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> clearControllers() async {
    log.i('_clearControllers | User Input on authentication is cleared');
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    confirmPassController.clear();
  }

  Future<void> _changePasswordSuccess() async {
    log.i('_clearControllers | Change Password Success');
    currentPasswordController.clear();
    newPasswordController.clear();
    isObscureCurrentPW!.value = true;
    isObscureNewPW!.value = true;
  }

  //initialize user
  Future<void> _initializeUser() async {
    userModel.value = await firestore
        .collection('users')
        .doc(firebaseUser.value!.uid)
        .get()
        .then((doc) => UserModel.fromJson(doc.data()!));
    log.i('_initializePatientModel | Initializing ${userModel.value}');
  }
}
