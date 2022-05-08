import '_firebase_imports.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;
Reference storageRef = storage.ref();

const firebaseConfig = FirebaseOptions(
    apiKey: "AIzaSyBAkXXsCcfAS3hyRKc-VJt4DSPOZiLMjHY",
    authDomain: "bidding-4af0e.firebaseapp.com",
    projectId: "bidding-4af0e",
    storageBucket: "bidding-4af0e.appspot.com",
    messagingSenderId: "1016446512811",
    appId: "1:1016446512811:web:5d4a6ee51295a6787c11ee");
