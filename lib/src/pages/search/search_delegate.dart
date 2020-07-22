import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/models/pelicula_model.dart';
import 'package:peliculas/src/pages/providers/peliculas_provider.dart';


class DataSearch extends SearchDelegate{

  final peliculasProvider = new PeliculasProvider();

  final peliculas =[
    'spiderman',
    'Aquaman',
    'Batman',
    'Shazan',
    'Ironman',
    'Capitan America',


  ];

  final peliculasRecientes =[
    'Spiderman',
    'Capitan America'

  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro appbar 
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
          //print('click!!!');
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar 
    return IconButton(
      icon: AnimatedIcon(
        icon:AnimatedIcons.menu_arrow ,
        progress: transitionAnimation,
        ),
        onPressed: (){
          close(context, null);
          print('Icons press');
        },
    );
    
  }

  @override
  Widget buildResults(BuildContext context) {
    // instrucion que crea los resultados que se van a mostrar 
    return Center(child: Container(

    ),
    );
  }

   @override
  Widget buildSuggestions(BuildContext context) {
    // son las sugerencias que aparecen cuando la persona escriben
    if(query.isEmpty){
      return Container();
    }
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {


        if(snapshot.hasData){
         final peliculas = snapshot.data;
         return ListView(
           children: peliculas.map((pelicula){
             return ListTile(
               leading: FadeInImage(
                 image: NetworkImage(pelicula.getPosterImg()),
                 placeholder: AssetImage('assets/img/no-image.jpg'),
                 width: 50.0,
                 fit: BoxFit.cover,

               ),
               title: Text(pelicula.title),
               subtitle: Text(pelicula.originalTitle),
               onTap: (){
                 close(context, null);
                 pelicula.uniqueId = '';
                 Navigator.pushNamed(context, 'detalle',arguments: pelicula);
               },



             );
           }).toList()
           );
          
        }else{
          return Center(
            child: CircularProgressIndicator()
            );

        }

        
      },
    );

  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   // son las sugerencias que aparecen cuando la persona escriben

  //   final listasugerida =(query.isEmpty)? peliculasRecientes:peliculas.where(
  //     (p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();


  //   return ListView.builder(
  //     itemCount: listasugerida.length,
  //     itemBuilder: (context,i){
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listasugerida[i]),
  //         onTap: (){

  //         },

  //       );
  //     },
      

  //   );
  // }




}