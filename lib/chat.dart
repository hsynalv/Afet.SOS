import 'dart:convert';
import 'dart:io';
import 'package:chat_app/devices.dart';
import 'package:chat_app/dm_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/io.dart';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

import 'message_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Map<String, dynamic> jsonAsString = Map<String, dynamic>();

  Map<String, dynamic> receivedDataFor = Map<String, dynamic>();

  final TextEditingController _controller = TextEditingController();
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.4.1/chat'),
  );

  List<types.Message> _messages = [];
  final _user = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3ac',
  );

  final _user2 = const types.User(
    id: '82091008-a484-4a89-ae75-a22bf8d6f3gh',
  );

  void initState() {
    super.initState();
    _loadMessages();
    _channel.stream.listen((data) {
      _handleReceivedData(data);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text("Afet SOS"),
          centerTitle: true,
          backgroundColor: Color(0xff262626),
          leading: Padding(
            padding: const EdgeInsets.only(left: 50),
            child: IconButton(
              onPressed: () {},
              color: Colors.red,
              icon: Icon(
                Icons.notifications,
                size: 40,
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 5, top: 5),
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.black26)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Devices()),
                    );
                  },
                  child: const Text(
                    "Direkt Mesaj" " >",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
        body: Chat(
          messages: _messages,
          onMessageTap: _handleMessageTap,
          onPreviewDataFetched: _handlePreviewDataFetched,
          onSendPressed: _handleSendPressed,
          showUserAvatars: true,
          showUserNames: true,
          user: _user,
          avatarBuilder: (user) {
            if (user == _user) {
              // Kullanıcı avatarını burada oluşturun (örneğin kullanıcının profil resmi)
              return CircleAvatar(
                backgroundImage: AssetImage('assets/user_avatar.png'),
              );
            } else {
              // Karşı taraftan gelen kullanıcının avatarını burada oluşturun
              return CircleAvatar(
                backgroundImage: AssetImage('assets/other_user_avatar.png'),
                backgroundColor: Colors.white,
              );
            }
          },
        ),
      );

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: true,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final index =
              _messages.indexWhere((element) => element.id == message.id);
          final updatedMessage =
              (_messages[index] as types.FileMessage).copyWith(
            isLoading: null,
          );

          setState(() {
            _messages[index] = updatedMessage;
          });
        }
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final index = _messages.indexWhere((element) => element.id == message.id);
    final updatedMessage = (_messages[index] as types.TextMessage).copyWith(
      previewData: previewData,
    );

    setState(() {
      _messages[index] = updatedMessage;
    });
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
    jsonAsString.addAll({"id": 123456});
    jsonAsString.addAll({
      "source": {"id": 1, "name": "Flutter"}
    });
    jsonAsString.addAll({"route_id": -1});
    jsonAsString.addAll({
      "action": {"type": 18, "ext": 34}
    });

    jsonAsString.addAll({
      "data": [
        {
          "source": {"id": 1, "name": "Flutter"},
          "data": textMessage.text
        }
      ]
    });

    _channel.sink.add(jsonEncode(jsonAsString));
  }

  void _handleReceivedData(dynamic receivedData) {
    final parsedData = MessageModel.fromJson(jsonDecode(receivedData));

    final textMessage = types.TextMessage(
      author: _user2,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: parsedData.data?.first?.data ?? '',
    );
    _addMessage(textMessage);

    // JSON verisini assets/messages.json dosyasına kaydetmek
    final jsonData = jsonEncode(parsedData.toJson());
    //final filePath = 'assets/messages.json';
    //final file = File(filePath);
    //file.writeAsString(jsonData);
  }

  void _loadMessages() async {
    final response = await rootBundle.loadString('assets/messages.json');
    final messages = (jsonDecode(response));

    setState(() {
      _messages = messages;
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }
}
