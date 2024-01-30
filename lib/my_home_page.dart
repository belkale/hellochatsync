import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'my_list_provider.dart';

class MyHomePage extends ConsumerWidget {
  final String title;
  final TextEditingController messageController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  MyHomePage({required this.title, super.key});

  void _sendMessage(WidgetRef ref) async {
    ref.read(myListProvider.notifier).add(messageController.text);
    messageController.clear();
    myFocusNode.requestFocus();
    _asyncResponse(ref);
  }

  void _asyncResponse(WidgetRef ref) async {
    await Future.delayed(Duration(seconds: 5));
    ref.read(myListProvider.notifier).add("Response from server");
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(myListProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemCount: items.length,
                  itemBuilder: (context, index) => items.length <= index? null : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      items[index],
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  )),
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onSubmitted: (message) => _sendMessage(ref),
                      focusNode: myFocusNode,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () => _sendMessage(ref),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}
