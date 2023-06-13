import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'learning_theme.dart';
import 'model/list_data.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({
    Key? key,
    this.listData,
    this.animationController,
    this.animation,
    this.callback,
  }) : super(key: key);

  final VoidCallback? callback;
  final ListData? listData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: callback,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.6),
                        offset: const Offset(4, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            AspectRatio(
                              aspectRatio: 2,
                              child: CachedNetworkImage(
                                imageUrl: listData!.imagePath,
                                cacheKey: listData!.imagePath,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              color: LearningTheme.buildLightTheme()
                                  .backgroundColor,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16, top: 8, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              listData!.titleTxt,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 22,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  listData!.subTxt,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey
                                                          .withOpacity(0.8)),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  listData!.difficult > 0 &&
                                                          listData!.difficult <
                                                              1.5
                                                      ? "easy"
                                                      : (listData!.difficult <
                                                              3.5
                                                          ? "medium"
                                                          : "hard"),
                                                  style: TextStyle(
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: <Widget>[
                                                  RatingBar(
                                                    initialRating:
                                                        listData!.difficult,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    itemCount: 5,
                                                    itemSize: 24,
                                                    ratingWidget: RatingWidget(
                                                      full: Icon(
                                                        Icons.star_rate_rounded,
                                                        color: LearningTheme
                                                                .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                      half: Icon(
                                                        Icons.star_half_rounded,
                                                        color: LearningTheme
                                                                .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                      empty: Icon(
                                                        Icons
                                                            .star_border_rounded,
                                                        color: LearningTheme
                                                                .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                    itemPadding:
                                                        EdgeInsets.zero,
                                                    onRatingUpdate: (rating) {},
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: listData!.type == DataType.quiz
                                        ? SvgPicture.asset(
                                            "assets/icons/cup-svgrepo-com.svg",
                                            width: 40,
                                            height: 40,
                                          )
                                        : SvgPicture.asset(
                                            "assets/icons/book-closed-svgrepo-com.svg",
                                            width: 40,
                                            height: 40,
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(32.0),
                              ),
                              onTap: () {},
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.favorite_border,
                                  color: LearningTheme.buildLightTheme()
                                      .primaryColor,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
