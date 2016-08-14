create view v_follower_user_details
(
       source_user_id,
       source_user_name,
       source_email_id,
       source_company_id,
       source_user_role,
       source_user_role_name,
       source_location,
       source_icon_path,
       admin_user_id,
       admin_user_name,
       admin_email_id,
       admin_company_id,
       admin_user_role,
       admin_user_role_name,
       admin_location,
       admin_source_icon_path
)
as
SELECT a.follower_id,
       b.first_name AS name,
       b.email_id,
       b.company_id,
       b.user_role,
       c.name AS user_role_name,
       d.location,
       e.file_name source_icon_path,
       f.admin_user_id,
       f.admin_user_name,
       f.admin_email_id,
       f.admin_company_id,
       f.admin_user_role,
       f.admin_user_role_name,
       f.admin_location,
       f.admin_source_icon_path
  FROM follow a
       LEFT OUTER JOIN users b ON (a.follower_id = b.id)
       LEFT OUTER JOIN user_role c ON (b.user_role = c.id)
       LEFT OUTER JOIN company d ON (b.company_id = d.id)
       LEFT OUTER JOIN assets e ON (d.assets->'PROFILE_IMAGE' = e.id ::varchar)
       LEFT OUTER JOIN (SELECT a.id,
                               c.id AS admin_user_id,
                               c.first_name AS admin_user_name,
                               c.email_id admin_email_id,
                               c.company_id admin_company_id,
                               d.id AS admin_user_role,
                               d.name AS admin_user_role_name,
                               e.location admin_location,
                               f.file_name admin_source_icon_path
                          FROM users a LEFT OUTER JOIN user_role b ON (a.user_role = b.id)
                                       LEFT OUTER JOIN users c  ON (a.company_id = c.company_id)
                                       LEFT OUTER JOIN user_role d  ON (c.user_role = d.id)
                                       LEFT OUTER JOIN company e ON (c.company_id = e.id)
                                       left outer join assets f on (e.assets->'PROFILE_IMAGE' = f.id::varchar)
                         WHERE b.name = 'USER' AND d.name = 'ADMINISTRATOR') f
          ON (a.follower_id = f.id)
 WHERE LOWER (a.follower_entity_type) = 'user';