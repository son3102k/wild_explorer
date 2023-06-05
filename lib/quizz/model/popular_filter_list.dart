class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
  });

  String titleTxt;
  bool isSelected;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: 'Atoms',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Cells',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'Genetics',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'minerals',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: 'rocks',
      isSelected: false,
    ),
  ];

  static List<PopularFilterListData> typeList = [
    PopularFilterListData(
      titleTxt: 'All',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Quizz',
      isSelected: true,
    ),
    PopularFilterListData(
      titleTxt: 'Lesson',
      isSelected: true,
    ),
  ];
}
