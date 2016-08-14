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
			 FROM messsages a
				  INNER JOIN (  SELECT b.from_user,
									   MAX (b.message_time) max_message_time
								  FROM messsages b
							  GROUP BY b.from_user) c
					 ON (a.from_user = c.from_user)
				  LEFT OUTER JOIN messsages d
					 ON (a.id = d.parent_msg_ref)
		WHERE date_trunc('second',a.message_time) >= date_trunc('second',c.max_message_time - interval '5 hour');		
	 