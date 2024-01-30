import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_list_provider.g.dart';
@riverpod
class MyList extends _$MyList {
  @override
  List<String> build() => List.generate(20, (index) => "This is message $index")
      .reversed.toList();
  void add(String message) {
    state = [message, ...state];
  }
}