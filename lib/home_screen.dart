import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_bag_application/cubit/cubit.dart';
import 'package:my_bag_application/cubit/states.dart';
import 'package:my_bag_application/custom_widgets.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController bagTitleController = TextEditingController(
      // text: 'Enter Bag Title',
      );

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (BuildContext context, AppStates state) {},
      builder: (BuildContext context, AppStates state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('My Bags'),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              myListView(
                  cubit: cubit,
                  itemBuilder: (BuildContext context, int index) =>
                      myRowBag(context, cubit, index),
                  itemCount: cubit.myBags.length),
              myConditionalBuilder(
                condition: cubit.newBagDialogIsShown,
                builder: myAlertDialog(
                  context: context,
                  cubit: cubit,
                  formKey: formKey,
                  titleController: bagTitleController,
                  dialogTitle: 'Add New Bag',
                  labelText: 'Enter Bag Title',
                  isForm: true,
                  isDone: false,
                  list: cubit.myBags,
                  isBag: true,
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        alertDialogTextButton(
                          buttonName: 'Cancel',
                          buttonFunction: () {
                            cubit.removeNewBagAlertDialog();
                          },
                        ),
                        alertDialogTextButton(
                          buttonName: 'Create',
                          buttonFunction: () {
                            if (formKey.currentState!.validate()) {
                              cubit.insertNewBag(
                                  bagTitle: bagTitleController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                fallback: SizedBox(height: 0),
              ),
            ],
          ),
          floatingActionButton: myConditionalBuilder(
            condition: cubit.newBagDialogIsShown,
            builder: SizedBox(width: 0),
            fallback: FloatingActionButton(
              onPressed: () {
                cubit.showNewBagAlertDialog();
              },
              child: Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }
}
