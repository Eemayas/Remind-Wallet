// firebase_database.dart
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../Componet/custom_snackbar.dart';
import './database.dart';

const String transactionsFD = 'transactions';
const String usersFD = 'users';
const String amountsFD = 'amounts';
const String amountsDocumentFD = 'amountsDocument';
const String accountsFD = 'accounts';
const String userDetailsFD = 'userDetails';

class FirebaseDatabases {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _userId;

  List accountsList = [];
  Map amountsList = {};
  List transactionList = [];
  Map userDetail = {};
  Database db = Database();
  FirebaseDatabases() {
    initUserId();
  }

  // Initialize the user ID when the user signs in
  Future<void> initUserId() async {
    User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
  }

// Save transaction data to Firebase Firestore for the current user
  Future<void> saveTransactionDataToFirebase(BuildContext context) async {
    db.getTransactionDB();
    transactionList = db.TransactionList;
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for transactions
      CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

      // Delete existing transaction data
      var existingTransactions = await transactionsRef.get();
      for (var doc in existingTransactions.docs) {
        await doc.reference.delete();
      }

      // Save each transaction separately
      for (var transaction in transactionList) {
        // Convert keys and values to strings
        Map<String, dynamic> transactionMap = {};
        transaction.forEach((key, value) {
          transactionMap[key.toString()] = value.toString();
        });

        // Add the transaction data to Firestore
        await transactionsRef.add(transactionMap);
      }

      customSnackbar(context: context, text: "Transactions are saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving transaction data: \n$e');
      print('Error saving transaction data: $e');
    }
  }

// Save accounts to Firebase Firestore for the current user
  Future<void> saveAccountsToFirebase(BuildContext context) async {
    // initUserId();
    db.getAccountDB();
    accountsList = db.AccountsList;
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for accounts
      CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

      // Delete existing account data
      var existingAccounts = await accountsRef.get();
      for (var doc in existingAccounts.docs) {
        await doc.reference.delete();
      }

      // Save each account separately
      for (var account in accountsList) {
        // Convert keys and values to strings
        Map<String, dynamic> accountMap = {};
        account.forEach((key, value) {
          accountMap[key.toString()] = value.toString();
        });

        // Add the account data to Firestore
        await accountsRef.add(accountMap);
      }

      customSnackbar(context: context, text: "Accounts are saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving accounts: \n$e');
      print('Error saving accounts: $e');
    }
  }

// Save transaction data to Firebase Firestore for the current user
  Future<void> saveSingleTransactionDataToFirebase(BuildContext context) async {
    db.getTransactionDB();
    transactionList = db.TransactionList;
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for transactions
      CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

      // Save each transaction separately
      for (var transaction in transactionList) {
        // Generate a unique identifier for the transaction
        String uniqueIdentifier = Uuid().v4();

        // Convert keys and values to strings
        Map<String, dynamic> transactionMap = {};
        transaction.forEach((key, value) {
          transactionMap[key.toString()] = value.toString();
        });

        // Add the unique identifier to the transaction map
        transactionMap['uniqueIdentifier'] = uniqueIdentifier;

        // Check if the transaction with the same unique identifier exists
        var query = await transactionsRef.where("uniqueIdentifier", isNotEqualTo: uniqueIdentifier).get();
        if (query.docs.isEmpty) {
          await transactionsRef.add(transactionMap);
        }
      }

      customSnackbar(context: context, text: "Transactions are saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving transaction data: \n$e');
      print('Error saving transaction data: $e');
    }
  }

// Save accounts to Firebase Firestore for the current user
  Future<void> saveSingleAccountsToFirebase(BuildContext context) async {
    // initUserId();
    db.getAccountDB();
    accountsList = db.AccountsList;
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for accounts
      CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

      // Save each account separately
      for (var account in accountsList) {
        // Generate a unique identifier for the account
        String uniqueIdentifier = Uuid().v4();

        // Convert keys and values to strings
        Map<String, dynamic> accountMap = {};
        account.forEach((key, value) {
          accountMap[key.toString()] = value.toString();
        });

        // Add the unique identifier to the account map
        accountMap['uniqueIdentifier'] = uniqueIdentifier;

        // Check if the account with the same unique identifier exists
        var query = await accountsRef.where("uniqueIdentifier", isEqualTo: uniqueIdentifier).get();
        if (query.docs.isEmpty) {
          await accountsRef.add(accountMap);
        }
      }

      customSnackbar(context: context, text: "Accounts are saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving accounts: \n$e');
      print('Error saving accounts: $e');
    }
  }

  // Save user detail to Firebase Firestore for the current user
  Future<void> saveUserDetailToFirebase(BuildContext context) async {
    db.getUserDetailDB();
    userDetail = db.userDetail;
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Convert keys and values to strings
      Map<String, dynamic> userDetailString = {};
      userDetail.forEach((key, value) {
        userDetailString[key.toString()] = value.toString();
      });

      // Get a reference to the Firestore collection for users
      CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);

      // Save user detail document for the current user
      await usersRef.doc(_userId).set(userDetailString);
      customSnackbar(context: context, text: "UserData is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving user detail: \n$e');
      print('Error saving user detail: $e');
    }
  }

  // Save amounts to Firebase Firestore for the current user
  Future<void> saveAmountsToFirebase(BuildContext context) async {
    db.getAmountDB();
    amountsList = db.amountsList;
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Convert keys and values to strings
      Map<String, dynamic> amountsListString = {};
      amountsList.forEach((key, value) {
        amountsListString[key.toString()] = value.toString();
      });

      // Get a reference to the Firestore collection for amounts
      CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);

      // Save amounts document for the current user
      await amountsRef.doc(amountsDocumentFD).set(amountsListString);
      customSnackbar(context: context, text: "Ammount is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving amounts: \n$e');
      print('Error saving amounts: \n$e');
    }
  }

// function to save data to Firebase
  Future<void> saveAllDataToFirebase(BuildContext context) async {
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Save transaction data
      db.getTransactionDB();
      transactionList = db.TransactionList;
      CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);
      for (var transaction in transactionList) {
        // Convert keys and values to strings
        Map<String, dynamic> transactionMap = {};
        transaction.forEach((key, value) {
          transactionMap[key.toString()] = value.toString();
        });
        await transactionsRef.add(transactionMap);
      }

      // Save user detail
      db.getUserDetailDB();
      userDetail = db.userDetail;
      // Convert keys and values to strings
      Map<String, dynamic> userDetailString = {};
      userDetail.forEach((key, value) {
        userDetailString[key.toString()] = value.toString();
      });
      // CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD); change to this
      CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);
      await usersRef.doc(_userId).set(userDetailString);

      // Save amounts data
      db.getAmountDB();
      amountsList = db.amountsList;
      // Convert keys and values to strings
      Map<String, dynamic> amountsListString = {};
      amountsList.forEach((key, value) {
        amountsListString[key.toString()] = value.toString();
      });
      CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);
      await amountsRef.doc(amountsDocumentFD).set(amountsListString);

      // Save accounts data
      db.getAccountDB();
      accountsList = db.AccountsList;
      CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);
      for (var account in accountsList) {
        // Convert keys and values to strings
        Map<String, dynamic> accountMap = {};
        account.forEach((key, value) {
          accountMap[key.toString()] = value.toString();
        });
        await accountsRef.add(accountMap);
      }

      customSnackbar(context: context, text: "All Data is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error saving data to Firebase: \n$e');
      print('Error saving data to Firebase: $e');
    }
  }

  // Retrieve transaction data from Firebase Firestore for the current user
  Future<void> retrieveTransactionsFromFirebase(BuildContext context) async {
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for transactions
      CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

      // Retrieve transaction data for the current user
      QuerySnapshot transactionSnapshot = await transactionsRef.get();
      List<DocumentSnapshot> transactionDocuments = transactionSnapshot.docs;
      transactionList = transactionDocuments.map((transaction) => transaction.data() as Map<String, dynamic>).toList();
    } catch (e) {
      customSnackbar(context: context, text: 'Error retrieving transactions: \n$e');
      print('Error retrieving transactions: $e');
      transactionList = [];
    }
  }

  // Retrieve user detail from Firebase Firestore for the current user
  Future<void> retrieveUserDetailFromFirebase(BuildContext context) async {
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for users
      CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);

      // Retrieve user detail for the current user
      DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
      userDetail = userSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      customSnackbar(context: context, text: 'Error retrieving user detail: \n$e');
      print('Error retrieving user detail: $e');
      userDetail = {};
    }
  }

  // Retrieve amounts from Firebase Firestore for the current user
  Future<void> retrieveAmountsFromFirebase(BuildContext context) async {
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for amounts
      CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);

      // Retrieve amounts for the current user
      DocumentSnapshot amountsSnapshot = await amountsRef.doc(amountsDocumentFD).get();
      amountsList = amountsSnapshot.data() as Map<String, dynamic>;
    } catch (e) {
      customSnackbar(context: context, text: 'Error retrieving amounts: \n$e');
      print('Error retrieving amounts: $e');
      amountsList = {};
    }
  }

  // Retrieve accounts from Firebase Firestore for the current user
  Future<void> retrieveAccountsFromFirebase(BuildContext context) async {
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get a reference to the Firestore collection for accounts
      CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

      // Retrieve accounts for the current user
      QuerySnapshot accountSnapshot = await accountsRef.get();
      List<DocumentSnapshot> accountDocuments = accountSnapshot.docs;
      accountsList = accountDocuments.map((account) => account.data() as Map<String, dynamic>).toList();
    } catch (e) {
      customSnackbar(context: context, text: 'Error retrieving accounts: \n$e');
      print('Error retrieving accounts: $e');
      accountsList = [];
    }
  }

  // function to retrieve data from Firebase
  Future<void> retrieveAllDataFromFirebase(BuildContext context) async {
    try {
      // Check if user is authenticated
      if (_userId == null) {
        customSnackbar(context: context, text: "User not authenticated");
        throw Exception('User not authenticated');
      }

      // Get references to the Firestore collections
      CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);
      CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);
      CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);
      CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

      // Retrieve transaction data
      QuerySnapshot transactionSnapshot = await transactionsRef.get();
      List<DocumentSnapshot> transactionDocuments = transactionSnapshot.docs;
      transactionList = transactionDocuments.map((transaction) => transaction.data() as Map<String, dynamic>).toList();

      // Retrieve user detail
      DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
      userDetail = userSnapshot.data() as Map<String, dynamic>;

      // Retrieve amounts data
      DocumentSnapshot amountsSnapshot = await amountsRef.doc(amountsDocumentFD).get();
      amountsList = amountsSnapshot.data() as Map<String, dynamic>;

      // Retrieve accounts data
      QuerySnapshot accountSnapshot = await accountsRef.get();
      List<DocumentSnapshot> accountDocuments = accountSnapshot.docs;
      accountsList = accountDocuments.map((account) => account.data() as Map<String, dynamic>).toList();

      // Do something with the retrieved data...
      print('Transaction Data: $transactionList');
      print('User Data: $userDetail');
      print('Amount Data: $amountsList');
      print('Accounts Data: $accountsList');
    } catch (e) {
      customSnackbar(context: context, text: 'Error retrieving data from Firebase: \n$e');
      print('Error retrieving data from Firebase: $e');
    }
  }

  Future<void> deleteAllDocumentsFromCollection(BuildContext context, String collectionName) async {
    try {
      // Get a reference to the Firestore collection
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(collectionName);
      CollectionReference collectionAmtRef = FirebaseFirestore.instance.collection(collectionName);

      // Query for all documents in the collection
      QuerySnapshot querySnapshot = await collectionRef.get();
      QuerySnapshot queryAmtSnapshot = await collectionRef.get();

      // Delete each document
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      for (var doc in queryAmtSnapshot.docs) {
        await doc.reference.delete();
      }
      print('All documents in $collectionName collection deleted successfully');
      customSnackbar(
          context: context,
          text: 'All documents in $collectionName collection deleted successfully',
          icons: Icons.done_all,
          iconsColor: Colors.green);
    } catch (e) {
      customSnackbar(context: context, text: 'Error deleting documents: \n$e');
      print('Error deleting documents: $e');
    }
  }

  Future<void> deleteAllDataFromFirestore(BuildContext context) async {
    try {
      // Delete all documents from the "users" collection
      await deleteAllDocumentsFromCollection(context, usersFD);

      // Delete all documents from the "transactions" collection
      await deleteAllDocumentsFromCollection(context, transactionsFD);

      // Delete all documents from the "amounts" collection
      await deleteAllDocumentsFromCollection(context, amountsFD);

      // Delete all documents from the "accounts" collection
      await deleteAllDocumentsFromCollection(context, accountsFD);

      // Add more collections to delete if needed
      customSnackbar(context: context, text: "Account is deleted from Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
      print('All data in Firestore deleted successfully');
    } catch (e) {
      customSnackbar(context: context, text: 'Error deleting data from Firestore: \n$e');
      print('Error deleting data from Firestore: $e');
    }
  }
}
