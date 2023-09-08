import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/daily_news/domain/entities/article.dart';
import 'package:news_app/features/daily_news/domain/usecases/get_saved_article.dart';
import 'package:news_app/features/daily_news/domain/usecases/remove_article.dart';
import 'package:news_app/features/daily_news/domain/usecases/save_article.dart';

part 'local_article_event.dart';
part 'local_article_state.dart';

class LocalArticleBloc extends Bloc<LocalArticleEvent, LocalArticleState> {
  final GetSavedArticleUseCase _getSavedArticleUseCase;
  final SaveArticleUseCase _saveArticleUseCase;
  final RemoveArticleUseCase _removeArticleUseCase;

  LocalArticleBloc(
    this._getSavedArticleUseCase,
    this._saveArticleUseCase,
    this._removeArticleUseCase,
  ) : super(const LocalArticleLoading()) {
    on<GetSavedArticles>(onGetSavedArticles);
    on<RemoveArticle>(onRemoveArticle);
    on<SaveArticle>(onSaveArticle);
  }

  void onGetSavedArticles(
      GetSavedArticles event, Emitter<LocalArticleState> emit) async {
    final List<ArticleEntity> articles = await _getSavedArticleUseCase();
    emit(LocalArticleComplete(articles));
  }

  void onRemoveArticle(
      RemoveArticle article, Emitter<LocalArticleState> emit) async {
    await _removeArticleUseCase(params: article.article);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticleComplete(articles));
  }

  void onSaveArticle(
      SaveArticle article, Emitter<LocalArticleState> emit) async {
    await _saveArticleUseCase(params: article.article);
    final articles = await _getSavedArticleUseCase();
    emit(LocalArticleComplete(articles));
  }
}
