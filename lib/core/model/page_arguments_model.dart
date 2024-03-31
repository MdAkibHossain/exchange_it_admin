import 'package:exchange_it_admin/features/home/data/post_model.dart';

class PageRouteArguments {
  final String? fromPage;
  final String? toPage;
  final List<dynamic>? datas;
  final String? title;
  final dynamic data;
  final String? id;
  final int? businessTypeId;
  final bool? commonBool;
  final PostModel? postModel;
  PageRouteArguments(
      {this.commonBool,
      this.data,
      this.title,
      this.fromPage,
      this.toPage,
      this.datas,
      this.id,
      this.businessTypeId,
      this.postModel});
}

class PageRouteIdArgument<T> {
  final T id;

  PageRouteIdArgument({required this.id});
}
