import 'package:bidding/main/_auth/_auth_screens.dart';
import 'package:bidding/main/admin/screens/home.dart';
import 'package:bidding/main/bidder/screens/_bidder_screens.dart';
import 'package:bidding/main/seller/screens/_seller_screens.dart';
import 'package:bidding/models/user_additional_info.dart';
import 'package:bidding/shared/services/image_upload.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bidding/models/_models.dart';

class AuthController extends GetxController {
  final log = getLogger('Auth Controller');

  //Login Screen
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  Rxn<User> firebaseUser = Rxn<User>();

  //User Streamed Information
  Rxn<AdditionalInfo> info = Rxn<AdditionalInfo>();

  //Sign Up Screen
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController idnumberController = TextEditingController();
  final RxString usertype = ''.obs;

  XFile? imgOfValidIDFile;
  XFile? imgOfForm1File;
  final RxString validIDImage = ''.obs;
  final RxString form1Image = ''.obs;
  TextEditingController confirmPwController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  final ImagePickerService picker = ImagePickerService();
  final RxString userType = ''.obs;
  final RxString idImage = ''.obs;
  final RxString form1Url = ''.obs;
  final RxString umIdUrl = ''.obs;
  XFile? imgIdFile;
  XFile? imgForm1File;

  //Change pw
  TextEditingController currentPwController = TextEditingController();
  TextEditingController newPwController = TextEditingController();

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
      if (userModel.value!.userRole == 'Seller') {
        await Get.offAll(() => const SellerHome());
      } else if (userModel.value!.userRole == 'Bidder') {
        await Get.offAll(() => const BidderHome());
      } else {
        await Get.offAll(() => const AdminHome());
      }
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

  Future<void> _initializeUser() async {
    try {
      userModel.value = await firestore
          .collection('users')
          .doc(firebaseUser.value!.uid)
          .get()
          .then((doc) => UserModel.fromJson(doc.data()!));
      log.i('_initialize User | Initializing ${userModel.value}');
      info.bindStream(getAdditionalInfo());
    } catch (error) {
      log.i('_initialize User| $error');
    }
  }

  Stream<AdditionalInfo> getAdditionalInfo() {
    return firestore
        .collection('users')
        .doc(firebaseUser.value!.uid)
        .collection('additional_info')
        .doc('value')
        .snapshots()
        .map((value) => AdditionalInfo.fromJson(value.data()!));
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
    log.i('_clearControllers | User Input after auth is cleared');
    emailController.clear();
    passwordController.clear();
  }

  //For Registration ---------------------------------
  Future<void> submitRegistration(BuildContext context) async {
    if (form1Image.value != '' && idImage.value != '') {
      await registerUser(context);
    } else {
      showSimpleDialog(
        title: 'All fields are required',
        description: 'Please provide your ID and Form 1.',
        onTapFunc: () => dismissDialog(),
      );
    }
  }

  Future<void> registerUser(BuildContext context) async {
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
      log.i('goind to create user');
      await _createUser(result.user!.uid, context);
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

  Future<void> _createUser(String _userID, BuildContext context) async {
    await uploadPhotos(_userID);
    log.i('done upload');
    await firestore.collection('users').doc(_userID).set(<String, dynamic>{
      'user_id': _userID,
      'email': emailController.text.trim(),
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'user_role': userType.value,
      'id_number': idNumberController.text.trim(),
      'form_1': form1Url.value,
      'um_id': umIdUrl.value,
    }).then((value) async {
      await addSubCollection(_userID);
      dismissDialog();
      await signInWithEmailAndPassword(context);
      registrationSuccess();
    });
  }

  Future<void> addSubCollection(String _userID) async {
    await firestore
        .collection('users')
        .doc(_userID)
        .collection('additional_info')
        .doc('value')
        .set({'profile_photo': ''});
  }

  Future<void> uploadPhotos(String id) async {
    log.i('uploading photos');
    if (kIsWeb) {
      form1Url.value = await Upload.photoToWeb(
        image: imgForm1File!,
        saveAs: 'user/$id/Form-1',
      );
      umIdUrl.value = await Upload.photoToWeb(
        image: imgIdFile!,
        saveAs: 'user/$id/UM-ID',
      );
    } else {
      form1Url.value = await Upload.photo(
        filePathID: form1Image.value,
        saveAs: 'user/$id/Form-1',
      );
      umIdUrl.value = await Upload.photo(
        filePathID: idImage.value,
        saveAs: 'user/$id/UM-ID',
      );
    }
  }

  void pickImageID() async {
    imgIdFile = await picker.pickImageOnWeb(idImage);
  }

  void pickImageForm1() async {
    imgForm1File = await picker.pickImageOnWeb(form1Image);
  }

  Future<void> registrationSuccess() async {
    log.i('_clearControllers | User Input after registration');
    firstNameController.clear();
    lastNameController.clear();
    confirmPwController.clear();
    idNumberController.clear();
    userType.value = '';
    idImage.value = '';
    form1Image.value = '';
    form1Url.value = '';
    umIdUrl.value = '';
  }

  //Change Password and Forgot Password ---------------------------------
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
        email: user!.email!, password: currentPwController.text);
    showLoading();
    await user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPwController.text).then((_) {
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

  Future<void> _changePasswordSuccess() async {
    log.i('_clearControllers | Change Password Success');
    currentPwController.clear();
    newPwController.clear();
    isObscureCurrentPW!.value = true;
    isObscureNewPW!.value = true;
  }
}
