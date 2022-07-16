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
  TextEditingController idNumberController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final RxString usertype = ''.obs;

  XFile? imgOfValidIDFile;
  XFile? imgOfForm1File;
  final RxString validIDImage = ''.obs;
  final RxString form1Image = ''.obs;
  TextEditingController confirmPwController = TextEditingController();
  final ImagePickerService picker = ImagePickerService();
  final RxString userType = ''.obs;
  final RxString idImage = ''.obs;
  final RxString form1Url = ''.obs;
  final RxString umIdUrl = ''.obs;
  XFile? imgIdFile;
  XFile? imgForm1File;

  RxBool? isObscureText = true.obs;
  RxBool? isObscureText2 = true.obs;
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
        .doc(auth.currentUser!.uid)
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
    RxBool successUpload = false.obs;
    try {
      await uploadPhotos(_userID);
      log.i('done upload');
      successUpload.value = true;
    } catch (error) {
      log.i(error);
    }
    if (successUpload.value) {
      await createUserBatch(_userID, context);
    } else {
      dismissDialog();
      Get.snackbar(
        'Error creating account',
        'Please try again later',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> createUserBatch(String _userID, BuildContext context) async {
    final batch = firestore.batch();

    final userRef = firestore.collection('users').doc(_userID);
    Map<String, dynamic> userData = {
      'user_id': _userID,
      'email': emailController.text.trim(),
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
      'user_role': userType.value,
      'id_number': idNumberController.text.trim(),
      'form_1': form1Url.value,
      'um_id': umIdUrl.value,
      'contact_number': contactController.text.trim(),
    };

    batch.set(userRef, userData);

    final addtionalRef = firestore
        .collection('users')
        .doc(_userID)
        .collection('additional_info')
        .doc('value');
    Map<String, dynamic> additionalData = {
      'profile_photo': '',
      'notif_badge': 1
    };

    batch.set(addtionalRef, additionalData);

    final notifRef = firestore
        .collection('users')
        .doc(_userID)
        .collection('notifications')
        .doc(_userID);

    Map<String, dynamic> firstNotif = {
      'title': 'Welcome, ${firstNameController.text.trim()}!',
      'message':
          'As a new user of our application, we welcome you with pleasure. '
              'You may now start to explore our community bidding.',
      'created_at': FieldValue.serverTimestamp(),
    };

    batch.set(notifRef, firstNotif);

    batch.commit().then((value) async {
      dismissDialog();
      await signInWithEmailAndPassword(context);
      registrationSuccess();
    }).catchError((onError) {
      dismissDialog();
      showErrorDialog(
          errorTitle: 'Something went wrong',
          errorDescription: 'An error occured while creating your account');
      log.i(onError);
    });
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
    contactController.clear();
    userType.value = '';
    idImage.value = '';
    form1Image.value = '';
    form1Url.value = '';
    umIdUrl.value = '';
  }

  //Forgot Password ---------------------------------
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
}
