import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' hide Router;
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:notebook/core/utils/routes/router.gr.dart';
import 'package:notebook/domain/repositories/local_settings.dart';
import 'package:notebook/service_locator/service_locator.dart';


class IntroPageState extends State<IntroPage> {
  List<Slide> slides;

  @override
  void initState() {
    super.initState();

    slides = _InitIntroSlides()();
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,

      renderNextBtn: renderNextBtn(),
      renderSkipBtn: renderSkipBtn(),
      renderDoneBtn: renderDoneBtn(),

    );
  }

  Widget renderNextBtn() {
    return const Icon(
      Icons.arrow_forward,
      color: Color(0xff009688),
      size: 35.0,
    );
  }

  Widget renderSkipBtn() {
    return const Icon(
      Icons.skip_next,
      color: Color(0xff009688),
      size: 35.0,
    );
  }

  Widget renderDoneBtn() {
    return IconButton(
      icon: const Icon(Icons.done, size: 35.0),
      color: const Color(0xff009688),
      onPressed: () {
        locator.get<LocalSettings>().closeIntro();
        ExtendedNavigator.of(context).pushAndRemoveUntil(Routes.mainPage, (route) => false);
      }

    );
  }

}

class IntroPage extends StatefulWidget {
  const IntroPage({Key key}) : super(key: key);
  @override
  IntroPageState createState() => IntroPageState();
}



class _InitIntroSlides {
  List<Slide> call() {
    return [
      Slide(
        backgroundColor: Colors.white,
        title: "Purenote",
        styleTitle: _textTitleStyle(),
        description:
        "Take control of your notes",
        styleDescription: _textDescriptionStyle(),
        pathImage: "assets/images/icon_app_colored.png",
      ),
      Slide(
        backgroundColor: Colors.white,
        title: "Actions",
        styleTitle: _textTitleStyle(),
        description:
        "Swipe a single notebook/note to the left to reveal actions",
        styleDescription: _textDescriptionStyle(),
        pathImage: "assets/images/swipe_intro.png",
      ),
      Slide(
        backgroundColor: Colors.white,
        title: "Purenote is under development",
        maxLineTitle: 2,
        styleTitle: _textTitleStyle(),
        description: "The application is constantly being developed with new features.\n"
            "Keep the app up to date",
        styleDescription: _textDescriptionStyle(),
      ),

    ];
  }

  TextStyle _textTitleStyle() {
    return GoogleFonts.openSans(
        color: Colors.black,
        fontSize: 26.0,
        fontWeight: FontWeight.bold,
    );
  }

  TextStyle _textDescriptionStyle() {
    return GoogleFonts.openSans(
        color: Colors.black,
        fontSize: 18.0
    );
  }


}