import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';
import '../models/createdBy.dart';
import '../models/message.dart';
import '../models/user.dart';
import 'package:flutter/material.dart';

class ChatProvider with ChangeNotifier {
  final CollectionReference _chatsCollectionReference =
      Firestore.instance.collection('chats');

  Chat _singleChat;
  Chat get getSingleChat => _singleChat;

  Stream<QuerySnapshot> getChatSnapShot(String uid) {
    return _chatsCollectionReference
        .document(uid)
        .collection("chat_history")
        .orderBy("createTimestamp", descending: true)
        .limit(30)
        .snapshots();
  }

  Stream<QuerySnapshot> getAllChatsSnapShot() {
    return _chatsCollectionReference.limit(30).snapshots();
  }

  Future createNewChatRoomForUser(User user) async {
    try {
      await _chatsCollectionReference.document(user.id).setData(new Chat(
            createdBy:
                CreatedBy(name: user.name, userId: user.id, type: user.type),
            name: "${user.name} Chat Room",
            active: true,
            createTimestamp: FieldValue.serverTimestamp(),
            lastMessage: Message(
                createTimestamp: FieldValue.serverTimestamp(),
                message: "",
                type: "Doctor",
                userId: "",
                userName: "Empty"),
          ).toJson());
    } catch (e) {
      return e.message;
    }
  }

  Future<void> fetchAndSetChat(String uid) async {
    try {
      var chatData = await _chatsCollectionReference.document(uid).get();
      _singleChat = Chat.fromJson(chatData.data);
      notifyListeners();
    } catch (e) {
      return e.message;
    }
  }

  Future<void> sendMessage(Message message, String uid) async {
    try {
      await _chatsCollectionReference
          .document(uid)
          .collection("chat_history")
          .add(message.toJson());
      await fetchAndSetChat(uid);
      this._singleChat.lastMessage = message;
      await _chatsCollectionReference
          .document(uid)
          .updateData(_singleChat.toJson());
    } catch (e) {
      return e.message;
    }
  }
}
