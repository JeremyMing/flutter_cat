import 'package:flutter/material.dart';
import 'package:flutter_cat/bean/result_bean.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 识别结果展示页
class ResultPage extends StatefulWidget {
  final ResultBean resultBean;

  const ResultPage({Key? key, required this.resultBean}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("识别结果"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: ScreenUtil().screenWidth,
            padding: EdgeInsets.all(12),
            color: Color(0xffF36509).withOpacity(0.1),
            child: Text(
              "以下是识别出的可能结果，按匹配度由高到低排列",
              style: TextStyle(fontSize: 16, color: Color(0xffF36509).withOpacity(0.6)),
            ),
          ),
          Divider(
            height: 0.5,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.resultBean.result?.length ?? 0,
              itemBuilder: (ctx, index) {
                return _buildItem(widget.resultBean.result![index], index + 1);
              },
              separatorBuilder: (ctx, index) {
                return Divider(
                  height: 0.5,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(Result result, int index) {
    return Container(
      padding: EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$index.品种名称：${result.name ?? ""}",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            "匹配度：${(num.parse(result.score ?? "0") * 100).toStringAsFixed(2)}%",
            style: TextStyle(fontSize: 13, color: Color(0xff91996f)),
          ),
          SizedBox(
            height: 10,
          ),
          result.baikeInfo?.imageUrl != null
              ? Image.network(
                  result.baikeInfo?.imageUrl ?? "",
                  width: 200,
                )
              : Text(
                  "暂无相关图片",
                  style: TextStyle(fontSize: 14, color: Color(0xff878383)),
                ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            visible: result.baikeInfo?.description != null,
            child: Text(
              result.baikeInfo?.description ?? "",
              style: TextStyle(fontSize: 14, color: Color(0xffa8a8a4)),
            ),
          ),
        ],
      ),
    );
  }
}
