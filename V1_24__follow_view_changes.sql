CREATE OR REPLACE VIEW v_follow
AS
SELECT a.follower_id source_id,b.name source_name,f.file_name source_icon_path,a.follower_entity_type source_type,'Admin' source_user,c.location source_location,
a.following_id targer_id,d.name target_name,g.file_name target_icon_path,a.following_entity_type target_type
FROM follow a LEFT OUTER JOIN users b
ON (a.follower_id = b.id)
LEFT OUTER JOIN company c
ON(b.company_id = c.id)
LEFT OUTER JOIN users d
ON (a.following_id = d.id)
LEFT OUTER JOIN company e
ON(d.company_id = e.id)
left outer join assets f
on (c.assets->'PROFILE_IMAGE' = f.id::varchar)
left outer join assets g
on (e.assets->'PROFILE_IMAGE' = g.id::varchar)
WHERE LOWER(a.follower_entity_type) = 'user' AND LOWER(a.following_entity_type ) = 'user'
UNION ALL
SELECT a.follower_id source_id,b.name source_name,f.file_name source_icon_path,a.follower_entity_type source_type,'Admin' source_user,c.location source_location,
a.following_id targer_id,d.name target_name,g.file_name target_icon_path,a.following_entity_type target_type
FROM follow a LEFT OUTER JOIN users b
ON (a.follower_id = b.id)
LEFT OUTER JOIN company c
ON(b.company_id = c.id)
LEFT OUTER JOIN products d
ON (a.following_id = d.id)
left outer join assets f
on (c.assets->'PROFILE_IMAGE' = f.id::varchar)
left outer join assets g
on (d.product_Details->'MAIN_IMAGE' = g.id::varchar)
WHERE LOWER(a.follower_entity_type) = 'user' AND LOWER(a.following_entity_type ) = 'product'
UNION ALL
SELECT a.follower_id source_id,b.name source_name,f.file_name source_icon_path,a.follower_entity_type source_type,'Admin' source_user,c.location source_location,
a.following_id targer_id,d.name target_name,g.file_name target_icon_path,a.following_entity_type target_type
FROM follow a LEFT OUTER JOIN users b
ON (a.follower_id = b.id)
LEFT OUTER JOIN company c
ON(b.company_id = c.id)
LEFT OUTER JOIN company d
ON (a.following_id = d.id)
left outer join assets f
on (c.assets->'PROFILE_IMAGE' = f.id::varchar)
left outer join assets g
on (d.assets->'PROFILE_IMAGE' = g.id::varchar)
WHERE LOWER(a.follower_entity_type) = 'user' AND LOWER(a.following_entity_type ) = 'company'
UNION ALL
SELECT a.follower_id source_id,c.name source_name,f.file_name source_icon_path,a.follower_entity_type source_type,'Admin' source_user,c.location source_location,
a.following_id targer_id,d.name target_name,g.file_name target_icon_path,a.following_entity_type target_type
FROM follow a LEFT OUTER JOIN company c
ON (a.follower_id = c.id) 
LEFT OUTER JOIN users d
ON (a.following_id = d.id)
LEFT OUTER JOIN company e
ON(d.company_id = e.id)
left outer join assets f
on (c.assets->'PROFILE_IMAGE' = f.id::varchar)
left outer join assets g
on (e.assets->'PROFILE_IMAGE' = g.id::varchar)
WHERE LOWER(a.follower_entity_type) = 'company' AND LOWER(a.following_entity_type ) = 'user'
UNION ALL
SELECT a.follower_id source_id,c.name source_name,f.file_name source_icon_path,a.follower_entity_type source_type,'Admin' source_user,c.location source_location,
a.following_id targer_id,d.name target_name,g.file_name target_icon_path,a.following_entity_type target_type
FROM follow a  LEFT OUTER JOIN company c
ON (a.follower_id = c.id) 
LEFT OUTER JOIN products d
ON (a.following_id = d.id)
left outer join assets f
on (c.assets->'PROFILE_IMAGE' = f.id::varchar)
left outer join assets g
on (d.product_Details->'MAIN_IMAGE' = g.id::varchar)
WHERE LOWER(a.follower_entity_type) = 'company' AND LOWER(a.following_entity_type ) = 'product'
UNION ALL
SELECT a.follower_id source_id,c.name source_name,f.file_name source_icon_path,a.follower_entity_type source_type,'Admin' source_user,c.location source_location,
a.following_id targer_id,d.name target_name,g.file_name target_icon_path,a.following_entity_type target_type
FROM follow a  LEFT OUTER JOIN company c
ON (a.follower_id = c.id) 
LEFT OUTER JOIN company d
ON (a.following_id = d.id)
left outer join assets f
on (c.assets->'PROFILE_IMAGE' = f.id::varchar)
left outer join assets g
on (d.assets->'PROFILE_IMAGE' = g.id::varchar)
WHERE LOWER(a.follower_entity_type) = 'company' AND LOWER(a.following_entity_type ) = 'company';