abstract class Plat{
   String imagePath;
   String title;
   String description;
   String from;
   double price;
  Plat(this.imagePath,this.title,this.description,this.from, this.price);
}

class Pizza extends Plat{
  final String imagePath,title,description,caption,from;
  final double price;

  Pizza(this.imagePath, this.title, this.description,this.caption,this.price, this.from):super(imagePath,title,description,from,price);
}
class Sand extends Plat{
  final String imagePath,title,description,caption,from;
  final double price;

  Sand(this.imagePath, this.title, this.description,this.caption,this.price, this.from):super(imagePath,title,description,from,price);
}
class Assiette extends Plat{
  final String imagePath,title,description,caption,from;
  final double price;

  Assiette(this.imagePath, this.title, this.description,this.caption,this.price,this.from):super(imagePath,title,description,from,price);
}
final pizzas=[
  Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,"O'Tacos"),
  Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,"O'Tacos"),
  Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,"O'Tacos"),
  Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,"O'Tacos"),
];
final assiette=[
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',900,'Sweety Food'),
  Assiette('assets/ChawarmaP.png','Assiette Kebab','Kebab','',1200,'Bruger King'),
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',1500,'Sweety Food'),
  Assiette('assets/ChawarmaP.png','Assiette Kebab','Kebab','',1200,'Bruger King'),
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',1400,'Sweety Food'),
  Assiette('assets/ChawarmaP.png','Assiette Kebab','Kebab','',800,'Bruger King'),
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',1400,'Sweety Food'),
  Assiette('assets/ChawarmaP.png','Assiette Kebab','Kebab','',1200,'Bruger King')
];
final sands=[
  Sand('assets/tacos.png','Tacos','Tacos','',200,'Bruger King'),
  Sand('assets/chawarma.png','Chawarma','Chawarma','',300,"L'Oasis"),
  Sand('assets/tacos.png','Tacos','Tacos','',400,'Bruger King'),
  Sand('assets/chawarma.png','Chawarma','Chawarma','',200,"L'Oasis"),
  Sand('assets/tacos.png','Tacos','Tacos','',200,'Bruger King'),
  Sand('assets/chawarma.png','Chawarma','Chawarma','',600,"L'Oasis"),
  Sand('assets/tacos.png','Tacos','Tacos','',400,'Bruger King'),
  Sand('assets/chawarma.png','Chawarma','Chawarma','',500,"L'Oasis")
];
final platFav=[
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,'Bruger King'),
  Sand('assets/tacos.png','Tacos','Tacos','',400,'Bruger King')
];
final platcmd=[
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,'Bruger King'),
  Sand('assets/tacos.png','Tacos','Tacos','',400,'Bruger King'),
  Assiette('assets/variee.png','Assiette variée','Complet marinée','',400,'Bruger King'),
  Assiette('assets/ChawarmaP.png','Assiette Kebab','Kebab','',600,'Bruger King'),
  Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400,'Bruger King'),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600,'Bruger King'),
  Sand('assets/tacos.png','Tacos','Tacos','',400,'Bruger King'),
  Sand('assets/chawarma.png','Chawarma','Chawarma','',600,'Bruger King')
];
/**
 * final pizzas=[
    Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400),
    Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600)
    ];
    final assiette=[
    Assiette('assets/variee.png','Assiette variée','Complet marinée','',400),
    Assiette('assets/ChawarmaP.png','Assiette Kebab','Kebab','',600)
    ];
    final sands=[
    Sand('assets/tacos.png','Tacos','Tacos','',400),
    Sand('assets/chawarma.png','Chawarma','Chawarma','',600)
    ];
 */
class Carted extends Plat{
  int x;
  final String imagePath,title,description,caption,from;
  final double price;

  Carted(this.x, this.imagePath, this.title, this.description, this.caption, this.from, this.price) : super('', '', '', '', 0.0);
  
}
final platCarted=[
];