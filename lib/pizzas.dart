abstract class Plat{
  final String imagePath;
  final String title;
  final String description;

  Plat(this.imagePath,this.title,this.description,);
}

class Pizza extends Plat{
  final String imagePath,title,description,caption;
  final double price;

  Pizza(this.imagePath, this.title, this.description,this.caption,this.price):super(imagePath,title,description);
}
class Sand extends Plat{
  final String imagePath,title,description,caption;
  final double price;

  Sand(this.imagePath, this.title, this.description,this.caption,this.price):super(imagePath,title,description);
}
class Assiette extends Plat{
  final String imagePath,title,description,caption;
  final double price;

  Assiette(this.imagePath, this.title, this.description,this.caption,this.price):super(imagePath,title,description);
}
final pizzas=[
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
