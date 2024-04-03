import 'package:flutter/material.dart';

import '../models/size_config.dart';

class SearchField extends StatelessWidget {
  final Function(String) onSubmit;
  const SearchField({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).secondaryHeaderColor,
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: "Search",
          hintStyle: const TextStyle(color: Colors.blue),
          prefixIcon: const Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(20),
              vertical: getProportionateScreenWidth(9)),
        ),
        onSubmitted: onSubmit,
      ),
    );
  }
}


// class CustomSearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final Function(String)? onChanged;

//   CustomSearchBar({required this.controller, this.onChanged});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       
//       child: Row(
//         children: [
//           const Icon(Icons.search),
//           const SizedBox(width: 10),
//           Expanded(
//             child: TextField(
//               controller: controller,
//               onChanged: onChanged,
//               decoration: const InputDecoration(
//                 focusedBorder: InputBorder.none,
//                 hintText: 'Search',
//                 hintStyle: TextStyle(color: Colors.blue),
//                 border: InputBorder.none,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
