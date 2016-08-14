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
					insert into activity_targets(id,parent_activity_id,target) VALUES (uuid_generate_v4(),p_activity_id,quote_ident(mviews.admin_user_id));
                    COMMIT;
		       END IF;
	    END LOOP;
		select dblink_disconnect();
    elsif p_activity_type in ('EDIT_DELETE_PRODUCT') then
	    FOR mviews IN select admin_user_id from dblink('select distinct m.user_id,m.product_id from 
                                                       (select distinct x.user_id,z.id as product_id from
                                                       (select  user_id,json_array_elements(allocated_products->''products'')::json->''code'' as category
                                                        from user_allocation_details) x inner join products z on (''"''||z.product_category[array_length(z.product_category, 1)]||''"'' = x.category::character varying)
                                                        where x.category is not null
                                                        union
														select distinct c.follower_id as user_id,a.id as product_id from
														products a  inner join follow c on (a.company_id = c.following_id)
														where c.follower_entity_type = ''USER''
														and c.following_entity_type =''COMPANY''
														union
														select distinct b.follower_id as user_id,a.id as product_id from products a inner join follow b on (a.id = b.following_id)
														where b.follower_entity_type = ''USER''
														and b.following_entity_type =''PRODUCT'') m
														where m.user_id not in (select o.id from products n inner join users o on (n.company_id = o.company_id)
													    inner join user_role p on (p.id = o.user_role)
													    where n.id = m.product_id
													    and p.name = ''ADMINISTRATOR'')') 
										  as t1(admin_user_id uuid,product_id uuid)
			   where product_id = p_source_id
			   loop
					IF quote_ident(mviews.admin_user_id) is not null and p_activity_id is not null THEN
						insert into activity_targets(id,parent_activity_id,target) VALUES (uuid_generate_v4(),p_activity_id,quote_ident(mviews.admin_user_id));
						COMMIT;
		            END IF;
			   end loop;
	END IF;
	RETURN null;
EXCEPTION WHEN others THEN
    RETURN SQLSTATE||'Error occured in function FN_INSUPD_ACTIVITY_TARGET';
END;
$$ LANGUAGE plpgsql; 