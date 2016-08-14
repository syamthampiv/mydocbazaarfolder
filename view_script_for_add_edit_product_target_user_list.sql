select distinct x.user_id,z.id as product_id from
(select  user_id,json_array_elements(allocated_products->'products')::json->'code' as category
from user_allocation_details) x inner join  v_products y on (x.category::character varying = '"'||y.product_category||'"')
                                inner join products z on (z.product_category[array_length(z.product_category, 1)] = y.product_category)
where x.category is not null
union
select distinct c.follower_id,a.id as product_id from
products a inner join company b 
on (a.company_id = b.id)
inner join follow c on (b.id = c.following_id)
where c.follower_entity_type = 'USER'
and c.following_entity_type ='PRODUCT'
union
select distinct b.follower_id,a.id as product_id from products a inner join follow b on (a.id = b.following_id)
where b.follower_entity_type = 'USER'
and b.following_entity_type ='PRODUCT';