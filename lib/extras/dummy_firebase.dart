






// class FirebaseDatabase {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _userId;

//   List accountsList = [];
//   Map amountsList = {};
//   List transactionList = [];
//   Map userDetail = {};
//   Database db = Database();

//   // Initialize the user ID when the user signs in
//   Future<void> initUserId() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       _userId = user.uid;
//     }
//   }

//   // Combined function to save and retrieve data from Firebase Firestore
//   Future<void> saveAndRetrieveDataFromFirebase(BuildContext context) async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         customSnackbar(context: context, text: "User not authenticated");
//       }

//       // Save data to Firebase
//       await _saveDataToFirebase(context);

//       // Retrieve data from Firebase
//       await _retrieveDataFromFirebase(context);

//       // Perform any other actions after saving and retrieving data if needed

//     } catch (e) {
//       customSnackbar(context: context, text: 'Error: $e');
//       print('Error: $e');
//     }
//   }

//   // Private function to save data to Firebase
//   Future<void> _saveDataToFirebase(BuildContext context) async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Save transaction data
//       db.getTransactionDB();
//       transactionList = db.TransactionList;
//       CollectionReference transactionsRef =
//           FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);
//       for (var transaction in transactionList) {
//         await transactionsRef.add(transaction);
//       }

//       // Save user detail
//       db.getUserDetailDB();
//       userDetail = db.userDetail;
//       CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);
//       await usersRef.doc(_userId).set(userDetail);

//       // Save amounts data
//       db.getAmountDB();
//       amountsList = db.amountsList;
//       CollectionReference amountsRef =
//           FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);
//       await amountsRef.doc(amountsDocumentFD).set(amountsList);

//       // Save accounts data
//       db.getAccountDB();
//       accountsList = db.AccountsList;
//       CollectionReference accountsRef =
//           FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);
//       for (var account in accountsList) {
//         await accountsRef.add(account);
//       }
//     } catch (e) {
//       customSnackbar(context: context, text: 'Error saving data to Firebase: $e');
//       print('Error saving data to Firebase: $e');
//     }
//   }

//   // Private function to retrieve data from Firebase
//   Future<void> _retrieveDataFromFirebase(BuildContext context) async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get references to the Firestore collections
//       CollectionReference transactionsRef =
//           FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);
//       CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);
//       CollectionReference amountsRef =
//           FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);
//       CollectionReference accountsRef =
//           FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

//       // Retrieve transaction data
//       QuerySnapshot transactionSnapshot = await transactionsRef.get();
//       List<DocumentSnapshot> transactionDocuments = transactionSnapshot.docs;
//       transactionList =
//           transactionDocuments.map((transaction) => transaction.data() as Map<String, dynamic>).toList();

//       // Retrieve user detail
//       DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
//       userDetail = userSnapshot.data() as Map<String, dynamic>;

//       // Retrieve amounts data
//       DocumentSnapshot amountsSnapshot = await amountsRef.doc(amountsDocumentFD).get();
//       amountsList = amountsSnapshot.data() as Map<String, dynamic>;

//       // Retrieve accounts data
//       QuerySnapshot accountSnapshot = await accountsRef.get();
//       List<DocumentSnapshot> accountDocuments = accountSnapshot.docs;
//       accountsList = accountDocuments.map((account) => account.data() as Map<String, dynamic>).toList();

//       // Do something with the retrieved data...
//       print('Transaction Data: $transactionList');
//       print('User Data: $userDetail');
//       print('Amount Data: $amountsList');
//       print('Accounts Data: $accountsList');
//     } catch (e) {
//       customSnackbar(context: context, text: 'Error retrieving data from Firebase: $e');
//       print('Error retrieving data from Firebase: $e');
//     }
//   }
// }




















// // ignore_for_file: avoid_print

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:expenses_tracker/Componet/custom_snackbar.dart';
// import 'package:flutter/material.dart';
// import './database.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseDatabse {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _userId;

//   List accountsList = [];
//   Map amountsList = {};
//   List transactionList = [];
//   Map userDetail = {};
//   Database db = Database();

//   // Initialize the user ID when the user signs in
//   Future<void> initUserId() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       _userId = user.uid;
//     }
//   }

//   // Save transaction data to Firebase Firestore for the current user
//   Future<void> saveTransactionDataToFirebase(BuildContext context) async {
//     db.getTransactionDB();
//     transactionList = db.TransactionList;
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         customSnackbar(context: context, text: "User not authenticated");
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for transactions
//       CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

//       // Save each transaction separately
//       for (var transaction in transactionList) {
//         await transactionsRef.add(transaction);
//       }
//     } catch (e) {
//       customSnackbar(context: context, text: 'Error saving transaction data: \n$e');
//       print('Error saving transaction data: $e');
//     }
//   }

//   // Save user detail to Firebase Firestore for the current user
//   Future<void> saveUserDetailToFirebase() async {
//     db.getUserDetailDB();
//     userDetail = db.userDetail;
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for users
//       CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);

//       // Save user detail document for the current user
//       await usersRef.doc(_userId).set(userDetail);
//     } catch (e) {
//       print('Error saving user detail: $e');
//     }
//   }

//   // Save amounts to Firebase Firestore for the current user
//   Future<void> saveAmountsToFirebase() async {
//     db.getAmountDB();
//     amountsList = db.amountsList;
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for amounts
//       CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);

//       // Save amounts document for the current user
//       await amountsRef.doc(amountsDocumentFD).set(amountsList);
//     } catch (e) {
//       print('Error saving amounts: $e');
//     }
//   }

//   // Save accounts to Firebase Firestore for the current user
//   Future<void> saveAccountsToFirebase() async {
//     db.getAccountDB();
//     accountsList = db.AccountsList;
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for accounts
//       CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

//       // Save each account separately
//       for (var account in accountsList) {
//         await accountsRef.add(account);
//       }
//     } catch (e) {
//       print('Error saving accounts: $e');
//     }
//   }

//   // Retrieve transaction data from Firebase Firestore for the current user
//   Future<void> retrieveTransactionsFromFirebase() async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for transactions
//       CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

//       // Retrieve transaction data for the current user
//       QuerySnapshot transactionSnapshot = await transactionsRef.get();
//       List<DocumentSnapshot> transactionDocuments = transactionSnapshot.docs;
//       transactionList = transactionDocuments.map((transaction) => transaction.data() as Map<String, dynamic>).toList();
//     } catch (e) {
//       print('Error retrieving transactions: $e');
//       transactionList = [];
//     }
//   }

//   // Retrieve user detail from Firebase Firestore for the current user
//   Future<void> retrieveUserDetailFromFirebase() async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for users
//       CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);

//       // Retrieve user detail for the current user
//       DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
//       userDetail = userSnapshot.data() as Map<String, dynamic>;
//     } catch (e) {
//       print('Error retrieving user detail: $e');
//       userDetail = {};
//     }
//   }

//   // Retrieve amounts from Firebase Firestore for the current user
//   Future<void> retrieveAmountsFromFirebase() async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for amounts
//       CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);

//       // Retrieve amounts for the current user
//       DocumentSnapshot amountsSnapshot = await amountsRef.doc(amountsDocumentFD).get();
//       amountsList = amountsSnapshot.data() as Map<String, dynamic>;
//     } catch (e) {
//       print('Error retrieving amounts: $e');
//       amountsList = {};
//     }
//   }

//   // Retrieve accounts from Firebase Firestore for the current user
//   Future<void> retrieveAccountsFromFirebase() async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         throw Exception('User not authenticated');
//       }

//       // Get a reference to the Firestore collection for accounts
//       CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

//       // Retrieve accounts for the current user
//       QuerySnapshot accountSnapshot = await accountsRef.get();
//       List<DocumentSnapshot> accountDocuments = accountSnapshot.docs;
//       accountsList = accountDocuments.map((account) => account.data() as Map<String, dynamic>).toList();
//     } catch (e) {
//       print('Error retrieving accounts: $e');
//       accountsList = [];
//     }
//   }
// }
