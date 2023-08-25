import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

void main() {
  runApp(test());
}

class test extends StatefulWidget {
  @override
  _testState createState() => _testState();
}

class _testState extends State<test> {
  late int selectedPage;
  late final PageController _pageController;
  List<Textlist> textlist = [
    Textlist("Timeline for your precious\n memories"),
    Textlist("Safe and Secure, End-to-end\n encrypted"),
    Textlist("Build a timeline of your\n shared memories"),
    Textlist("Shop from exclusive gifts \n and vouchers"),
  ];

  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pageCount = 5;

    return
        // title: 'Page view dot indicator',
        // theme: ThemeData(
        //   primarySwatch: Colors.blue,
        //   visualDensity: VisualDensity.adaptivePlatformDensity,
        // ),
        Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 178,
              width: 230,
              // color: Colors.red,
              child: PageView.builder(
                controller: _pageController,
                itemBuilder: buildlistitem,

                itemCount: textlist.length,
                onPageChanged: (page) {
                  setState(() {
                    selectedPage = page;
                  });
                },
                // children: List.generate(pageCount, (index) {
                //   return Container(
                //     child: Center(
                //       child: Text('Page $index'),
                //     ),
                //   );
                // }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: PageViewDotIndicator(
                currentItem: selectedPage,
                count: pageCount - 1,
                unselectedColor: Colors.black26,
                selectedColor: Colors.black,
                duration: Duration(milliseconds: 200),
                boxShape: BoxShape.circle,
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildlistitem(BuildContext context, int index) {
    Textlist textwidget = textlist[index];
    // return SizedBox(
    //   width: MediaQuery.of(context).size.width - 20,
    //   height: 300,
    //   child: Container(
    //     // key: itemKey,
    //     // color: Colors.red,
    //     height: 30,
    //     width: MediaQuery.of(context).size.width - 20,
    //     child: Column(
    //       children: [
    //         // Container(
    //         //   height: 2,
    //         //   width: 108,
    //         //   color: Colors.black,
    //         // ),
    //         Container(
    //           height: 30,
    //         ),
    //         Row(
    //           children: [
    //             // Container(
    //             //   height: 52,
    //             //   width: 7,
    //             //   color: Colors.black,
    //             // ),
    //             Container(
    //               height: 10,
    //               width: 22,
    //             ),
    //             Container(
    //               // color: Colors.red,
    //               width: MediaQuery.of(context).size.width - 80,
    //               height: 40,
    //               child: FittedBox(
    //                 fit: BoxFit.fitWidth,
    //                 child: Text(
    //                   textwidget.textdisplay,
    //                   style: TextStyle(
    //                     color: Color.fromRGBO(136, 75, 197, 3),
    //                     fontSize: 24,
    //                     fontWeight: FontWeight.w500,
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //         Container(
    //           height: 20,
    //         ),
    //         // Row(
    //         //   children: [
    //         //     SizedBox(
    //         //       width: 25,
    //         //     ),
    //         //     Container(
    //         //       height: 2,
    //         //       width: 108,
    //         //       color: Colors.black,
    //         //     ),
    //         //   ],
    //         // ),
    //       ],
    //     ),
    //   ),
    // );

    // return Container(
    //   height: 50,
    //   color: Colors.yellow,
    //   width: 50,
    // );

    return Column(
      children: [
        Container(
          height: 178,
          width: 178,
          child: Transform.scale(
            scale: index == selectedPage ? 1 : 0.9,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Card ${index + 1}",
                  style: TextStyle(fontSize: 32),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Textlist {
  final String textdisplay;

  Textlist(this.textdisplay);
}
