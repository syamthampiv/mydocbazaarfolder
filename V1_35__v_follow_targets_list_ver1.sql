create view v_follow_targets_list
(
source_user_id ,
activity_name,
target_user_id
)
as
 select a.id as  source_user_id ,'FOLLOW_COMPANY'::character varying as activity_name,e.id  as  target_user_id
 from users a inner join  user_role c on (a.user_role = c.id) 
              inner join company d on (d.id = a.company_id)
              inner join users e on (e.company_id = d.id)
              inner join user_role f on (e.user_role = f.id) 
 and c.name = 'USER' 
 and f.name = 'ADMINISTRATOR';