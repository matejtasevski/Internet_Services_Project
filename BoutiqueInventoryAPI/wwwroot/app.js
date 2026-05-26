async function loadDashboard() {
    await loadProducts();

    const warehouses = await fetch("/api/warehouses").then(r => r.json());
    const categories = await fetch("/api/categories").then(r => r.json());
    const expiring = await fetch("/api/products/expiring-soon").then(r => r.json());

    document.getElementById("totalWarehouses").innerText = warehouses.length;
    document.getElementById("totalCategories").innerText = categories.length;
    document.getElementById("expiringProducts").innerText = expiring.length;
}

async function loadProducts() {
    const response = await fetch("/api/products");
    const data = await response.json();

    const products = data.products || data;

    document.getElementById("totalProducts").innerText = data.total || products.length;

    const table = document.getElementById("productsTable");
    table.innerHTML = "";

    products.forEach(p => {
        table.innerHTML += `
            <tr>
                <td>${p.name}</td>
                <td>${p.type}</td>
                <td>${p.size ?? ""}</td>
                <td>${p.warehouseName ?? ""}</td>
                <td>${p.shelfLocation ?? ""}</td>
                <td>${p.expirationDate ? p.expirationDate.substring(0, 10) : "No expiration"}</td>
            </tr>
        `;
    });
}

async function createWarehouse() {
    const name = document.getElementById("warehouseName").value;
    const location = document.getElementById("warehouseLocation").value;

    await fetch("/api/warehouses", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name, location })
    });

    alert("Warehouse added.");
    loadDashboard();
}

async function createCategory() {
    const name = document.getElementById("categoryName").value;

    await fetch("/api/categories", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name })
    });

    alert("Category added.");
    loadDashboard();
}
async function createProduct() {
    const categoryIdsText = document.getElementById("productCategoryIds").value;

    const categoryIds = categoryIdsText
        .split(",")
        .map(x => parseInt(x.trim()))
        .filter(x => !isNaN(x));

    const product = {
        name: document.getElementById("productName").value,
        type: document.getElementById("productType").value,
        size: document.getElementById("productSize").value,
        expirationDate: document.getElementById("productExpiration").value || null,
        imagePath: document.getElementById("productImagePath").value,
        warehouseId: parseInt(document.getElementById("productWarehouseId").value),
        shelfLocation: document.getElementById("productShelfLocation").value,
        categoryIds: categoryIds
    };

    const response = await fetch("/api/products", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(product)
    });

    if (response.ok) {
        alert("Product added successfully.");
        loadDashboard();
    } else {
        alert("Error adding product.");
    }
}
loadDashboard();