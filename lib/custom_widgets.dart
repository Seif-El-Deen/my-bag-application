import 'package:flutter/material.dart';
import 'package:my_bag_application/bag_screen.dart';
import 'package:my_bag_application/cubit/cubit.dart';

Widget myDivider() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 1,
        color: Colors.grey,
      ),
    );

Widget myRowBag(BuildContext context, AppCubit cubit, int index) {
  return Dismissible(
    key: Key(cubit.myBags[index]['BagTitle']),
    onDismissed: (direction) {
      cubit.deleteBag(bagTitle: cubit.myBags[index]['BagTitle']);
    },
    background: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              Icons.restore_from_trash,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Delete Bag',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'Delete Bag',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.restore_from_trash,
              color: Colors.black,
            ),
          ],
        ),
      ),
    ),
    child: InkWell(
      onTap: () {
        cubit.getFromDatabase(cubit.database, cubit.myBags[index]['BagTitle'],
            isBag: false);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BagScreen(cubit.myBags[index]['BagTitle'])));
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green[100],
            child: Text(
              'Bag ${index + 1}',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            '${cubit.myBags[index]['BagTitle']}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Container(
          //   width: 170,
          //   child: Text(
          //     '${cubit.myBags[index]['BagTitle']}',
          //     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          //     textAlign: TextAlign.center,
          //     maxLines: 2,
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
          // Spacer(),
          // IconButton(
          //   onPressed: () {
          //     secondaryBagName = cubit.myBags[index]['BagTitle'];
          //     cubit.editBagName(
          //         bagOldName: secondaryBagName, bagNewName: 'hello');
          //     print(secondaryBagName);
          //   },
          //   icon: Icon(
          //     Icons.edit,
          //     color: Colors.grey,
          //     size: 50,
          //   ),
          // ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    ),
  );
}

Widget myRowItem(TextEditingController itemTitleController, AppCubit cubit,
    int index, String bagTitle) {
  return Dismissible(
    key: UniqueKey(),
    onDismissed: (direction) {
      cubit.deleteBagItem(
          bagTitle: bagTitle, itemTitle: cubit.myItems[index]['ItemTitle']);
    },
    behavior: HitTestBehavior.opaque,
    background: Container(
      color: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              Icons.restore_from_trash,
              color: Colors.black,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Delete Item',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              'Delete Item',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.restore_from_trash,
              color: Colors.black,
            ),
          ],
        ),
      ),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green[100],
          child: Text(
            'Item ${index + 1}',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          width: 25,
        ),
        Container(
          width: 120,
          child: Text(
            '${cubit.myItems[index]['ItemTitle']}',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            itemTitleController.text = cubit.myItems[index]['ItemTitle'];
            BagScreen.editedIndex = index;
            cubit.showEditingAlertDialog();
          },
          icon: Icon(
            Icons.edit_outlined,
            color: Colors.grey,
            size: 50,
          ),
        ),
        Spacer(),
        IconButton(
          onPressed: () {
            cubit.changeIconColor(cubit.myItemsIconColor, index);
            print('change icon color button');
          },
          icon: Icon(
            Icons.check_circle,
            color: cubit.myItemsIconColor[index]['Color'],
            size: 50,
          ),
        ),
        Spacer(),
      ],
    ),
  );
}

Widget alertDialogTextButton(
        {required String buttonName, required buttonFunction}) =>
    TextButton(
      onPressed: buttonFunction,
      child: Text(
        '$buttonName',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

// I created this conditional builder because the conditional builder package is not supported with the flutter update (null  safety)
Widget myConditionalBuilder(
    {required bool condition,
    required Widget builder,
    required Widget fallback}) {
  if (condition) {
    return builder;
  } else {
    return fallback;
  }
}

Widget myAlertDialog({
  required BuildContext context,
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required AppCubit cubit,
  required List<Widget> actions,
  required String dialogTitle,
  required String labelText,
  required bool isForm,
  required bool isDone,
  required bool isBag,
  required List<Map> list,
}) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    color: Colors.black.withOpacity(0.6),
    child: AlertDialog(
      title: Text(
        '$dialogTitle',
        textAlign: TextAlign.center,
      ),
      content: myAlertDialogContent(
        cubit: cubit,
        titleController: titleController,
        labelText: labelText,
        formKey: formKey,
        isDone: isDone,
        isForm: isForm,
        list: list,
        isBag: isBag,
      ),
      actions: actions,
    ),
  );
}

Widget myAlertDialogContent({
  required GlobalKey<FormState> formKey,
  required TextEditingController titleController,
  required AppCubit cubit,
  required String labelText,
  required bool isForm,
  required bool isDone,
  required bool isBag,
  required List<Map> list,
}) {
  if (isForm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            controller: titleController,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.green[800],
            ),
            decoration: InputDecoration(
              labelText: labelText,
            ),
            validator: (String? value) {
              if (value!.isEmpty) {
                if (isBag)
                  return 'Bag Title must not be empty';
                else
                  return 'Item Title must not be empty';
              }
              if (cubit.titleIsRepeated(list, titleController.text,
                  isBag: isBag)) {
                if (isBag)
                  return 'Can\'t have two bags with the same name';
                else
                  return 'Can\'t have two Items with the same name';
              }
            },
          ),
        )
      ],
    );
  } else if (isDone) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle_outline,
          size: 80,
          color: Colors.green,
        ),
        SizedBox(
          height: 5,
        ),
        Text('You Forget Nothing'),
      ],
    );
  } else
    return Container();
}

Widget myListView(
        {required AppCubit cubit,
        required int itemCount,
        required Widget Function(BuildContext, int index) itemBuilder}) =>
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: itemBuilder,
        separatorBuilder: (BuildContext context, int index) => myDivider(),
        itemCount: itemCount,
      ),
    );
