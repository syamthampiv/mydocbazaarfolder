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
	 
	