import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:bidding/screens/seller/home.dart';
import 'package:bidding/shared/_packages_imports.dart';
import 'package:bidding/shared/constants/_firebase_imports.dart';
import 'package:bidding/shared/constants/firebase.dart';
import 'package:bidding/shared/services/_services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bidding/models/_models.dart';
import 'package:bidding/screens/auth/_auth_screens.dart';

class AuthController extends GetxController {
  final log = getLogger('Auth Controller');

  //Login Screen
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Rxn<UserModel> userModel = Rxn<UserModel>();
  Rxn<User> firebaseUser = Rxn<User>();
  //String? userRole = 'Test';

  //Sign Up Screen
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPwController = TextEditingController();
  TextEditingController idNumberController = TextEditingController();
  TextEditingController regPwController = TextEditingController();
  final ImagePickerService picker = ImagePickerService();
  final RxString userType = ''.obs;
  final RxString idImage = ''.obs;
  final RxString form1Image = ''.obs;
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

  Future<void> _initializeUser() async {
    userModel.value = await firestore
        .collection('users')
        .doc(firebaseUser.value!.uid)
        .get()
        .then((doc) => UserModel.fromJson(doc.data()!));
    log.i('_initializePatientModel | Initializing ${userModel.value}');
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

  //For Registration ---------------------------------
  Future<void> submitRegistration(BuildContext context) async {
    //check if nakapick ug photos, then
    if (form1Image.value != '' && idImage.value != '') {
      log.i('Proceed to register');
      //await registerUser(context);
    } else {
      log.i('Please select ID');
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

    await firestore.collection('users').doc(_userID).set(<String, dynamic>{
      'user_id': _userID,
      'email': emailController.text.trim(),
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'user_role': userType.value,
      'id_number': idNumberController.text.trim(),
      'form_1': form1Url,
      'um_id': umIdUrl,
    }).then((value) async {
      dismissDialog();
      signInWithEmailAndPassword(context);
    });
  }

  Future<void> uploadPhotos(String id) async {
    if (kIsWeb) {
      form1Url.value =
          await uploadSinglePhotoOnWeb(imgForm1File!, 'Form-1', id);
      umIdUrl.value = await uploadSinglePhotoOnWeb(imgIdFile!, 'UM-ID', id);
    } else {
      form1Url.value = await uploadSinglePhoto(form1Image.value, 'Form-1', id);
      umIdUrl.value = await uploadSinglePhoto(idImage.value, 'UM-ID', id);
    }
  }

  void pickImageID() async {
    imgIdFile = await picker.pickImageOnWeb(idImage);
  }

  void pickImageForm1() async {
    imgForm1File = await picker.pickImageOnWeb(form1Image);
  }

  Future<String> uploadSinglePhoto(
      String filePathID, String fileName, String id) async {
    String downloadUrl = '';
    final ref = storageRef.child('user/$id/$fileName');
    final uploadTask = ref.putFile(File(filePathID));
    await uploadTask.then((res) async {
      downloadUrl = await res.ref.getDownloadURL();
    });
    return downloadUrl;
  }

  Future<String> uploadSinglePhotoOnWeb(
      XFile image, String fileName, String id) async {
    String downloadUrl = '';
    final fileBytes = image.readAsBytes();
    final metadata = firebase_storage.SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': image.path});
    final ref = storageRef.child('user/$id/$fileName');
    final uploadTask = ref.putData(await fileBytes, metadata);
    await uploadTask.then((res) async {
      downloadUrl = await res.ref.getDownloadURL();
    });
    return downloadUrl;
  }

  Future<void> clearControllers() async {
    log.i('_clearControllers | User Input on authentication is cleared');
    emailController.clear();
    passwordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    confirmPwController.clear();
    idNumberController.clear();
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
