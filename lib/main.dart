import 'package:flutter/material.dart';

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

class Contacts {
  final String name;
  const Contacts({required this.name});
}

class ContactsBook{
  ContactsBook._sharedInstance();
  static final ContactsBook _shared = ContactsBook._sharedInstance();
  factory ContactsBook()=> _shared;

  final List<Contacts> _contact=
  [
    const Contacts(name: 'ahmed HANY'),
  ];

  int get length =>_contact.length;


  void add({required Contacts contact})=>_contact.add(contact);
  void remove({required Contacts contact})=>_contact.remove(contact);

  Contacts? contacts({required int atIndx})=>
      _contact.length>atIndx? _contact[atIndx]:null;


}

class MyHomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final contactbook =ContactsBook();
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Home Page')),
      ),
      body:ListView.builder(
          itemCount: contactbook.length,
          itemBuilder: (context,index){
            final contact =contactbook.contacts(atIndx: index)!;
            return ListTile(
              title: Text(contact.name),
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
                final contact = Contacts(name: _controller.text);
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


