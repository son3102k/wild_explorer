import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wild_explorer/discovery/discovery_home_screen.dart';
import 'package:wild_explorer/discovery/utils/HexColor.dart';
import 'package:wild_explorer/services/api/api_service.dart';

import 'discovery_app_theme.dart';
import 'models/entity.dart';

class EntityListView extends StatefulWidget {
  final CategoryType categoryType;
  const EntityListView({Key? key, this.callBack, required this.categoryType})
      : super(key: key);

  final Function(Entity entity)? callBack;
  @override
  _EntityListViewState createState() => _EntityListViewState();
}

class _EntityListViewState extends State<EntityListView>
    with TickerProviderStateMixin {
  List<Entity> entityList = <Entity>[];
  List<Entity> animalList = <Entity>[];
  List<Entity> plantList = <Entity>[];

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getData() async {
    if (widget.categoryType == CategoryType.animal) {
      if (animalList.isEmpty) {
        animalList = await (ApiService().getRandomFive(widget.categoryType));
      }
      entityList = animalList;
    } else if (widget.categoryType == CategoryType.plant) {
      if (plantList.isEmpty) {
        plantList = await (ApiService().getRandomFive(widget.categoryType));
      }
      entityList = plantList;
    }
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
                itemCount: entityList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return CategoryView(
                    category: entityList[index],
                    callback: () {
                      widget.callBack!.call(entityList[index]);
                    },
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
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  category!.name,
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
                                padding:
                                    const EdgeInsets.only(right: 16, bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${category!.specie}',
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '\$${category!.rating}',
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
                                          color: DiscoveryAppTheme.nearlyWhite,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
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
                        child: CachedNetworkImage(
                          imageUrl: category!.avatar,
                        )),
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
