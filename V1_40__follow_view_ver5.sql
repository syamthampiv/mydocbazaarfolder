CREATE OR REPLACE VIEW v_follow AS 
 SELECT a.follower_id AS source_id,
    b.first_name AS source_name,
    f.file_name AS source_icon_path,
    a.follower_entity_type AS source_type,
    'Admin'::text AS source_user,
    c.location AS source_location,
    d.id AS targer_id,
    d.name AS target_name,
    g.file_name AS target_icon_path,
    a.following_entity_type AS target_type,
    h.id AS target_user_id,
    a.id AS follow_id,
	d.product_desc as product_description,
	'FOLLOW_PRODUCT' as activity_type
   FROM follow a
     LEFT JOIN users b ON a.follower_id = b.id
     LEFT JOIN company c ON b.company_id = c.id
     LEFT JOIN products d ON a.following_id = d.id
     LEFT JOIN company e ON d.company_id = e.id
     LEFT JOIN assets f ON (c.assets -> 'PROFILE_IMAGE'::text) = f.id::character varying::text
     LEFT JOIN assets g ON (d.product_details -> 'MAIN_IMAGE'::text) = g.id::character varying::text
     LEFT JOIN users h ON e.id = h.company_id
     LEFT JOIN user_role i ON h.user_role = i.id
  WHERE lower(a.follower_entity_type::text) = 'user'::text AND lower(a.following_entity_type::text) = 'product'::text  AND upper(i.name::text) = 'ADMINISTRATOR'::text
UNION ALL
 SELECT a.follower_id AS source_id,
    b.first_name AS source_name,
    f.file_name AS source_icon_path,
    a.follower_entity_type AS source_type,
    'Admin'::text AS source_user,
    c.location AS source_location,
    a.following_id AS targer_id,
    d.name AS target_name,
    g.file_name AS target_icon_path,
    a.following_entity_type AS target_type,
    h.id AS target_user_id,
    a.id AS follow_id,
	null as product_description,
	'FOLLOW_COMPANY' as activity_type
   FROM follow a
     LEFT JOIN users b ON a.follower_id = b.id
     LEFT JOIN company c ON b.company_id = c.id
     LEFT JOIN company d ON a.following_id = d.id
     LEFT JOIN assets f ON (c.assets -> 'PROFILE_IMAGE'::text) = f.id::character varying::text
     LEFT JOIN assets g ON (d.assets -> 'PROFILE_IMAGE'::text) = g.id::character varying::text
     LEFT JOIN users h ON d.id = h.company_id
     LEFT JOIN user_role i ON h.user_role = i.id
  WHERE lower(a.follower_entity_type::text) = 'user'::text AND lower(a.following_entity_type::text) = 'company'::text AND upper(i.name::text) = 'ADMINISTRATOR'::text
UNION ALL
select c.id as source_id,
       c.first_name AS source_name, 
	   f.file_name AS source_icon_path,
	   'USER' AS source_type,
	   'Admin'::text AS source_user,
       b.location AS source_location,
	   a.id AS targer_id,
	   a.name AS target_name,
	   g.file_name AS target_icon_path,
	   'PRODUCT' AS target_type,
       c.id AS target_user_id,
	   null AS follow_id,
	   a.product_desc as product_description,
	   'ADD_PRODUCT' as activity_type
     from products a  
		inner join company b on (a.company_id = b.id)
		inner join users c on (c.company_id = b.id)
		inner join user_role d on (c.user_role = d.id)
		LEFT JOIN assets f ON (b.assets -> 'PROFILE_IMAGE'::text) = f.id::character varying::text
		LEFT JOIN assets g ON (a.product_details -> 'MAIN_IMAGE'::text) = g.id::character varying::text
		where d.name = 'ADMINISTRATOR'
UNION ALL
select c.id as source_id,
       c.first_name AS source_name, 
	   f.file_name AS source_icon_path,
	   'USER' AS source_type,
	   'Admin'::text AS source_user,
       b.location AS source_location,
	   a.id AS targer_id,
	   a.name AS target_name,
	   g.file_name AS target_icon_path,
	   'PRODUCT' AS target_type,
       c.id AS target_user_id,
	   null AS follow_id,
	   a.product_desc as product_description,
	   'EDIT_PRODUCT' as activity_type
     from products a  
		inner join company b on (a.company_id = b.id)
		inner join users c on (c.company_id = b.id)
		inner join user_role d on (c.user_role = d.id)
		LEFT JOIN assets f ON (b.assets -> 'PROFILE_IMAGE'::text) = f.id::character varying::text
		LEFT JOIN assets g ON (a.product_details -> 'MAIN_IMAGE'::text) = g.id::character varying::text
		where d.name = 'ADMINISTRATOR';
