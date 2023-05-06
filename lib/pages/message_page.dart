import 'package:flutter/material.dart';

class MessagePages extends StatefulWidget {
  @override
  _MessagePagesState createState() => _MessagePagesState();
}

class _MessagePagesState extends State<MessagePages> {
  final TextEditingController _textEditingController = TextEditingController();
  List<String> _messages = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tin nhắn'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _messages[index],
                    style: TextStyle(fontSize: 16),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Nhập nội dung tin nhắn tại đây',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _messages.add(_textEditingController.text);
                      _textEditingController.clear();
                    });
                  },
                  child: Text('Gửi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
