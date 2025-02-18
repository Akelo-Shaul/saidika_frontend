import 'package:flutter/material.dart';
import 'package:saidika_ui/ui/theme/colors.dart';
import 'package:saidika_ui/ui/widgets/appButton.dart';
import 'package:saidika_ui/utils/constants.dart';
import 'package:saidika_ui/utils/route.dart';

class IntroSliderScreen extends StatefulWidget {
  const IntroSliderScreen({super.key});

  @override
  State<IntroSliderScreen> createState() => _IntroSliderScreenState();
}

class _IntroSliderScreenState extends State<IntroSliderScreen> {

  int currentIndex = 0;
  int pageIndex = 0;
  PageController pageController = PageController();

  List<String> titles = ['Offer Services', 'Find Services','Anytime Anywhere'];
  List<String> subTitles = [
    'Quick, Easy Booking, Choose From a Wide Range of Services.',
    'Find Services from certified providers close to you.',
    'Personalised services from the tip of your hands.'
  ];

  onTap(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void onButtonPressed(){
    if (currentIndex < 2){
      setState(() {
        currentIndex++;
        pageController.animateToPage(
            currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      });
    } else {
      Navigator.pushNamed(context, signInScreen);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            start: 0,
            end: 0,
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: PageView.builder(
                  onPageChanged: onTap,
                  controller: pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Image.asset(
                          '${imagePath}slider_$index.jpg',
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height * 0.70,
                        ),
                        Container(
                          padding: const EdgeInsetsDirectional.all(20),
                          child: Column(
                            children: [
                              Text(
                                titles[index],
                                softWrap: true,
                                style: appTextTheme(context)
                                    .labelLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                subTitles[index],
                                softWrap: true,
                                style: appTextTheme(context).labelSmall,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                )),
          ),
          PositionedDirectional(
            bottom: 0,
            start: 0,
            end: 0,
            child: Container(
                padding: const EdgeInsetsDirectional.only(start: 30, end: 30, bottom: 30),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return currentIndex == index
                            ? Container(
                          margin: const EdgeInsetsDirectional.all(10),
                          padding: const EdgeInsetsDirectional.all(10),
                          height: 10,
                          width: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.primaryColor,
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.primaryColor),
                                left: BorderSide(
                                    color: AppColors.primaryColor),
                                right: BorderSide(
                                    color: AppColors.primaryColor),
                                top: BorderSide(
                                    color: AppColors.primaryColor)),
                          ),
                        )
                            : Container(
                          margin: const EdgeInsetsDirectional.all(10),
                          padding: const EdgeInsetsDirectional.all(10),
                          height: 10,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.textColorLight,
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.textColorLight),
                                left: BorderSide(
                                    color: AppColors.textColorLight),
                                right: BorderSide(
                                    color: AppColors.textColorLight),
                                top: BorderSide(
                                    color: AppColors.textColorLight)),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 15),
                    AppButton(
                      btnText: currentIndex < 2 ? 'Next' :'Get Started',
                      voidCallBack: onButtonPressed,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
