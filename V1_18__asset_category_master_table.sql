CREATE TABLE product_classification
(
  id uuid NOT NULL,
  name character varying(100),
  tenant_id uuid,
  asset_id uuid,
  description character varying(500),
  classification_sequence numeric,
  CONSTRAINT pk_asset_category PRIMARY KEY (id),
  CONSTRAINT fk_prod_classificaion_prod_classification FOREIGN KEY (tenant_id)
      REFERENCES tenant (id),
  CONSTRAINT fk_prod_classification_assets_id FOREIGN KEY (asset_id)
      REFERENCES assets (id)
);