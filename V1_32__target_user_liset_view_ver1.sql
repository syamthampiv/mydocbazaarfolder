create view v_activity_source_target_list
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
 and f.name = 'ADMINISTRATOR';