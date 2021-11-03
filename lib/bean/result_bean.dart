/// result : [{"name":"蓝眼白猫","score":"0.237702","baike_info":{"baike_url":"http://baike.baidu.com/item/%E8%93%9D%E7%9C%BC%E7%99%BD%E7%8C%AB/6309075","image_url":"https://bkimg.cdn.bcebos.com/pic/42166d224f4a20a4e28e847899529822730ed0f9","description":"蓝眼白猫，祖先为安哥拉猫、波斯猫。起源于1880年代。习性温顺，耳朵在头部位置。四肢较低粗短的颈，披毛细腻而柔滑的被毛，\"蓝眼白猫\"是一个统称，指具有蓝色眼睛，白色被毛特征的猫，可为土猫，也可为品种猫。"}},{"name":"布偶猫","score":"0.233425","baike_info":{"baike_url":"http://baike.baidu.com/item/%E5%B8%83%E5%81%B6%E7%8C%AB/642121","image_url":"https://bkimg.cdn.bcebos.com/pic/4034970a304e251fc3ec88c8af86c9177f3e53e2","description":"布偶猫是猫中较大、较重的一种。它的头呈V形，眼大而圆，被毛丰厚，四肢粗大，尾长，身体柔软，多为三色或双色猫。布偶猫抱起来像软绵绵的布偶，而且对人非常友善。它性格大胆，不知道什么叫恐惧，而且对疼痛的忍耐性相当强，常被误认为缺乏疼痛感，因此很能容忍孩子的玩弄，是非常理想的家庭宠物。"}},{"name":"狮子猫","score":"0.125637","baike_info":{"baike_url":"http://baike.baidu.com/item/%E7%8B%AE%E5%AD%90%E7%8C%AB/4340094","image_url":"https://bkimg.cdn.bcebos.com/pic/5882b2b7d0a20cf431ada5c49c415c36acaf2edd33dd","description":"狮子猫又称临清狮子猫，主要产于山东省临清市，是由蓝眼睛的波斯猫与黄眼睛的鲁西本地狸猫杂交繁育出来的变异品种。在诸多品种中，以一只蓝眼、一只黄眼，白毛拖地的雪狮子最为珍贵。人们称其为“鸳鸯眼狮猫”。临清狮子猫的培育形成与伊斯兰教的传人和运河的开通有密切的关系。到了明代，伴随着明朝与波斯的交往，波斯猫也在这里安家落户，加之波斯猫喜食羊的肝肾，便很快在回民家中繁衍开来。纯种临清狮子猫的颈、背部毛长达4—5厘米，站姿犹如狮子。也有黑白相间毛色的品种，但以纯白的较为珍贵。狮子猫身体强壮、抗病力强、耐寒冷、善于捕鼠。性格温婉，不喜欢陌生人，对主人有较强的依赖性。临清狮子猫因其独特的形象，一直是宠物市场上的高价极品猫。"}},{"name":"波斯猫","score":"0.114046","baike_info":{"baike_url":"http://baike.baidu.com/item/%E6%B3%A2%E6%96%AF%E7%8C%AB/585","image_url":"https://bkimg.cdn.bcebos.com/pic/cc11728b4710b9123e0206d7cefdfc03934522dc","description":"波斯猫(Persian cat)是以阿富汗的土种长毛猫和土耳其的安哥拉长毛猫为基础，在英国经过100多年的选种繁殖，于1860年诞生的一个品种。波斯猫是最常见的长毛猫，波斯猫有一张讨人喜爱的面庞，长而华丽的背毛，优雅的举止，故有“猫中王子”、“王妃”之称，是世界上爱猫者最喜欢的纯种猫之一，占有极其重要的地位。"}},{"name":"家猫","score":"0.0986276","baike_info":{"baike_url":"http://baike.baidu.com/item/%E5%AE%B6%E7%8C%AB/4200676","image_url":"https://bkimg.cdn.bcebos.com/pic/f9dcd100baa1cd11e6db6e9db112c8fcc3ce2d19","description":"家猫(学名：Felis catus)俗称猫咪，是食肉目猫科、猫属哺乳动物。平均体重约有3～4.5公斤左右，大多数全身披毛，毛皮毛色纷繁，全身横纹者居多，少量为纯一色或杂色者。趾底有脂肪质肉垫，趾端生有锐利的爪，爪平时不伸出，故行走无声。家猫为人类伴生动物之一。它猎食小鸟、兔子、老鼠、鱼等。在世界各地(除南极洲)都被发现与人类一起生活。家猫在世界自然保护联盟红色名录,华盛顿公约没有特殊的地位。(概述图来源)"}},{"name":"怪眼白色猫","score":"0.0427051","baike_info":{"baike_url":"http://baike.baidu.com/item/%E6%80%AA%E7%9C%BC%E7%99%BD%E8%89%B2%E7%8C%AB/6030156","image_url":"https://bkimg.cdn.bcebos.com/pic/b3119313b07eca806538a103307380dda144ac34258c","description":"安哥拉猫。起源于：1880年代。怪眼白色异国种猫。温顺。可能是蓝眼种猫或杂交所生的猫仔。如有耳聋，聋的耳朵一定在蓝眼那一边。"}}]
/// log_id : 1455728683870390051

class ResultBean {
  List<Result>? result;
  int? logId;
  String? error_msg;

  ResultBean({
      this.result, 
      this.error_msg,
      this.logId});

  ResultBean.fromJson(dynamic json) {
    if (json['result'] != null) {
      result = [];
      json['result'].forEach((v) {
        result?.add(Result.fromJson(v));
      });
    }
    logId = json['log_id'];
    error_msg = json['error_msg'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (result != null) {
      map['result'] = result?.map((v) => v.toJson()).toList();
    }
    map['log_id'] = logId;
    map['error_msg'] = error_msg;
    return map;
  }

}

/// name : "蓝眼白猫"
/// score : "0.237702"
/// baike_info : {"baike_url":"http://baike.baidu.com/item/%E8%93%9D%E7%9C%BC%E7%99%BD%E7%8C%AB/6309075","image_url":"https://bkimg.cdn.bcebos.com/pic/42166d224f4a20a4e28e847899529822730ed0f9","description":"蓝眼白猫，祖先为安哥拉猫、波斯猫。起源于1880年代。习性温顺，耳朵在头部位置。四肢较低粗短的颈，披毛细腻而柔滑的被毛，\"蓝眼白猫\"是一个统称，指具有蓝色眼睛，白色被毛特征的猫，可为土猫，也可为品种猫。"}

class Result {
  String? name;
  String? score;
  Baike_info? baikeInfo;

  Result({
      this.name, 
      this.score, 
      this.baikeInfo});

  Result.fromJson(dynamic json) {
    name = json['name'];
    score = json['score'];
    baikeInfo = json['baike_info'] != null ? Baike_info.fromJson(json['baike_info']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = name;
    map['score'] = score;
    if (baikeInfo != null) {
      map['baike_info'] = baikeInfo?.toJson();
    }
    return map;
  }

}

/// baike_url : "http://baike.baidu.com/item/%E8%93%9D%E7%9C%BC%E7%99%BD%E7%8C%AB/6309075"
/// image_url : "https://bkimg.cdn.bcebos.com/pic/42166d224f4a20a4e28e847899529822730ed0f9"
/// description : "蓝眼白猫，祖先为安哥拉猫、波斯猫。起源于1880年代。习性温顺，耳朵在头部位置。四肢较低粗短的颈，披毛细腻而柔滑的被毛，\"蓝眼白猫\"是一个统称，指具有蓝色眼睛，白色被毛特征的猫，可为土猫，也可为品种猫。"

class Baike_info {
  String? baikeUrl;
  String? imageUrl;
  String? description;

  Baike_info({
      this.baikeUrl, 
      this.imageUrl, 
      this.description});

  Baike_info.fromJson(dynamic json) {
    if(json != null){
      baikeUrl = json['baike_url'];
      imageUrl = json['image_url'];
      description = json['description'];
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['baike_url'] = baikeUrl;
    map['image_url'] = imageUrl;
    map['description'] = description;
    return map;
  }

}