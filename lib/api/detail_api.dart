

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'api_util.dart';

class DetailApi {
  static Future<SearchEntity> detail(SearchEntity item) async {
    if(item.key == 'ishuquge'){
      String url = 'https://www.ishuquge.la/txt/${item.id}/index.html';
      Response response = await dio.get(url);
      Document document = parse(response.data);
      Element jj = document.getElementsByClassName("intro").first;
      jj.children.first.remove();
      item.info = jj.text
          .trim()
          .replaceAll(" ", "")
          .replaceAll("展开>>", "")
          .split("推荐地址：https://www.ishuquge")[0];
      List<Element> listMain = document
          .getElementsByClassName('listmain')
          .first
          .getElementsByTagName('dl')
          .first
          .children;
      int index =
      listMain.lastIndexWhere((element) => element.toString() == "<html dt>");
      List<Element> allListElement = listMain.sublist(index + 1, listMain.length);
      List<NovelList> allList = [];
      allListElement.forEach((e) {
        Element a = e.getElementsByTagName('a').first;
        Map<String, String> map = {};
        map['title'] = a.text;
        map['link'] = a.attributes['href']!;
        final novelList = NovelList.fromJson(map);
        novelList.obj = {
          "id":item.id,
          "page":a.attributes['href']!,
          "key":item.key,
        };
        allList.add(novelList);
      });
      item.novelList = allList;
    }
    return item;
  }
}