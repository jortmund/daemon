extends Resource
class_name Shop

export (String) var Name : String
export (String) var Keeper : String
export (Texture) var Logo
export (int, -1, 15) var ShopLevel : int
export (Item.Types, FLAGS) var Sales
