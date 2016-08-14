CREATE TABLE user_role
(
  id uuid,
  name character varying(100),
  description character varying(200),
  tenant_id uuid,
  CONSTRAINT pk_user_role PRIMARY KEY (id),
  CONSTRAINT fk_user_role FOREIGN KEY (tenant_id)
      REFERENCES tenant (id)
);

alter table users rename column name to first_name;

alter table users rename column phone to mobile_phone;

alter table users add column last_name character varying(200),
				  add column work_phone hstore,
				  add column address hstore,
				  add column designation character varying(100);

ALTER TABLE  users ALTER COLUMN user_role type uuid USING user_role::uuid;

CREATE TABLE user_allocation_details
(
  id uuid NOT NULL,
  user_id uuid,
  area_of_operation character varying,
  allocated_area json,
  allocated_products json,
  CONSTRAINT pk_user_allocation_details PRIMARY KEY (id),
  CONSTRAINT fk_allocation_detail_user FOREIGN KEY (user_id)
      REFERENCES users (id)
);

CREATE TABLE license
(
  id uuid NOT NULL, 
  company_id uuid,
  valid_from timestamp,
  valid_up_to timestamp,
  license_flag character varying(10),
  user_id uuid,
  CONSTRAINT pk_license PRIMARY KEY (id),
  CONSTRAINT fk_license_company FOREIGN KEY (company_id)
      REFERENCES company (id),
  CONSTRAINT fk_license_user_id foreign key (user_id) references users (id)
);

CREATE VIEW v_license_management AS SELECT 
              a.id AS license_id, 
			  a.company_id,
			  a.date_from,
			  a.date_to,
			  a.license_flag,
			  b.id AS user_id,
			  b.first_name AS user_first_name,
			  b.last_name AS user_last_name,
			  b.email_id  AS user_email,
			  b.user_role,
			  b.designation AS user_designation
FROM license a LEFT OUTER JOIN users b ON (a.user_id = b.id);

CREATE VIEW v_user_allocation_management AS SELECT 
			  a.id AS allocation_details_id,
			  a.user_id, 
			  a.area_of_operation,
			  a.allocated_area,
			  a.allocated_products,			  			  
			  b.first_name,
			  b.last_name,
			  b.email_id,
			  b.address,
			  b.mobile_phone,
			  b.work_phone,
			  b.activated,
			  b.verified,
			  b.user_role,
			  b.company_id,
			  b.designation
FROM user_allocation_details a LEFT OUTER JOIN users b ON (a.user_id = b.id);