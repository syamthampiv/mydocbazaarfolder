alter table messsages rename to messages;

drop view v_messages;

create or replace view v_messages as
with user_det as (SELECT t.user_id,t.company_id,t.image_path
		      FROM dblink('dbname=atto_dev','SELECT a.id as user_id,b.id as company_id,c.file_name AS image_path
                                                     FROM users a inner join company b on (a.company_id = b.id)
                                                     left outer join assets c ON (b.assets -> ''PROFILE_IMAGE''::text) = c.id::character varying::text')
                      AS t(user_id uuid,company_id uuid,image_path character varying))
SELECT a.id AS parent_message_id,
    a.from_user as parent_from_user,
    e.image_path as parent_from_user_image_path,
    a.to_user parnt_to_user,
    f.image_path as parent_to_user_image_path,
    a.message_text as parent_message_text,
    a.message_time as parent_message_time,
    a.activity_ref as parent_Activity_ref,
    a.parent_msg_ref,
    d.id as child_message_id,
    d.from_user as child_from_user,
    g.image_path as child_from_user_image_path,
    d.to_user child_to_user,
    h.image_path as child_to_user_image_path,
    d.message_text as child_message_text,
    d.message_time as child_message_time,
    d.activity_ref as child_Activity_ref
   FROM messages a
     JOIN ( SELECT b.from_user,
            max(b.message_time) AS max_message_time
           FROM messages b
          GROUP BY b.from_user) c ON a.from_user = c.from_user
     LEFT JOIN messages d ON a.id = d.parent_msg_ref
     left outer join user_det e
                      on (a.from_user = e.user_id)
     left outer join user_det f
                      on (a.to_user = f.user_id)  
     left outer join user_det g
                      on (d.from_user = g.user_id)
     left outer join user_det h
                      on (d.to_user = h.user_id)                                
  WHERE date_trunc('second'::text, a.message_time) >= date_trunc('second'::text, c.max_message_time - '05:00:00'::interval); 