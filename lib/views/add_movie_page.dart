import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  List<String> selectedCategories = [];

  final List<String> categoryOptions = [
    'Action',
    'Science-fiction',
    'Aventure',
    'Comedie',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Name : '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: nameController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Year : '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: yearController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                side: BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Poster : '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: posterController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Catégorie'),
              isExpanded: true,
              value: null,
              icon: const Icon(Icons.arrow_drop_down),
              onChanged: (String? newValue) {
                setState(() {
                  if (newValue != null && !selectedCategories.contains(newValue)) {
                    selectedCategories.add(newValue);
                  }
                });
              },
              items: categoryOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Wrap(
              spacing: 8.0,
              children: selectedCategories.map((category) {
                return Chip(
                  label: Text(category),
                  onDeleted: () {
                    setState(() {
                      selectedCategories.remove(category);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('Movies').add({
                  'name': nameController.value.text,
                  'year': yearController.value.text,
                  'poster': posterController.value.text,
                  'categories': selectedCategories,
                  'likes': 0,
                });
                Navigator.pop(context);
              },
              child: const Text('Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}

























// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AddPage extends StatefulWidget {
//   const AddPage({super.key});

//   @override
//   State<AddPage> createState() => _AddPageState();
// }

// class _AddPageState extends State<AddPage> {
//   final nameController = TextEditingController();
//   final yearController = TextEditingController();
//   final posterController = TextEditingController();
//   List<String> categories = [];
//   List<String> selectedCategories = [];

//   final List<String> categoryOptions = [
//     'Action',
//     'Science-fiction',
//     'Aventure',
//     'Comedie',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Movie'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           children: [
//             ListTile(
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(4)), // Remplacement ici
//                 side: BorderSide(color: Colors.white30, width: 1.5),
//               ),
//               title: Row(
//                 children: [
//                   const Text('Name : '),
//                   Expanded(
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                       controller: nameController,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ListTile(
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(4)), 
//                 side: BorderSide(color: Colors.white30, width: 1.5),
//               ),
//               title: Row(
//                 children: [
//                   const Text('Year : '),
//                   Expanded(
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                       controller: yearController,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ListTile(
//               shape: const RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(4)),
//                 side: BorderSide(color: Colors.white30, width: 1.5),
//               ),
//               title: Row(
//                 children: [
//                   const Text('Poster : '),
//                   Expanded(
//                     child: TextField(
//                       decoration: const InputDecoration(
//                         border: InputBorder.none,
//                       ),
//                       controller: posterController,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             DropdownButton<String>(
//               hint: const Text('Catégorie'),
//               isExpanded: true,
//               value: null,
//               icon: const Icon(Icons.arrow_drop_down),
//               onChanged: (String? newValue) {
//                 setState(() {
//                   if (newValue != null && !selectedCategories.contains(newValue)) {
//                     selectedCategories.add(newValue);
//                   }
//                 });
//               },
//               items: categoryOptions.map<DropdownMenuItem<String>>((String value) {
//                 return DropdownMenuItem<String>(
//                   value: value,
//                   child: Text(value),
//                 );
//               }).toList(),
//             ),
//             Wrap(
//               spacing: 8.0,
//               children: selectedCategories.map((category) {
//                 return Chip(
//                   label: Text(category),
//                   onDeleted: () {
//                     setState(() {
//                       selectedCategories.remove(category);
//                     });
//                   },
//                 );
//               }).toList(),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 FirebaseFirestore.instance.collection('Movies').add({
//                   'name': nameController.value.text,
//                   'year': yearController.value.text,
//                   'poster': posterController.value.text,
//                   'categories': selectedCategories,
//                   'likes': 0,
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text('Ajouter'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
