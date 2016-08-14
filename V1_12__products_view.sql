CREATE VIEW v_products AS 
 SELECT products.id,
 products.name,
 products.model,
 products.hsn_code,
 products.ean_upc_code,
 products.factory_price,
 products.status,
 products.tenant_id,
 products.product_desc,
 products.product_details,
 products.product_category[array_length(products.product_category,1)] product_category,
 products.company_id,
 products.company_name,
 products.product_spec,
 products.category_name
 FROM products;