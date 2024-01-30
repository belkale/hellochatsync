import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:projects/chat_service_provider.dart';
import 'my_list_provider.dart';

class MyHomePage extends ConsumerWidget {
  final String title;
  final TextEditingController messageController = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  MyHomePage({required this.title, super.key});

  void _sendMessage(WidgetRef ref) async {
    final message = messageController.text;
    ref.read(myListProvider.notifier).add(message);
    messageController.clear();
    myFocusNode.requestFocus();
    _asyncResponse(ref, message);
  }

  void _asyncResponse(WidgetRef ref, String message) async {
    final chatService = ref.read(chatServiceProvider);
    final response = await chatService.send(message);
    ref.read(myListProvider.notifier).add(response);
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(myListProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Expanded(
              child: switch(itemsAsync) {
                AsyncError(:final error) => Text('Error: $error'),
                AsyncData(:final value) => ListView.builder(
                    reverse: true,
                    itemCount: value.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        value[index],
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    )),
                _ => const CircularProgressIndicator(),
              },
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
