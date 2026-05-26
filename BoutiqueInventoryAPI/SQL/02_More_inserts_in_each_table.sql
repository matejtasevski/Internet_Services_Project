-- =========================
-- INSERT WAREHOUSES
-- =========================

INSERT INTO Warehouses(Name, Location, IsActive)
VALUES
('Main Warehouse', 'Skopje', 1),
('Mall Storage', 'City Mall', 1),
('Perfume Storage', 'Tetovo', 1),
('Fashion Warehouse', 'Bitola', 1),
('Outlet Warehouse', 'Ohrid', 1),
('Luxury Storage', 'Skopje East', 1),
('Winter Collection', 'Prilep', 1),
('Summer Collection', 'Struga', 1),
('Accessories Warehouse', 'Kumanovo', 1),
('Backup Warehouse', 'Veles', 1);

-- =========================
-- INSERT CATEGORIES
-- =========================

INSERT INTO Categories(Name)
VALUES
('Perfumes'),
('Clothes'),
('Shoes'),
('Bags'),
('Accessories'),
('Luxury'),
('Summer'),
('Winter'),
('Gift Sets'),
('Limited Edition');

-- =========================
-- INSERT PRODUCTS
-- =========================

INSERT INTO Products
(
    Name,
    Type,
    Size,
    ExpirationDate,
    ImagePath,
    WarehouseId,
    ShelfLocation
)
VALUES
('Armani BlackCode', 'Perfume', '50ml', '2028-05-26', 'images/armani.jpg', 1, 'Shelf A1'),

('Luxury Perfume', 'Perfume', '100ml', '2026-06-10', 'images/perfume1.jpg', 1, 'Shelf A2'),

('Summer Dress', 'Clothes', 'M', NULL, 'images/dress1.jpg', 2, 'Rack B2'),

('Nike Air Max', 'Shoes', '42', NULL, 'images/nike.jpg', 3, 'Rack C1'),

('Gucci Bag', 'Bag', NULL, NULL, 'images/gucci.jpg', 4, 'Shelf D5'),

('Winter Jacket', 'Clothes', 'L', NULL, 'images/jacket.jpg', 5, 'Rack W1'),

('Luxury Gift Set', 'Perfume', '200ml', '2027-12-01', 'images/giftset.jpg', 6, 'Shelf G7'),

('Summer Sandals', 'Shoes', '39', NULL, 'images/sandals.jpg', 7, 'Rack S2'),

('Diamond Necklace', 'Accessories', NULL, NULL, 'images/diamond.jpg', 8, 'Shelf X1'),

('Limited Edition Chanel', 'Perfume', '75ml', '2027-03-15', 'images/chanel.jpg', 9, 'Shelf P9');

-- =========================
-- INSERT PRODUCT CATEGORIES
-- =========================

INSERT INTO ProductCategories(ProductId, CategoryId)
VALUES
(1, 1),
(1, 6),

(2, 1),

(3, 2),
(3, 7),

(4, 3),

(5, 4),
(5, 6),

(6, 2),
(6, 8),

(7, 1),
(7, 9),

(8, 3),
(8, 7),

(9, 5),
(9, 6),

(10, 1),
(10, 10);