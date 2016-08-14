CREATE TABLE accredition
(
  id uuid NOT NULL,
  status character varying,
  country character varying(20),
  approver_id uuid,
  requester_id uuid,
  notes character varying(20),
  area_of_operaton character varying(200)[],
  product_category character varying(200)[],
  CONSTRAINT PK_ACCREDITION PRIMARY KEY(id)
);