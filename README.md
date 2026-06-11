# GlobalScale Retail Data Warehouse

Project UAS Mata Kuliah Data Warehouse  
Jurusan Teknologi Informasi — D4 Sistem Informasi Bisnis  
Politeknik Negeri Malang 2026

**Dosen Pengampu:** Endah Septa Sintiya, S.Pd., M.Kom.

---

## Anggota Kelompok

| Nama | NIM |
|------|-----|
| Muhammad Farras Awaludin Alwi | 244107060032 |
| Naswanida Nafiula | 244107060063 |
| Primayunita Putri Agustine | 244107060094 |
| Yanuar Alda Baran | 244107060016 |

---

## Deskripsi Proyek

Proyek ini membangun sebuah **Data Warehouse** berbasis Star Schema menggunakan dataset **Sales Data Sample** yang bersumber dari Kaggle. Pipeline ETL dibangun menggunakan **Pentaho Spoon** untuk memproses data dari file CSV ke dalam database MySQL.

---

## Dataset

- **Nama:** Sales Data Sample
- **Sumber:** Kaggle (https://www.kaggle.com/datasets/kyanyoga/sample-sales-data)
- **Format:** CSV
- **Jumlah Kolom:** 25
- **Lokasi:** `dataset/sales_data_sample.csv`

---

## Star Schema

Terdiri dari 1 tabel fakta dan 4 tabel dimensi:

- **fact_orders** — tabel fakta utama
- **dimcustomer** — dimensi pelanggan
- **dimproducts** — dimensi produk
- **dimdate** — dimensi waktu
- **dimlocation** — dimensi lokasi

---

## Cara Menjalankan ETL

### Prasyarat
- Pentaho Spoon (PDI) sudah terinstall
- MySQL Server berjalan
- Database `dw_sales` sudah dibuat

### Langkah-langkah

1. Jalankan script SQL untuk membuat tabel:
```sql
   -- Jalankan file sql/create_table.sql di MySQL
```

2. Buka Pentaho Spoon

3. Jalankan transformation sesuai urutan:
   - `etl/dimcustomer_project uas.ktr`
   - `etl/dimproducts_project uas.ktr`
   - `etl/dimdate_project uas.ktr`
   - `etl/dimlocation_project uas.ktr`
   - `etl/factorders_project uas.ktr`

4. Atau jalankan sekaligus melalui job:
   - `etl/Job Project UAS_Kelompok 4.kjb`

---

## KPI yang Dianalisis

### KPI 1 — Total Revenue per Tahun
```sql
SELECT 
    d.year AS tahun,
    SUM(f.sales) AS total_revenue,
    COUNT(f.id_factOrder) AS jumlah_transaksi
FROM fact_orders f
JOIN dimdate d ON f.id_dimDate = d.id_dimDate
GROUP BY d.year
ORDER BY d.year;
```

### KPI 2 — Product Line dengan Revenue Tertinggi
```sql
SELECT 
    p.productLine AS kategori_produk,
    SUM(f.sales) AS total_revenue,
    SUM(f.quantityOrdered) AS total_unit_terjual,
    ROUND(AVG(f.priceEach), 2) AS rata_rata_harga
FROM fact_orders f
JOIN dimproducts p ON f.id_dimProduct = p.id_dimProduct
GROUP BY p.productLine
ORDER BY total_revenue DESC;
```

### KPI 3 — Deal Size yang Paling Banyak Menghasilkan Revenue
```sql
SELECT 
    f.dealSize AS ukuran_deal,
    COUNT(f.id_factOrder) AS jumlah_order,
    SUM(f.sales) AS total_revenue,
    ROUND(AVG(f.sales), 2) AS rata_rata_nilai_order
FROM fact_orders f
GROUP BY f.dealSize
ORDER BY total_revenue DESC;
```

### KPI 4 — Top 10 Pelanggan dengan Pembelian Terbanyak
```sql
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
```

### KPI 5 — Negara dengan Penjualan Tertinggi
```sql
SELECT 
    l.country AS negara,
    l.territory AS wilayah,
    COUNT(f.id_factOrder) AS jumlah_transaksi,
    SUM(f.sales) AS total_revenue
FROM fact_orders f
JOIN dimlocation l ON f.id_dimLocation = l.id_dimLocation
GROUP BY l.country, l.territory
ORDER BY total_revenue DESC;
```

---

## Struktur Repository

```
📁 Project UAS_Kelompok 4/
├── 📁 dataset/
│   └── sales_data_sample.csv
├── 📁 etl/
│   ├── dimcustomer_project uas.ktr
│   ├── dimproducts_project uas.ktr
│   ├── dimdate_project uas.ktr
│   ├── dimlocation_project uas.ktr
│   ├── factorders_project uas.ktr
│   └── Job Project UAS_Kelompok 4.kjb
├── 📁 sql/
│   ├── create_table.sql
│   └── kpi_query.sql
├── 📁 laporan/
│   └── Laporan Project UAS_Kelompok 4.pdf
└── README.md
```