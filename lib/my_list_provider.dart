import 'package:projects/chat_service_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_list_provider.g.dart';
@riverpod
class MyList extends _$MyList {
  @override
  Future<List<String>>build() async {
    final chatService = ref.read(chatServiceProvider);
    return await chatService.list();
  }
  void add(String message) {
    state = state.whenData((value) => [message, ...value]);
  }
}