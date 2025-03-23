import 'package:flutter/foundation.dart';
import '../models/news.dart';
import '../services/api_service.dart';

class NewsProvider extends ChangeNotifier {
  final ApiService _apiService;
  List<News> _news = [];
  bool _isLoading = false;
  String? _error;

  NewsProvider(this._apiService);

  List<News> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchNews() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Mock data for testing - in a real app this would come from the API
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      _news = [
        News(
          id: '1',
          title: 'New Library Opening',
          content:
              'We are excited to announce the opening of our new library wing. The new wing features modern study spaces, additional research resources, and state-of-the-art technology facilities. Students and faculty are invited to the grand opening ceremony.',
          date: DateTime.now().subtract(Duration(days: 2)),
          imageUrl:
              'https://images.unsplash.com/photo-1568667256549-094345857637?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          author: 'Admin Office',
        ),
        News(
          id: '2',
          title: 'Academic Excellence Awards',
          content:
              'Congratulations to all students who received Academic Excellence Awards this semester. Your dedication and hard work have paid off, and we are proud of your achievements. The ceremony will be held in the main auditorium.',
          date: DateTime.now().subtract(Duration(days: 5)),
          imageUrl:
              'https://images.unsplash.com/photo-1523580494863-6f3031224c94?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          author: 'Dean of Students',
        ),
        News(
          id: '3',
          title: 'Sports Tournament Results',
          content:
              'The annual inter-college sports tournament concluded last weekend with our institution securing first place in basketball and swimming events. We congratulate all the participants and thank everyone who supported our teams.',
          date: DateTime.now().subtract(Duration(days: 7)),
          imageUrl:
              'https://images.unsplash.com/photo-1579952363873-27f3bade9f55?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          author: 'Sports Department',
        ),
        News(
          id: '4',
          title: 'Research Grant Awarded',
          content:
              'Our institution has been awarded a prestigious research grant of 2.5 million dollars for advanced studies in renewable energy. This grant will support ongoing research projects and provide new opportunities for student involvement in cutting-edge research.',
          date: DateTime.now().subtract(Duration(days: 10)),
          imageUrl:
              'https://images.unsplash.com/photo-1507413245164-6160d8298b31?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          author: 'Research Office',
        ),
        News(
          id: '5',
          title: 'New Online Courses Available',
          content:
              'We have added 15 new online courses to our curriculum, covering various subjects including data science, artificial intelligence, digital marketing, and sustainable development. Registrations are now open for the upcoming semester.',
          date: DateTime.now().subtract(Duration(days: 12)),
          imageUrl:
              'https://images.unsplash.com/photo-1501504905252-473c47e087f8?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
          author: 'Academic Affairs',
        ),
      ];

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to fetch news';
      _isLoading = false;
      notifyListeners();
    }
  }

  News getNewsById(String id) {
    return _news.firstWhere((news) => news.id == id);
  }
}
