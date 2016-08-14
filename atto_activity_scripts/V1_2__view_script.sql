CREATE OR REPLACE VIEW v_messages AS 
 SELECT a.id AS child_id,
    a.from_user,
    a.to_user,
    a.message_text,
    a.message_time,
    a.activity_ref,
    a.parent_msg_ref,
    d.message_text AS parent_message,
    d.activity_ref AS parent_ativity_ref
   FROM messsages a
     JOIN ( SELECT b.from_user,
            max(b.message_time) AS max_message_time
           FROM messsages b
          GROUP BY b.from_user) c ON a.from_user = c.from_user
     LEFT JOIN messsages d ON a.id = d.parent_msg_ref
  WHERE date_trunc('second'::text, a.message_time) >= date_trunc('second'::text, c.max_message_time - '05:00:00'::interval);
  
CREATE OR REPLACE VIEW v_user_timeline AS 
 SELECT a.id AS activity_id,
    a.source AS source_id,
    a.activity_data,
    a.activity_time,
    d.verb,
    d.display_name,
    d.definition AS activity_definition,
    e.target AS target_user_id
   FROM activities a
     JOIN ( SELECT b.source,
            max(b.activity_time) AS max_activity_time
           FROM activities b
          GROUP BY b.source) c ON a.source = c.source
     JOIN activity_definition d ON a.activity_type = d.id
     LEFT JOIN activity_targets e ON a.id = e.parent_activity_id
  WHERE date_trunc('second'::text, a.activity_time) >= date_trunc('second'::text, c.max_activity_time - '05:00:00'::interval)
  ORDER BY a.activity_time DESC;
