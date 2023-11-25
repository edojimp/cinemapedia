import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;
import 'package:isar/isar.dart';
import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';

class IsarDatasource extends LocalStorageDatasource {
  late Future<Isar> db;

  IsarDatasource() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [MovieSchema],
        inspector: true,
        //name: 'default',
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<bool> isMovieeFavorite(int movieId) async {
    //si la pelicula con este id exixte
    final isar = await db;

    final Movie? isFavoriteMovie =
        await isar.movies.filter().idEqualTo(movieId).findFirst();
    //genera un filtro y busca los que son iguales de id y encuentra el primero
    return isFavoriteMovie != null;
  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    final isar = await db;
    return isar.movies.where().offset(offset).limit(limit).findAll();
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    final isar = await db;

    final favoriteMovie =
        await isar.movies.filter().idEqualTo(movie.id).findFirst();
//si esta la pelicula agregar si si borrar
    if (favoriteMovie != null) {
      //Borrar
      isar.writeTxnSync(() => isar.movies.deleteSync(favoriteMovie.isarId!));
      return;
    }
    //Insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));
  }
}
