import 'package:flutter/material.dart';
import 'package:wild_explorer/discovery/discovery_home_screen.dart';
import 'package:wild_explorer/discovery/models/entity.dart';
import 'package:wild_explorer/discovery/utils/HexColor.dart';
import 'package:wild_explorer/services/api/api_service.dart';

import 'discovery_app_theme.dart';

class PopularEntityListView extends StatefulWidget {
  final CategoryType categoryType;
  const PopularEntityListView(
      {Key? key, this.callBack, required this.categoryType})
      : super(key: key);

  final Function(Entity entity)? callBack;
  @override
  _PopularEntityListViewState createState() => _PopularEntityListViewState();
}

class _PopularEntityListViewState extends State<PopularEntityListView>
    with TickerProviderStateMixin {
  List<Entity> popularEntityList = <Entity>[];
  @override
  void initState() {
    super.initState();
  }

  Future<bool> getData() async {
    popularEntityList = await (ApiService().getPopular(widget.categoryType));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return GridView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                popularEntityList.length,
                (int index) {
                  return EntityView(
                    callback: () {
                      widget.callBack!.call(popularEntityList[index]);
                    },
                    entity: popularEntityList[index],
                  );
                },
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 32.0,
                crossAxisSpacing: 32.0,
                childAspectRatio: 0.8,
              ),
            );
          }
        },
      ),
    );
  }
}

class EntityView extends StatelessWidget {
  const EntityView({Key? key, this.entity, this.callback}) : super(key: key);

  final VoidCallback? callback;
  final Entity? entity;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: callback,
      child: SizedBox(
        height: 280,
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor('#F8FAFB'),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(16.0)),
                      // border: new Border.all(
                      //     color: DesignCourseAppTheme.notWhite),
                    ),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 16, left: 16, right: 16),
                                child: Text(
                                  entity!.name,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    letterSpacing: 0.27,
                                    color: DiscoveryAppTheme.darkerText,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 16, right: 16, bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      width: 80,
                                      child: Text(
                                        entity!.specie,
                                        textAlign: TextAlign.left,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 12,
                                          letterSpacing: 0.27,
                                          color: DiscoveryAppTheme.grey,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${entity!.rating}',
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
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 48,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: DiscoveryAppTheme.grey.withOpacity(0.2),
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 6.0),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                  child: AspectRatio(
                      aspectRatio: 1.28, child: Image.network(entity!.avatar)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
