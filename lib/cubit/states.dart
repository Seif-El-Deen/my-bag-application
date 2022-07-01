abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppShowAlertDialogState extends AppStates {}

class AppRemoveAlertDialogState extends AppStates {}

class AppCreateDatabaseState extends AppStates {}

class AppCreateDatabaseSuccessState extends AppStates {}

class AppCreateDatabaseErrorState extends AppStates {}

class AppOpenDatabaseSuccessState extends AppStates {}

class AppOpenDatabaseErrorState extends AppStates {}

class AppGetBagsListState extends AppStates {}

class AppGetItemsListState extends AppStates {}

class AppGetListState extends AppStates {}

class AppNewBagInsertedDatabaseSuccessState extends AppStates {}

class AppNewBagInsertedDatabaseErrorState extends AppStates {}

class AppNewBagTableCreatedSuccessState extends AppStates {}

class AppNewBagTableCreatedErrorState extends AppStates {}

class AppInsertItemDatabaseSuccessState extends AppStates {}

class AppInsertErrorDatabaseState extends AppStates {}

class AppUpdateItemNameSuccessState extends AppStates {}

class AppUpdateItemNameErrorState extends AppStates {}

class AppBagDeletedFromBagsSuccessState extends AppStates {}

class AppBagDeletedFromBagsErrorState extends AppStates {}

class AppBagTableDeletedSuccessState extends AppStates {}

class AppBagTableDeletedErrorState extends AppStates {}

class AppDeleteItemFromBagSuccessState extends AppStates {}

class AppDeleteItemFromBagErrorState extends AppStates {}

class AppChangeIconColorState extends AppStates {}

class AppEditingItemErrorState extends AppStates {}
