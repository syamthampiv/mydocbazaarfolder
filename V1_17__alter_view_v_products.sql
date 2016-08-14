DROP VIEW v_products;

CREATE VIEW v_products AS 
 SELECT b.company_id,
    b.company_name,
    b.tenant_id,
    b.product_category,
    string_agg(b.product_list, ';  '::text) AS product_list,
    c.assets AS product_assets
   FROM ( SELECT (a.id::character varying::text || '~'::text) || a.name::text AS product_list,
            a.company_id,
            a.company_name,
            a.tenant_id,
            a.product_category[array_length(a.product_category, 1)] AS product_category
           FROM products a) b
     LEFT JOIN company c ON b.company_id = c.id
  GROUP BY b.company_id, b.company_name, c.assets, b.tenant_id, b.product_category
  ORDER BY b.company_id;