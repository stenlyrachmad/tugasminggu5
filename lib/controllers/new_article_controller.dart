import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas_minggu_5/globals/repositories/news_api.dart';
import 'package:tugas_minggu_5/models/news.dart';
import 'package:tugas_minggu_5/routes/app_router.dart';
import 'package:tugas_minggu_5/controllers/home_controller.dart';

class NewArticleController extends GetxController {
  HomeController homeController = Get.find<HomeController>();
  NewsRepository newsController = Get.find<NewsRepository>();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController imageUrlController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String sourceName = '';

  void getCachedData() {
    Map<String, dynamic> data = GetStorage().read('user');

    sourceName = data['name'];
    print("sourceName : $sourceName");
  }

  void postDataToApi() {
    newsController
        .postForm(
      title: titleController.text,
      description: descriptionController.text,
      imageUrl: imageUrlController.text,
      content: contentController.text,
      source: sourceName,
    )
        .then((value) {
      final userNews = NewsModel(
        title: value['title'],
        imageUrl: value['imageUrl'],
        description: value['description'],
        content: value['content'],
        source: value['source'],
        publishedAt: DateTime.now(),
      );

      homeController.listOfNews.insert(0, userNews);
      homeController.listOfNews.refresh();
      // Get.offAllNamed(AppRouter.urlHome);
      Get.back();
    }).onError((error, stackTrace) {
      print(error);
      print(stackTrace);
    });
  }

  @override
  void onReady() {
    getCachedData();
    super.onReady();
  }
}
