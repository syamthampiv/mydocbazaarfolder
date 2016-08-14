CREATE OR REPLACE VIEW v_user_timeline
(
   activity_id,
   source_id,
   activity_data,
   activity_time,
   verb,
   display_name,
   activity_definition,
   target_user_id
)
AS
     SELECT a.id,
            a.source,
            a.activity_data,
            a.activity_time,
            d.verb,
            d.display_name,
            d.definition,
            e.target
       FROM activities a
            INNER JOIN (  SELECT b.source,
                                 MAX (b.activity_time) max_activity_time
                            FROM activities b
                        GROUP BY source) c
               ON (a.source = c.source)
            INNER JOIN activity_definition d
               ON (a.activity_type = d.id)
            LEFT OUTER JOIN activity_targets e
               ON (a.id = e.parent_activity_id)
   WHERE date_trunc('second',a.activity_time) >= date_trunc('second',c.max_activity_time - interval '5 hour')
   ORDER BY activity_time DESC;