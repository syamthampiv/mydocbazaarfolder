CREATE TABLE activity_definition
(
  id uuid NOT NULL,
  tenant_id uuid,
  verb character varying,
  display_name character varying,
  definition json,
  CONSTRAINT pk_activity_def PRIMARY KEY (id)
);

CREATE TABLE activities
(
  id uuid NOT NULL,
  activity_type uuid,
  source uuid,
  activity_data json,
  activity_time timestamp without time zone,
  CONSTRAINT pk_activities PRIMARY KEY (id)
);

CREATE TABLE activity_targets
(
  id uuid NOT NULL,
  parent_activity_id uuid,
  target uuid,
  CONSTRAINT pk_activity_targets PRIMARY KEY (id),
  CONSTRAINT fk_parent_activity_id FOREIGN KEY (parent_activity_id)
      REFERENCES activities (id)
);

CREATE TABLE activity_timeline
(
  id uuid NOT NULL,
  attributes hstore,
  CONSTRAINT pk_activity_timeline PRIMARY KEY (id)
);

CREATE TABLE messsages
(
  id uuid NOT NULL,
  from_user uuid,
  to_user uuid,
  message_text text,
  message_time timestamp without time zone,
  activity_ref uuid,
  parent_msg_ref uuid,
  CONSTRAINT pk_messages PRIMARY KEY (id)
);

