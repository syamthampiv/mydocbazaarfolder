create or replace function fn_activity_timeline(p_user_id character varying default null,p_result out text) returns text as $$
declare
mview record;
v_result text;
v_para character varying (2):='}]';
v_activity_data character varying;  
begin
v_result:=null;
for mview in select distinct activity_id::character varying as activity_id,
                    source_id::character varying as source_id,
                    activity_data::text as activity_data,
                    activity_time::character varying as activity_time,
                    verb,
                    display_name 
                    from v_user_timeline 
                    where (source_id::character varying = p_user_id or target_user_id::character varying = p_user_id) loop
			v_activity_data:=null; 
			if v_result is null then 
				
					v_result:='[{ 
				'||'"'||'activityId'||'"'||':'||quote_ident(mview.activity_id)||','||'
				'||'"'||'sourceId'||'"'||':'||quote_ident(mview.source_id)||',
				'; 
				select quote_ident(mview.activity_data)::character varying into v_activity_data; 
				v_result:=v_result||'"'||'activityData'||'"'||':'||replace(trim(both '"' from v_activity_data),'""','"')||','||'
				'||'"'||'activityTime'||'"'||':'||quote_ident(mview.activity_time)||','||'
				'||'"'||'verb'||'"'||':'|| quote_ident(mview.verb)||','||'
				'||'"'||'displayName'||'"'||':'||quote_ident(mview.display_name); 	
			elsif v_result is not null then 
				v_result:=v_result||'
				}, { 
				'||'"'||'activityId'||'"'||':'||quote_ident(mview.activity_id)||','||'
				'||'"'||'sourceId'||'"'||':'||quote_ident(mview.source_id)||',
				'; 
				select quote_ident(mview.activity_data)::character varying into v_activity_data; 
				v_result:=v_result||'"'||'activityData'||'"'||':'||replace(trim(both '"' from v_activity_data),'""','"')||','||'
				'||'"'||'activityTime'||'"'||':'||quote_ident(mview.activity_time)||','||'
				'||'"'||'verb'||'"'||':'|| quote_ident(mview.verb)||','||'
				'||'"'||'displayName'||'"'||':'||quote_ident(mview.display_name); 
			end if;
			
	end loop;
	
	if v_result is not null then 
	v_result:=v_result||'
	'||v_para;
	end if;
	p_result:=v_result;
	--raise notice 'Result is(%)',v_result;
	return;
end;
$$ LANGUAGE plpgsql; 