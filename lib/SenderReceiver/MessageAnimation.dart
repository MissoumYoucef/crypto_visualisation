import 'package:flutter/material.dart';
import 'sender.dart';
import 'receiver.dart';

// ignore: use_key_in_widget_constructors
class MessageAnimation extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MessageAnimationState createState() => _MessageAnimationState();
}

class _MessageAnimationState extends State<MessageAnimation> {
  bool _isMessageSent = false;
  var sender = Sender();
  var receiver = Receiver();
  String message = "Hi you can Send \n a message Now";
  late String secretKet;
  late String mac;
  String SendMessage = "Hi you can Send \n a message Now";
  late String editedMessage;
  double _messageLeft = 20;
  double _messageTop = 100;
  Duration _animationDuration = const Duration(seconds: 6);

  void _animateMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter a message'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Message',
                ),
                onChanged: (value) {
                  message = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'SecretKey for Hashing',
                ),
                onChanged: (value) {
                  secretKet = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                // Add code to send the message here
                mac = sender.sendMessage(secretKet, message);
                SendMessage = "$message\n MAC:$mac";
                setState(() {
                  _isMessageSent = !_isMessageSent;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _stopAnimation() {
    setState(() {
      //_animationDuration = Duration.zero;
      //_messageLeft = _isMessageSent ? _messageLeft : 800;
      //_messageTop = _isMessageSent ? _messageTop : 100;
      _isMessageSent = false;
    });
  }

  void _resumeAnimation() {
    setState(() {
      _isMessageSent = true;
      _animationDuration = const Duration(seconds: 6);
    });
  }

  void _animateMessage2() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String editedMessage = message;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Modify the message'),
            content: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Message',
              ),
              initialValue: message,
              onChanged: (value) {
                editedMessage = value;
              },
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Send'),
                onPressed: () {
                  setState(() {
                    message = editedMessage;
                    SendMessage = '$editedMessage\nMAC:$mac';
                    _resumeAnimation();
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      },
    );
  }

  void _verifyMessage(String secretKey, String message, String mac) {
    bool isReceived = receiver.receiveMessage(secretKey, message, mac);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message Verification'),
          content: Text(
            isReceived ? 'Message not modified!' : 'Message modified',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Activity3')),
      body: Stack(
        children: [
          const Positioned(
              left: 30,
              bottom: 80,
              child: Text(
                'Please Make sure you have the full screen Size',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          const Positioned(
              left: 30,
              bottom: 50,
              child: Text(
                'Please refrech the page to send again',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )),
          Positioned(
            right: 450,
            left: 450,
            top: 50,
            child: Column(
              children: [
                const Text("Send"),
                FloatingActionButton(
                  heroTag: 'btn1',
                  onPressed: _animateMessage,
                  child: const Icon(Icons.send_outlined),
                ),
              ],
            ),
          ),
          Positioned(
            left: 450,
            right: 450,
            bottom: 200,
            child: Column(
              children: [
                const Text('       Stop and      \nModify the message'),
                FloatingActionButton(
                  heroTag: 'btn2',
                  onPressed: () {
                    _stopAnimation();
                    _animateMessage2();
                  },
                  child: const Icon(Icons.mode_edit),
                ),
              ],
            ),
          ),
          AnimatedPositioned(
            right: _isMessageSent ? _messageLeft : 1200,
            top: 200,
            duration: _animationDuration,
            curve: Curves.easeInOut,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: _animationDuration,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  SendMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 200,
            bottom: 200,
            child: Column(
              children: [
                const Text("Receiver"),
                const Icon(Icons.person, size: 50),
                ElevatedButton(
                    onPressed: () {
                      _verifyMessage(secretKet, message, mac);
                    },
                    child: const Text('verify the integrity'))
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 200,
            bottom: 200,
            child: Column(
              children: const [
                Text("Sender"),
                Icon(Icons.person, size: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
