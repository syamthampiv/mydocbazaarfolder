ALTER TABLE messsages RENAME TO messages;

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
   FROM messages a
     JOIN ( SELECT b.from_user,
            max(b.message_time) AS max_message_time
           FROM messages b
          GROUP BY b.from_user) c ON a.from_user = c.from_user
     LEFT JOIN messages d ON a.id = d.parent_msg_ref
  WHERE date_trunc('second'::text, a.message_time) >= date_trunc('second'::text, c.max_message_time - '05:00:00'::interval);