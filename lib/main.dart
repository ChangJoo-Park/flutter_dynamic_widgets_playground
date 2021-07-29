import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/basic/dynamic_widget_json_exportor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: AppBarTheme(color: Colors.black87)),
      home: MyHomePage(title: 'Dynamic Widget Playground'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  late DynamicWidgetJsonExportor _exportor;

  var _json = '''
{
  "type": "Container",
  "alignment": "center",
  "child": {
    "type": "ElevatedButton",
    "padding": "16,16,16,16",
    "click_event" : "route://productDetail?goods_id=123",
    "child" : {
      "type": "Text",
      "data": "I am a button"
    }
  }
}
''';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: constraints,
                      child: IntrinsicHeight(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          color: Colors.black,
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              initialValue: _json,
                              onSaved: (String? value) {
                                setState(() => _json = value!);
                              },
                              style: TextStyle(
                                  color: Colors.green,
                                  fontFamily: 'CascadiaCode'),
                              cursorColor: Colors.white,
                              cursorWidth: 8,
                              enableSuggestions: false,
                              autofocus: true,
                              scrollPadding: const EdgeInsets.all(16),
                              showCursor: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                              ),
                              maxLines: 9999,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width / 2 * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 8,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(16)),
                child: Center(
                  child: FutureBuilder<Widget?>(
                    future: _buildWidget(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<Widget?> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("에러")));
                        return Container(
                            child: Text(snapshot.error.toString()));
                      }
                      return snapshot.hasData
                          ? _exportor = DynamicWidgetJsonExportor(
                              child: snapshot.data,
                            )
                          : Text("Loading...");
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          formKey.currentState!.save();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Future<Widget?> _buildWidget(BuildContext context) async {
    return DynamicWidgetBuilder.build(_json, context, DefaultClickListener());
  }
}

class DefaultClickListener implements ClickListener {
  @override
  void onClicked(String? event) {
    print(event);
  }
}
