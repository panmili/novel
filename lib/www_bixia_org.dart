import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
Dio _dio = Dio();

void main() {
  WwwBiXiaOrg.search();
}

class WwwBiXiaOrg{

   static String baseUrl = 'http://www.bixia.org';


  static Future<String> search() async {
    Response response = await _dio.post("$baseUrl/ar.php",data: {'keyWord':'深空彼岸'},options: Options(contentType: 'application/x-www-form-urlencoded',responseType: ResponseType.plain));
    Document document = parse(
        response.data);
    List<Map<String,String>> novelList = [];
    List<Element> elements = document.getElementsByClassName('list search-list').first.getElementsByTagName('a');
    for(int i=0;i<elements.length;i++) {
      Element e = elements[i];
      Map<String,String> map = HashMap();
      List arr = e.getElementsByTagName('p').first.text.split(' / ');
      String href = '${e.attributes['href']}';
      map['name'] = arr[0];
      map['author'] = arr[1];
      map['href'] = href;
      novelList.add(map);
      Response res = await _dio.get('$baseUrl$href',options: Options(contentType: 'application/x-www-form-urlencoded',responseType: ResponseType.plain));
      print(res);
    }
    print(novelList);
    return '';
  }

}