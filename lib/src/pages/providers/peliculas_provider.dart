

import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/pages/models/actores_model.dart';
import 'package:peliculas/src/pages/models/pelicula_model.dart';
import 'package:http/http.dart' as http;


class PeliculasProvider{

  String _apikey    = '6f7f6ab0f650a5b5efaded0e1816dd62';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularespage = 0;
  bool _cargando = false;
  
  List<Pelicula> _populares = new List();

  //codigo para crear un stream

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>)  get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;


  void  disposeStream (){
    _popularesStreamController?.close();
  }


  Future<List<Pelicula>> _procesarRespueta (Uri url)async{
     final resp = await http.get(url);
    final decoredData = json.decode(resp.body);

    final peliculas = new Peliculas.fromJsonList(decoredData['results']);


      return peliculas.items;

  }


  Future<List<Pelicula>>  getEnCines()async{

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apikey,
      'language'  : _language,
  
      });

      return await _procesarRespueta(url);

  }

  Future<List<Pelicula>> getPopulares()async{
    if(_cargando)return [];
   
    _cargando = true;
    _popularespage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apikey,
      'language'  : _language,
      'page'      : _popularespage.toString()
      });

      final respo =  await _procesarRespueta(url);

      _populares.addAll(respo);
      popularesSink(_populares);

      _cargando = false;
      
      return respo;





  }

 Future<List<Actor>>  getCast(String peliId) async{

final url = Uri.https(_url, '3/movie/$peliId/credits',{
   'api_key'   : _apikey,
    'language'  : _language,

});

    final resp = await  http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodedData['cast']);

    return cast.actores;
 }

  Future<List<Pelicula>>  buscarPelicula(String query)async{

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apikey,
      'language'  : _language,
      'query'      : query
  
      });

      return await _procesarRespueta(url);

  }

}