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
final pizzas=[
  Pizza('assets/sicillian.png','Pizza Sicilienne','Anchois, oignons,olives et fromage','',400),
  Pizza('assets/pepperoni.png','Pizza Pepperoni','Pepperoni, Mozzarella et Parmesan','',600)
];