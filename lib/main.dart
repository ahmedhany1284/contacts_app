import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:  MyHomePage(),
      routes: {
        '/new-contact':(context)=>const _NewContactView()
      },
    );
  }
}

class Contact {
  final String id;
  final String name;
  Contact({required this.name}):id=const Uuid().v4();
}

class ContactsBook extends ValueNotifier<List<Contact>> {
  ContactsBook._sharedInstance() : super([
  ]);
  static final ContactsBook _shared = ContactsBook._sharedInstance();
  factory ContactsBook() => _shared;

  final List<Contact> _contact = [
     Contact (name: 'ahmed HANY'),
  ];

  int get length => value.length;

  void add({required Contact contact}){
    final contacts=value;
    contacts.add(contact);
    value=contacts;
    notifyListeners();
  }
  void remove({required Contact  contact}) {
    final contacts=value;
    if(contacts.contains(contact)){
      contacts.remove(contact);
      notifyListeners();
    }
  }

  Contact ? contact ({required int atIndx}) =>
      value.length > atIndx ? value[atIndx] : null;
}

class MyHomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final ValueListenableBuilder builder;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home Page')),
      ),
      body:ValueListenableBuilder(
        valueListenable: ContactsBook(),
        builder: (context,value,child){
          final contacts= value as List<Contact>;
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context,index){
              final contact =contacts[index];
              return Dismissible(
                onDismissed: (direction){
                  ContactsBook().remove(contact: contact);
                },
                key: ValueKey(contact.id),
                child: Material(

                  color: Colors.grey[300],
                  elevation: 6.0,
                  child: ListTile(
                    title: Text(contact.name),
                  ),
                ),
              );
            },
          );
        },
      ) ,
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await Navigator.of(context).pushNamed('/new-contact');
        },
        child: Icon(Icons.add),
      ),
    );

  }
  
}
class _NewContactView extends StatefulWidget {
  const _NewContactView({Key? key}) : super(key: key);

  @override
  State<_NewContactView> createState() => _NewContactViewState();
}

class _NewContactViewState extends State<_NewContactView> {
  late final TextEditingController _controller;
  void initState(){
    _controller=TextEditingController();
    super.initState();
  }

  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
      ),
      body: Column(
        children:
        [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter New Contact Name Here',

            ) ,
          ),

          TextButton(
              onPressed: (){
                final contact = Contact (name: _controller.text);
                ContactsBook().add(contact: contact);
                Navigator.of(context).pop();
              },
              child: Text('Add Contact'),
          ),
        ],
      ),
    );
  }
}


