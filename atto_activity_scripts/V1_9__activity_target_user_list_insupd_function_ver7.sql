CREATE OR REPLACE FUNCTION fn_insupd_activity_target(p_activity_id character varying default null,p_source_id character varying default null,p_activity_type character varying default null) RETURNS text AS $$
DECLARE
    v_user_id uuid; 
	v_accreditation_id uuid;
BEGIN
    IF p_activity_type in ('FOLLOW_COMPANY','FOLLOW_PRODUCT') then
	   PERFORM dblink_connect('host=139.59.236.58
							  dbname=atto_dev');
		FOR v_user_id IN select admin_user_id from dblink('SELECT e.id as admin_user_id,a.id as normal_user_id 
			 FROM users a inner join  user_role c on (a.user_role = c.id) 
				      inner join company d on (d.id = a.company_id)
				      inner join users e on (e.company_id = d.id)
				      inner join user_role f on (e.user_role = f.id) 
		      WHERE c.name = ''USER'' 
		      AND f.name = ''ADMINISTRATOR''') as t1(admin_user_id uuid,normal_user_id uuid)
			  where normal_user_id::character varying = p_source_id
	   LOOP
		      IF v_user_id is not null and p_activity_id is not null THEN
					 
                    execute 'insert into activity_targets(id,parent_activity_id,target) VALUES ('''||uuid_generate_v4()||''','''||p_activity_id::uuid||''','''||v_user_id||''')';
		      END IF;
	   END LOOP;
		PERFORM dblink_disconnect();
    elsif p_activity_type in ('EDIT_PRODUCT','DELETE_PRODUCT') then
	   PERFORM dblink_connect('host=139.59.236.58
							  dbname=atto_dev');
	   FOR v_user_id IN select admin_user_id from dblink('select distinct m.user_id,m.product_id from 
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
			  where product_id::character varying = p_source_id
			  loop
					IF v_user_id is not null and p_activity_id is not null THEN
						execute 'insert into activity_targets(id,parent_activity_id,target) VALUES ('''||uuid_generate_v4()||''','''||p_activity_id::uuid||''','''||v_user_id||''')';
		           END IF;
			  end loop;
			  PERFORM dblink_disconnect();
	elsif p_activity_type in ('ADD_PRODUCT') then
	   PERFORM dblink_connect('host=139.59.236.58
							  dbname=atto_dev');
	   FOR v_user_id IN select admin_user_id from dblink('select distinct m.user_id,m.product_id from 
                                                       (select distinct x.user_id,z.id as product_id from
                                                       (select  user_id,json_array_elements(allocated_products->''products'')::json->''code'' as category
                                                        from user_allocation_details) x inner join products z on (''"''||z.product_category[array_length(z.product_category, 1)]||''"'' = x.category::character varying)
                                                        where x.category is not null
                                                        union
														select distinct c.follower_id as user_id,a.id as product_id from
														products a  inner join follow c on (a.company_id = c.following_id)
														where c.follower_entity_type = ''USER''
														and c.following_entity_type =''COMPANY''
														) m
														where m.user_id not in (select o.id from products n inner join users o on (n.company_id = o.company_id)
													   inner join user_role p on (p.id = o.user_role)
													   where n.id = m.product_id
													   and p.name = ''ADMINISTRATOR'')') 
										 as t1(admin_user_id uuid,product_id uuid)
			  where product_id::character varying = p_source_id
			  loop
					IF v_user_id is not null and p_activity_id is not null THEN
						execute 'insert into activity_targets(id,parent_activity_id,target) VALUES ('''||uuid_generate_v4()||''','''||p_activity_id::uuid||''','''||v_user_id||''')';
		           END IF;
			  end loop;
			  PERFORM dblink_disconnect();
	elsif p_activity_type in ('APPROVE_ACCREDITATION') then
		select activity_data->'accreditationid'::uuid into v_accreditation_id from activities a where id::character varying = p_activity_id;
		PERFORM dblink_connect('host=139.59.236.58
							  dbname=atto_dev');
		
		--USERS (MANUFACTURERS,DISTRIBUTORS,BUYERS) FOLLOWING THE APPROVER COMPANY
		FOR v_user_id IN select admin_user_id from dblink('select b.follower_id,a.id from users a inner join follow b on (a.company_id = b.following_id)
															inner join user_role c on (a.user_role = c.id)
															where b.follower_entity_type = ''USER''
															and b.following_entity_type =''COMPANY''
															and c.name = ''ADMINISTRATOR''') 
										 as t1(admin_user_id uuid,approver_id uuid)
			  where approver_id::character varying = p_source_id
			  and admin_user_id::character varying <> p_source_id
			  loop
					IF v_user_id is not null and p_activity_id is not null THEN
						execute 'insert into activity_targets(id,parent_activity_id,target) VALUES ('''||uuid_generate_v4()||''','''||p_activity_id::uuid||''','''||v_user_id||''')';
		           END IF;
		END LOOP;
		--USERS(MANUFACTURER,DISTRIBUTOR,BUYER) FOLLOWING THE PRODUCTS THAT COMES UNDER THE CATEGORY THAT REQUESTED FOR ACCREDITATION
		FOR v_user_id IN select admin_user_id from dblink('select e.follower_id,b.accreditation_id from
															(select a.id as accreditation_id,unnest(a.product_Category) product_category
															from accreditation a) b inner join 
															(select c.id as product_id,c.product_category[array_length(c.product_category, 1)] as product_category from products c ) d
															on (b.product_category = d.product_category )
															inner join follow e on (e.following_id = d.product_id)
															order by b.accreditation_id') 
										 as t1(admin_user_id uuid,accreditation_id uuid)
			  where accreditation_id = v_accreditation_id
			  and admin_user_id::character varying <> p_source_id
			  loop
					IF v_user_id is not null and p_activity_id is not null THEN
						execute 'insert into activity_targets(id,parent_activity_id,target) VALUES ('''||uuid_generate_v4()||''','''||p_activity_id::uuid||''','''||v_user_id||''')';
		           END IF;
		END LOOP;
		--USERS(MANUFACTURER,DISTRIBUTOR,BUYER) ALLOCATED TO THE CATEGORY THAT REQUESTED FOR ACCREDITATION
	    FOR v_user_id IN select admin_user_id from dblink('select c.user_id,b.accreditation_id from
														(select a.id as accreditation_id,unnest(a.product_Category) product_category
														from accreditation a) b inner join
														(select  user_id,json_array_elements(allocated_products->''products'')::json->''code'' as category
														from user_allocation_details) c
														on (''"''||b.product_category||''"'' = c.category::character varying)') 
										 as t1(admin_user_id uuid,accreditation_id uuid)
			  where accreditation_id = v_accreditation_id
			  and admin_user_id::character varying <> p_source_id
			  loop
					IF v_user_id is not null and p_activity_id is not null THEN
						execute 'insert into activity_targets(id,parent_activity_id,target) VALUES ('''||uuid_generate_v4()||''','''||p_activity_id::uuid||''','''||v_user_id||''')';
		           END IF;
		END LOOP;
        PERFORM dblink_disconnect();			  
	END IF;
	RETURN null;
EXCEPTION WHEN others THEN
    RETURN SQLSTATE||'Error occured in function FN_INSUPD_ACTIVITY_TARGET '||sqlerrm;
END;
$$ LANGUAGE plpgsql; 