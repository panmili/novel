import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:novel_api/model/search_entity.dart';

import 'api/api_util.dart';

void main() {
  WapIsHuQuGeLa.search("深空彼岸").then((value) {
    value.forEach((e) async {
      e.detailFun!((a){
        int aa = a.novelList!.length;
        a.novelList?[aa-2].readFun!((ReadDetail b){
          // print(b.text);
          b.nextFun!((ReadDetail c){
            print("下一章");
            print(c.text);
          });
          b.lastFun!((ReadDetail d){
            print("上一章");
            print(d.text);
          });
        });
      });
    });
  });

  // DetailApi.detail(SearchEntity.fromJson({
  //   "key": 'ishuquge',
  //   "href": "https://wap.ishuquge.la/s/30353.html",
  //   "img": "https://www.ishuquge.la/files/article/image/30/30353/30353s.jpg",
  //   "name": "深空彼岸",
  //   "author": "辰东",
  //   "updatelast": "终篇 第156章 举世无双",
  //   "id": "30353",
  //   "info": null
  // })).then((value) => {
  //    print(value.toString())
  // });
}

class WapIsHuQuGeLa {
  static String baseUrl = 'https://wap.ishuquge.la';

  static Future<List<SearchEntity>> search(v) async {
    Response response = await dio.post("$baseUrl/search.php",
        data: {'searchkey': v},
        options: Options(
            contentType: 'application/x-www-form-urlencoded',
            responseType: ResponseType.plain));
    Document document = parse(response.data);
    List<SearchEntity> novelList = [];
    List<Element> elements = document
        .getElementsByClassName('read_book')
        .first
        .getElementsByClassName('bookbox');
    for (int i = 0; i < elements.length; i++) {
      Element e = elements[i];
      Map<String, String> map = {};
      Element a = e
          .getElementsByClassName('bookimg')
          .first
          .getElementsByTagName('a')
          .first;
      String href = '$baseUrl${a.attributes['href']}';
      map['href'] = href;
      Element img = a.getElementsByTagName('img').first;
      map['img'] = '${img.attributes['src']}';
      Element bookname = e.getElementsByClassName('bookname').first;
      map['name'] = bookname.text;
      Element author = e.getElementsByClassName('author').first;
      map['author'] = author.text.replaceAll("作者：", "");
      Element updatelast = e
          .getElementsByClassName('updatelast')
          .first
          .getElementsByTagName('a')
          .first;
      map['updatelast'] = updatelast.text;
      map['id'] = href.replaceAll(RegExp(r'[^0-9]'), '');
      final search = SearchEntity.fromJson(map);
      search.key = 'ishuquge';
      search.detailFun = ((Function cb)async {
        SearchEntity s = await detail(search);
        cb(s);
      });
      novelList.add(search);
    }
    return novelList;
  }

  static Future<SearchEntity> detail(SearchEntity item) async {
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
    Iterable<Element> ee =
        listMain.where((element) => element.toString() == "<html dt>");
    if (ee.length > 2) {
      for (int a = 0; a < listMain.length; a++) {
        if (listMain[a].toString() == "<html dt>" && a > 0) {
          index = a;
          break;
        }
      }
    }
    List<Element> allListElement = listMain.sublist(index + 1, listMain.length);
    List<NovelList> allList = [];
    allListElement.forEach((e) {
      if (e.toString() != '<html dt>') {
        Element a = e.getElementsByTagName('a').first;
        Map<String, String> map = {};
        map['title'] = a.text;
        map['link'] = a.attributes['href']!;
        final novelList = NovelList.fromJson(map);
        novelList.readFun = ((Function cb)async{
          ReadDetail str = await read({"id":item.id,"page":novelList.link});
          cb(str);
        });
        allList.add(novelList);
      }
    });
    item.novelList = allList;
    return item;
  }

  static Future<ReadDetail> read(item) async {
    String url = 'https://www.ishuquge.la/txt/${item['id']}/${item['page']}';
    Response response = await dio.get(url);
    Document document = parse(response.data);
    Element content = document.getElementById("content")!;
    content.children.first.remove();
    final readDetail = ReadDetail();
    String text = content.text
        .replaceAll(RegExp(r'\n'), '')
        .replaceAll(" ", "")
        .replaceAll(' ', '')
        .split('https://www.ishuquge')[0]
        .trim();
    readDetail.text = text;
    List<Element> elements = document.getElementsByClassName("page_chapter").first.getElementsByTagName("a");
    readDetail.lastFun = (Function cb) async{
      cb(await read({"id":item['id'],"page":elements.first.attributes['href']}));
    };
    readDetail.nextFun = (Function cb) async{
      cb(await read({"id":item['id'],"page":elements.last.attributes['href']}));
    };
    return readDetail;
  }
}
