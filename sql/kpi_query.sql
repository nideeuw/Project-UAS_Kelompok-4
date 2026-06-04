-- KPI Queries - Data Warehouse GlobalScale Retail
-- Dataset: Sales Data Sample

USE dw_sales;

-- KPI 1 - Total Revenue per Tahun
SELECT 
    d.year AS tahun,
    SUM(f.sales) AS total_revenue,
    COUNT(f.id_factOrder) AS jumlah_transaksi
FROM fact_orders f
JOIN dimdate d ON f.id_dimDate = d.id_dimDate
GROUP BY d.year
ORDER BY d.year;

-- KPI 2 - Product Line dengan Revenue Tertinggi
SELECT 
    p.productLine AS kategori_produk,
    SUM(f.sales) AS total_revenue,
    SUM(f.quantityOrdered) AS total_unit_terjual,
    ROUND(AVG(f.priceEach), 2) AS rata_rata_harga
FROM fact_orders f
JOIN dimproducts p ON f.id_dimProduct = p.id_dimProduct
GROUP BY p.productLine
ORDER BY total_revenue DESC;

-- KPI 3 - Deal Size yang Paling Banyak Menghasilkan Revenue
SELECT 
    f.dealSize AS ukuran_deal,
    COUNT(f.id_factOrder) AS jumlah_order,
    SUM(f.sales) AS total_revenue,
    ROUND(AVG(f.sales), 2) AS rata_rata_nilai_order
FROM fact_orders f
GROUP BY f.dealSize
ORDER BY total_revenue DESC;

-- KPI 4 - Top 10 Pelanggan dengan Pembelian Terbanyak
SELECT 
    c.customerName AS nama_pelanggan,
    COUNT(f.id_factOrder) AS jumlah_transaksi,
    SUM(f.quantityOrdered) AS total_unit_dibeli,
    SUM(f.sales) AS total_belanja
FROM fact_orders f
JOIN dimcustomer c ON f.id_dimCustomer = c.id_dimCustomer
GROUP BY c.customerName
ORDER BY total_belanja DESC
LIMIT 10;

-- KPI 5 - Negara dengan Penjualan Tertinggi
SELECT 
    l.country AS negara,
    l.territory AS wilayah,
    COUNT(f.id_factOrder) AS jumlah_transaksi,
    SUM(f.sales) AS total_revenue
FROM fact_orders f
JOIN dimlocation l ON f.id_dimLocation = l.id_dimLocation
GROUP BY l.country, l.territory
ORDER BY total_revenue DESC;