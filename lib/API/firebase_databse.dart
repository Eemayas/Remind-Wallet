// firebase_database.dart
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/Componet/check_internet_connection.dart';
import 'package:expenses_tracker/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../Componet/custom_snackbar.dart';
import '../Encryption/encryption_decryption.dart';
import '../Encryption/substitution.dart';
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
  EncryptionHelper eh = EncryptionHelper();
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

// Save transaction data to Firebase Firestore for the current use
  final _uuid = const Uuid();
  Future<bool> saveAllDataToFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
      db.getAccountDB();
      db.getAmountDB();
      db.getTransactionDB();
      db.getUserDetailDB();
      transactionList = db.TransactionList;
      accountsList = db.AccountsList;
      userDetail = db.userDetail;
      amountsList = db.amountsList;
      try {
        // Check if user is authenticated
        if (_userId == null) {
          customSnackbar(context: context, text: "User not authenticated");
          throw Exception('User not authenticated');
        }

        // Save transaction data
        // saveTransactionDataToFirebase(context);
        // Get a reference to the Firestore collection for transactions
        CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

        // Delete existing transaction data
        var existingTransactions = await transactionsRef.get();
        for (var doc in existingTransactions.docs) {
          await doc.reference.delete();
        }

        // Save each transaction separately with a unique identifier
        for (var transaction in transactionList) {
          // Generate a unique identifier for each transaction
          String uniqueIdentifier = _uuid.v4();

          // Convert keys and values to strings
          Map<String, dynamic> transactionMap = {};
          transaction.forEach((key, value) {
            transactionMap[key.toString()] = SubstitutionCipher.encrypt(value.toString());
          });

          // Add the unique identifier to the transaction map
          transactionMap['uniqueIdentifier'] = uniqueIdentifier;

          // Add the transaction data to Firestore
          await transactionsRef.add(transactionMap);
        }

        // Save user detail
        // saveUserDetailToFirebase(context);
        // Convert keys and values to strings
        Map<String, dynamic> userDetailString = {};
        userDetail.forEach((key, value) {
          userDetailString[key.toString()] = value.toString();
        });

        // Get a reference to the Firestore collection for users
        CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);

        // Save user detail document for the current user
        await usersRef.doc(_userId).set(userDetailString);

        // Save amounts data
        // saveAmountsToFirebase(context);
        // Convert keys and values to strings
        Map<String, dynamic> amountsListString = {};
        amountsList.forEach((key, value) {
          amountsListString[key.toString()] = value.toString();
        });

        // Get a reference to the Firestore collection for amounts
        CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);

        // Save amounts document for the current user
        await amountsRef.doc(amountsDocumentFD).set(amountsListString);

        // Save accounts data
        // saveAccountsToFirebase(context);
        // Get a reference to the Firestore collection for accounts
        CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

        // Delete existing account data
        var existingAccounts = await accountsRef.get();
        for (var doc in existingAccounts.docs) {
          await doc.reference.delete();
        }

        // Save each account separately with a unique identifier
        for (var account in accountsList) {
          // Generate a unique identifier for each account
          String uniqueIdentifier = _uuid.v4();

          // Convert keys and values to strings
          Map<String, dynamic> accountMap = {};
          account.forEach((key, value) {
            accountMap[key.toString()] = value.toString();
          });

          // Add the unique identifier to the account map
          accountMap['uniqueIdentifier'] = uniqueIdentifier;

          // Add the account data to Firestore
          await accountsRef.add(accountMap);
        }

        customSnackbar(context: context, text: "All Data is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error saving data to Firebase: \n$e');
        print('Error saving data to Firebase: $e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  // function to retrieve data from Firebase
  Future<bool> retrieveAllDataFromFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
      try {
        initUserId();
        // Check if user is authenticated
        if (_userId == null) {
          customSnackbar(context: context, text: "User not authenticated");
          throw Exception('User not authenticated');
        }

        // Retrieve transaction data
        // await retrieveTransactionsFromFirebase(context);
        // Get a reference to the Firestore collection for transactions
        CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);

        // Retrieve transaction data for the current user
        QuerySnapshot transactionSnapshot = await transactionsRef.get();
        List<DocumentSnapshot> transactionDocuments = transactionSnapshot.docs;
        transactionList = transactionDocuments.map((transaction) => transaction.data() as Map<String, dynamic>).toList();
        db.deleteTransactionDB();
        for (int i = 0; i < transactionList.length; i++) {
          db.addTransactionDB(
              transactionTitle: SubstitutionCipher.decrypt(transactionList[i][transationNameD]),
              createdDate: SubstitutionCipher.decrypt(transactionList[i][transactionCreatedDateD]),
              amount: SubstitutionCipher.decrypt(transactionList[i][transactionAmountD]).runtimeType == String
                  ? int.tryParse(SubstitutionCipher.decrypt(transactionList[i][transactionAmountD]))
                  : SubstitutionCipher.decrypt(transactionList[i][transactionAmountD]),
              transactionType: SubstitutionCipher.decrypt(transactionList[i][transactionTypeD]),
              transactionTag: SubstitutionCipher.decrypt(transactionList[i][transactionTagD]),
              transactionDate: SubstitutionCipher.decrypt(transactionList[i][transactionDateD]),
              transactionPerson: SubstitutionCipher.decrypt(transactionList[i][transactionPersonD]),
              transactionNote: SubstitutionCipher.decrypt(transactionList[i][transactionDescriptionD]),
              account: SubstitutionCipher.decrypt(transactionList[i][transactionAmountD]));
        }
        // Retrieve user detail
        // await retrieveUserDetailFromFirebase(context);
        // Get a reference to the Firestore collection for users
        // CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);
        CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);

        // Retrieve user detail for the current user
        DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
        userDetail = userSnapshot.data() as Map<String, dynamic>;
        db.editUserNameDB(
          updated_userName: userDetail[userNameD],
          updated_userEmail: userDetail[userEmailD],
          updated_userPhoneNumber: userDetail[userPhoneD],
          updated_userDOB: userDetail[userDOBD],
        );
        // Retrieve accounts data
        // await retrieveAccountsFromFirebase(context);
        // Get a reference to the Firestore collection for accounts
        CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

        // Retrieve accounts for the current user
        QuerySnapshot accountSnapshot = await accountsRef.get();
        List<DocumentSnapshot> accountDocuments = accountSnapshot.docs;
        accountsList = accountDocuments.map((account) => account.data() as Map<String, dynamic>).toList();
        db.deleteAccountDB();
        for (int i = 0; i < accountsList.length; i++) {
          db.addAccountOnlyDB(
              accountName: accountsList[i][accountNameD],
              amount: accountsList[i][accountCurrentBalanceD].runtimeType == String
                  ? int.tryParse(accountsList[i][accountCurrentBalanceD])
                  : accountsList[i][accountCurrentBalanceD]);
        }
        // Retrieve amounts data
        // await retrieveAmountsFromFirebase(context);
        // Get a reference to the Firestore collection for amounts
        CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);

        // Retrieve amounts for the current user
        DocumentSnapshot amountsSnapshot = await amountsRef.doc(amountsDocumentFD).get();
        amountsList = amountsSnapshot.data() as Map<String, dynamic>;
        db.editAmountDB(
          updated_CurrentBalance: int.tryParse(amountsList[currentBalanceD]),
          updated_TotalIncome: int.tryParse(amountsList[totalIncomeD]),
          updated_totalExpenses: int.tryParse(amountsList[totalExpensesD]),
          updated_TotalToPay: int.tryParse(amountsList[toPayD]),
          updated_TotalToReceive: int.tryParse(amountsList[toReceiveD]),
        );
        // Do something with the retrieved data...
        if (transactionList.isNotEmpty &&
            userDetail.isNotEmpty &&
            amountsList.isNotEmpty &&
            db.TransactionList.isNotEmpty &&
            db.userDetail.isNotEmpty &&
            db.amountsList.isNotEmpty &&
            db.AccountsList.isNotEmpty) {
          print('Transaction Data: $transactionList');
          print('User Data: $userDetail');
          print('Amount Data: $amountsList');
          print('Accounts Data: $accountsList');
          customSnackbar(context: context, text: "All datas are received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
          return true;
        } else {
          customSnackbar(context: context, text: "All datas are empty in Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
          return false;
        }
      } catch (e) {
        // customSnackbar(context: context, text: 'Error retrieving data from Firebase: \n$e');
        print('Error retrieving data from Firebase: $e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  Future<bool> deleteAllDocumentsFromCollection(BuildContext context, String collectionName) async {
    if (await isInternetAvailable()) {
      try {
        // Get a reference to the Firestore collection
        CollectionReference collectionRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(collectionName);
        // CollectionReference collectionAmtRef = FirebaseFirestore.instance.collection(collectionName);

        // Query for all documents in the collection
        QuerySnapshot querySnapshot = await collectionRef.get();
        // QuerySnapshot queryAmtSnapshot = await collectionRef.get();

        // Delete each document
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
        }
        print('All documents in $collectionName collection deleted successfully');
        // customSnackbar(
        //     context: context,
        //     text: 'All documents in $collectionName collection deleted successfully',
        //     icons: Icons.done_all,
        //     iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error deleting documents: \n$e');
        print('Error deleting documents: $e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  Future<void> deleteAllDataFromFirestore(BuildContext context) async {
    if (await isInternetAvailable()) {
      try {
        // Delete all documents from the "users" collection
        await deleteAllDocumentsFromCollection(context, userDetailsFD);

        // Delete all documents from the "transactions" collection
        await deleteAllDocumentsFromCollection(context, transactionsFD);

        // Delete all documents from the "amounts" collection
        await deleteAllDocumentsFromCollection(context, amountsFD);

        // Delete all documents from the "accounts" collection
        await deleteAllDocumentsFromCollection(context, accountsFD);

        // Add more collections to delete if needed
        customSnackbar(
            context: context, text: "All data is deleted from Firebase Cloud", icons: Icons.delete_forever_outlined, iconsColor: Colors.green);
        print('All data in Firestore deleted successfully');
      } catch (e) {
        customSnackbar(context: context, text: 'Error deleting data from Firestore: \n$e');
        print('Error deleting data from Firestore: $e');
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
    }
  }

// Save transaction data to Firebase Firestore for the current user
  Future<bool> saveTransactionDataToFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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

        // Save each transaction separately with a unique identifier
        for (var transaction in transactionList) {
          // Generate a unique identifier for each transaction
          String uniqueIdentifier = _uuid.v4();

          // Convert keys and values to strings
          Map<String, dynamic> transactionMap = {};
          transaction.forEach((key, value) {
            transactionMap[key.toString()] = value.toString();
          });

          // Add the unique identifier to the transaction map
          transactionMap['uniqueIdentifier'] = uniqueIdentifier;

          // Add the transaction data to Firestore
          await transactionsRef.add(transactionMap);
        }

        customSnackbar(context: context, text: "Transactions are saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error saving transaction data: \n$e');
        print('Error saving transaction data: $e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

// Save accounts to Firebase Firestore for the current user
  Future<bool> saveAccountsToFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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

        // Save each account separately with a unique identifier
        for (var account in accountsList) {
          // Generate a unique identifier for each account
          String uniqueIdentifier = _uuid.v4();

          // Convert keys and values to strings
          Map<String, dynamic> accountMap = {};
          account.forEach((key, value) {
            accountMap[key.toString()] = value.toString();
          });

          // Add the unique identifier to the account map
          accountMap['uniqueIdentifier'] = uniqueIdentifier;

          // Add the account data to Firestore
          await accountsRef.add(accountMap);
        }

        customSnackbar(context: context, text: "Accounts are saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error saving accounts: \n$e');
        print('Error saving accounts: $e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  // Save user detail to Firebase Firestore for the current user
  Future<bool> saveUserDetailToFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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
        CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);

        // Save user detail document for the current user
        await usersRef.doc(_userId).set(userDetailString);
        customSnackbar(context: context, text: "UserData is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error saving user detail: \n$e');
        print('Error saving user detail: $e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  // Save amounts to Firebase Firestore for the current user
  Future<bool> saveAmountsToFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error saving amounts: \n$e');
        print('Error saving amounts: \n$e');
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

// function to save data to Firebase

//
//
//
//
  // Retrieve transaction data from Firebase Firestore for the current user
  Future<bool> retrieveTransactionsFromFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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
        db.deleteTransactionDB();
        for (int i = 0; i < transactionList.length; i++) {
          db.addTransactionDB(
              transactionTitle: transactionList[i][transationNameD],
              createdDate: transactionList[i][transactionCreatedDateD],
              amount: transactionList[i][transactionAmountD].runtimeType == String
                  ? int.tryParse(transactionList[i][transactionAmountD])
                  : transactionList[i][transactionAmountD],
              transactionType: transactionList[i][transactionTypeD],
              transactionTag: transactionList[i][transactionTagD],
              transactionDate: transactionList[i][transactionDateD],
              transactionPerson: transactionList[i][transactionPersonD],
              transactionNote: transactionList[i][transactionDescriptionD],
              account: transactionList[i][transactionAmountD]);
        }
        if (transactionList.isNotEmpty && db.TransactionList.isNotEmpty) {
          customSnackbar(context: context, text: "Transactions is received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        customSnackbar(context: context, text: 'Error retrieving transactions: \n$e');
        print('Error retrieving transactions: $e');
        transactionList = [];
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  // Retrieve user detail from Firebase Firestore for the current user
  Future<bool> retrieveUserDetailFromFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
      try {
        // Check if user is authenticated
        if (_userId == null) {
          customSnackbar(context: context, text: "User not authenticated");
          throw Exception('User not authenticated');
        }

        // Get a reference to the Firestore collection for users
        // CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);
        CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);

        // Retrieve user detail for the current user
        DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
        userDetail = userSnapshot.data() as Map<String, dynamic>;
        db.editUserNameDB(
          updated_userName: userDetail[userNameD],
          updated_userEmail: userDetail[userEmailD],
          updated_userPhoneNumber: userDetail[userPhoneD],
          updated_userDOB: userDetail[userDOBD],
        );
        print(userDetail);
        customSnackbar(context: context, text: "UserDetails is received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error retrieving user detail: \n$e');
        print('Error retrieving user detail: $e');
        userDetail = {};
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  // Retrieve amounts from Firebase Firestore for the current user
  Future<bool> retrieveAmountsFromFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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
        db.editAmountDB(
          updated_CurrentBalance: int.tryParse(amountsList[currentBalanceD]),
          updated_TotalIncome: int.tryParse(amountsList[totalIncomeD]),
          updated_totalExpenses: int.tryParse(amountsList[totalExpensesD]),
          updated_TotalToPay: int.tryParse(amountsList[toPayD]),
          updated_TotalToReceive: int.tryParse(amountsList[toReceiveD]),
        );
        print(amountsList);
        print(db.amountsList);
        customSnackbar(context: context, text: "Amounts is received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
        return true;
      } catch (e) {
        customSnackbar(context: context, text: 'Error retrieving amounts: \n$e');
        print('Error retrieving amounts: $e');
        amountsList = {};
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
    }
  }

  // Retrieve accounts from Firebase Firestore for the current user
  Future<bool> retrieveAccountsFromFirebase(BuildContext context) async {
    if (await isInternetAvailable()) {
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
        db.deleteAccountDB();
        for (int i = 0; i < accountsList.length; i++) {
          db.addAccountDB(
              accountName: accountsList[i][accountNameD],
              amount: accountsList[i][accountCurrentBalanceD].runtimeType == String
                  ? int.tryParse(accountsList[i][accountCurrentBalanceD])
                  : accountsList[i][accountCurrentBalanceD]);
        }
        if (accountsList.isNotEmpty && db.AccountsList.isNotEmpty) {
          print(accountsList);
          customSnackbar(context: context, text: "Accounts is received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
          return true;
        } else {
          return false;
        }
      } catch (e) {
        customSnackbar(context: context, text: 'Error retrieving accounts: \n$e');
        print('Error retrieving accounts: $e');
        accountsList = [];
        return false;
      }
    } else {
      customSnackbar(context: context, text: "No Internet Available", icons: Icons.signal_wifi_statusbar_connected_no_internet_4);
      return false;
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
        String uniqueIdentifier = const Uuid().v4();

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
        String uniqueIdentifier = const Uuid().v4();

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
}





//4/8/2020 5.04

//  Future<void> retrieveAllDataFromFirebase(BuildContext context) async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         customSnackbar(context: context, text: "User not authenticated");
//         throw Exception('User not authenticated');
//       }

//       // Retrieve transaction data
//       await retrieveTransactionsFromFirebase(context);

//       // Retrieve user detail
//       await retrieveAmountsFromFirebase(context);

//       // Retrieve amounts data
//       await retrieveAmountsFromFirebase(context);

//       // Retrieve accounts data
//       await retrieveAccountsFromFirebase(context);

//       // Do something with the retrieved data...
//       if (transactionList.isNotEmpty && userDetail.isNotEmpty && amountsList.isNotEmpty && accountsList.isNotEmpty) {
//         print('Transaction Data: $transactionList');
//         print('User Data: $userDetail');
//         print('Amount Data: $amountsList');
//         print('Accounts Data: $accountsList');
//         customSnackbar(context: context, text: "All data is received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
//       }
//     } catch (e) {
//       customSnackbar(context: context, text: 'Error retrieving data from Firebase: \n$e');
//       print('Error retrieving data from Firebase: $e');
//     }
//   }










// 3/8/2023  11.23


// // function to save data to Firebase
//   Future<void> saveAllDataToFirebase(BuildContext context) async {
//     try {
//       // Check if user is authenticated
//       if (_userId == null) {
//         customSnackbar(context: context, text: "User not authenticated");
//         throw Exception('User not authenticated');
//       }

//       // Save transaction data
//       saveTransactionDataToFirebase(context);

//       // Save user detail
//       saveUserDetailToFirebase(context);

//       // Save amounts data
//       saveAmountsToFirebase(context);

//       // Save accounts data
//       saveAccountsToFirebase(context);

//       customSnackbar(context: context, text: "All Data is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
//     } catch (e) {
//       customSnackbar(context: context, text: 'Error saving data to Firebase: \n$e');
//       print('Error saving data to Firebase: $e');
//     }
//   }
  // Future<void> retrieveAllDataFromFirebase(BuildContext context) async {
  //   try {
  //     // Check if user is authenticated
  //     if (_userId == null) {
  //       customSnackbar(context: context, text: "User not authenticated");
  //       throw Exception('User not authenticated');
  //     }

  //     // Get references to the Firestore collections
  //     CollectionReference transactionsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(transactionsFD);
  // CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);
      // // CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD);
  //     CollectionReference amountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(amountsFD);
  //     CollectionReference accountsRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(accountsFD);

  //     // Retrieve transaction data
  //     QuerySnapshot transactionSnapshot = await transactionsRef.get();
  //     List<DocumentSnapshot> transactionDocuments = transactionSnapshot.docs;
  //     transactionList = transactionDocuments.map((transaction) => transaction.data() as Map<String, dynamic>).toList();

  //     // Retrieve user detail
  //     DocumentSnapshot userSnapshot = await usersRef.doc(_userId).get();
  //     userDetail = userSnapshot.data() as Map<String, dynamic>;

  //     // Retrieve amounts data
  //     DocumentSnapshot amountsSnapshot = await amountsRef.doc(amountsDocumentFD).get();
  //     amountsList = amountsSnapshot.data() as Map<String, dynamic>;

  //     // Retrieve accounts data
  //     QuerySnapshot accountSnapshot = await accountsRef.get();
  //     List<DocumentSnapshot> accountDocuments = accountSnapshot.docs;
  //     accountsList = accountDocuments.map((account) => account.data() as Map<String, dynamic>).toList();

  //     // Do something with the retrieved data...
  //     print('Transaction Data: $transactionList');
  //     print('User Data: $userDetail');
  //     print('Amount Data: $amountsList');
  //     print('Accounts Data: $accountsList');
  //     customSnackbar(context: context, text: "All data is received from Firebase cloud", icons: Icons.done_all, iconsColor: Colors.green);
  //   } catch (e) {
  //     customSnackbar(context: context, text: 'Error retrieving data from Firebase: \n$e');
  //     print('Error retrieving data from Firebase: $e');
  //   }
  // }


  // // // Save user detail to Firebase Firestore for the current user
  // Future<void> saveUserDetailToFirebase(BuildContext context) async {
  //   db.getUserDetailDB();
  //   userDetail = db.userDetail;
  //   try {
  //     // Check if user is authenticated
  //     if (_userId == null) {
  //       customSnackbar(context: context, text: "User not authenticated");
  //       throw Exception('User not authenticated');
  //     }

  //     // Convert keys and values to strings
  //     Map<String, dynamic> userDetailString = {};
  //     userDetail.forEach((key, value) {
  //       userDetailString[key.toString()] = value.toString();
  //     });

  //     // Get a reference to the Firestore collection for users
  //     CollectionReference usersRef = FirebaseFirestore.instance.collection(usersFD).doc(_userId).collection(userDetailsFD);

  //     // Save user detail document for the current user
  //     await usersRef.doc(_userId).set(userDetailString);
  //     customSnackbar(context: context, text: "UserData is saved to Firebase Cloud", icons: Icons.done_all, iconsColor: Colors.green);
  //   } catch (e) {
  //     customSnackbar(context: context, text: 'Error saving user detail: \n$e');
  //     print('Error saving user detail: $e');
  //   }
  // }
