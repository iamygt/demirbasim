// import 'package:demirbasim/widgets/icon_button.dart';
// import 'package:flutter/material.dart';

// Widget botNav(BuildContext context) {
//   return Stack(
//     children: [
//       Align(
//         alignment: const AlignmentDirectional(0, 2.83),
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             DemirBasimIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 50,
//               icon: const Icon(
//                 Icons.home_rounded,
//                 color: Color(0xFF9299A1),
//                 size: 24,
//               ),
//               onPressed: () {
//                 if (kDebugMode) {
//                   print('IconButton pressed ...');
//                 }
//               },
//             ),
//             DemirBasimIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 50,
//               icon: const Icon(
//                 Icons.home_work,
//                 color: Color(0xFF9299A1),
//                 size: 24,
//               ),
//               onPressed: () {
//                 if (kDebugMode) {
//                   print('IconButton pressed ...');
//                 }
//               },
//             ),
//             Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
//                   child: DemirBasimIconButton(
//                     borderColor: Colors.transparent,
//                     borderRadius: 4,
//                     borderWidth: 1,
//                     buttonSize: 60,
//                     fillColor: DemirBasimTheme.of(context).primary,
//                     icon: const Icon(
//                       Icons.add,
//                       color: Colors.white,
//                       size: 30,
//                     ),
//                     onPressed: () {
//                       if (kDebugMode) {
//                         print('MiddleButton pressed ...');
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             DemirBasimIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 50,
//               icon: const Icon(
//                 Icons.favorite_rounded,
//                 color: Color(0xFF9299A1),
//                 size: 24,
//               ),
//               onPressed: () {
//                 if (kDebugMode) {
//                   print('IconButton pressed ...');
//                 }
//               },
//             ),
//             DemirBasimIconButton(
//               borderColor: Colors.transparent,
//               borderRadius: 30,
//               borderWidth: 1,
//               buttonSize: 50,
//               icon: const Icon(
//                 Icons.settings,
//                 color: Color(0xFF9299A1),
//                 size: 24,
//               ),
//               onPressed: () {
//                 if (kDebugMode) {
//                   print('IconButton pressed ...');
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }
