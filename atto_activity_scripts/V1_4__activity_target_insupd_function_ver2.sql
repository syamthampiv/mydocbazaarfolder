CREATE OR REPLACE FUNCTION fn_insupd_activity_target(p_activity_id uuid default null,p_source_id uuid default null,p_activity_type character varying default null) RETURNS text AS $$
DECLARE
    mviews RECORD; 
BEGIN
    IF p_activity_type in ('FOLLOW_COMPANY','FOLLOW_PRODUCT') then
	    SELECT dblink_connect('host=139.59.236.58
							   dbname=atto_dev');
		FOR mviews IN select admin_user_id from dblink('SELECT e.id as admin_user_id,a.id as normal_user_id 
			  FROM users a inner join  user_role c on (a.user_role = c.id) 
				       inner join company d on (d.id = a.company_id)
				       inner join users e on (e.company_id = d.id)
				       inner join user_role f on (e.user_role = f.id) 
		       WHERE c.name = ''USER'' 
		       AND f.name = ''ADMINISTRATOR''') as t1(admin_user_id uuid,normal_user_id uuid)
			   where normal_user_id = p_source_id
	    LOOP
		       IF quote_ident(mviews.admin_user_id) is not null and p_activity_id is not null THEN
					insert into (id,parent_activity_id,target) VALUES (uuid_generate_v4(),p_activity_id,quote_ident(mviews.admin_user_id));
                    COMMIT;
		       END IF;
	    END LOOP;
		select dblink_disconnect();
    END IF;
	RETURN null;
EXCEPTION WHEN others THEN
    RETURN SQLSTATE||'Error occured in function FN_INSUPD_ACTIVITY_TARGET';
END;
$$ LANGUAGE plpgsql; 