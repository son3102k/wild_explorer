import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'discovery_app_theme.dart';

class EntityInfoScreen extends StatefulWidget {
  const EntityInfoScreen({super.key, required this.entity});
  final Entity entity;
  @override
  _EntityInfoScreenState createState() => _EntityInfoScreenState();
}

class _EntityInfoScreenState extends State<EntityInfoScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController(initialPage: 0);
  int currentPage = 0;

  final double infoHeight = 364.0;
  AnimationController? animationController;
  Animation<double>? animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController!,
        curve: const Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> setData() async {
    animationController?.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Entity entity = widget.entity;
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    return Container(
      color: DiscoveryAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 1.2,
                  child: entity.images.isNotEmpty
                      ? PageView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: entity.images.length,
                          itemBuilder: (context, index) {
                            return CachedNetworkImage(
                              imageUrl: entity.images[index],
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                            'No images to display',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                ),
              ],
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: DiscoveryAppTheme.nearlyWhite,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32.0),
                      topRight: Radius.circular(32.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DiscoveryAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 32.0, left: 18, right: 16),
                            child: Text(
                              entity.name,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                letterSpacing: 0.27,
                                color: DiscoveryAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, bottom: 8, top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  entity.specie,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 16,
                                    letterSpacing: 0.27,
                                    color: DiscoveryAppTheme.nearlyBlue,
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        entity.rating.toString(),
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color: DiscoveryAppTheme.grey,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.star,
                                        color: DiscoveryAppTheme.nearlyBlue,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 18, right: 16),
                            child: Container(
                              height: 50,
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 10,
                                  );
                                },
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: entity.images.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      _pageController.animateToPage(
                                        index,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.easeInOut,
                                      );
                                      setState(() {
                                        currentPage = index;
                                      });
                                    },
                                    child: Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: index == currentPage
                                            ? DiscoveryAppTheme.nearlyBlue
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          width: 1,
                                          color: DiscoveryAppTheme.nearlyBlue,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${index + 1}',
                                          style: TextStyle(
                                              color: index == currentPage
                                                  ? Colors.white
                                                  : DiscoveryAppTheme
                                                      .nearlyBlue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity1,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: <Widget>[
                                    getTimeBoxUI('60–85 cm', 'Length'),
                                    getTimeBoxUI(' 4–15 kg', 'Weight'),
                                    getTimeBoxUI('~ 100.000', 'Individuals'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: opacity2,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  child: Text(
                                    entity.description,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 14,
                                      letterSpacing: 0.85,
                                      color: DiscoveryAppTheme.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 500),
                            opacity: opacity3,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, bottom: 16, right: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: DiscoveryAppTheme.nearlyBlue,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(16.0),
                                        ),
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: DiscoveryAppTheme
                                                  .nearlyBlue
                                                  .withOpacity(0.5),
                                              offset: const Offset(1.1, 1.1),
                                              blurRadius: 10.0),
                                        ],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Ask GPT',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18,
                                            letterSpacing: 0.0,
                                            color:
                                                DiscoveryAppTheme.nearlyWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
              right: 35,
              child: ScaleTransition(
                alignment: Alignment.center,
                scale: CurvedAnimation(
                    parent: animationController!, curve: Curves.fastOutSlowIn),
                child: Card(
                  color: DiscoveryAppTheme.nearlyBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  elevation: 10.0,
                  child: Container(
                    width: 60,
                    height: 60,
                    child: const Center(
                      child: Icon(
                        Icons.favorite,
                        color: DiscoveryAppTheme.nearlyWhite,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: SizedBox(
                width: AppBar().preferredSize.height,
                height: AppBar().preferredSize.height,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius:
                        BorderRadius.circular(AppBar().preferredSize.height),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: DiscoveryAppTheme.nearlyBlack,
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DiscoveryAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DiscoveryAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DiscoveryAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DiscoveryAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
