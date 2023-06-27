import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wild_explorer/chatopenai/chat_widget.dart';
import 'package:wild_explorer/chatopenai/models/chat_model.dart';
import 'package:wild_explorer/services/api/api_service.dart';
import 'package:wild_explorer/services/openai/chat_service.dart';
import 'package:wild_explorer/services/openai/openai_model_provider.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key, this.initText});

  final String? initText;

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  bool _isTyping = false;

  late TextEditingController controller;
  late FocusNode focusNode;
  late ScrollController scrollController;

  List<ChatModel> chatList = [];

  @override
  void initState() {
    scrollController = ScrollController();
    controller = TextEditingController();
    focusNode = FocusNode();
    if (widget.initText != null) {
      controller.text = widget.initText!;
    }
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF343541),
      appBar: AppBar(
        elevation: 2,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: const Color(0xFF444654),
        title: const Text(
          'Asking question',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                await ChatService.showModalSheet(context: context);
              },
              icon: const Icon(
                Icons.more_vert_rounded,
                color: Colors.white,
              ))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    controller: scrollController,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      return ChatWidget(
                        msg: chatList[index].msg,
                        chatIndex: chatList[index].chatIndex,
                        scrollToEnd: () {
                          scrollListToEnd();
                        },
                      );
                    })),
            if (_isTyping) ...[
              const SpinKitThreeBounce(
                color: Colors.white,
                size: 18,
              ),
            ],
            const SizedBox(
              height: 15,
            ),
            Material(
              color: const Color(0xFF444654),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Consumer<OpenAIModelProvider>(
                          builder: (context, model, _) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onSubmitted: (value) async {
                            await sendMessageFCT(provider: model);
                          },
                          decoration: const InputDecoration(
                              hintText: "How can I help you?",
                              hintStyle: TextStyle(color: Colors.grey),
                              fillColor: Color(0xFF444654),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500),
                        );
                      }),
                    ),
                    Consumer<OpenAIModelProvider>(builder: (context, model, _) {
                      return IconButton(
                          onPressed: () async {
                            await sendMessageFCT(provider: model);
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ));
                    })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void scrollListToEnd() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
  }

  Future<void> sendMessageFCT({required OpenAIModelProvider provider}) async {
    String msg = controller.text;
    setState(() {
      _isTyping = true;
      chatList.add(ChatModel(msg: controller.text, chatIndex: 0));
      controller.clear();
      focusNode.unfocus();
    });
    try {
      chatList.addAll(await ApiService.sendMessage(
          message: msg, modelId: provider.getCurrentModel));
      setState(() {});
    } on Exception catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        scrollListToEnd();

        _isTyping = false;
      });
    }
  }
}
