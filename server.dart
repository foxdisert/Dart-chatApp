import 'dart:io';

class ClientInfo {
  final Socket socket;
  String username;

  ClientInfo(this.socket, {this.username = "Unknown"});
}

final List<ClientInfo> clients = [];

void main() async {
  final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
  print("✅ Server running on ${server.address.address}:${server.port}");

  await for (Socket socket in server) {
    final client = ClientInfo(socket);
    clients.add(client);

    print("👤 A client connected");

    socket.listen(
      (data) {
        String message = String.fromCharCodes(data).trim();

        if (message.startsWith("USERNAME:")) {
          client.username = message.substring(9).trim();
          print("✅ Username set: ${client.username}");
          return;
        }

        if (message.startsWith("MSG:")) {
          String text = message.substring(4).trim();
          print("${client.username}: $text");

          for (var c in clients) {
            if (c.socket != socket) {
              c.socket.write("${client.username}: $text\n");
            }
          }
        }
      },
      onDone: () {
        print("❌ ${client.username} disconnected");
        clients.remove(client);
      },
    );
  }
}
