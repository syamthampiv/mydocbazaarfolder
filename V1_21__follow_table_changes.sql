CREATE TYPE FOLLOWER_ENTITY_TYPE AS ENUM ('user','company');

CREATE TYPE FOLLOWING_ENTITY_TYPE AS ENUM ('product','user','company');

CREATE TABLE follow
(
  id uuid NOT NULL,
  follower_id uuid,
  follower_name character varying,
  follower_entity_type character varying,
  following_id uuid,
  following_name character varying,
  following_entity_type character varying,
  CONSTRAINT pk_follow PRIMARY KEY (id)
);