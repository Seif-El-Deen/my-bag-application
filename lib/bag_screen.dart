import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bag_application/cubit/cubit.dart';
import 'package:my_bag_application/cubit/states.dart';
import 'package:my_bag_application/custom_widgets.dart';

class BagScreen extends StatelessWidget {
  final String title;
  var formKey = GlobalKey<FormState>();
  final TextEditingController itemTitleController = TextEditingController(
      // text: 'Enter Item Title',
      );
  late Color iconColor;

  static int editedIndex = 0;

  BagScreen(this.title);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('$title'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              myListView(
                cubit: cubit,
                itemCount: cubit.myItems.length,
                itemBuilder: (BuildContext context, int index) =>
                    myRowItem(itemTitleController, cubit, index, title),
              ),
              myConditionalBuilder(
                condition: cubit.bagItemDialogIsShown,
                builder: myAlertDialog(
                  context: context,
                  formKey: formKey,
                  titleController: itemTitleController,
                  cubit: cubit,
                  isForm: true,
                  isDone: false,
                  list: cubit.myItems,
                  isBag: false,
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        alertDialogTextButton(
                          buttonName: 'Cancel',
                          buttonFunction: () {
                            cubit.removeBagItemAlertDialog();
                          },
                        ),
                        alertDialogTextButton(
                          buttonName: 'Add',
                          buttonFunction: () {
                            if (formKey.currentState!.validate()) {
                              cubit.insertNewBagItemInBag(
                                  bagTitle: title,
                                  itemName: itemTitleController.text);
                              itemTitleController.text = '';
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                  dialogTitle: 'Add New Item',
                  labelText: 'Enter Item Title',
                ),
                fallback: SizedBox(height: 0),
              ),
              myConditionalBuilder(
                condition: cubit.editItemDialogIsShown,
                builder: myAlertDialog(
                    context: context,
                    formKey: formKey,
                    titleController: itemTitleController,
                    cubit: cubit,
                    isForm: true,
                    isDone: false,
                    isBag: false,
                    list: cubit.myItems,
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          alertDialogTextButton(
                            buttonName: 'Cancel',
                            buttonFunction: () {
                              cubit.removeEditingAlertDialog();
                            },
                          ),
                          alertDialogTextButton(
                            buttonName: 'Edit',
                            buttonFunction: () {
                              if (formKey.currentState!.validate()) {
                                cubit.updateItemName(editedIndex,
                                    itemTitleController.text, title);
                              }
                            },
                          ),
                        ],
                      )
                    ],
                    dialogTitle: 'Edit Item Name',
                    labelText: 'Edit item name'),
                fallback: SizedBox(height: 0),
              ),
              myConditionalBuilder(
                condition: cubit.readyToGoDialogIsShown,
                builder: myAlertDialog(
                    context: context,
                    formKey: formKey,
                    titleController: itemTitleController,
                    cubit: cubit,
                    isDone: true,
                    isForm: false,
                    isBag: false,
                    list: cubit.myItems,
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          alertDialogTextButton(
                            buttonName: 'Done',
                            buttonFunction: () {
                              cubit.removeReadyToGoAlertDialog();
                              cubit.giveInitialValueToIconColor();
                            },
                          ),
                        ],
                      )
                    ],
                    dialogTitle: 'Your Bag is ready',
                    labelText: 'You Forget Nothing'),
                fallback: SizedBox(height: 0),
              ),
            ],
          ),
          floatingActionButton: myConditionalBuilder(
            condition: cubit.bagItemDialogIsShown,
            builder: SizedBox(width: 0),
            fallback: FloatingActionButton(
              onPressed: () {
                cubit.showBagItemAlertDialog();
              },
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
