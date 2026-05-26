# Environment Setup Document
## Boutique Inventory & Warehouse Management API

---

# 1. Project Overview

The Boutique Inventory & Warehouse Management API is a modern ASP.NET Core Web API solution designed for boutique owners who manage products across multiple warehouses.

The system supports:

- Product management
- Warehouse management
- Category management
- Product search and filtering
- Expiration date monitoring
- Stored Procedures (SQL Server)
- Swagger API testing
- Postman API testing
- Custom dashboard UI

The project is built using:

- C#
- ASP.NET Core Web API
- .NET 6
- SQL Server
- Entity Framework Core
- HTML/CSS/JavaScript

---

# 2. Required Software

Before running the project, install the following software.

| Software | Purpose |
|---|---|
| Visual Studio 2022 / Visual Code| Main development environment |
| .NET 6 SDK | Required for building and running the API |
| SQL Server Express | Database engine |
| SQL Server Management Studio (SSMS) | Database management |
| Postman | API testing |


---

# 3. Predecessor : Install .NET 6 SDK

Download and install: 

- .NET 6 SDK

Official website:

https://dotnet.microsoft.com/en-us/download/dotnet/6.0

After installation verify using terminal:

```bash
dotnet --list-sdks
```

Expected result:

```text
6.0.xxx
```

---

# 4. Predecessor : Install Visual Studio 2022 / Visual Code 

Download:

https://visualstudio.microsoft.com/

During installation select:

- ASP.NET and web development
- .NET desktop development
- Data storage and processing

Recommended optional components:

- SQL Server Data Tools
- Entity Framework Tools

---

# 5. Predecessor : Install SQL Server Express

Download:

https://www.microsoft.com/en-us/sql-server/sql-server-downloads

Install:

- SQL Server Express

Recommended instance name:

```text
SQLEXPRESS
In our case example : DESKTOP-GQA2CTH\SQLEXPRESS
```

Authentication mode:

- Windows Authentication

---

# 6. Predecessor : Install SQL Server Management Studio (SSMS)

Download:

https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms

SSMS is used to:

- Create databases
- Execute SQL scripts
- Create stored procedures
- View tables and data
- Debug SQL queries

---

# 7. Predecessor : Install Postman

Download:

https://www.postman.com/downloads/

Postman is used for:

- API testing
- Sending HTTP requests
- Organizing API collections
- Testing endpoints professionally

---

# 8. Project Folder Structure

The project contains the following important folders:

```text
BoutiqueInventoryAPI
│
├── Controllers
├── Data
├── DTOs
├── Models
├── Services
├── SQL
├── wwwroot
├── appsettings.json
├── Program.cs
└── BoutiqueInventoryAPI.csproj
```

Folder explanation:

| Folder | Description |
|---|---|
| Controllers | API endpoints |
| Data | Database context |
| DTOs | Request/response models |
| Models | Database entities |
| Services | Business logic |
| SQL | SQL scripts and stored procedures |
| wwwroot | Dashboard UI |

---

# 9. Open the Project

## Visual Studio

1. Extract the ZIP project
2. Open Visual Studio
3. Click:

```text
Open a project or solution
```

4. Select:

```text
BoutiqueInventoryAPI.csproj
```

---

# 10. Configure Database Connection

Open:

```text
appsettings.json
```

Default connection string:

```json
"ConnectionStrings": {
  "DefaultConnection": "Server=localhost\\SQLEXPRESS;Database=BoutiqueInventoryDB;Trusted_Connection=True;TrustServerCertificate=True;"
}
```

If your SQL Server instance is different, replace:

```text
localhost\\SQLEXPRESS
```

with your SQL Server name.

Example:

```text
DESKTOP-GQA2CTH\\SQLEXPRESS
```

---

# 11. Create Database and Tables

Open SSMS.

Connect to SQL Server.

Open:

```text
SQL/01_CreateTables_And_StoredProcedures.sql
```

Execute the script.

The script creates:

- BoutiqueInventoryDB database
- Tables
- Relationships
- Stored Procedures
- Sample data

Created tables:

- Products
- Warehouses
- Categories
- ProductCategories

---

# 12. Stored Procedures

The system uses SQL Server Stored Procedures for insert and update operations.

Examples:

```sql
sp_InsertProduct
sp_UpdateProduct
sp_InsertWarehouse
sp_UpdateWarehouse
```

Benefits:

- Better organization
- Improved security
- Easier maintenance
- Faster execution

---

# 13. Restore NuGet Packages

Open terminal inside project folder.

Run:

```bash
dotnet restore
```

This installs all required project dependencies.

---

# 14. Run the Project

Run:

```bash
dotnet run
```

Expected result:

```text
Now listening on:
https://localhost:5001
```

---

# 15. Open the Dashboard

Open browser:

```text
https://localhost:5001
```

The custom dashboard allows:

- Viewing products
- Adding warehouses
- Adding categories
- Monitoring expiration dates

---

# 16. Open Swagger

Open:

```text
https://localhost:5001/swagger
```

Swagger is used for:

- API documentation
- Endpoint testing
- Request testing
- Viewing JSON responses

---

# 17. Import Postman Collection

Open Postman.

Click:

```text
Import
```

Select:

```text
BoutiqueInventoryAPI_SP_UI.postman_collection.json
```

Update variable:

```text
baseUrl
```

Example:

```text
https://localhost:5001
```

---

# 18. Main API Endpoints

## Warehouses

| Method | Endpoint |
|---|---|
| GET | /api/warehouses |
| POST | /api/warehouses |
| PUT | /api/warehouses/{id} |
| DELETE | /api/warehouses/{id} |

---

## Products

| Method | Endpoint |
|---|---|
| GET | /api/products |
| POST | /api/products |
| PUT | /api/products/{id} |
| DELETE | /api/products/{id} |
| GET | /api/products/search |
| GET | /api/products/expiring-soon |

---

## Categories

| Method | Endpoint |
|---|---|
| GET | /api/categories |
| POST | /api/categories |
| PUT | /api/categories/{id} |
| DELETE | /api/categories/{id} |

---

# 19. Example API Request

Example product creation request:

```json
{
  "name": "Luxury Perfume",
  "type": "Perfume",
  "size": "100ml",
  "expirationDate": "2026-06-10",
  "imagePath": "images/perfume1.jpg",
  "warehouseId": 1,
  "shelfLocation": "Shelf A1",
  "categoryIds": [1]
}
```

---

# 20. Expiration Monitoring

The system automatically checks product expiration dates.

Products expiring within one month are:

- displayed in the Expiring Soon endpoint
- included in notification service

This feature is important for:

- perfumes
- cosmetics
- sensitive products

---

# 21. Troubleshooting examples 

## Problem: .NET SDK not found

Solution:

Install .NET 6 SDK.

Verify:

```bash
dotnet --list-sdks
```

---

## Problem: Database connection error

Check:

- SQL Server service is running
- Connection string is correct
- SQL Server instance name is correct

---

## Problem: Port already in use

Stop previous API process or change launch port.

---

## Problem: Swagger 500 Error

Usually caused by JSON circular reference.

Solution:

Add:

```csharp
ReferenceHandler.IgnoreCycles
```

inside Program.cs.

---

# 22. Conclusion

The Boutique Inventory & Warehouse Management API demonstrates:

- Modern Web API development
- SQL Server integration
- Stored Procedures
- Dashboard UI design
- Product and warehouse management
- Expiration monitoring
- RESTful API architecture

The project simulates a real-world boutique inventory management environment and can be extended further with:

- authentication
- image upload
- email notifications
- mobile applications
- advanced analytics

