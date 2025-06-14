import 'package:flutter/material.dart';

class CenteredListView extends StatefulWidget {
  @override
  _CenteredListViewState createState() => _CenteredListViewState();
}

class _CenteredListViewState extends State<CenteredListView> {
  final ScrollController _scrollController = ScrollController();
  final List<String> items = List.generate(20, (index) => 'Item ${index + 1}');
  int _centerIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCenterIndex);
  }

  void _updateCenterIndex() {
    double centerOffset = _scrollController.offset + (MediaQuery.of(context).size.height / 4);
    int newIndex = (centerOffset / 300).floor();
    if (newIndex != _centerIndex) {
      setState(() => _centerIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateCenterIndex);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Centered ListView')),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: items.length,
        padding: EdgeInsets.symmetric(vertical: 20),
        itemBuilder: (context, index) {
          bool isCentered = index == _centerIndex;
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: 300,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              color: isCentered ? Colors.blueAccent : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: isCentered
                  ? [BoxShadow(color: Colors.blue.withOpacity(0.5), blurRadius: 15, spreadRadius: 2)]
                  : [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            alignment: Alignment.center,
            child: Text(
              items[index],
              style: TextStyle(
                fontSize: isCentered ? 26 : 20,
                fontWeight: isCentered ? FontWeight.bold : FontWeight.normal,
                color: isCentered ? Colors.white : Colors.black87,
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: CenteredListView()));
}
