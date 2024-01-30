class ChatService {
  Future<void> init() async {

  }

  Future<List<String>> list() async {
    return Future<List<String>>.delayed(Duration(seconds: 5), () =>
        List.generate(20, (index) => "This is message $index")
        .reversed.toList());
  }

  Future<String> send(String message) async {
    return Future<String>.delayed(Duration(seconds: 5),
            () => "response for $message");
  }
}