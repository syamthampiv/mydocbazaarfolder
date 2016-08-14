ALTER TABLE users ADD COLUMN created_Date timestamp;

ALTER TABLE users ADD COLUMN verification_token uuid;

ALTER TABLE users ADD COLUMN activation_token uuid;

DROP TABLE follow_products;

DROP VIEW v_user_allocation_management;

CREATE VIEW v_user_allocation_management AS 
 SELECT a.id AS allocation_details_id,
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
    b.created_date,
    b.activated,
    b.verified,
    b.user_role,
    b.company_id,
    b.designation
   FROM user_allocation_details a
     LEFT JOIN users b ON a.user_id = b.id;

DROP VIEW v_license_management;

CREATE VIEW v_license_management AS 
 SELECT a.id AS license_id,
    a.company_id,
    a.valid_from,
    a.valid_up_to,
    a.license_flag,
    b.id AS user_id,
    b.first_name AS user_first_name,
    b.last_name AS user_last_name,
    b.email_id AS user_email,
    b.created_date,
    b.user_role,
    b.designation AS user_designation
   FROM license a
     LEFT JOIN users b ON a.user_id = b.id;