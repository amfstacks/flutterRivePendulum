import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class RivePage extends StatefulWidget {
  const RivePage({Key? key}) : super(key: key);

  @override
  State<RivePage> createState() => _RivePageState();
}

// https://rive.app/community/6150-11984-a-hyper-realistic-pendulum
class _RivePageState extends State<RivePage> {
  Artboard? riveArtBoard;
  SMIBool? isPlay;
  bool myBool = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    rootBundle.load('assets/pendulum.riv').then((data) {
      try {
        final file = RiveFile.import(data);
        final artboard = file.mainArtboard;
        var controller =
            StateMachineController.fromArtboard(artboard, 'moveit');

        if (controller != null) {
          artboard.addController(controller);
          isPlay = controller.findSMI('play');
          setState(() {
            riveArtBoard = artboard;
            isPlay!.value = false;
          });
        }
      } catch (e) {
        print(e);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: Text(
          'Interactive Pendulum Animation with Rive by Amfstacks',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ),
      body: riveArtBoard == null
          ? Text('loading')
          : Container(
              // color: Colors.green,
              height: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Stack(
                    children: [
                      Rive(
                        artboard: riveArtBoard!,
                      ),
                      // Positioned(
                      //     bottom: 60,
                      //     right: 0,
                      //     child: Container(
                      //       height: 50,
                      //       width: 300,
                      //       color: Colors.teal,
                      //     )),
                    ],
                  )),
                  GestureDetector(
                      onTap: () {
                        // togglePlay(value)

                        setState(() {
                          myBool = !myBool;
                          togglePlayB();
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: !myBool
                                ? Colors.teal.shade900
                                : Colors.redAccent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 29),
                            child: Text(
                              !myBool ? 'Swing Me' : 'Stop Me',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))),
                  // Switch(
                  //   value: isPlay!.value,
                  //   onChanged: (value) => togglePlay(value),
                  // )
                ],
              ),
            ),
    );
  }

  togglePlay(bool value) {
    setState(() {
      isPlay!.value = value;
    });
  }

  togglePlayB() {
    setState(() {
      isPlay!.value = myBool;
    });
  }
}
