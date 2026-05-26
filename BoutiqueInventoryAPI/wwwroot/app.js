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

loadDashboard();