using BoutiqueInventoryAPI.Data;
using Microsoft.EntityFrameworkCore;

namespace BoutiqueInventoryAPI.Services;

public class ExpirationNotificationService : BackgroundService
{
    private readonly IServiceProvider _serviceProvider;
    private readonly IConfiguration _configuration;
    private readonly ILogger<ExpirationNotificationService> _logger;

    public ExpirationNotificationService(
        IServiceProvider serviceProvider,
        IConfiguration configuration,
        ILogger<ExpirationNotificationService> logger)
    {
        _serviceProvider = serviceProvider;
        _configuration = configuration;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        var intervalHours = _configuration.GetValue<int>(
            "NotificationSettings:CheckIntervalHours", 24);

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await CheckExpiringProducts(stoppingToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error while checking expiration dates.");
            }

            await Task.Delay(TimeSpan.FromHours(intervalHours), stoppingToken);
        }
    }

    private async Task CheckExpiringProducts(CancellationToken stoppingToken)
    {
        using var scope = _serviceProvider.CreateScope();

        var context = scope.ServiceProvider.GetRequiredService<BoutiqueDbContext>();
        var emailService = scope.ServiceProvider.GetRequiredService<IEmailService>();

        var today = DateTime.Today;
        var limitDate = today.AddMonths(1);

        var ownerEmail = _configuration.GetValue<string>(
            "NotificationSettings:OwnerEmail") ?? "owner@example.com";

        var expiringProducts = await context.Products
            .Include(p => p.Warehouse)
            .Where(p =>
                p.ExpirationDate != null &&
                p.ExpirationDate >= today &&
                p.ExpirationDate <= limitDate)
            .ToListAsync(stoppingToken);

        if (!expiringProducts.Any())
            return;

        var body = "Products expiring within one month:" + Environment.NewLine + Environment.NewLine;

        foreach (var p in expiringProducts)
        {
            body += "- " + p.Name +
                    ", Expiration: " + p.ExpirationDate?.ToString("yyyy-MM-dd") +
                    ", Warehouse: " + p.Warehouse?.Name +
                    ", Location: " + p.ShelfLocation +
                    Environment.NewLine;
        }

        await emailService.SendEmailAsync(
            ownerEmail,
            "Boutique Inventory Expiration Warning",
            body);
    }
}