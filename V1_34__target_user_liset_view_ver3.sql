create or replace view v_activity_source_target_list
(source_user_id ,
 activity_name ,
 target_user_id  
 )
 as  select a.follower_id as  source_user_id,'FOLLOW_COMPANY'::character varying as activity_name,e.id  as  target_user_id 
 from follow a left outer join users b on (a.follower_id = b.id)
               left outer join user_role c on (b.user_role = c.id)
               left outer join company d on (a.following_id = d.id)
               left outer join users e on (e.company_id = d.id)
               left outer join user_role f on (e.user_role = f.id)
 where a.follower_entity_type = 'USER' 
 and a.following_entity_type = 'COMPANY' 
 and c.name = 'ADMINISTRATOR'
 and f.name = 'ADMINISTRATOR'
 union all
select a.follower_id as  source_user_id,'FOLLOW_COMPANY'::character varying as activity_name,h.id  as  target_user_id 
 from follow a left outer join users b on (a.follower_id = b.id)
               left outer join user_role c on (b.user_role = c.id) 
               left outer join company g on (b.company_id = g.id)
               left outer join users h on (h.company_id = g.id)
               left outer join user_role i on (h.user_role = i.id)
 where a.follower_entity_type = 'USER' 
 and a.following_entity_type = 'COMPANY' 
 and c.name = 'USER' 
 and i.name = 'ADMINISTRATOR'
 union all
 select a.follower_id as  source_user_id,'FOLLOW_COMPANY'::character varying as activity_name,e.id  as  target_user_id 
 from follow a left outer join users b on (a.follower_id = b.id)
               left outer join user_role c on (b.user_role = c.id)
               left outer join company d on (a.following_id = d.id)
               left outer join users e on (e.company_id = d.id)
               left outer join user_role f on (e.user_role = f.id) 
 where a.follower_entity_type = 'USER' 
 and a.following_entity_type = 'COMPANY' 
 and c.name = 'USER'
 and f.name = 'ADMINISTRATOR' 
 union all
 select a.follower_id as  source_user_id,'FOLLOW_PRODUCT'::character varying as activity_name,f.id  as  target_user_id 
 from follow a left outer join users b on (a.follower_id = b.id)
               left outer join user_role c on (b.user_role = c.id)
               left outer join products d on (a.following_id = d.id)
               left outer join company e on (e.id = d.company_id)
               left outer join users f on (f.company_id = e.id)
               left outer join user_role g on (f.user_role = g.id)
 where a.follower_entity_type = 'USER' 
 and a.following_entity_type = 'PRODUCT' 
 and c.name = 'ADMINISTRATOR'
 and g.name = 'ADMINISTRATOR'
 union all
select a.follower_id as  source_user_id,'FOLLOW_PRODUCT'::character varying as activity_name,f.id  as  target_user_id 
 from follow a left outer join users b on (a.follower_id = b.id)
               left outer join user_role c on (b.user_role = c.id)
               left outer join company e on (e.id = b.company_id)
               left outer join users f on (f.company_id = e.id)
               left outer join user_role g on (f.user_role = g.id)
 where a.follower_entity_type = 'USER' 
 and a.following_entity_type = 'PRODUCT' 
 and c.name = 'USER' 
 and g.name = 'ADMINISTRATOR'
 union all
 select a.follower_id as  source_user_id,'FOLLOW_PRODUCT'::character varying as activity_name,f.id  as  target_user_id 
 from follow a left outer join users b on (a.follower_id = b.id)
               left outer join user_role c on (b.user_role = c.id)
               left outer join products d on (a.following_id = d.id)
               left outer join company e on (d.company_id = e.id)
               left outer join users f on (f.company_id = e.id)
               left outer join user_role g on (f.user_role = g.id) 
 where a.follower_entity_type = 'USER' 
 and a.following_entity_type = 'PRODUCT' 
 and c.name = 'USER'
 and g.name = 'ADMINISTRATOR';