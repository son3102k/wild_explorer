import 'package:flutter/material.dart';
import 'package:wild_explorer/discovery/utils/HexColor.dart';

import 'discovery_app_theme.dart';
import 'models/entity.dart';

class EntityListView extends StatefulWidget {
  const EntityListView({Key? key, this.callBack}) : super(key: key);

  final Function()? callBack;
  @override
  _EntityListViewState createState() => _EntityListViewState();
}

class _EntityListViewState extends State<EntityListView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: SizedBox(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: Entity.entityList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryView(
                    category: Entity.entityList[index],
                    callback: widget.callBack,
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key? key, this.category, this.callback})
      : super(key: key);

  final VoidCallback? callback;
  final Entity? category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: callback,
      child: SizedBox(
        width: 280,
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                const SizedBox(
                  width: 48,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 48 + 24.0,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text(
                                    category!.title,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.27,
                                      color: DiscoveryAppTheme.darkerText,
                                    ),
                                  ),
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 16, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${category!.lessonCount} lesson',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DiscoveryAppTheme.grey,
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '${category!.rating}',
                                            textAlign: TextAlign.left,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 18,
                                              letterSpacing: 0.27,
                                              color: DiscoveryAppTheme.grey,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.star,
                                            color: DiscoveryAppTheme.nearlyBlue,
                                            size: 20,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        '\$${category!.money}',
                                        textAlign: TextAlign.left,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          letterSpacing: 0.27,
                                          color: DiscoveryAppTheme.nearlyBlue,
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          color: DiscoveryAppTheme.nearlyBlue,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add,
                                            color:
                                                DiscoveryAppTheme.nearlyWhite,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.asset(category!.imagePath)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
