namespace BoutiqueInventoryAPI.Models;
public class Warehouse{public int Id{get;set;} public string Name{get;set;}=string.Empty; public string Location{get;set;}=string.Empty; public bool IsActive{get;set;}=true; public List<Product> Products{get;set;}=new();}
