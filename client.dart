import 'dart:io';

void main() async {
  final socket = await Socket.connect('10.30.51.166', 3000);
  print('✅ Connected to chat server!');

  stdout.write("Enter your name: ");
  String? name = stdin.readLineSync();

  if (name == null || name.trim().isEmpty) {
    name = "Unknown";
  }

  socket.write("USERNAME:$name\n");

  socket.listen(
    (data) {
      print(String.fromCharCodes(data).trim());
    },
    onDone: () {
      print("❌ Server closed connection");
      exit(0);
    },
  );

  stdin.listen((data) {
    String msg = String.fromCharCodes(data).trim();
    socket.write("MSG:$msg\n");
  });
}
