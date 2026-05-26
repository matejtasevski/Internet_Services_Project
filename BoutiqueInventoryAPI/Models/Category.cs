namespace BoutiqueInventoryAPI.Models;
public class Category{public int Id{get;set;} public string Name{get;set;}=string.Empty; public List<ProductCategory> ProductCategories{get;set;}=new();}
