import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bag_application/cubit/states.dart';
import 'package:sqflite/sqflite.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  // Alert Dialog in home screen
  bool newBagDialogIsShown = false;
  void showNewBagAlertDialog() {
    newBagDialogIsShown = true;
    emit(AppShowAlertDialogState());
  }

  void removeNewBagAlertDialog() {
    newBagDialogIsShown = false;
    emit(AppRemoveAlertDialogState());
  }

  //Alert Dialog in Bag Screen
  bool bagItemDialogIsShown = false;
  void showBagItemAlertDialog() {
    bagItemDialogIsShown = true;
    emit(AppShowAlertDialogState());
  }

  void removeBagItemAlertDialog() {
    bagItemDialogIsShown = false;
    emit(AppRemoveAlertDialogState());
  }

  //Editing Alert Dialog in Bag Screen
  bool editItemDialogIsShown = false;
  void showEditingAlertDialog() {
    editItemDialogIsShown = true;
    emit(AppShowAlertDialogState());
  }

  void removeEditingAlertDialog() {
    editItemDialogIsShown = false;
    emit(AppRemoveAlertDialogState());
  }

  //Editing Alert Dialog in Bag Screen Ready to go alert dialog
  bool readyToGoDialogIsShown = false;
  void showReadyToGoAlertDialog() {
    readyToGoDialogIsShown = true;
    emit(AppShowAlertDialogState());
  }

  void removeReadyToGoAlertDialog() {
    readyToGoDialogIsShown = false;
    emit(AppRemoveAlertDialogState());
  }

  // A function to check if a title is repeated in the list before or not (checks if the title is found in the list ) form myBags and myTitles lists
  bool titleIsRepeated(List<Map> myList, newTitle, {required bool isBag}) {
    if (isBag) {
      for (Map value in myList) {
        if (value['BagTitle'] == newTitle) {
          print('repeated title');
          emit(AppEditingItemErrorState());
          return true;
        }
      }
    } else {
      for (Map value in myList) {
        if (value['ItemTitle'] == newTitle) {
          print('repeated title');

          emit(AppEditingItemErrorState());
          return true;
        }
      }
    }
    return false;
  }

  static int counter = 0;
  List<Map> myItemsIconColor = [];

  void giveInitialValueToIconColor() {
    counter = 0;
    for (int i = 0; i < myItems.length; i++) {
      Map<String, Color> element = {'Color': Colors.grey};
      myItemsIconColor.insert(i, element);
    }
  }

  void changeIconColor(myItemsIconColor, int index) {
    if (myItemsIconColor[index]['Color'] == Colors.grey) {
      myItemsIconColor[index]['Color'] = Colors.green;
      print('entered change to green');
      counter++;
    } else if (myItemsIconColor[index]['Color'] == Colors.green) {
      myItemsIconColor[index]['Color'] = Colors.grey;
      print('entered change to grey');
      counter--;
    }
    if (counter == myItems.length) {
      print('Your bag is done');
      showReadyToGoAlertDialog();
    }
    emit(AppChangeIconColorState());
  }

  late Database database;

  List<Map> myBags = [];
  List<Map> myItems = [];

  void createDatabase() async {
    database = await openDatabase('myDataBase.db', version: 1,
        onCreate: (Database db, int version) async {
      await db
          .execute(
              'CREATE TABLE myBags (id INTEGER PRIMARY KEY, BagTitle TEXT)')
          .then((value) {
        print('Database Created Successfully');
        emit(AppCreateDatabaseSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(AppCreateDatabaseErrorState());
      });
    }, onOpen: (Database db) async {
      getFromDatabase(db, 'myBags', isBag: true);
    }).then((value) {
      database = value;
      print('Database opened Successfully');
      emit(AppOpenDatabaseSuccessState());
      return value;
    }).catchError((error) {
      print('${error.toString()}');
      emit(AppOpenDatabaseErrorState());
    });
  }

  // gets all data in a specific table (tableName) and puts in in mybags or myItems

  void getFromDatabase(
    Database database,
    String tableName, {
    required isBag,
  }) async {
    if (isBag) {
      myBags = await database.rawQuery('SELECT * FROM myBags');
      print('The Bags List Filled Successfully');
      emit(AppGetBagsListState());
    } else {
      myItems = await database.rawQuery('SELECT * FROM "$tableName"');
      print('The Items List Filled');
      emit(AppGetItemsListState());
      giveInitialValueToIconColor();
    }
    emit(AppGetListState());
  }

  // // The methods of bags in the home layout using the database
  void insertNewBag({required String bagTitle}) async {
    await database.transaction((txn) async {
      await txn.rawInsert('INSERT INTO myBags (BagTitle) VALUES ("$bagTitle")');
    }).then((value) {
      print('$bagTitle Added to myBags table');
      emit(AppNewBagInsertedDatabaseSuccessState());
      database
          .execute(
              'CREATE TABLE  "${bagTitle.toString()}" (itemID INTEGER PRIMARY KEY, ItemTitle TEXT)')
          .then((value) {
        print('$bagTitle Table have been created');
        emit(AppNewBagTableCreatedSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(AppNewBagTableCreatedErrorState());
      });
      removeNewBagAlertDialog();
      myItems = [];
      getFromDatabase(database, 'myBags', isBag: true);
    }).catchError((error) {
      print(error.toString());
      emit(AppNewBagInsertedDatabaseErrorState());
    });
  }

  void insertNewBagItemInBag(
      {required String bagTitle, required String itemName}) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          "INSERT INTO '$bagTitle' (ItemTitle) VALUES ('$itemName')");
      // print('the id of the new item: $count');
    }).then((value) {
      removeBagItemAlertDialog();
      print('New Item named:$itemName inserted into Bag: $bagTitle');
      emit(AppInsertItemDatabaseSuccessState());
      getFromDatabase(database, bagTitle, isBag: false);
      giveInitialValueToIconColor();
    }).catchError((error) {
      print(error.toString());
      emit(AppInsertErrorDatabaseState());
    });
  }

  void updateItemName(int index, String newValue, String bagTitle) async {
    String oldItemName = myItems[index]['ItemTitle'];
    print(index);

    await database.rawUpdate(
        'UPDATE "$bagTitle" SET ItemTitle = ? WHERE itemID = ?',
        ['$newValue', index + 1]).then((value) {
      print('$oldItemName updated successfully to $newValue');
      emit(AppUpdateItemNameSuccessState());
      getFromDatabase(database, bagTitle, isBag: false);
      print('In the Item List ${myItems[index]['ItemTitle']}');
    }).catchError((error) {
      print(error.toString());
      emit(AppUpdateItemNameErrorState());
    });
    editItemDialogIsShown = false;
  }

  void deleteBag({required String bagTitle}) async {
    await database.rawDelete(
        'DELETE FROM myBags WHERE bagTitle = ?', ["$bagTitle"]).then((value) {
      print('the bag $bagTitle deleted from bags');
      emit(AppBagDeletedFromBagsSuccessState());
      getFromDatabase(database, 'myBags', isBag: true);
    }).catchError((error) {
      print(error.toString());
      emit(AppBagDeletedFromBagsErrorState());
    });
    // "DROP TABLE IF EXISTS tableName
    await database.execute('DROP TABLE IF EXISTS "$bagTitle"').then((value) {
      print('the bag table $bagTitle deleted');
      emit(AppBagTableDeletedSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AppBagTableDeletedErrorState());
    });
  }

  void deleteBagItem(
      {required String bagTitle, required String itemTitle}) async {
    await database.rawDelete('DELETE FROM "$bagTitle" WHERE ItemTitle = ?',
        ["$itemTitle"]).then((value) {
      print('the bag item $itemTitle deleted from the bag $bagTitle');
      emit(AppDeleteItemFromBagSuccessState());
      getFromDatabase(database, bagTitle, isBag: false);
    }).catchError((error) {
      print(error.toString());
      emit(AppDeleteItemFromBagErrorState());
    });
  }

  void editBagName({required String bagOldName, required String bagNewName}) {
    getFromDatabase(database, bagOldName, isBag: true);
    print(myItems);
  }
}
