using BoutiqueInventoryAPI.Data;
using BoutiqueInventoryAPI.DTOs;
using BoutiqueInventoryAPI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace BoutiqueInventoryAPI.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ProductsController : ControllerBase
{
    private readonly BoutiqueDbContext _context;
    private readonly IStoredProcedureService _spService;

    public ProductsController(BoutiqueDbContext context, IStoredProcedureService spService)
    {
        _context = context;
        _spService = spService;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll(int page = 1, int pageSize = 10)
    {
        var query = _context.Products
            .Include(p => p.Warehouse)
            .AsQueryable();

        var total = await query.CountAsync();

        var products = await query
            .OrderBy(p => p.Name)
            .Skip((page - 1) * pageSize)
            .Take(pageSize)
            .Select(p => new
            {
                p.Id,
                p.Name,
                p.Type,
                p.Size,
                p.ExpirationDate,
                p.ImagePath,
                p.WarehouseId,
                WarehouseName = p.Warehouse != null ? p.Warehouse.Name : null,
                WarehouseLocation = p.Warehouse != null ? p.Warehouse.Location : null,
                p.ShelfLocation
            })
            .ToListAsync();

        return Ok(new
        {
            total,
            page,
            pageSize,
            products
        });
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var product = await _context.Products
            .Include(p => p.Warehouse)
            .Where(p => p.Id == id)
            .Select(p => new
            {
                p.Id,
                p.Name,
                p.Type,
                p.Size,
                p.ExpirationDate,
                p.ImagePath,
                p.WarehouseId,
                WarehouseName = p.Warehouse != null ? p.Warehouse.Name : null,
                WarehouseLocation = p.Warehouse != null ? p.Warehouse.Location : null,
                p.ShelfLocation
            })
            .FirstOrDefaultAsync();

        if (product == null)
            return NotFound("Product not found.");

        return Ok(product);
    }

    [HttpPost]
    public async Task<IActionResult> Create(ProductCreateDto dto)
    {
        var id = await _spService.InsertProductAsync(dto);

        return CreatedAtAction(nameof(GetById), new { id }, new
        {
            message = "Product created successfully.",
            productId = id
        });
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> Update(int id, ProductUpdateDto dto)
    {
        await _spService.UpdateProductAsync(id, dto);

        return Ok(new
        {
            message = "Product updated successfully.",
            productId = id
        });
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var product = await _context.Products.FindAsync(id);

        if (product == null)
            return NotFound("Product not found.");

        _context.Products.Remove(product);
        await _context.SaveChangesAsync();

        return Ok("Product deleted successfully.");
    }

    [HttpGet("search")]
    public async Task<IActionResult> Search(
        string? name,
        string? type,
        string? size,
        int? categoryId,
        int? warehouseId,
        string? shelfLocation,
        string? imagePath)
    {
        var query = _context.Products
            .Include(p => p.Warehouse)
            .Include(p => p.ProductCategories)
            .ThenInclude(pc => pc.Category)
            .AsQueryable();

        if (!string.IsNullOrWhiteSpace(name))
            query = query.Where(p => p.Name.Contains(name));

        if (!string.IsNullOrWhiteSpace(type))
            query = query.Where(p => p.Type == type);

        if (!string.IsNullOrWhiteSpace(size))
            query = query.Where(p => p.Size == size);

        if (categoryId.HasValue)
            query = query.Where(p =>
                p.ProductCategories.Any(pc => pc.CategoryId == categoryId.Value));

        if (warehouseId.HasValue)
            query = query.Where(p => p.WarehouseId == warehouseId.Value);

        if (!string.IsNullOrWhiteSpace(shelfLocation))
            query = query.Where(p => p.ShelfLocation.Contains(shelfLocation));

        if (!string.IsNullOrWhiteSpace(imagePath))
            query = query.Where(p =>
                p.ImagePath != null && p.ImagePath.Contains(imagePath));

        var products = await query
            .OrderBy(p => p.Name)
            .Select(p => new
            {
                p.Id,
                p.Name,
                p.Type,
                p.Size,
                p.ExpirationDate,
                p.ImagePath,
                p.WarehouseId,
                WarehouseName = p.Warehouse != null ? p.Warehouse.Name : null,
                WarehouseLocation = p.Warehouse != null ? p.Warehouse.Location : null,
                p.ShelfLocation,
                Categories = p.ProductCategories
                    .Select(pc => new
                    {
                        pc.CategoryId,
                        CategoryName = pc.Category != null ? pc.Category.Name : null
                    })
                    .ToList()
            })
            .ToListAsync();

        return Ok(products);
    }

    [HttpGet("expiring-soon")]
    public async Task<IActionResult> ExpiringSoon()
    {
        var today = DateTime.Today;
        var limitDate = today.AddMonths(1);

        var products = await _context.Products
            .Include(p => p.Warehouse)
            .Where(p =>
                p.ExpirationDate != null &&
                p.ExpirationDate >= today &&
                p.ExpirationDate <= limitDate)
            .OrderBy(p => p.ExpirationDate)
            .Select(p => new
            {
                p.Id,
                p.Name,
                p.Type,
                p.Size,
                p.ExpirationDate,
                p.WarehouseId,
                WarehouseName = p.Warehouse != null ? p.Warehouse.Name : null,
                p.ShelfLocation
            })
            .ToListAsync();

        return Ok(products);
    }

    [HttpGet("expired")]
    public async Task<IActionResult> Expired()
    {
        var today = DateTime.Today;

        var products = await _context.Products
            .Include(p => p.Warehouse)
            .Where(p =>
                p.ExpirationDate != null &&
                p.ExpirationDate < today)
            .OrderBy(p => p.ExpirationDate)
            .Select(p => new
            {
                p.Id,
                p.Name,
                p.Type,
                p.Size,
                p.ExpirationDate,
                p.WarehouseId,
                WarehouseName = p.Warehouse != null ? p.Warehouse.Name : null,
                p.ShelfLocation
            })
            .ToListAsync();

        return Ok(products);
    }
}