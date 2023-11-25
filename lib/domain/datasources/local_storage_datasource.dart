import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toggleFavorite(
      Movie
          movie); // envia toda la prlicula si la agrega o la quita a los favoritos
  Future<bool> isMovieeFavorite(int movieId); //si mi pelicula esta en favoritos
  Future<List<Movie>> loadMovies(
      {int limit = 10,
      offset =
          0}); //es la paginacion el limite de carga de 10 y offset el queda despues de la paginación
}
