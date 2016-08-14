CREATE TABLE company_classification
(
  id uuid NOT NULL,
  name character varying(100),
  tenant_id uuid,
  description character varying(500),
  classification_sequence numeric,
  classification_type character varying(100),
  CONSTRAINT pk_company_classification PRIMARY KEY (id),
  CONSTRAINT fk_prod_classificaion_prod_classification FOREIGN KEY (tenant_id)
      REFERENCES tenant (id) 
);