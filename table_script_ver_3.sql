CREATE TABLE country
(
  id uuid NOT NULL,
  country_code character varying(3),
  country_name character varying(500),
  CONSTRAINT pk_country_id PRIMARY KEY (id)
);

CREATE TABLE state
(
  id uuid NOT NULL,
  state_code character varying(3),
  state_name character varying(500),
  country_id uuid,
  CONSTRAINT pk_state_id PRIMARY KEY (id),
  CONSTRAINT fk_state_country_id FOREIGN KEY (country_id)
      REFERENCES country (id)
);