create table activity_definition 
	(id  uuid,
	tenant_id uuid,
	verb character varying, 
	display_name character varying,
	definition json,
	constraint pk_activity_def primary key (id)
	);

create table activities
(   id uuid,
	activity_type uuid,
	source uuid,
	activity_data json,
	activity_time timestamp without time zone,
	constraint pk_activities primary key (id) 
	);
	
	create table activity_targets
	(
	id uuid,
	parent_activity_id uuid,
	target uuid,
	constraint pk_activity_targets primary key (id),
	constraint fk_parent_activity_id foreign key (parent_activity_id) references activities (id)
	);
	
	
	
	create table messsages
	(id uuid,
	from_user uuid,
	to_user uuid,
	message_text text, --in the mail the data type is mentioned as UUID. is that correct? its the original message,rt?
	message_time  timestamp without time zone,
	activity_ref uuid,
	parent_msg_ref uuid,
	constraint pk_messages primary key (id)
	);
	
	create table activity_timeline --this table will store the 5 hour attribute to get the last 5 hours activity in the view
	(id uuid,
	 attributes hstore,
	 constraint pk_activity_timeline primary key (id)
	 );
	 
	CREATE VIEW v_user_timeline
        (
           activity_id,
           source_id,
           activity_data,
           activity_time,
           verb,
           display_name,
           activity_definition
        )
        AS
           SELECT a.id,
                  a.source,
                  a.activity_data,
                  a.activity_time,
                  d.verb,
                  d.display_name,
                  d.definition
             FROM activities a
                  INNER JOIN (  SELECT b.source,
                                       MAX (b.activity_time) max_activity_time
                                  FROM activities b
                              GROUP BY source) c
                     ON (a.source = c.source)
                  INNER JOIN activity_definition d
                     ON (a.activity_type = d.id)
        WHERE date_trunc('second',a.activity_time) >= date_trunc('second',c.max_activity_time - interval '5 hour');
		
    CREATE VIEW v_messages
		AS
		   SELECT a.id child_id,
				  a.from_user,
				  a.to_user,
				  a.MESSAGE_TEXT,
				  a.message_time,
				  a.activity_ref,
				  a.parent_msg_ref,
				  d.MESSAGE_TEXT parent_message,
				  d.activity_ref parent_ativity_ref
			 FROM docbazaar.messsages a
				  INNER JOIN (  SELECT b.from_user,
									   MAX (b.message_time) max_message_time
								  FROM docbazaar.messsages b
							  GROUP BY b.from_user) c
					 ON (a.from_user = c.from_user)
				  LEFT OUTER JOIN docbazaar.messsages d
					 ON (a.id = d.parent_msg_ref)
		WHERE date_trunc('second',a.message_time) >= date_trunc('second',c.max_message_time - interval '5 hour');		
	 