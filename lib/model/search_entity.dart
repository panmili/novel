

import 'dart:convert';


class SearchEntity {
	String? key;
	String? href;
	String? img;
	String? name;
	String? author;
	String? updatelast;
	String? id;
	String? info;
	List<NovelList>? novelList;
	Function? detailFun;

	SearchEntity(
			{
				this.key,
				this.href,
				this.img,
				this.name,
				this.author,
				this.updatelast,
				this.id,
				this.info,
				this.novelList});

	SearchEntity.fromJson(Map<String, dynamic> json) {
		key = json['key'];
		href = json['href'];
		img = json['img'];
		name = json['name'];
		author = json['author'];
		updatelast = json['updatelast'];
		id = json['id'];
		info = json['info'];
		if (json['novel_list'] != null) {
			novelList = <NovelList>[];
			json['novel_list'].forEach((v) {
				novelList!.add(new NovelList.fromJson(v));
			});
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['key'] = this.key;
		data['href'] = this.href;
		data['img'] = this.img;
		data['name'] = this.name;
		data['author'] = this.author;
		data['updatelast'] = this.updatelast;
		data['id'] = this.id;
		data['info'] = this.info;
		if (this.novelList != null) {
			data['novel_list'] = this.novelList!.map((v) => v.toJson()).toList();
		}
		return data;
	}

}

class NovelList {

	String? title;
	String? link;
	Function? readFun;
	Map? obj;

	NovelList({this.title, this.link,this.obj});

	NovelList.fromJson(Map<String, dynamic> json) {
		title = json['title'];
		link = json['link'];
		obj = json['obj'];
		readFun = json['readFun'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['title'] = this.title;
		data['link'] = this.link;
		data['obj'] = this.obj;
		data['readFun'] = this.readFun;
		return data;
	}

}

class ReadDetail {
	Function? lastFun;
	Function? nextFun;
	String? text;

	ReadDetail({this.lastFun,this.nextFun,this.text});

	ReadDetail.fromJSon(Map<String, dynamic> json){
		lastFun = json['lastFun'];
		nextFun = json['nextFun'];
		text = json['text'];
	}
}

